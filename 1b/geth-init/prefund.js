const from = eth.accounts[0];
const contractDeployer = "0xEA56b22c446A5fbEd33c231feCD42A1d78641119";
eth.sendTransaction({
  from: from,
  to: contractDeployer,
  value: web3.toWei(100, "ether"),
});

console.log("Successfully pre-funded 100 ETH to " + contractDeployer);

