# Derived from https://www.calazan.com/docker-cleanup-commands/

# Kill all running containers.
alias docker-kill-all='docker kill $(docker ps -q)'

# Delete all stopped containers.
alias docker-clean-containers='printf "\n>>> Deleting stopped containers\n\n" && docker rm $(docker ps -a -q)'

# Delete all untagged images.
alias docker-clean-images='printf "\n>>> Deleting untagged images\n\n" && docker rmi $(docker images -q -f dangling=true)'

# Delete all stopped containers and untagged images.
alias docker-clean='docker-clean-containers || true && docker-clean-images'
