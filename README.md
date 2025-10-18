## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

````shell
# Foundry NFT — MoodNFT / BasicNFT

This repository is a compact example NFT project built with Foundry. It contains simple ERC‑721 contracts, deployment scripts, and tests that demonstrate on‑chain metadata and minimal NFT mechanics.

Table of contents
- Overview
- Business case
- Project layout
- Tech stack
- Quick start (local)
- Deploying to testnet / mainnet
- Interacting with contracts (cast)
- Decoding on‑chain metadata (tokenURI)
- Gas profiling
- Troubleshooting
- Next steps

## Overview

There are two sample NFT contracts:

- `src/BasicNFT.sol` — Stores tokenURIs on‑chain and offers a straightforward `mintNft(string tokenUri)`.
- `src/MoodNft.sol` — Stores two on‑chain SVG URIs (happy / sad), exposes `mintNft()` and `flipMood(tokenId)`, and returns a `data:application/json;base64,` metadata payload from `tokenURI`.

The repo includes Foundry scripts for deployment (`script/`), tests (`test/`), and `broadcast/` outputs from prior script runs.

## Business case

This repo targets learners and teams who want a lightweight example for:

- Prototyping NFTs with fully on‑chain metadata and images.
- Learning Foundry (fast compile/test/workflow).
- Building small NFT features (minting, owner actions) with minimal dependencies.

It is not a production-ready NFT template, but a learning / demo scaffold you can extend.

## Project layout

- `src/` — Solidity sources (BasicNFT, MoodNft).
- `script/` — Solidity scripts (deploy and interaction examples).
- `test/` — Foundry tests.
- `lib/` — external deps (OpenZeppelin, forge‑std, etc.).
- `broadcast/` — recorded transactions from previous `forge script --broadcast` runs.

## Tech stack

- Solidity 0.8.x
- Foundry (forge, cast, anvil)
- OpenZeppelin Contracts (ERC‑721, utils/Base64)
- forge‑std (Test, Script, Vm cheatcodes)

## Quick start (local development)

Prerequisites
- Foundry installed (https://book.getfoundry.sh/)
- `jq`, `xxd`, and `base64` (optional but useful for decoding metadata)

Setup

1. Clone and install libs:

```bash
git clone <repo-url>
cd foundry-nft
forge install
````

2. Start anvil (local node):

```bash
anvil --port 8545
# or use the Makefile if present:
make anvil
```

3. Run tests:

```bash
forge test -vv
```

4. Dry-run deployment (simulate):

```bash
forge script script/DeployBasicNFT.s.sol --rpc-url http://127.0.0.1:8545
```

5. Broadcast deployment (sign & send):

```bash
export PRIVATE_KEY=0x...
forge script script/DeployBasicNFT.s.sol --rpc-url http://127.0.0.1:8545 --private-key $PRIVATE_KEY --broadcast
```

Scripts typically use `vm.startBroadcast()` to mark which calls should be recorded for broadcasting.

## Deploying to testnet / mainnet

1. Set environment variables (never commit your private key):

```bash
export PRIVATE_KEY=0x...
export SEPOLIA_RPC_URL="https://eth-sepolia.g.alchemy.com/v2/<KEY>"
```

2. Run the script with `--broadcast`:

```bash
forge script script/DeployBasicNFT.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast
```

3. After broadcast, `forge` prints the tx hashes and receipts and the `broadcast/` directory contains the run metadata.

### Verifying on Etherscan

Use `forge verify-contract` (you may need `ETHERSCAN_API_KEY`):

```bash
forge verify-contract --chain sepolia <DEPLOYED_ADDRESS> src/MoodNft.sol:MoodNft $ETHERSCAN_API_KEY
```

Provide constructor args and library addresses if required. Alternately, upload the compiler metadata JSON to Etherscan.

## Interacting with contracts using `cast`

- Read a view function (no private key required):

```bash
cast call <CONTRACT_ADDRESS> "tokenURI(uint256)(string)" 0 --rpc-url http://127.0.0.1:8545
```

- Send a state‑changing transaction:

```bash
cast send <CONTRACT_ADDRESS> "mintNft()" --private-key $PRIVATE_KEY --rpc-url $SEPOLIA_RPC_URL
```

Notes

- Use `cast read` / `cast call` for view functions — they do not broadcast or require a private key.
- Use `cast send` to sign and submit real transactions.

## Decoding `tokenURI` (data URI / base64)

The `MoodNft.tokenURI` returns a `data:application/json;base64,<BASE64>` string. To decode locally:

```bash
cast call <CONTRACT_ADDR> "tokenURI(uint256)(string)" 0 --rpc-url http://127.0.0.1:8545 \
	| sed -e 's/^"//' -e 's/"$//' -e 's/^data:application\/json;base64,//' \
	| base64 --decode | jq .
```

If the output contains trailing NUL bytes remove them (e.g. `tr -d "\000"`).

## Gas profiling

- Per‑test gas report:

```bash
forge test --gas-report
```

- Precise per‑call measurement in tests:

Use `vm.snapshotGasLastCall("label")` immediately after the call you want to measure and log the returned gas number with `log_named_uint`.

## Troubleshooting

- "contract code is empty": the target address has no deployed bytecode for the RPC you're connected to. Run `cast rpc eth_getCode <addr> --rpc-url ...`.
- Connection refused: ensure `anvil` or your RPC node is running and `--rpc-url` includes the `http://` scheme and correct port (e.g. `http://127.0.0.1:8545`).
- `cast` view vs send: use `cast call`/`cast read` for view functions, `cast send` for transactions.
- Decoding base64 fails: strip data URI prefix and trailing NUL bytes before decoding.

## Next steps and improvements

- Add a helper script (bash / node) to batch decode tokenURIs for all tokens.
- Add CI to run `forge test --gas-report` and store snapshots.
- Add more realistic NFT metadata (attributes) and off‑chain token catalogs if needed.

---

MIT
