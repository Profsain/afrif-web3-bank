// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// compound integration
interface cETH {
    
    // define functions of COMPOUND we'll be using
    
    function mint() external payable; // to deposit to compound
    function redeem(uint redeemTokens) external returns (uint); // to withdraw from compound
    
    //following 2 functions to determine how much you'll be able to withdraw
    function exchangeRateStored() external view returns (uint); 
    function balanceOf(address owner) external view returns (uint256 balance);
}

contract ArifBank {
    // total bank balance
    uint totalBankBalance = 0;

    // define COMPOUND 
     address COMPOUND_CETH_ADDRESS = 0xAec1F48e02Cfb822Be958B68C7957156EB3F0b6e;
    cETH ceth = cETH(COMPOUND_CETH_ADDRESS);

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

       // store the deposit time
       depositTimeStamp[msg.sender] = block.timestamp;

       // send eth to compount mint()
       ceth.mint{value: msg.value}();
    }

    // check any user balance
    function getBalance(address _userAddress) public view returns(uint) {
        // uint principal = balances[_userAddress];
        // uint timeElapsed = block.timestamp - depositTimeStamp[_userAddress];
        // //simple interest of 0.07%  per year
        // return principal + uint((principal * 7 * timeElapsed) / (100 * 365 * 24 * 60 * 60)) + 1; 
        return ceth.balanceOf(_userAddress) * ceth.exchangeRateStored() / 1e18;
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