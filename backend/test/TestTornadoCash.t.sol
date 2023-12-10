// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
// import "../src/Hasher.sol";

import "../src/IWETH9.sol";
import "../src/IFlashLoanReceiver.sol";


contract Tester is Test {
    Bank public bank;
    B public b;
    WETH  weth;

    function setUp() public {
        weth = new WETH();
        bank = new Bank(payable(address(weth)));

        b = new B(payable(address(weth)), payable(address(bank)));
        


    }

    function testFlow() external {
        deal(address(bank), 100 ether);
        deal(address(bank), 2 ether);
        deal(address(weth), address(b), 2 ether);

        b.callFlashLoan(1 ether);
    }

}

contract    B {


  address payable weth;
  address payable tsunami;
  Bank immutable itsunami;

  constructor(address payable _weth, address payable _tsunami){
    weth = _weth;
    tsunami = _tsunami;
    itsunami = Bank(tsunami);
  }
 

   function callFlashLoan(uint amount) external{
        itsunami.executeFlashLoanSimple(address(this), amount);
   }

  function executeOperation(
    uint256 amount,
    uint256 fee,
    address initiator
  ) external returns (bool){

    IWETH9(weth).approve(tsunami, amount+fee);

    return true;

  }


}
contract Bank {

address payable weth;

  constructor(address payable _weth ){
    weth = _weth;
  }

    function executeFlashLoanSimple(
        address receiverAddress,
        uint256 amount
    ) external {

        IFlashLoanReceiver receiver = IFlashLoanReceiver(receiverAddress);
        uint256 fee =  1;
        IWETH9(weth).deposit{value: amount}();
        IWETH9(weth).transfer(receiverAddress, amount);

        // require(
        receiver.executeOperation(
            amount,
            fee,
            msg.sender
        );
        // "INVALID_FLASHLOAN_EXECUTOR_RETURN"
        // ); 

        uint256 amountPlusPremium = amount + fee;

        IWETH9(weth).transferFrom(
            receiverAddress,
            address(this),
            amountPlusPremium
        );
        
        IWETH9(weth).withdraw(amountPlusPremium);
        // (bool ok, ) = relayer.call{value: fee}("");
        // require(ok, "Something went wrong");
        

    }

    fallback() external payable {}
}

/**
 *Submitted for verification at Etherscan.io on 2023-03-14
*/

// File: contracts/mocks/WETH.sol


// solhint-disable
contract WETH {
    string public name     = "Wrapped Ether";
    string public symbol   = "WETH";
    uint8  public decimals = 18;

    event  Approval(address indexed src, address indexed guy, uint wad);
    event  Transfer(address indexed src, address indexed dst, uint wad);
    event  Deposit(address indexed dst, uint wad);
    event  Withdrawal(address indexed src, uint wad);

    mapping (address => uint)                       public  balanceOf;
    mapping (address => mapping (address => uint))  public  allowance;

    receive() external payable {
        deposit();
    }
    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
    function withdraw(uint wad) public {
        require(balanceOf[msg.sender] >= wad);
        balanceOf[msg.sender] -= wad;
        payable(msg.sender).transfer(wad);
        emit Withdrawal(msg.sender, wad);
    }

    function totalSupply() public view returns (uint) {
        return address(this).balance;
    }

    function approve(address guy, uint wad) public returns (bool) {
        allowance[msg.sender][guy] = wad;
        emit Approval(msg.sender, guy, wad);
        return true;
    }

    function transfer(address dst, uint wad) public returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(address src, address dst, uint wad)
        public
        returns (bool)
    {
        require(balanceOf[src] >= wad);

        if (src != msg.sender && allowance[src][msg.sender] != type(uint256).max) {
            require(allowance[src][msg.sender] >= wad);
            allowance[src][msg.sender] -= wad;
        }

        balanceOf[src] -= wad;
        balanceOf[dst] += wad;

        emit Transfer(src, dst, wad);

        return true;
    }
}
// solhint-enable