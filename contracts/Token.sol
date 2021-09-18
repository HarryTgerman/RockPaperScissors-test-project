pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor(address _alice, address _bob) ERC20("RPS Reward Token", "RPS") {
        _mint(msg.sender, 1000000 * 1e18);
        _mint(_alice, 10 * 1e18);
        _mint(_bob, 10 * 1e18);
    }
}
