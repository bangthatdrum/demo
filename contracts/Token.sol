// SPDX-License-Identifier: unlicensed
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Token {
	string public name;
	string public symbol;
	uint256 public decimals = 18;
	uint256 public totalSupply; 

	mapping(address => uint256) public balanceOf;
	mapping(address => mapping(address => uint256)) public allowance;

	event Transfer(address indexed from, address indexed to, uint256 value);
	event Approval(address indexed owner, address indexed spender, uint256 value);

	constructor(
		string memory _name, string memory _symbol, uint256 _totalSupply) {
		name = _name;           
		symbol = _symbol;
		totalSupply = _totalSupply * (10**decimals);
		balanceOf[msg.sender] = totalSupply;
	}

	function _transfer(address _from, address _to, uint256 _value) internal returns (bool success) {
		balanceOf[_from] = balanceOf[_from] - _value;
		balanceOf[_to] = balanceOf[_to] + _value;
		emit Transfer(_from, _to, _value);
		return true;
	}

	function transfer(address _to, uint256 _value) public returns (bool success) {	
		require(_to != address(0), "Token: Invalid recipient address");	
		require(balanceOf[msg.sender] >= _value, "Token: Insufficient balance"); 
		_transfer(msg.sender, _to, _value);
		return true;
	}

	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
		//console.log(_from, _to, _value);
		require(_value <= balanceOf[_from], "Token: Insufficient balance");
		require(_value <= allowance[_from][msg.sender], "Token: Insufficient allowance"); // caller has approval to take money from _from
		allowance[_from][msg.sender] = allowance[_from][msg.sender] - _value;
		_transfer(_from, _to, _value);
		return true;
	}

	function approve(address _spender, uint256 _value) public returns (bool success) {
		require(_spender != address(0), "Token: Invalid spender");
		allowance[msg.sender][_spender] = _value;
		emit Approval(msg.sender, _spender, _value);
		return true;
	}

	function getBalanceOf(address _user) public view returns (uint256) {
		return balanceOf[_user];
	}
}
