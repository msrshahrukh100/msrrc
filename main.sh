# Git aliases
alias gs='git status'
alias ga='git add'
alias glog='git log'
function gcommit() {
    if [ -z "$1" ]; then
        echo "Usage: gcommit <commit_message>"
        return 1
    fi
    git commit -m "$*"
}
alias gpm='git push origin main'
alias gpma='git push origin main && git push origin2 main'
alias gpush="git push origin"


# Docker aliases
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dsa='docker stop $(docker ps -a -q) > /dev/null 2>&1'
function dl() {
    if [ -z "$1" ]; then
        echo "Usage: dl <container_name>"
        return 1
    fi
    
    # Get the full container name
    container_name=$(docker ps --format "{{.Names}}" | grep "$1")
    
    if [ -z "$container_name" ]; then
        echo "Error: No running container found with name containing '$1'"
        echo "Running containers:"
        docker ps --format "{{.Names}}"
        return 1
    fi
    
    # If multiple containers found, use the first one
    container_name=$(echo "$container_name" | head -n1)
    echo "Connecting to container: $container_name"
    
    # Try bash first with TERM environment, if it fails, try sh
    if ! docker exec -it -e TERM=xterm "$container_name" bash 2>/dev/null; then
        echo "Bash shell failed, trying sh..."
        if ! docker exec -it -e TERM=xterm "$container_name" sh 2>/dev/null; then
            echo "Both bash and sh failed. Trying with alpine..."
            docker exec -it -e TERM=xterm "$container_name" /bin/ash
        fi
    fi
}

# Docker compose shortcuts
alias up='docker-compose up'
alias down='docker-compose down'
alias makemigrations='docker-compose run backend python manage.py makemigrations'
alias migrate='docker-compose run backend python manage.py migrate'
alias uldb='docker-compose run cron ./scripts/updatelocaldb.sh'
# Project aliases
alias bismillah=". $HOME/Code/projects/boilerplate-project/start-project.sh"

alias klaicd="cd $HOME/Code/projects/klai/development"
alias klai="klaicd && docker ps -a -q | xargs -r docker stop > /dev/null 2>&1 && cursor . && up"

alias fecocd="cd $HOME/Code/projects/footprint-economy/development"
alias feco="feco && docker ps -a -q | xargs -r docker stop > /dev/null 2>&1 && cursor . && up"

alias scribblecd="cd $HOME/Code/projects/scribblewithai/development"
alias scribble="scribblecd && docker ps -a -q | xargs -r docker stop > /dev/null 2>&1 && cursor . && up"


function write() {
    # Path to the ideas folder
    IDEAS_DIR="/Users/mohammadshahrukh/Code/projects/content-machine/ideas"
    
    # Find the highest numbered folder
    HIGHEST=$(find "$IDEAS_DIR" -maxdepth 1 -type d -name '[0-9]*' | sed 's/.*\///' | sort -n | tail -1)
    
    # Calculate next number
    NEXT=$((HIGHEST + 1))
    
    # Create new folder
    NEW_DIR="$IDEAS_DIR/$NEXT"
    mkdir -p "$NEW_DIR"
    
    # Create my.md file
    NEW_FILE="$NEW_DIR/my.md"
    touch "$NEW_FILE"
    
    # Open in TextEdit
    open -a TextEdit "$NEW_FILE"
}


# System shortcuts
alias c='clear'

# Response time measurement tool
function measure() {
    if [ -z "$1" ]; then
        echo "Usage: measure <url> [options]"
        echo "Options:"
        echo "  -n <iterations>  Number of iterations (default: 5)"
        echo "  -m <method>     HTTP method (default: GET)"
        echo "  -d <data>       Request data in JSON format"
        echo "  -H <headers>    Request headers in JSON format"
        return 1
    fi
    
    # Make sure the script is executable
    chmod +x "$HOME/msrrc/response_time_measure.sh" 2>/dev/null
    
    # Run the shell script
    "$HOME/msrrc/response_time_measure.sh" -u "$1" "${@:2}"
}
