#!/bin/bash

# Function to show a loading animation while a process is running
show_loading_animation() {
    pid=$1
    spin='-\|/'
    i=0
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r%s" "${spin:$i:1}"
        sleep 0.1
    done
    printf "\r" # Clear the loading animation
}

echo "#######################################################################################################################"
echo ">> MINOS Installation"

# Step 1: Update and upgrade the system
echo "> Updating and upgrading the system..."
sudo apt-get update && sudo apt-get upgrade -y

# Step 2: Install Python versions and dependencies
echo "> Installing Python versions and dependencies..."
sudo apt install -y python3-pip python2.7-dev python3-tk build-essential libxi-dev libglu1-mesa-dev libglew-dev libopencv-dev libboost-all-dev libglib2.0-dev

# Step 3: Install libvips separately if not installed
echo "> Checking for libvips..."
if ! command -v vips &> /dev/null; then
    echo "> libvips not found, installing..."
    cd ~/dev/
    wget https://github.com/libvips/libvips/releases/download/v8.5.5/vips-8.5.5.tar.gz
    tar -xzvf vips-8.5.5.tar.gz
    rm vips-8.5.5.tar.gz
    mv vips-8.5.5 libvips
    cd libvips/
    sudo apt-get update
    chmod +x configure
    ./configure
    make
    sudo make install
else
    echo "> libvips is already installed."
fi

# Step 4: Install minos if not installed
echo "> Checking for MINOS..."
if [ ! -d "~/dev/minos" ]; then
    echo "> MINOS not found, installing..."
    cd ~/dev/
    git clone --branch v0.7.x https://github.com/minosworld/minos.git
    if [ $? -eq 0 ]; then
        echo "> Cloning MINOS repository completed"
    else
        echo "> Failed to clone the MINOS repository"
        exit 1
    fi
    cd minos/
    git checkout v0.7.x
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.7/install.sh | bash
    source ~/.bashrc
    nvm install v10.13.0
    nvm alias default 10.13.0
    cd minos/server/
    npm config set python /usr/bin/python2.7

    echo "> Installing npm dependencies, this might take up to an hour..."
    ( npm install node-gyp@3.8.0 bufferutil@4.0.1 utf-8-validate@5.0.2 ) &
    pid=$!
    show_loading_animation $pid
    wait $pid
    if [ $? -eq 0 ]; then
        echo "> npm dependencies installed successfully"
    else
        echo "> Failed to install npm dependencies"
        exit 1
    fi
else
    echo "> MINOS is already installed."
fi

# Step 5: Install Python requirements if not installed
echo "> Checking for socketIO-client-2..."
if ! pip3 show socketIO-client-2 &> /dev/null; then
    echo "> socketIO-client-2 not found, installing..."
    cd ~/dev/minos/
    pip3 uninstall socketIO-client-2 -y || true
    git clone https://github.com/msavva/socketIO-client-2
    if [ $? -eq 0 ]; then
        echo "> Cloning socketIO-client-2 repository completed"
    else
        echo "> Failed to clone the socketIO-client-2 repository"
        exit 1
    fi
    cd socketIO-client-2
    pip3 install -e .
    rm -rf socketIO_client_2.egg-info
else
    echo "> socketIO-client-2 is already installed."
fi

# Add PATH to .bashrc
if ! grep -q 'export PATH=$PATH:/home/$USER/.local/bin' ~/.bashrc; then
    echo 'export PATH=$PATH:/home/$USER/.local/bin' >> ~/.bashrc
    source ~/.bashrc
fi

# Install additional dependencies and Python requirements
cd ~/dev/minos/
sudo apt install -y libsdl2-dev
pip3 install -e . -r requirements.txt

echo "#######################################################################################################################"
echo ">> MINOS Installation Completed Successfully"
