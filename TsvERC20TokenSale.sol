// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.3/token/ERC20/ERC20.sol";

contract TsvERC20TokenSale is ERC20 {

    uint constant multipleOfFeeRequired = 0.001 ether;
    uint constant finney = 1e15;
    uint constant maxTokenSupply = 1000000;

    constructor() ERC20("TsvToken", "TSV") {}

    modifier isMultipleOfFee() {
        require(msg.value % multipleOfFeeRequired == 0);
        _;
    }

    uint private mintedAmount;

    function getMintedAmount() public view returns(uint) {
        return mintedAmount;
    }

    //TODO: I could remove the modified and let all the hell break loose
    function mint() isMultipleOfFee payable public {
        mintedAmount = msg.value/finney;        
        _mint(msg.sender, mintedAmount);
    }

    function withdraw(address payable to) public {        
        uint tokenBalance = balanceOf(msg.sender);
        _burn(msg.sender, tokenBalance);
        to.transfer(tokenBalance*finney);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override  {
        if(from == address(0)) {
            require(totalSupply() + amount < maxTokenSupply, "Cannot mint have more than 1 million tokens in circulation ");
        }
        super._beforeTokenTransfer(from, to, amount);
    }
}

/*
Partial Refund
Take what you did in assignment 4 and give the users the ability to transfer their tokens to the contract and receive 0.5 ether for every 1000 tokens they transfer. You should accept amounts other than 1,000 Implement a function sellBack(uint256 amount)
ERC20 tokens don’t have the ability to trigger functions on smart contracts. Users need to give the smart contract approval to withdraw their ERC20 tokens from their balance. See here: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol#L136
The smart contract should block the transaction if the smart contract does not have enough ether to pay the user.
Users can buy and sell as they please, but of course they lose ether if they keep doing so
If someone tries to mint tokens when the supply is used up and the contract isn’t holding any tokens, that operation should fail. The maximum supply should remain at 1 million
IMPORTANT: Be aware of integer division issues!

Token Sale
    Add a function where users can mint 1000 tokens if they pay 1 ether. Your contract should correctly handle amounts other than 1 ether.
    IMPORTANT: your token should have 18 decimal places as is standard in ERC20 tokens
    IMPORTANT: your total supply should not exceed 1 million tokens. The sale should close after 1 million tokens have been minted
    IMPORTANT: you must have a function to withdraw the ethereum from the contract to your address
*/