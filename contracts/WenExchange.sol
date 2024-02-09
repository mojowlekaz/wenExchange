// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract WENExchange is ERC721URIStorage, ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _itemsSold;
    uint256 public listingprice = 0 ether;

    // Modifier to restrict functions to WENAuthority
    modifier onlyWENAuthority {
        require(msg.sender == WENAuthority, "You are not WENAuthority");
        _;
    }

    // Address of WENAuthority
    address payable WENAuthority;
    // Mapping to store MarketItems
    mapping(uint256 => MarketItem) private idMarketItem;

    // Structure to represent a market item
    struct MarketItem {
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    // Event emitted when a market item is created
    event MarketItemCreated(uint256 indexed tokenId, address seller, address owner, uint256 price, bool sold);

    // Contract constructor
    constructor() ERC721("Wen Exchange", "WEN") {
        WENAuthority = payable(msg.sender);
    }

    // Function to set the listing price, restricted to WENAuthority
    function setListingPrice(uint256 newPistingPrice) public onlyWENAuthority {
        listingprice = newPistingPrice;
    }

    // Function to get the current listing price
    function getListingPice() public view returns (uint256) {
        return listingprice;
    }

    /**
     * @dev Creates a new NFT token and assigns it to the specified owner.
     * @param tokenUrl The URL associated with the new NFT.
     * @param price The price (in wei) required to purchase the NFT.
     * @return tokenId The unique identifier for the new NFT.
     */
    function makeToken(string memory tokenUrl, uint256 price) public payable returns (uint256) {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _mint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenUrl);
        createMarketItem(newTokenId, price);
        return newTokenId;
    }

    /**
     * @dev Creates a market item for the specified tokenId.
     */
    function createMarketItem(uint256 tokenId, uint256 price) public payable nonReentrant {
        require(price > 0, "price must be at least 1");
        require(msg.value == listingprice, "price must be equzal to listimg price");
        idMarketItem[tokenId] = MarketItem(tokenId, payable(msg.sender), payable(address(this)), price, false);
        _transfer(msg.sender, address(this), tokenId);
        emit MarketItemCreated(tokenId, msg.sender, address(this), price, false);
    }

    // Function to allow the item owner to resell the token
    function resellToken(uint256 tokenId, uint256 price) public payable {
        require(idMarketItem[tokenId].owner == msg.sender, "only the item owner");
        require(msg.value == listingprice, "price not met");
        idMarketItem[tokenId].sold = false;
        idMarketItem[tokenId].price = price;
        idMarketItem[tokenId].seller = payable(msg.sender);
        idMarketItem[tokenId].owner = payable(address(this));
        _itemsSold.decrement();
        _transfer(msg.sender, address(this), tokenId);
    }

    // Function to finalize the market sale
    function createMarketsale(uint256 tokenId) public payable nonReentrant returns (bool) {
        uint256 price = idMarketItem[tokenId].price;
        require(msg.value == price, "Not enough value for purchase");
        idMarketItem[tokenId].owner = payable(msg.sender);
        idMarketItem[tokenId].sold = true;
        idMarketItem[tokenId].owner = payable(address(0));
        _itemsSold.increment();
        _transfer(address(this), msg.sender, tokenId);
        payable(WENAuthority).transfer(listingprice);
        payable(idMarketItem[tokenId].seller).transfer(msg.value);
        return true;
    }

    // Function to get all unsold market items
    function getMarketItems() public view returns (MarketItem[] memory) {
        uint256 itemCount = _tokenIds.current();
        uint256 UnsoldItemsCount = _tokenIds.current() - _itemsSold.current();
        uint256 currentIndex = 0;
        MarketItem[] memory items = new MarketItem[](UnsoldItemsCount);
        for (uint256 i = 0; i < itemCount; i++) {
            if (idMarketItem[i + 1].owner == address(this)) {
                uint256 currentbid = i + 1;
                MarketItem storage currentItem = idMarketItem[currentbid];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    // Function to get all NFTs owned by the caller
    function getMysNFT() public view returns (MarketItem[] memory) {
        uint256 totalCount = _tokenIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;
        for (uint256 i = 0; i < totalCount; i++) {
            if (idMarketItem[i + 1].owner == msg.sender) {
                itemCount += 1;
            }
        }
        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint256 i = 0; i < totalCount; i++) {
            if (idMarketItem[i + 1].owner == msg.sender) {
                uint256 currentId = i + 1;
                MarketItem storage currentItem = idMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    // Function to get all items listed by the caller
    function getsingleItemsListed() public view returns (MarketItem[] memory) {
        uint256 totalCount = _tokenIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < totalCount; i++) {
            if (idMarketItem[i + 1].seller == msg.sender) {
                itemCount += 1;
            }
        }
        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint256 i = 0; i < totalCount; i++) {
            if (idMarketItem[i + 1].seller == msg.sender) {
                uint256 currentId = i + 1;
                MarketItem storage currentItem = idMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }

        return items;
    }
receive() payable external {}

function withdraw() external onlyWENAuthority returns(bool) {
    uint256 contractBalance = address(this).balance;
    require(contractBalance > 0, "Insufficient balance");
    payable(WENAuthority).transfer(contractBalance);
    return true;
}


}
