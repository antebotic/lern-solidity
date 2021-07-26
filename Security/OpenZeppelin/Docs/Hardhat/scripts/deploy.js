async function main () {
  const Box = await ethers.getContractFactory("Box");
  console.log("Deploying Box...");

  const box = await Box.deploy();
  await box.deployed();

  console.log("Box deployed to:", box.address);
}

main()
  .then(() => process.exit(0))
  .catch(err => {
    console.error(err);
    process.exit(1);
  })