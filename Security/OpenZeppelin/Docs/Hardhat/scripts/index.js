const { ethers } = require("hardhat");

async function main() {
  const accounts = await ethers.provider.listAccounts();

  console.log(accounts);

  const address = '0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512'; //will be reset
  const Box = await ethers.getContractFactory("Box");
  const box = await Box.attach(address);

  await box.store('42');

  const value = await box.retrieve();
  console.log('Box value is', value.toString());

  await box.store('23');

  const updatedVal = await box.retrieve();
  console.log("Box value is:", updatedVal.toString());
}

main()
  .then(() => process.exit(0))
  .catch(err => {
    console.error(err);
    process.exit(1);
  });