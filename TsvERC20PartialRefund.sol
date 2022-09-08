// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./TsvERC20TokenSale.sol";

contract TsvERC20PartialRefund is TsvERC20TokenSale {
    constructor() TsvERC20TokenSale() {}
    
    uint constant multipleOfEtherTransferable = 0.0005 ether; // for every 1 token
    uint public withdrawing;

    function sellBack(uint256 amount) public {
        approve(address(this), amount);        
        // check if smart contract has enough ether to pay
        require(address(this).balance >= amount*multipleOfEtherTransferable, "Not enough ether in the contract to sellBack tokens to it");
        // transfer tokens from msg.sender to address(this)
        transferFrom(msg.sender, address(this), amount);
        // transfer ether from contract balance to msg.sender
        payable(msg.sender).transfer(amount*multipleOfEtherTransferable);

        // 1000 - 0.5 ether, 
        // 100 - 0.05 ether, 
        // 10 - 0.005 ether, 
        // 1 - 0.0005 ether
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
*/