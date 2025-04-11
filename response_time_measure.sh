#!/bin/bash

# Default values
DEFAULT_ITERATIONS=5
DEFAULT_METHOD="GET"

# Function to display usage
show_usage() {
    echo "Usage: $0 -u <url> [options]"
    echo "Options:"
    echo "  -n <iterations>  Number of iterations (default: $DEFAULT_ITERATIONS)"
    echo "  -m <method>     HTTP method (default: $DEFAULT_METHOD)"
    echo "  -d <data>       Request data in JSON format"
    echo "  -H <headers>    Request headers in JSON format"
    exit 1
}

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo "Error: curl is required but not installed"
    exit 1
fi

# Check if jq is installed (for JSON parsing)
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed"
    exit 1
fi

# Initialize variables
URL=""
METHOD=$DEFAULT_METHOD
ITERATIONS=$DEFAULT_ITERATIONS
DATA=""
HEADERS=""

# Parse command line arguments
while getopts "u:m:n:d:H:" opt; do
    case $opt in
        u) URL="$OPTARG" ;;
        m) METHOD="$OPTARG" ;;
        n) ITERATIONS="$OPTARG" ;;
        d) DATA="$OPTARG" ;;
        H) HEADERS="$OPTARG" ;;
        *) show_usage ;;
    esac
done

# Check if URL is provided
if [ -z "$URL" ]; then
    echo "Error: URL is required"
    show_usage
fi

# Validate method
valid_methods=("GET" "POST" "PUT" "DELETE" "PATCH")
if [[ ! " ${valid_methods[*]} " =~ " ${METHOD} " ]]; then
    echo "Error: Invalid method. Must be one of: ${valid_methods[*]}"
    exit 1
fi

# Validate iterations
if ! [[ "$ITERATIONS" =~ ^[0-9]+$ ]] || [ "$ITERATIONS" -lt 1 ]; then
    echo "Error: Iterations must be a positive integer"
    exit 1
fi

# Function to validate JSON
validate_json() {
    if ! echo "$1" | jq . >/dev/null 2>&1; then
        echo "Error: Invalid JSON format"
        exit 1
    fi
}

# Validate JSON data if provided
if [ -n "$DATA" ]; then
    validate_json "$DATA"
fi

# Validate JSON headers if provided
if [ -n "$HEADERS" ]; then
    validate_json "$HEADERS"
fi

# Initialize total time
TOTAL_TIME=0

# Make requests and measure time
for ((i=1; i<=ITERATIONS; i++)); do
    echo -n "Request $i/$ITERATIONS... "
    
    # Build curl command
    CURL_CMD="curl -s -o /dev/null -w '%{time_total}'"
    
    # Add method
    CURL_CMD="$CURL_CMD -X $METHOD"
    
    # Add headers if provided
    if [ -n "$HEADERS" ]; then
        while IFS=: read -r key value; do
            # Remove quotes and trim whitespace
            key=$(echo "$key" | tr -d '"' | xargs)
            value=$(echo "$value" | tr -d '"' | xargs)
            CURL_CMD="$CURL_CMD -H '$key: $value'"
        done < <(echo "$HEADERS" | jq -r 'to_entries[] | "\(.key):\(.value)"')
    fi
    
    # Add data if provided
    if [ -n "$DATA" ]; then
        CURL_CMD="$CURL_CMD -d '$DATA'"
    fi
    
    # Add URL
    CURL_CMD="$CURL_CMD '$URL'"
    
    # Execute curl command and capture time
    RESPONSE_TIME=$(eval "$CURL_CMD")
    
    # Check if request was successful
    if [ $? -ne 0 ]; then
        echo "Failed"
        echo "Error: Request failed"
        exit 1
    fi
    
    echo "$RESPONSE_TIME seconds"
    TOTAL_TIME=$(echo "$TOTAL_TIME + $RESPONSE_TIME" | bc)
done

# Calculate and display average time
AVG_TIME=$(echo "scale=4; $TOTAL_TIME / $ITERATIONS" | bc)
echo "Average response time: $AVG_TIME seconds" 