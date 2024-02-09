require('@nomicfoundation/hardhat-toolbox')

// require("@nomiclabs/hardhat-ethers");\
async function main() {
    const [deployer] = await ethers.getSigners()

    console.log('Deploying contracts with the account:', deployer.address)

    const WENExchangeFactory = await ethers.getContractFactory('WENExchange')

    const WENExchangeDispenser = await WENExchangeFactory.deploy()

    console.log('WENExchange address:', await WENExchangeDispenser.getAddress())
}

main().catch((error) => {
    console.error(error)
    process.exitCode = 1
})
