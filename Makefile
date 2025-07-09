include .env

.PHONY:build clean test  deploy deploy-sepolia fund withdraw balance help

build:
	@forge build

clean:
	@forge clean

test:
	@forge test

deploy:
	@forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(RPC_URL) \
	--private-key $(PRIVATE_KEY) --broadcast -vvvv 
	
deploy-sepolia:
	@forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) \
	--private-key $(PRIVATE_KEY_SEPOLIA) --broadcast --verify \
	--etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

fund:
	@forge script script/Interactions.s.sol:FundFundMe --rpc-url $(RPC_URL) \
	--private-key $(PRIVATE_KEY) --broadcast -v

withdraw:
	@forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url $(RPC_URL) \
	--private-key $(PRIVATE_KEY) --broadcast -v

balance:
	@cast balance $(ACCOUNT_ADDRESS) --rpc-url $(RPC_URL) --ether

help:
	@echo "Available targets:"
	@echo "  build         - Build the project"
	@echo "  clean         - Clean build artifacts"
	@echo "  test          - Run tests"
	@echo "  deploy        - Deploy to custom RPC (e.g., local anvil)"
	@echo "  deploy-sepolia - Deploy to Sepolia with verification"
	@echo "  fund          - Fund the contract"
	@echo "  withdraw      - Withdraw from the contract"
	@echo "  balance       - Check balance of ACCOUNT_ADDRESS (default: $(ACCOUNT_ADDRESS))"
	@echo "                  Usage: make balance ACCOUNT_ADDRESS=0x<address>"
	@echo "  help          - Show this help message"

