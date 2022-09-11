// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.3/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.7.3/access/Ownable.sol";

contract TsvERC20Sanctions is ERC20, Ownable {
    
    mapping (address => bool) private blackList;
    constructor() ERC20("TsvToken", "TSV") { }

    function putAddressInBlackList(address luckyGuy) external onlyOwner {
        blackList[luckyGuy] = true;
    }
    function getBlackListValue(address to_check) external view returns(bool) {
        return blackList[to_check];
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(blackList[from] == false && blackList[to] == false, "from or to address is in the blackList");
        super._beforeTokenTransfer(from, to, amount);
    }
}

/*
ERC20 with sanctions
    Add the ability for a centralized authority to prevent sanctioned addresses from sending or receiving the token.
    Hint: what is the appropriate data structure to store this blacklist?
    Hint: make sure only the centralized authority can control this list!
    Hint: study the function here: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol#L358
*/
