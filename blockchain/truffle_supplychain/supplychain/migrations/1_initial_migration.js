const Migrations = artifacts.require("Migrations");
const Supplychain = artifacts.require("Supplychain");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(Supplychain);
};
