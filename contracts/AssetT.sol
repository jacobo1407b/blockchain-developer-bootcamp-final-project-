// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract AssetT{
    //Structs
    uint id_prop;
    
    
    struct Property{
        address user;
        bool visible;
        uint256 price;
        string ipfs_hash;
        string name;
        string document_hash;
    }



    mapping(address => Property[]) properties;
    mapping(address => string) user;
    mapping(address => bool) isUser;
    mapping(string => address) issuerProperty;
    mapping(uint => Property) propertyIdentifier;
    mapping(address => uint[]) issuerPropertyRegister;
    
    event UserRegistered(address indexed isuser, string id);
    event PropertyRegister(address indexed isuser, string IPFS);
    event propertyIssued(uint indexed property,address indexed user, string indexed document);
    
    function registerUser(string memory _user) public {
        require((isUser[msg.sender] == false), "Este usuario ya esta registrado");
        user[msg.sender] = _user;
        isUser[msg.sender] = true;
        emit UserRegistered(msg.sender, _user);
    }//funciona
    
    function getUser() public view returns(string memory){
        return user[msg.sender];
    }//funciona
    
    /*function registerProperty(string memory _uuid) public {
        require(isUser[msg.sender] == true,"Issuer not registered to register a certificate");
        issuerProperty[_uuid] = msg.sender;
        emit PropertyRegister(msg.sender, _uuid);
    }*/
    function emitRegisterProperty(string memory _uuid, string memory _img_uid,string memory _name,uint256 _value) public {
        require(isUser[msg.sender] == true,"Issuer not registered to register a certificate");
        Property memory proper;
        uint id = ++id_prop;
        
         proper.user = msg.sender;
         proper.visible = false;
         proper.price = _value;
         proper.ipfs_hash = _img_uid;
         proper.name = _name;
         proper.document_hash = _uuid;
         propertyIdentifier[id] = proper;
         
         issuerPropertyRegister[msg.sender].push(id);
         emit propertyIssued(id,msg.sender, _uuid);
        
    }//funciona
    
    function getIdProperty(uint _id) public view returns(Property memory){
        Property memory prop = propertyIdentifier[_id];
        return prop;
    }//funciona

    function getProperty() public view returns(uint[] memory){
        return issuerPropertyRegister[msg.sender];
    }//funciona
    
    function onVisible(bool _visible,uint _id) public {
        Property memory temp = propertyIdentifier[_id];
        temp.visible = _visible;
        propertyIdentifier[_id] = temp;
         emit propertyIssued(_id,msg.sender, temp.document_hash);
    }//funciona
    
    function onUpdatePrice(uint _id, uint256 _newPrice) public{
        Property memory temp = propertyIdentifier[_id];
        temp.price = _newPrice;
        propertyIdentifier[_id] = temp;
        emit propertyIssued(_id,msg.sender, temp.document_hash);
    }//funciona
    
    function payProperty(address _newowner,uint _id,string memory _newipfs) public{
        Property memory temp = getIdProperty(_id);
        uint [] memory issuer =  issuerPropertyRegister[msg.sender];
        temp.user = _newowner;
        temp.visible = false;
        temp.document_hash = _newipfs;
        propertyIdentifier[_id]=temp;
        issuer[_id]=0;
        issuerPropertyRegister[_newowner].push(_id);
        emit propertyIssued(_id,_newowner, temp.document_hash);
    }
}