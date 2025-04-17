
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IERC20 {
    // RETURN TOTAL SUPPLY OF TOKEN
    function totalSupply() external view returns (uint256);
    // RETURNS TOTAL BALANCE OF TOKEN
    function balanceOf(address account) external view returns (uint256);
    // TRASFERS TOKEN FROM CALLER/SENDER TO RECIPINET
    function transfer(address recipient, uint256 amount) external returns (bool);
    // ALLOWS SPENDER TO TRANSFER TOKENS FROM SENDER TO RECIPIENT
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    // APPROVES SPENDER TO SPEND A SPECIFIED AMOUNNT
    function approve(address spender, uint256 amount) external returns (bool);
    // RETURNS AMOUNT A SPENDER IS ALLOWED TO SPEND FROM AN OWNER OWNERS BALANCE
    function allowance(address owner, address spender) external view returns (uint256);
    // NAME OF TOKEN
    function _name() external view returns (string memory);
    // SYMBOL OF TOKEN
    function symbol() external view returns (string memory);
// 0x9e472aa63452dd0f1410C8AeD6eC5aE8888Dd3f2/

    // Token Decimal
    event Transfer(address indexed from, address indexed to, uint256 value );
    event Approval(address indexed owner, address indexed spender, uint256 amount);
}



contract ERC20Token is IERC20{
    
    string public name;
    string private _symbol;
    uint8 public decimals;
    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor(uint256 initialSupply, string memory TokenName, string memory TokenSymbol, uint8 tokenDecimals) {
         decimals = tokenDecimals;
        _totalSupply = initialSupply * 10 ** uint256(decimals);
        _balances[msg.sender] = _totalSupply;
        name = TokenName;
        _symbol = TokenSymbol;

        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function _name() external  view returns (string memory) {
    return name;
    }

    function symbol() external override  view returns (string memory) {
    return _symbol;
    }

   function totalSupply() external override  view returns (uint256){
    return _totalSupply;
   }

   function transfer(address recipient, uint256 amount) external override  returns (bool){
    _transfer(msg.sender, recipient, amount);
         return true;
   }

       function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool){
         _transfer(sender, recipient, amount);

         uint256 currentAllowance = _allowances[sender][msg.sender];
         require(currentAllowance >= amount, "ERC20:TRANSFER FROM ALLOWANCE MUST BE LESS THAN AMOUNT SEND");
         _approveToken(sender, msg.sender, currentAllowance - amount);
         return true;
       }

   function _transfer(address sender, address recipient, uint256 amount) internal{
    require(sender != address(0), "ERC20: TRANSFER FROM ZERO ADDRESS IS NOT VALID");
    require(recipient != address(0), "ERC20: TRANSFER FROM ZERO ADDRESS IS NOT VALID");
    require(_balances[sender] >= amount, "ERC20: TRANSFER FROM AMOUNT= address(0)");
    _balances[sender] -= amount;
    _balances[recipient] += amount;
    emit Transfer(sender, recipient, amount);
   }

   
   function balanceOf(address account) external override view returns (uint256){
    return _balances[account];
   }

   function approve(address spender, uint256 amount) external override  returns (bool){
    _approveToken(msg.sender, spender, amount);
    return true;
   }

   function _approveToken(address owner, address spender, uint256 amount) internal{
    require (owner != address(0), "ERC20: APPROVAL FROM ZERO ADDRESS IS NOT VALID");
  require (spender != address(0), "ERC20: TRANSFER TO AMOUNT ADDRESS");
   _allowances[owner][spender] = amount;
   emit Approval(owner, spender, amount);
   }

    function allowance(address owner, address spender) external override  view returns (uint256){
        return _allowances[owner][spender];
    }


}