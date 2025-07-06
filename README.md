# Foundry ERC20 Example

This repository demonstrates an ERC20 token project using [Foundry](https://github.com/foundry-rs/foundry), a fast, portable, and modular toolkit for Ethereum application development.

## Project Structure

- `src/` — Solidity contracts (including `OurToken.sol`)
- `test/` — Solidity tests using Forge
- `script/` — Deployment scripts
- `lib/` — External dependencies (OpenZeppelin, forge-std, etc.)

## Getting Started

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation) installed (`forge`, `anvil`, etc.)
- [Git](https://git-scm.com/) for cloning the repository

### Installation

Clone the repository and install dependencies:

```sh
git clone https://github.com/yourusername/Foundry-ERC20.git
cd Foundry-ERC20
forge install
```

### Build

```sh
forge build
```

### Test

```sh
forge test
```

### Format

```sh
forge fmt
```

### Gas Snapshots

```sh
forge snapshot
```

### Local Node

```sh
anvil
```

### Deploy

Update the deployment script and run:

```sh
forge script script/DeployOurToken.s.sol:DeployOurToken --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```sh
cast <subcommand>
```

## Documentation

- [Foundry Book](https://book.getfoundry.sh/)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts)

## License

MIT
