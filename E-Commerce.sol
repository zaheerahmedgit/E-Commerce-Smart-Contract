// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Ecommerce{
    struct Product{
        string title;
        string desc;
        address payable seller;
        uint productId;
        uint price;
        address buyer;
        bool delivered;
    }

    Product[] public products;

    uint counter = 1;

    event registered(string title, uint productId, address seller);
    event bought(uint productId, address buyer);
    event delivered(uint productId);

    function registerProduct(string memory _title, string memory _desc, uint _price) public {
        require(_price>0, "Price zero sy ziada honi chaiye");
        Product memory temProduct;
        temProduct.title = _title;
        temProduct.desc = _desc;
        temProduct.price = _price * 10**18;
        temProduct.seller = payable(msg.sender);
        temProduct.productId = counter;
        products.push(temProduct);
        counter ++;
        
        emit registered(_title, temProduct.productId, msg.sender);
    }
    function buy(uint _productId) payable public {
        require(products[_productId-1].price == msg.value, "puri price pay kren");
        require(products[_productId-1].seller != msg.sender, "malik product nahi buy kar sakta");
        products[_productId-1].buyer = msg.sender;

        emit bought(_productId, msg.sender);
    }
    
    function delivery(uint _productId) public {
        require(products[_productId-1].buyer == msg.sender, "tum buyer nahi ho");
         products[_productId-1].delivered = true;
         products[_productId-1].seller.transfer(products[_productId-1].price);

        emit delivered(_productId);
    }

}