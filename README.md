# Basic-Swap-installation-script
This is a Basic Swap DEX installation script without docker. Its based on the instructions provided on:
https://academy.particl.io/en/latest/basicswap-guides/basicswapguides_installation.html#install-without-docker, so instead of running the commands one by one, you can simply run this script once. 

In order to do so, you need to open a terminal and:

1. Run `wget https://raw.githubusercontent.com/bacoinin/Basic-Swap-installation-script/main/basicswap_install.sh` to download the bash script file
2. Run the following command `chmod +x basicswap_install.sh` to make the script executable.
3. Execute the script by running `./basicswap_install.sh`

NB! When the script terminastes make sure that you write down the recovery phrase that will be printed out!!!

This installation script installs all the currently supported coins Particl, Bitcoin, Litecoin, Monero, Dash, Pivx, Firo and requires at least 100 GB of disk space. Incase you need only a subset of the coins, edit the line 58 in the downloaded bash script according to the instructions provided on the lines 48-54 
