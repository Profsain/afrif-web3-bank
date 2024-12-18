// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

contract SmartBankAccount {

    uint totalContractBalance = 0;

    function getContractBalance() public view returns(uint){
        return totalContractBalance;
    }

    // users balance mapping
    mapping(address => uint) balances;
    // timestemp
    mapping(address => uint) depositTimestemps;

    // add balance
    function addBalance() public payable  {
        require(msg.value > 0 , "balance must be greater than 0");

        balances[msg.sender] = msg.value;
        totalContractBalance += msg.value;
        depositTimestemps[msg.sender] = block.timestamp;
    }

    // get balance
    function getBalance(address _userAddress) public view returns (uint) {
        uint principal = balances[_userAddress];
        uint timeElapsed = (block.timestamp - depositTimestemps[_userAddress]);

        // simple interest of 0.07% per year
        return principal + uint((principal * 7 * timeElapsed) / (100 * 365 * 24 * 60 * 60)) + 1;
    }

    // withdraw fund
    function withdraw() public payable  {
        require(getBalance(msg.sender) >= msg.value , "insufficient balance");

        address payable  withdrawTo = payable(msg.sender);
        uint amountToTransfer = getBalance(msg.sender);
        withdrawTo.transfer(amountToTransfer);

        totalContractBalance = totalContractBalance - amountToTransfer;
        balances[withdrawTo] = 0;
    }

    // add money to contract
    function addMoneyToContract() public payable {
        totalContractBalance += msg.value;
    }
    
}
