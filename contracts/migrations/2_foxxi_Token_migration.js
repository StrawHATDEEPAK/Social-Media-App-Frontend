const NotesContract = artifacts.require("FoxxiToken");

module.exports = function (deployer) {
  deployer.deploy(NotesContract,300000000000,100000000000);
};
