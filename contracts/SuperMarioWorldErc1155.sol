
import "./ERC1155.sol";

contract SuperMarioWorldErc1155 is ERC1155  {
     string public name;
     string public symbol;
     uint256 public tokenCount;

     mapping(uint256 => string ) _tokenURIs ;

     constructor ( string memory _name , string memory _symbol)  {
          name= _name;
          symbol = _symbol;
     }

     function uri(uint256  tokenId) public view  returns( string memory) {
          string memory url =  _tokenURIs[tokenId];
          // emit URI(url, tokenId);
          return url;
     }

     function mint(uint256 amount, string memory _url) public {
          require(msg.sender != address(0), "Mint to zero address");
          tokenCount += 1;
          _balances[tokenCount][msg.sender] +=  amount;
          _tokenURIs[tokenCount] = _url;
          emit TransferSingle(msg.sender, address(0) , msg.sender, tokenCount, amount);
     }

     function supportsInterface(bytes4 interfaceId) public pure override returns(bool) {
        return interfaceId == 0xd9b67a26 || interfaceId == 0x0e89341c;
    }

}