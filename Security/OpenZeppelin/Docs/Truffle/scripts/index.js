module.exports = async function main (callback) {
  try{
    const accounts = await web3.eth.getAccounts();
    console.log(accounts)

    const Box = artifacts.require("Box");
    const box = await Box.deployed();

    const value = await box.retrieve();
    console.log("Box value is", value.toString());

    await box.store(23);

    const value2 = await box.retrieve();
    console.log("Box value is", value2.toString());


    callback(0)
  } catch(err) {
    console.error(err);
    callback(1)
  }
}