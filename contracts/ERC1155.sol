// SPDX-License-Identifier: MIT


pragma solidity ^0.8.9;

contract ERC1155 {

    event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);
    event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    event URI(string _value, uint256 indexed _id);

    mapping(uint256 => mapping (address => uint256)) internal _balances;

    mapping (address=> mapping (address => bool))private _operatorApprovals;
    
    function safeBatchTransferFrom(address from, address to, uint256[] memory ids, uint256[] memory amounts) public {
        require( from == msg.sender || isApprovedForAll(from,msg.sender),"Msg.sender is not an approved sender");
        require(to != address(0),"You can not have a zero address");
        require(ids.length == amounts.length , "ids and amount are not the same length");
         for (uint i = 0; i < ids.length; i++) {
             uint256 id  = ids[i];
             uint256 amount = amounts[i];
             _transfer(from , to, id, amount);
         }
        emit TransferBatch(msg.sender,from, to, ids, amounts);
        require(_checkOnERC1155Received(),"Receiver Not Implemented");
    }

    function _transfer(address from , address to , uint256 id, uint256 amount) private {
        uint256  fromBalance = _balances[id][from];
        require(fromBalance >= amount, "Insufficient Balance");
        _balances[id][from] = fromBalance-amount;
        _balances[id][to] = amount;
    }

    //Transfer from  tokens  one account to another
    function safeTransferFrom(address from, address to, uint256 id, uint256 value) public {
         require( from == msg.sender || isApprovedForAll(from , msg.sender), "Msg.sender  is not an approved sender");
         require(to !=address(0), "You Can Not have a zero address");
         _transfer(from, to,id,value);
         emit TransferSingle(msg.sender,from,to,id,value);
         require(_checkOnERC1155Received(), "Receiver is Not Implemented");
    }

    function _checkOnERC1155Received() private pure returns(bool) {
         return true;
    }

    //get the balance of a single account tokens
    function balanceOf(address owner, uint256 id) public view returns (uint256){
        require(owner != address(0), "Address is zero");
        return  _balances[id][owner];
    }
    
    // get the balance of multiple account tokens 
    function balanceOfBatch(address[] memory owners, uint256[] memory ids) public view returns (uint256[] memory) {
        require(owners.length == ids.length ,"Accounts and ids are not the same length" );
         uint256[] memory  batchBalances = new uint256[](owners.length);
         for (uint256 i = 0; i < batchBalances.length; i++) {
             batchBalances[i]= balanceOf(owners[i], ids[i]);
         }

         return batchBalances;
    }

    // enable of disable to manage an operator assets 
    function setApprovalForAll(address operator, bool approved) public {
         require(operator !=address(0),"Operator can not be a zero address ");
         _operatorApprovals[msg.sender][operator]= approved;
         emit ApprovalForAll(msg.sender,operator, approved);
    }

    //Check if an operator address is allowed for  another address
    function isApprovedForAll(address owner, address operator) public view returns (bool) {
       return _operatorApprovals[owner][operator];
    }



}

