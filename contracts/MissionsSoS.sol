pragma solidity  >=0.5.16 <0.7.0;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b>0);
        return a / b;
    }
}

contract MissionsSoS{
    
    using SafeMath for uint;

    enum HTTPMethod  {GET, POST, PATCH, PUT, DELETE}
    enum ContentType {none, data, URL_encoded, raw, binary, GraphQL}
    enum RAWDataType {none, Text, JavaScript, JSON, HTML, XML}

   struct Mission {
        uint missionCode;
        string missionDescription;
        address missionOwner;
        string missionTag;
        uint missionCodeFather;
    }

    struct Parameter {
        string parameterKey;
        string parameterValue;
        string parameterDescription;
        string parameterContentType;
    }

    struct Constituent {
        uint constituentCode;
        address constituentOwner;
    }

    struct Service {
        uint serviceCode;
        string serviceDescription;
        address serviceOwner;
        HTTPMethod serviceHTTPMethod;
        string serviceURL;
        ContentType serviceContentType;
        RAWDataType serviceRAWDataType;
    }
    
    //--------Mission---------
    uint private _totalMission;
    mapping(uint => Mission) private missionMap;
 
    //---------Service-------
    uint private _totalService;
    mapping(uint => Service) private serviceMap;
    //-------Service Parameter-------
    mapping(uint => uint) private _totalServiceParameter;
    mapping(uint => Parameter[]) private serviceParameterMap;
    //-------Service Mission-------
    mapping(uint => uint) private _totalServiceMission;
    mapping(uint => Mission[]) private serviceMissionMap;
 
    //-------Constituent-------
    uint private _totalConstituent;
    mapping(uint => Constituent) private constituentMap;
    //--Constituent Parameter--
    mapping(uint => uint) private _totalConstituentParameter;
    mapping(uint => Parameter[]) private constituentParameterMap;
    //---Constituent Service---
    mapping(uint => uint) private _totalConstituentService;
    mapping(uint => Service[]) private constituentServiceMap;
 
    
    constructor() public {

    }
    
    
    //--------Mission---------
        
    function totalMission() public view returns (uint) {
        return _totalMission;
    }
    
    function setMission(string memory _missionDescription, string memory _missionTag, uint _missionCodeFather) public {
        _totalMission = _totalMission.add(1);
        missionMap[_totalMission] = Mission(_totalMission, _missionDescription, msg.sender, _missionTag, _missionCodeFather);
    }
    
    function getMission(uint  _missionCode) public view returns (uint, string memory, address, string memory, uint) {
        return (_missionCode, 
            missionMap[_missionCode].missionDescription,
            missionMap[_missionCode].missionOwner,
            missionMap[_missionCode].missionTag,
            missionMap[_missionCode].missionCodeFather
        );
    }
 
     //---------Service-------
    
    function totalService() public view returns (uint) {
        return _totalService;
    }
    
    function setService(string memory _serviceDescription, uint _serviceHTTPMethod, 
        string memory serviceURL, uint _serviceContentType, uint _serviceRAWDataType) public {
        _totalService = _totalService.add(1);
        serviceMap[_totalService] = Service(_totalService, _serviceDescription, msg.sender, 
        HTTPMethod(_serviceHTTPMethod), serviceURL, ContentType(_serviceContentType), RAWDataType(_serviceRAWDataType));
    }
    
    function getService(uint  _serviceCode) public view returns (uint, string memory, address, HTTPMethod, string memory, ContentType, RAWDataType) {
        return (_serviceCode, 
            serviceMap[_serviceCode].serviceDescription,
            serviceMap[_serviceCode].serviceOwner,
            serviceMap[_serviceCode].serviceHTTPMethod,
            serviceMap[_serviceCode].serviceURL,
            serviceMap[_serviceCode].serviceContentType,
            serviceMap[_serviceCode].serviceRAWDataType
        );
    }    
    
    //-------Service Parameter-------
    
    function setServiceParameter(uint  _serviceCode, string memory _parameterKey, 
        string memory _parameterValue) public returns (bool) {
        if(msg.sender==serviceMap[_serviceCode].serviceOwner)
        {
            MissionsSoS.Parameter memory parameter = Parameter(_parameterKey, _parameterValue, " ", " ");
            _totalServiceParameter[_serviceCode]=_totalServiceParameter[_serviceCode].add(1);
            serviceParameterMap[_serviceCode].push(parameter);
            return true;
        }else
        {
            return false;
        }
    }
    
    function totalServiceParameter(uint _serviceCode) public view returns (uint) {
        return _totalServiceParameter[_serviceCode];
    }
    
    function getServiceParameter(uint  _serviceCode, uint _parameterCode) public view 
        returns (string memory, string memory, string memory, string memory) {

        return (serviceParameterMap[_serviceCode][_parameterCode].parameterKey,
            serviceParameterMap[_serviceCode][_parameterCode].parameterValue,
            serviceParameterMap[_serviceCode][_parameterCode].parameterDescription,
            serviceParameterMap[_serviceCode][_parameterCode].parameterContentType
        );
    }

    
    //-------Constituent-------
    
    function totalConstituent() public view returns (uint) {
        return _totalConstituent;
    }
    
    function setConstituent() public {
        _totalConstituent = _totalConstituent.add(1);
        _totalConstituentParameter[_totalConstituent]=0;
        constituentMap[_totalConstituent] = Constituent(_totalConstituent, msg.sender);
    }
    
    function getConstituent(uint  _constituentCode) public view returns (uint, address) {
        return (_constituentCode, constituentMap[_constituentCode].constituentOwner);
    }
    
    //--Constituent Parameter--
    
    function setConstituentParameter(uint  _constituentCode, string memory _parameterKey, 
        string memory _parameterValue) public returns (bool) {
        if(msg.sender==constituentMap[_constituentCode].constituentOwner)
        {
            MissionsSoS.Parameter memory parameter = Parameter(_parameterKey, _parameterValue, " ", " ");
            _totalConstituentParameter[_constituentCode]=_totalConstituentParameter[_constituentCode].add(1);
            constituentParameterMap[_constituentCode].push(parameter);
            return true;
        }else
        {
            return false;
        }
    }
    
    function totalConstituentParameter(uint _constituentCode) public view returns (uint) {
        return _totalConstituentParameter[_constituentCode];
    }
    
    function getConstituentParameter(uint  _constituentCode, uint _parameterCode) public view 
        returns (string memory, string memory, string memory, string memory) {

        return (constituentParameterMap[_constituentCode][_parameterCode].parameterKey,
            constituentParameterMap[_constituentCode][_parameterCode].parameterValue,
            constituentParameterMap[_constituentCode][_parameterCode].parameterDescription,
            constituentParameterMap[_constituentCode][_parameterCode].parameterContentType
        );
    }
    

}