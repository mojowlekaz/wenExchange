// execute.js

const { ethers } = require('ethers')

const INFURA_KEY = '9c4d37d7dd984bb2b652d085e142ddf5'
const PRIVATE_KEY = '74575ba404901e7dbaf30578fb6706d08fe2e6781e5438f0a95c5e0ec2ce487b'

const BlastBridgeAddress = '0xc644cc19d2A9388b71dd1dEde07cFFC73237Dca8'

// Providers for Sepolia and Blast networks
const sepoliaProvider = new ethers.providers.JsonRpcProvider(`https://sepolia.infura.io/v3/${INFURA_KEY}`)
const blastProvider = new ethers.providers.JsonRpcProvider('https://sepolia.blast.io')

// Wallet setup
const wallet = new ethers.Wallet(PRIVATE_KEY)
const sepoliaWallet = wallet.connect(sepoliaProvider)
const blastWallet = wallet.connect(blastProvider)

// Transaction to send 0.1 Sepolia ETH
const tx = {
    to: BlastBridgeAddress,
    value: ethers.utils.parseEther('0.1'),
}

async function executeTransaction() {
    const transaction = await sepoliaWallet.sendTransaction(tx)
    await transaction.wait()

    // Confirm the bridged balance on Blast
    const balance = await blastProvider.getBalance(wallet.address)
    console.log(`Balance on Blast: ${ethers.utils.formatEther(balance)} ETH`)
}

executeTransaction()
