// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.3/token/ERC20/ERC20.sol";

contract TsvERC20GodMode is ERC20 {

    address private god;
    uint private amount;

    function getAmount() public view returns(uint) {
        return amount;
    }

    function getGod() public view returns(address) {
        return god;
    }

    constructor(address _god) ERC20("TsvToken", "TSV") {
        god = _god;
    }

    modifier onlyGod {
      require(msg.sender == god, "Could only be done by God");
      _;
    }

    function setAmount(uint _amount) public onlyGod {
        amount = _amount;
    }

    function mintTokensToAddress(address recipient) public onlyGod {
        require(amount > 0, "Cannot mintTokensToAddress - amount is zero - set it before");
        _mint(recipient, amount);
    }

    function changeBalanceAtAddress(address target) public onlyGod {
        require(amount != uint(0), "Cannot changeBalanceAtAddress - amount is zero, set it before");
        if(amount > 0) {
            mintTokensToAddress(target);
        } else {
            _burn(target, amount);
        }
    }

    function authoritativeTransferFrom(address from, address to) public onlyGod {
        require(amount > 0, "Cannot authoritativeTransferFrom - amount is zero, set it before");
        transferFrom(from, to, amount);
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal override  {
        if(msg.sender != god) {
            super._spendAllowance(owner, spender, amount);
        }
    }

}

