pragma solidity ^0.6.0;

contract wallet{
    address public owner;
    bool public pause;
    
    constructor() public{
        owner = msg.sender;
        
    }
    struct payment {
        uint amt;
        uint timestamp;
    }
    
    struct balance{
        uint totbal;
        uint numpay;
        
        mapping(uint=>payment) payments;
        
    }
    mapping(address=>balance)public balance_record;
    event sentmoney(address indexed add1, uint amt1);
    event recmoney(address indexed add2, uint amt2);
    modifier onlyOwner{
        require(msg.sender == owner,"You are not the owner");
        _;
    }
    
    modifier whileNotpaused{
        require(pause==false, "Sc is paused");
        _;
    }
    
    function change(bool ch)public onlyOwner{
        pause=ch;
    }
    
    function sendMoney() public payable whileNotpaused{
        balance_record[msg.sender].totbal += msg.value ;
        balance_record[msg.sender].numpay +=1;
        payment memory pay = payment(msg.value,now);
        balance_record[msg.sender].payments[balance_record[msg.sender].numpay]=pay;
        emit sentmoney(msg.sender,msg.value);
    }
    
    
    
    function getbal()public view whileNotpaused returns(uint){
        return balance_record[msg.sender].totbal;
    }
    
    
    
    function convert(uint amtinwei)public pure returns(uint){
        return amtinwei/1 ether ;
    }
    
    
    
    function withdraw(uint _amt)public whileNotpaused{
        
        require(balance_record[msg.sender].totbal>=_amt , "not enough funds");
        balance_record[msg.sender].totbal -= _amt;
        msg.sender.transfer(_amt);
        emit recmoney(msg.sender,_amt);
    }
    
    
    
    function destroy(address payable ender)public onlyOwner{
        selfdestruct(ender);
    }
    
}
