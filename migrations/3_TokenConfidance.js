const TokenConfidance = artifacts.require("TokenConfidance");

module.exports = function(deployer) {
  deployer.deploy(TokenConfidance);
};