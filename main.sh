# Git aliases
alias gs='git status'
function gc() {
    if [ -z "$1" ]; then
        echo "Usage: gc <commit_message>"
        return 1
    fi
    git commit -m "$*"
}
alias gpm='git push origin main'


# Docker aliases
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dsa='docker stop $(docker ps -a -q) > /dev/null 2>&1'
function dl() {
    if [ -z "$1" ]; then
        echo "Usage: dl <container_name>"
        return 1
    fi
    
    container_id=$(docker ps --format "{{.ID}}" --filter "name=$1")
    
    if [ -z "$container_id" ]; then
        echo "Error: No running container found with name '$1'"
        return 1
    fi
    
    docker exec -it "$container_id" sh
}

# Docker compose shortcuts
alias up='docker-compose up'
alias down='docker-compose down'
alias makemigrations='docker-compose run backend python manage.py makemigrations'
alias migrate='docker-compose run backend python manage.py migrate'

# Project aliases
alias bismillah=". $HOME/Code/projects/boilerplate-project/start-project.sh"
alias klai="cd $HOME/Code/projects/klai/development && docker ps -a -q | xargs -r docker stop > /dev/null 2>&1 && docker-compose up"
alias footprint-economy="cd $HOME/Code/projects/footprint-economy/development && docker ps -a -q | xargs -r docker stop > /dev/null 2>&1 && docker-compose up"






# System shortcuts
alias c='clear'