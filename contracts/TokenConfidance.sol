pragma solidity  >=0.5.16 <0.7.0;

import "./Context.sol";
import "./SafeMath.sol";

//Utilizando https://github.com/OpenZeppelin/openzeppelin-contracts/releases/tag/v2.4.0

contract TokenConfidance is Context {

    using SafeMath for uint256;

    mapping (address => uint256) private balanceMap;

    mapping (address => mapping (address => uint256)) private allowanceMap;

    uint256 private _totalSupply;

    function totalSupply() public view returns (uint256){
        return _totalSupply;
    }

    function balanceOf(address _account) public view returns (uint256) {
        return balanceMap[_account];
    }

    function transfer(address _recipient, uint256 _amount) public returns (bool) {
        _transfer(_msgSender(), _recipient, _amount);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowanceMap[_owner][_spender];
    }

    function approve(address _spender, uint256 _amount) public returns (bool) {
        _approve(_msgSender(), _spender, _amount);
        return true;
    }

    function transferFrom(address _sender, address _recipient, uint256 _amount) public returns (bool) {
        _transfer(_sender, _recipient, _amount);
        _approve(_sender, _msgSender(), allowanceMap[_sender][_msgSender()].sub(_amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool) {
        _approve(_msgSender(), _spender, allowanceMap[_msgSender()][_spender].add(_addedValue));
        return true;
    }

    function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool) {
        _approve(_msgSender(), _spender, allowanceMap[_msgSender()][_spender].sub(_subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function _transfer(address _sender, address _recipient, uint256 _amount) internal {
        require(_sender != address(0), "ERC20: transfer from the zero address");
        require(_recipient != address(0), "ERC20: transfer to the zero address");

        balanceMap[_sender] = balanceMap[_sender].sub(_amount, "ERC20: transfer amount exceeds balance");
        balanceMap[_recipient] = balanceMap[_recipient].add(_amount);
        emit Transfer(_sender, _recipient, _amount);
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    function _mint(address _account, uint256 _amount) internal {
        require(_account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(_amount);
        balanceMap[_account] = balanceMap[_account].add(_amount);
        emit Transfer(address(0), _account, _amount);
    }

    function _burn(address _account, uint256 _amount) internal {
        require(_account != address(0), "ERC20: burn from the zero address");

        balanceMap[_account] = balanceMap[_account].sub(_amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(_amount);
        emit Transfer(_account, address(0), _amount);
    }

    function _approve(address _owner, address _spender, uint256 _amount) internal {
        require(_owner != address(0), "ERC20: approve from the zero address");
        require(_spender != address(0), "ERC20: approve to the zero address");

        allowanceMap[_owner][_spender] = _amount;
        emit Approval(_owner, _spender, _amount);
    }

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, _msgSender(), allowanceMap[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
    }

}
