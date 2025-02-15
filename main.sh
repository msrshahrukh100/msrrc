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





# System shortcuts
alias c='clear'
