const Box = artifacts.require("Box");

module.exports = async function (deployer) {
  deployer.deploy(Box);
}