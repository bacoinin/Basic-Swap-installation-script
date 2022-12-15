#!/bin/bash
set -e

# Set the location where the local nodes for the coins that will included in BasicSwap will be installed
COINDATA_PATH=$HOME/coindata
echo "The path to the coins data dirs folder is $COINDATA_PATH"

# Uncomment the two lines below if something went wrong and you want to start fresh installation
#$echo "Removing coins data dir folder (if any) to start from the scratch incase this is a re-run"
#rm -R -f $COINDATA_PATH

echo "Installing dependencies for Whonix or other Debian based OSes. In case of other distros replace the package manager command with the appropriate one"
sudo apt-get install -y python3-venv python3-pip gnupg unzip protobuf-compiler automake libtool pkg-config curl jq git wget

echo "Creating coins data dir"
mkdir -p $COINDATA_PATH

cd $COINDATA_PATH

echo "Creating python virtual environment"
mkdir -p "$COINDATA_PATH/venv"
python3 -m venv "$COINDATA_PATH/venv"

source "$COINDATA_PATH/venv"/bin/activate 
echo "The virtual environment uses $(python -V)"

echo "Fetching the coincurve library"
wget https://github.com/tecnovert/coincurve/archive/refs/tags/anonswap_v0.1.tar.gz
tar -xf anonswap_v0.1.tar.gz
mv ./coincurve-anonswap_v0.1 ./coincurve-anonswap 
#git clone -b anonswap https://github.com/tecnovert/coincurve.git $SWAP_DATADIR/coincurve-anonswap

echo "Building and installing the Coincurve library"
cd $COINDATA_PATH/coincurve-anonswap
pip3 install .

echo "Cloning the Basic Swap DEX repo"
cd $HOME
git clone https://github.com/tecnovert/basicswap.git

echo "Building and installing the Basic Swap DEX"
cd $HOME/basicswap
protoc -I=basicswap --python_out=basicswap basicswap/messages.proto
pip3 install protobuf==3.20.*
pip3 install .

echo "Initializing the coins data directory $COINDATA_PATH"
# Append --usebtcfastsync to the below command to optionally initialise the Bitcoin datadir with a chain snapshot from btcpayserver FastSync.
# e.g. basicswap-prepare --datadir=$COINDATA_PATH --withcoins=monero,bitcoin,litecoin --xmrrestoreheight=$CURRENT_XMR_HEIGHT --usebtcfastsync

# Adjust --withcoins and --withoutcoins as desired to add or remove coins eg: --withcoins=monero,bitcoin. By default only Particl is loaded

# Example with only Litecoin and Dash 
#basicswap-prepare --datadir=$COINDATA_PATH --withcoins=litecoin,dash

# The line below installs all the currently supported coins 
CURRENT_XMR_HEIGHT=$(curl https://localmonero.co/blocks/api/get_stats | jq .height)
basicswap-prepare --datadir=$COINDATA_PATH --withcoins=monero,bitcoin,litecoin,dash,pivx,firo --xmrrestoreheight=$CURRENT_XMR_HEIGHT --usebtcfastsync

echo "To start the Basic Swap DEX run the command below:"
echo "source $COINDATA_PATH/venv/bin/activate && basicswap-run --datadir=$COINDATA_PATH"
echo "!!!DO NOT FORGET TO WRITE DOWN THE 24 WORDS (RECOVERY PHRASE) PRINTED A FEW LINES ABOVE!!!"
