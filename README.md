# MINOS-Simulator
Installation guidelines for Multimodal Indoor Simulator (MINOS), it is designed to support the development of multisensory models for goal-directed navigation in complex indoor environments. MINOS leverages large datasets of complex 3D environments and supports flexible configuration of multimodal sensor suites.

> ### Disclaimer:
>
> The code and materials provided in this repository are not owned by me. They are sourced from various external contributors, publicly available resources, or other repositories. All credit for the original
> work goes to the respective authors and contributors. I do not claim any ownership or rights over the code and materials within this repository.
> If you are the rightful owner of any content and wish to have it removed or properly attributed, please contact me, and I will address your concerns promptly.

> ### Original Source:
> MINOS-Simulator: https://minosworld.github.io/
## Installation Guidelines:
This has been tested on Ubuntu 20.04 only. There are two ways to install and setup MINOS on your local device.

### Bash-script Installation:
### Manual Script-by-Script Installation:
```
 sudo apt-get update && sudo apt-get upgrade
```
## Installation Python Version & Dependencies:
```
sudo apt install python3-pip
sudo apt install python2.7-dev
```
```
sudo apt-get install python3-tk && sudo apt-get install build-essential libxi-dev libglu1-mesa-dev libglew-dev libopencv-dev libboost-all-dev libglib2.0-dev
```
We need to install libvips separately, since if we run the ```sudo apt install libvips``` command; it installs libvips42 instead of libvips.
```
cd ~/dev/
wget https://github.com/libvips/libvips/releases/download/v8.5.5/vips-8.5.5.tar.gz
```
Extract the package and remove the downloaded tar.gz afterwards:
```
tar -xzvf vips-8.5.5.tar.gz
rm vips-8.5.5.tar.gz
mv vips-8.5.5 libvips
```
```
cd libvips/
sudo apt-get update
```
```
chmod +x configure
./configure
make
sudo make install
````
## Installation of minos:
```
cd ~/dev/
git clone --branch v0.7.x https://github.com/minosworld/minos.git
cd ~/dev/minos/
git checkout v0.7.x
```
```
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.7/install.sh | bash
source ~/.bashrc
```
```
nvm install v10.13.0
nvm alias default 10.13.0
```
```
cd minos/server/
npm config set python /usr/bin/python2.7
```
This command might take upto to a hour to complete. Be patience if it feels like its stuck.
```
npm install node-gyp@3.8.0 bufferutil@4.0.1 utf-8-validate@5.0.2
```
> Warning: Do not run the "npm audit fix" command, it will mess up the installed dependencies.

## Install Python Requirements:
First, we will install socketIO-client-2
```
cd ~/dev/minos/
```
> If already installed, and signs of corruption: ```pip3 uninstall socketIO-client-2 -y```

```
git clone https://github.com/msavva/socketIO-client-2
cd socketIO-client-2
pip3 install -e .
rm -rf socketIO_client_2.egg-info
```
```
gedit ~/.bashrc
```
Paste this at the end of file: ```export PATH=$PATH:/home/user/.local/bin```
After saving the file, run the following command to update:
```
source ~/.bashrc
```
```
cd ..
sudo apt install libsdl2-dev
pip3 install -e . -r requirements.txt
```
## Download Matterport3D Dataset
Request and download the [Matterport3D](https://niessner.github.io/Matterport/) datasets. Please indicate "use with MINOS simulator" in your request email. 
To download the Matterport3D data, use the invocation as follow with the provided download script.
```
download_mp.py --task_data minos -o .
```
This will download a 5.1GB zip archive which expands to approximately 6.3GB.

After download, extract the mp3d_minos.zip file to $HOME/work/ directory.
```
sudo apt install unzip
unzip /PATH/to/mp3d_minos.zip -d $HOME/work/
```
### Test MINOS by running matterport3d dataset
```
python3 -m minos.tools.pygame_client --dataset mp3d --scene_ids 17DRP5sb8fy --env_config pointgoal_mp3d_s
```

