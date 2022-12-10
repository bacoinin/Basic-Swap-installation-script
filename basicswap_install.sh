#!/bin/bash
set -e

# Set the location where the local nodes for the coins that will included in BasicSwap will be installed
SWAP_DATADIR=/var/data/coinswaps
echo "The path to the coins data dirs folder is $SWAP_DATADIR"

# Uncomment the two lines below if something went wrong and you want to start fresh installation
#$echo "Removing coins data dir folder (if any) to start from the scratch incase this is a re-run"
#rm -R -f $SWAP_DATADIR

echo "Installing dependencies for Whonix or other Debian based OSes. In case of other distros replace the package manager command with the appropriate one"
sudo apt-get install -y python3-venv python3-pip gnupg unzip protobuf-compiler automake libtool pkg-config curl jq git wget

echo "Creating coins data dir"
mkdir -p $SWAP_DATADIR

cd $SWAP_DATADIR

echo "Creating python virtual environment"
mkdir -p "$SWAP_DATADIR/venv"
python3 -m venv "$SWAP_DATADIR/venv"

source "$SWAP_DATADIR/venv"/bin/activate 
echo "The virtual environment uses $(python -V)"

echo "Fetching the coincurve library"
wget -O coincurve-anonswap.zip https://github.com/tecnovert/coincurve/archive/refs/tags/anonswap_v0.1.zip
unzip -d coincurve-anonswap coincurve-anonswap.zip
mv ./coincurve-anonswap/*/{.,}* ./coincurve-anonswap || true
#git clone -b anonswap https://github.com/tecnovert/coincurve.git $SWAP_DATADIR/coincurve-anonswap

echo "Building and installing the Coincurve library"
cd $SWAP_DATADIR/coincurve-anonswap
pip3 install .

echo "Cloning the Basic Swap DEX repo"
cd $SWAP_DATADIR
git clone https://github.com/tecnovert/basicswap.git

echo "Building and installing the Basic Swap DEX"
cd $SWAP_DATADIR/basicswap
protoc -I=basicswap --python_out=basicswap basicswap/messages.proto
pip3 install protobuf==3.20.*
pip3 install .

echo "Initializing the coins data directory $SWAP_DATADIR"
# Append --usebtcfastsync to the below command to optionally initialise the Bitcoin datadir with a chain snapshot from btcpayserver FastSync.
# e.g. basicswap-prepare --datadir=$SWAP_DATADIR --withcoins=monero,bitcoin,litecoin --xmrrestoreheight=$CURRENT_XMR_HEIGHT --usebtcfastsync

# Adjust --withcoins and --withoutcoins as desired to add or remove coins eg: --withcoins=monero,bitcoin. By default only Particl is loaded

# The line below installs all the currently supported coins 
CURRENT_XMR_HEIGHT=$(curl https://localmonero.co/blocks/api/get_stats | jq .height)
basicswap-prepare --datadir=$SWAP_DATADIR --withcoins=monero,bitcoin,litecoin,dash,pivx,firo --xmrrestoreheight=$CURRENT_XMR_HEIGHT --usebtcfastsync

echo "To start the Basic Swap DEX run the command below:"
echo "source $SWAP_DATADIR/venv/bin/activate && basicswap-run --datadir=$SWAP_DATADIR"
echo "!!!DO NOT FORGET TO WRITE DOWN THE 24 WORDS (RECOVERY PHRASE) PRINTED A FEW LINES ABOVE!!!"
