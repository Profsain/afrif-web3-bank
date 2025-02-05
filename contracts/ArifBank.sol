// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract ArifBank {
    // total bank balance
    uint totalBankBalance = 0;

    // get the curretent total Bank balance
    function getTotalBankBalance() public  view returns(uint) {
        return totalBankBalance;
    }

    //mapping user address
    mapping(address => uint) balances;
    // deposit timestamp
    mapping(address => uint256) depositTimeStamp;

    // deposit amount to user address and update totalBankBalance
    function deposit() public  payable {
       balances[msg.sender] = msg.value;

       // update total bank balance
       totalBankBalance += msg.value; 
    }

    // check any user balance
    function getBalance(address _userAddress) public view returns(uint) {
        uint principal = balances[_userAddress];
        uint timeElapsed = block.timestamp - depositTimeStamp[_userAddress];
        //simple interest of 0.07%  per year
        return principal + uint((principal * 7 * timeElapsed) / (100 * 365 * 24 * 60 * 60)) + 1; 
    }

    // handle withdrawel by user
    function withdrawal() public payable {
        // get the user address to pay to
        address payable withdrawTo = payable(msg.sender);
        // get the user current balance
        uint amountToTransfer = getBalance(msg.sender);
        // transfer the amount to user 
        withdrawTo.transfer(amountToTransfer);
        // remove the transfered amount from total bank balance
        totalBankBalance = totalBankBalance - amountToTransfer;
        // set user balance to 0
        balances[msg.sender] = 0;
    }

    // add money to pay the interest on deposit
    function addMoneyToContract() public payable {
        totalBankBalance += msg.value;
    }
}