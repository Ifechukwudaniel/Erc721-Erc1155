// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract ERC721 {

    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

   
    mapping(address => uint256)  internal _balances;

    mapping (uint256 => address) internal _owners;

    mapping(address => mapping(address => bool)) private _operatorApprovals;

    mapping(uint256=>address)  private  _tokenApproved;


    /// @notice Count all nfts assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this function throws for queries about the zero address
    /// @param owner an address to query it balance 
    /// @return  The Number of nfts owned by _owner

    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0),"Address is zero");
        return _balances[owner];
    }

    /// @notice Find the owner of the nft
    /// @dev Nfts  assigned assigned to zero address  are considered in valid
    /// @param tokenId The identifier of an NFT
    /// @return Return tha address of the owner
    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0),"TokenId does not exist");
        return owner;
    }
    
    /// @notice Enable and  disabling  third party from  operator for accessing all msg.sender assets 
    /// @dev Emit  ApprovalForAll  event. The contract must  allow multiple operators  per owner
    /// @param operator  the address of the authorized operator 
    /// @param approved  True is the operator is approved false is Not Approved
    function setApprovalForAll(address operator, bool approved) public {
      _operatorApprovals[msg.sender][operator] = approved;
      emit ApprovalForAll(msg.sender, operator, approved);
    }


    /// @notice Query if and address is an operator for another address
    /// @param owner The address of the owner of the nft
    /// @param operator the address that acts on behalf of the owner
    /// @return  True if if operator is approved by owner
    function isApprovedForAll(address owner, address operator) public view returns (bool) {
       return  _operatorApprovals[owner][operator];
    }

    
    /// @notice Explain to an end user what this does
    /// @dev  emit Approval. 
    /// @param approved  The new approved nft controller
    /// @param tokenId  The Nft Token Approved 
    function approve(address approved, uint256 tokenId) public payable {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender), "Msg.sender is not an approved operator");
        _tokenApproved[tokenId] = approved;
        emit Approval(owner, approved, tokenId);
    }

   /// @notice Get the approved address for a single nft
   /// @dev Explain to a developer any extra details
   /// @param tokenId  the nft to find the approved address 
   /// @return The approved address  of an nft, or a zero address if none
    function getApproved(uint256 tokenId) public view returns (address) {
        require(_owners[tokenId]!=address(0), "Token Id does not exist");
        return _tokenApproved[tokenId];
    }
 

    //Transfer owner ship of an nft
    function transferFrom(address from, address to, uint256 tokenId) public payable {
        address owner = ownerOf(tokenId);
        require(
            owner== msg.sender || getApproved(tokenId) == msg.sender || isApprovedForAll(owner,msg.sender), "Msg.send is not the owner or approved the transfer"
            );
        require(owner== from, "From address is not the owner");
        require(to !=address(0), "Address is Zero");
        require(_owners[tokenId]!= address(0),"TokenId does not exist");
        approve(address(0), tokenId);
        _balances[from] -=1;
        _balances[to] +=1;
        _owners[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }
 
    
    //Check if onERC21Received is implemented when sending to smart contract
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public payable {
        transferFrom(from, to, tokenId);
        require(_checkOnERC721Received(), "Receiver not implemented");
    }

     function safeTransferFrom(address from, address to, uint256 tokenId) public payable {
       safeTransferFrom(from, to, tokenId, "");
    }

    function _checkOnERC721Received()  private pure returns (bool) {
        return true;
    }

    //EIP 165
    function supportsInterface(bytes4 interfaceId) public pure  virtual returns (bool) {
        return interfaceId == 0x80ac58cd;
    }
    
}