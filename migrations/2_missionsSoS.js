const MissionsSoS = artifacts.require("MissionsSoS");

module.exports = function(deployer) {
  deployer.deploy(MissionsSoS);
};
