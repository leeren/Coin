# YELPCOIN README
Author of this instructional guide: Leeren Chang (~leeren)

## INSTALLATION AND REQUIREMENTS

### GETH (Go-based Ethereum Client) [MAX OS X]

This is the most popular Ethereum node client.
These client tools are composed of a CLI, JSON-RPC server (for web3 communication), and console/

1. Upgrade and update brew: `brew update && brew upgrade` 
2. Install ethereum tap: `brew tap ethereum/ethereum && brew install ethereum`

Note for a list of all commands / options involving geth, just type in `geth --help`.

### Solidity (Smart-contract programming language for Ethereum)

1. Install solidity: `brew install solidity`

### Joining Network [GETH]

For all of us to join the same network, we must have the same genesis JSON file and same network id.
With this, Geth can via node-discovery RPC protocol connect to the YelpCoin network and discover peers.

- What is the genesis JSON file?
  This is a JSON file that defines the configurations for your blockchain. 
  We all require the same genesis JSON file (along with network ID) to connect with each other.

  Here is a brief description of parameters used in our case:
  - `config.chainId`: Used to prevent replay attacks. ETH and ETC (Ethereum classic) used to have same networkID, so this was added.
  - `config.homesteadBlock`: Version 0 means we are using the newest Ethereum release version which is called Homestead.
  - `config.eip155Block`: Defaults to 0 meaning we do not hard-fork from the initial proposal described by this EIP.
  - `config.eip158Block`: Defaults to 0 meaning we do not hard-fork from the initial proposal described by this EIP.
  - `coinbase`: 160-bit default address where mining reward gets credited to.
  - `difficulty`: `nonce` difficulty level used when mining. The higher this is the longer blocks take to be generated.
  - `extraData`: Optional field to store extra stuff.
  - `gasLimit`: Tx cost = gasPrice x gasLimit. gasLimit = max transaction expenditure. 21000 is the standard.
  - `nonce": 64-bit hash combined with "mixhash` to be used for PoW calculations. For genesis.json this just helps make file unique.
  - `mixhash`: 256-bit hash that is used for PoW validation as mentioned above. For genesis.json this just helps make file unique.
  - `timestamp`: Time of creation of the genesis block (which is what genesis.json settings describe).
  - `alloc`: Here we pre-allocate a certain about of ethereum to a given address for testing purposes.

- What is the network ID?
    This helps identify what blockchain network we are on. 1 for example is the Ethereum mainnet. 
    For YelpCoin, we will use network ID 8777679 (arbitrary - first six digits of Yelp biz phone number).

1. Create a DB that utilizes the YelpCoin genesis block: `geth --datadir ~/.ethereum_private init genesis.json`
   You can replace `ethereum_private` with whatever directory you want.
2. Start or connect to the network using the directory data and network id: 
   `geth --ipcpath ~/Library/Ethereum/geth.ipc --datadir ~/.ethereum_private --cache 512 --networkid 8777679 console`
3. If you want, you can create another terminal window to access the node using `geth attach`

Refer to the commands section for displaying node information.

### Deplyoing a smart contract [GETH] (using JS console)
1. Compile your solidity file into a single JSON file that includes the solidity binary file as well as ABI (for EVM machine code to solidity translation) using the following command:
`solc --optimize --combined-json abi,bin,interface SRC.sol`
2. Load this JSON file as an  JS variable. To do this, just save the variable assignment as a separate javascript variable and load it in the console itself:
`echo "var json=`solc --optimize --combined-json abi,bin,interface SRC.sol`" > json.js`
(console) `loadscript("/path/to/json.js")`
3. Load the contract (sort of like a factory object) from the specific contract ABI from the combined JSON output:
(console) `var contractFactory = eth.contract(JSON.parse(json.contracts["SRC.sol:greeter"].abi))`(here contract is the individual contract name being loaded from your original solidity file)
4. Load the compiled solidity binary as this is also needed for deployment
(console) `var contractCompiled = "0x" + json.contracts["SRC.sol:contract"].bin`


### dApp setup

1. `npm install -g truffle` (easier contract monitoring / deployment with npm)
2. `truffle unbox DOkwufulueze/eth-vue`
### SETTING UP MULTIPLE NODES ON SAME HOST (you can skip this)
Ensure each node initializes with the same genesis and runs with a distinct:
- Data Directory: Specified by `--datadir DIRECTORY` when running geth
- Network Port: Specified by `--port PORT` (default 30303) when running geth
- RPC Port: Specified by `--rpcport RPCPORT` (default 8545) when running geth

## USEFUL COMMANDS

### Must-know geth commands

**List all peers associated with your node**
`admin.peers`

**Get node URL (required for p2p establishment)**
`admin.nodeInfo.enode` - copy this down since we will need it to connect with each other

**Create account (remember this passphrase)**
`personal.newAccount("PASSWORD")`

**Display all accounts**
`eth.accounts`

**Get default session account (this is where your mining rewards move to)**
`eth.coinbase`

### DApp API Namespaces Overview (GETH):
-eth
-shh (Whisper - broadcasting messaging API)
-web3 (Ethereum Javascript API which utilizes RPC calls)
-admin (RPC management of Geth instance, including peer and RPC endpoint management)
-debug (runtime inspection)
-miner (control mining operations and settings)
-personal (manages your private keys)
-txpool (look at transaction pool)
