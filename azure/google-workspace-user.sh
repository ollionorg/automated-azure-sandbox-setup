#!/bin/bash

echo "$CREDENTIALS_FILE" > credentials.json
sleep 10
VIRTUALENV_NAME="venv"

if command -v virtualenv >/dev/null 2>&1; then
    echo "virtualenv is already installed."
else
    echo "virtualenv is not installed. Installing..."
    pip3 install virtualenv
fi

if [ ! -d "$VIRTUALENV_NAME" ]; then
    echo "Virtualenv $VIRTUALENV_NAME does not exist. Creating..."
    virtualenv -p python3 "$VIRTUALENV_NAME"
fi

source venv/bin/activate

if [ -f requirements.txt ]; then
    echo "Installing dependencies from requirements.txt..."
    # Loop through requirements and install any that are not already installed
    while read requirement; do
        package=$(echo $requirement | cut -d'=' -f1)
        if ! pip freeze | grep -q $package ; then
            echo "Installing $requirement..."
            pip3 install  $requirement
        else
            echo "$package is already installed."
        fi
    done < requirements.txt
else
    echo "requirements.txt file not found."
fi

if [ ! -x "/usr/local/bin/token" ]; then
    echo "token command not found in /usr/local/bin"
    sudo apt install -y unzip
    unzip gsuite-tokens.zip && \
    chmod +x "token-linux" && \
    sudo mv token-linux /usr/local/bin/token
fi


USER_EMAIL=$1


python3 google-workspace-validate-users.py "google_auth_email_id" "./credentials.json" $USER_EMAIL
