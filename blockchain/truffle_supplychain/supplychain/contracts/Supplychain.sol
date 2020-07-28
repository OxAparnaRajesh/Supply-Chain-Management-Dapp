pragma solidity 0.5.16;

/* This is contract of Supplychain */
contract Supplychain{
    address public manufacturer; /* declare manufacturer address  */
    uint256 productUniqueId; /* declare productUniqueId*/
    
    constructor() public{
        manufacturer = msg.sender; /* assign manufacturer into msg.sender */
        productUniqueId = 1000; /* initiate productUniqueId */
    }
    /*restrict onlyManufacturer for adding manufacturer */
    modifier onlyManufacturer(){
        require(msg.sender==manufacturer);
        _;
    }
    /*restrict onlyPartners for updating partners details */
    modifier onlyPartners(){
        for(uint i;i<partner.length;i++) {
            require(partner[i]._partnerAddress==msg.sender, "UnAuthourized");
            _;
        }
    }
    /*struct manufacturer*/
    struct Mfg{
        bytes32 _mfgName;
        bytes32 _mfgLocation;
        address _mfgAddress;
    }

    Mfg[] public mfg;
    mapping(address=>Mfg) ManufacturerAddressList;
    
    /*struct pantner*/
    struct Partner{
        bytes32 _partnerName;
        bytes32 _partnerLocation;
        bytes32 _roles;
        bytes32 _partnerStage;//supplier=2,assemblier(manufacturer)=3,distributor=4,retailor=5
        bytes32 _partnerHandle;//screen,battery,motherboard,assemblier,distributor,retailor
        address _partnerAddress;
    }

    Partner[] public partner;
    mapping(address => Partner) public PartnerAddressList;
    
    /*struct product*/
    struct Product{
        uint256 _productId;
        bytes32 _productName;
        bytes32[] _productState; // initiate-1,rawmatrial-2, assembler-3,distributor-4,retailor-5
        bytes32[] _productTimeStamp;//when
        address[] _partnerAddress;//who
        bytes32[] _productHandle;
    }
    
    Product[] public product;
    mapping(uint256 =>Product) public ProductIdList;

    /*adding Manufacturer Details -- only Manufacturer will add Manufacturer details*/
    function addManufacturer(bytes32 _mfgName,bytes32 _mfgLocation,address _mfgAddress) public onlyManufacturer(){
        Mfg memory _mfg = Mfg(_mfgName,_mfgLocation,_mfgAddress);
        mfg.push(_mfg);
        ManufacturerAddressList[_mfgAddress]= _mfg;
    }
    /*verify Manufacturer Details */
    function verifyManufacturer(address verifyMfgAddress)public view returns(bytes32 _mfgName,bytes32 _mfgLocation,address _mfgAddress){
        for(uint i;i<mfg.length;i++){
            if(mfg[i]._mfgAddress == verifyMfgAddress){
                return(mfg[i]._mfgName,mfg[i]._mfgLocation,mfg[i]._mfgAddress);
            }
        }
    }
    /*Add partners Details -- only Manufacturer will add partner details */
    function addPartner(bytes32 _partnerName,bytes32 _partnerLocation,bytes32 _roles,bytes32 _partnerStage,bytes32 _partnerHandle,address _partnerAddress) public onlyManufacturer(){
        Partner memory _partner = Partner(_partnerName,_partnerLocation,_roles,_partnerStage,_partnerHandle,_partnerAddress);
        partner.push(_partner);
        PartnerAddressList[_partnerAddress]=_partner;
    }
    /*Verify partners Details */
    function verifyPartner(address verifyPartnerAddress)public view returns(bytes32 _partnerName,bytes32 _partnerLocation,bytes32 _roles,bytes32 _partnerStage,bytes32 _partnerHandle,address _partnerAddress){
        for(uint i;i<partner.length;i++){
            if(partner[i]._partnerAddress == verifyPartnerAddress){
                return(partner[i]._partnerName,partner[i]._partnerLocation,partner[i]._roles,partner[i]._partnerStage,partner[i]._partnerHandle,partner[i]._partnerAddress);
            }
        }
    }
    /*getAllPartners Details function */
    function getAllPartners() public view returns (bytes32[] memory, bytes32[] memory,bytes32[] memory,bytes32[] memory,bytes32[] memory,address[] memory){
        bytes32[] memory _partnerNames = new bytes32[](partner.length);
        bytes32[] memory _partnerLocations = new bytes32[](partner.length);
        bytes32[] memory _partnerRoles = new bytes32[](partner.length);
        bytes32[] memory _partnerStages = new bytes32[](partner.length);
        bytes32[] memory _partnerHandles = new bytes32[](partner.length);
        address[] memory _partnerAddresses = new address[](partner.length);
        
        for(uint i=0;i<partner.length;i++){
            _partnerNames[i]=partner[i]._partnerName;
            _partnerLocations[i]=partner[i]._partnerLocation;
            _partnerRoles[i]=partner[i]._roles;
            _partnerStages[i]=partner[i]._partnerStage;
            _partnerHandles[i]=partner[i]._partnerHandle;
           _partnerAddresses[i]= partner[i]._partnerAddress;
        }
        return(_partnerNames,_partnerLocations,_partnerRoles,_partnerStages,_partnerHandles,_partnerAddresses);
    }
    /*Edit partners Details -- only Manufacturer will edit partner details */
    function editPartner(bytes32 _partnerName,bytes32 _partnerLocation,bytes32 _roles,bytes32 _partnerStage,bytes32 _partnerHandle,address _partnerAddress) public onlyManufacturer(){
        for(uint i;i<partner.length;i++){
            if(partner[i]._partnerAddress==_partnerAddress){
                partner[i]._partnerName = _partnerName;
                partner[i]._partnerLocation = _partnerLocation;
                partner[i]._roles = _roles;
                partner[i]._partnerStage=_partnerStage;
                partner[i]._partnerHandle=_partnerHandle;
                partner[i]._partnerAddress = _partnerAddress;
            }
        }
    }
    /*Add Product Details -- only Manufacturer will add Product details */
    function addProduct(
        bytes32 _productName,
        bytes32[] memory _productState,
        bytes32[] memory _productTimeStamp,
        address[] memory _partnerAddress,
        bytes32[] memory _productHandle) public onlyManufacturer{
            uint256 tempProductId = productUniqueId++;
            Product memory _product =Product(tempProductId, _productName, _productState, _productTimeStamp, _partnerAddress, _productHandle);
            product.push(_product);
            ProductIdList[tempProductId]=_product;
        }
     /*verify product details */   
    function verifyProduct(uint256 verifyProductId) public view returns(
        bytes32 _productName,
        bytes32[] memory _productState,
        bytes32[] memory _productTimeStamp,
        address[]memory _partnerAddress,
        bytes32[]memory _productHandle) {
            if(ProductIdList[verifyProductId]._productId==verifyProductId){
            return(ProductIdList[verifyProductId]._productName, 
                ProductIdList[verifyProductId]._productState, 
                ProductIdList[verifyProductId]._productTimeStamp, 
                ProductIdList[verifyProductId]._partnerAddress, 
                ProductIdList[verifyProductId]._productHandle);
        }
    }
        
    /*update product details with productIdlist --onlypartners can update the products details  */
    function updateProduct(uint256 _productId, bytes32 _productName, bytes32 _productState,bytes32 _productTimeStamp, address _partnerAddress, bytes32 _productHandle) public onlyPartners() {
        ProductIdList[_productId]._productName = _productName;
        (ProductIdList[_productId]._productState).push(_productState);
        (ProductIdList[_productId]._productTimeStamp).push(_productTimeStamp);
        (ProductIdList[_productId]._partnerAddress).push(_partnerAddress);
        (ProductIdList[_productId]._productHandle).push(_productHandle);
        
        }
        

}