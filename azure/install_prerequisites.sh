#!/bin/bash
packages=(ca-certificates curl gnupg lsb-release pinentry-tty)
directory_path="/etc/apt/keyrings"

while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1 || sudo fuser /var/lib/apt/lists/lock >/dev/null 2>&1 || sudo fuser /var/cache/apt/archives/lock >/dev/null 2>&1; do
    echo "Waiting for existing apt process to finish..."
    sleep 5
done


# Check if each package is installed and install it if it's missing
sudo apt-get update
for package in "${packages[@]}"
do
    if ! command -v "$package" &> /dev/null
    then
        echo "$package is not installed. Installing..."
        sudo apt-get install -y "$package"
    else
        echo "$package is already installed."
    fi
done

if [ ! -d "$directory_path" ]; then
    # Create directory
    mkdir -p "$directory_path"
    echo "Directory created at $directory_path"
else
    echo "Directory already exists at $directory_path"
fi

if ! test -f /etc/apt/keyrings/docker.gpg; then
    # If key is not installed, download it and add it to apt-key
    
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --no-tty --yes --dearmor -o /etc/apt/keyrings/docker.gpg
fi

if ! test -f /etc/apt/sources.list.d/docker.list; then
    # If repository is not configured, add it to apt sources
     sudo -- sh -c "echo deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable > /etc/apt/sources.list.d/docker.list"
fi

if command -v docker >/dev/null 2>&1; then
    echo "Docker is already installed."
else
    echo "Docker is not installed. Installing..."
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    sudo usermod -aG docker `whoami`
fi
