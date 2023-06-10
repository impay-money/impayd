# this is secret. Please chage it when intalling full node.
# should be changed
PASSWORD=${PASSWORD:-12345678} 
# chain id to replace genesis file with existing one.
# must be correct chain id equal to gitup folder name under networks repository.
CHAIN_ID=${CHAIN_ID:-impay-testnet}
# give any key name for full node name. This will be visible at block explorer as a validator name. 
# should be changed. If no changes, you can change it at config.toml file with moniker name.
MONIKER=${MONIKER:-node002}
# configuration file names. no need to change
FILENAME=${FILENAME:-"$HOME"/.impayd/config/genesis.json}
CONFIG=${CONFIG:-"$HOME"/.impayd/config/config.toml}  

rm -rf ~/.impayd

impayd init --chain-id "$CHAIN_ID" "$MONIKER"

rm -rf "$HOME"/networks

git clone https://github.com/impay-money/networks.git "$HOME"/networks

SOURCE_GENESIS="$HOME"/networks/"$CHAIN_ID"/genesis.json

result=$(stat $SOURCE_GENESIS)
if [ $? -ne 0 ]; then
  echo "Error: genesis file not found"
  exit 1
fi 

cp -rf $SOURCE_GENESIS $FILENAME 

PERSISTENT_PEERS_PATH="$HOME"/networks/"$CHAIN_ID"/persistent_peers

result=$(stat $PERSISTENT_PEERS_PATH)
if [ $? -ne 0 ]; then
  echo "Error: genesis file not found"
  exit 1
fi   

PERSISTENT_PEERS=$(cat $PERSISTENT_PEERS_PATH)

# making 1 sec block time.
sed -i 's/timeout_commit = "5s"/timeout_commit = "1s"/' $CONFIG
sed -i "s/persistent_peers = \"\"/persistent_peers = \"$PERSISTENT_PEERS\"/" $CONFIG

echo "NOTICE !!!!!"

echo "Chain is starting. Node will be synchronized with name " $MONIKER
echo "Follow belowing step."
echo "1. Execute create_wallet.sh to create wallet. Please backup your mnemonic words"
echo "2. Execute create_validator.sh to become validator node."

echo "After chain start and being syched, then stop the program."
echo 'Use "nohup impayd start &" to run process at background. '
echo "Enjoy !!!!!!!!!"

sleep 5

impayd start

