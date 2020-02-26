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

contract MissionsSoSService{
    
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

    }

    struct Constituent {
        uint constituentCode;
        address constituentOwner;
    }

    struct Service {
        uint serviceCode;
        string serviceDescription;
        HTTPMethod serviceHTTPMethod;
        string serviceURL;
        ContentType serviceContentType;
        RAWDataType serviceRAWDataType;
    }
    
    //--------Mission---------
    uint private _totalMission;
    mapping(uint => Mission) private missionMap;
 
    //---------Constituyente Service-------
    //uint private _totalService;
    //mapping(uint => Service) private serviceMap;

    //-------Constituent-------
    uint private _totalConstituent;
    mapping(uint => Constituent) private constituentMap;
    //--Constituent Parameter--
    mapping(uint => uint) private _totalConstituentParameter;
    mapping(uint => Parameter[]) private constituentParameterMap;
    //---Constituent Service---
    mapping(uint => uint) private _totalConstituentService;
    mapping(uint => Service[]) private constituentServiceMap;

    //-------Constituent Service Parameter-------
    mapping(uint => mapping(uint => uint)) private _totalConstituentServiceParameter;
    mapping(uint => mapping(uint => Parameter[])) private constituentServiceParameterMap;
    
    //-------Service Mission-------
    mapping(uint => uint) private _totalServiceMission;
    mapping(uint => Mission[]) private serviceMissionMap;
 


    //--------Mission---------

    function totalMission() public view returns (uint) {
        return _totalMission;
    }
    
    function setMission(string memory _missionDescription, string memory _missionTag, uint _missionCodeFather) public {
        missionMap[_totalMission] = Mission(_totalMission, _missionDescription, msg.sender, _missionTag, _missionCodeFather);
        _totalMission = _totalMission.add(1);
    }

    function getMission(uint  _missionCode) public view returns (uint, string memory, address, string memory, uint) {
        return (_missionCode,
            missionMap[_missionCode].missionDescription,
            missionMap[_missionCode].missionOwner,
            missionMap[_missionCode].missionTag,
            missionMap[_missionCode].missionCodeFather
        );
    }
 
    
    //-------Constituent-------
    
    function totalConstituent() public view returns (uint) {
        return _totalConstituent;
    }
    
    function setConstituent() public {        
        constituentMap[_totalConstituent] = Constituent(_totalConstituent, msg.sender);
        _totalConstituent = _totalConstituent.add(1);
        _totalConstituentParameter[_totalConstituent]=0;
    }
    
    function getConstituent(uint  _constituentCode) public view returns (uint, address) {
        return (_constituentCode, constituentMap[_constituentCode].constituentOwner);
    }
    
    //--Constituent Parameter--
    
    function setConstituentParameter(uint  _constituentCode, string memory _parameterKey, 
        string memory _parameterValue, string memory _parameterDescription) public returns (bool) {
        if(msg.sender==constituentMap[_constituentCode].constituentOwner)
        {
            MissionsSoSService.Parameter memory parameter = Parameter(_parameterKey, _parameterValue, _parameterDescription);
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
        returns (string memory, string memory, string memory) {

        return (constituentParameterMap[_constituentCode][_parameterCode].parameterKey,
            constituentParameterMap[_constituentCode][_parameterCode].parameterValue,
            constituentParameterMap[_constituentCode][_parameterCode].parameterDescription
        );
    }

    //--Constituent Service----
    
    function setConstituentService(uint  _constituentCode, string memory _serviceDescription, uint _serviceHTTPMethod, 
        string memory serviceURL, uint _serviceContentType, uint _serviceRAWDataType) public returns (bool) {
        if(msg.sender==constituentMap[_constituentCode].constituentOwner)
        {            
            MissionsSoSService.Service memory _service = Service(_totalConstituentService[_constituentCode],
            _serviceDescription, HTTPMethod(_serviceHTTPMethod), serviceURL, ContentType(_serviceContentType), 
            RAWDataType(_serviceRAWDataType));
            _totalConstituentService[_constituentCode]=_totalConstituentService[_constituentCode].add(1);
            constituentServiceMap[_constituentCode].push(_service);
            return true;
        }else
        {
            return false;
        }
    }
    
    function totalConstituentService(uint _constituentCode) public view returns (uint) {
        return _totalConstituentService[_constituentCode];
    }
    
    function getConstituentService(uint  _constituentCode, uint _serviceCode) public view returns (
        uint, string memory, HTTPMethod, 
        string memory, ContentType, RAWDataType) {
        return (_serviceCode, constituentServiceMap[_constituentCode][_serviceCode].serviceDescription,
            constituentServiceMap[_constituentCode][_serviceCode].serviceHTTPMethod,
            constituentServiceMap[_constituentCode][_serviceCode].serviceURL,
            constituentServiceMap[_constituentCode][_serviceCode].serviceContentType,
            constituentServiceMap[_constituentCode][_serviceCode].serviceRAWDataType
        );
    }

    //--Constituent Service Parameter--
    
    function setConstituentServiceParameter(uint  _constituentCode, uint  _serviceCode, string memory _parameterKey, 
        string memory _parameterValue, string memory _parameterDescription) public returns (bool) {
        if(msg.sender==constituentMap[_constituentCode].constituentOwner)
        {
            MissionsSoSService.Parameter memory parameter = Parameter(_parameterKey, _parameterValue, _parameterDescription);
            constituentServiceParameterMap[_constituentCode][_serviceCode].push(parameter);
            _totalConstituentServiceParameter[_constituentCode][_serviceCode]=_totalConstituentServiceParameter[_constituentCode][_serviceCode].add(1);
            return true;
        }else
        {
            return false;
        }
    }
    
    function totalConstituentServiceParameter(uint _constituentCode, uint _serviceCode) public view returns (uint) {
        return _totalConstituentServiceParameter[_constituentCode][_serviceCode];
    }
    
    function getConstituentServiceParameter(uint  _constituentCode, uint _serviceCode, uint _parameterCode) public view 
        returns (string memory, string memory, string memory) {
        
        return (
            (constituentServiceParameterMap[_constituentCode][_serviceCode])[_parameterCode].parameterKey,
            (constituentServiceParameterMap[_constituentCode][_serviceCode])[_parameterCode].parameterValue,
            (constituentServiceParameterMap[_constituentCode][_serviceCode])[_parameterCode].parameterDescription
        );
    }
    
     //---------Service-------
    /*
    function totalService() public view returns (uint) {
        return _totalService;
    }
    
    function setService(string memory _serviceDescription, uint _serviceHTTPMethod, 
        string memory serviceURL, uint _serviceContentType, uint _serviceRAWDataType) public {
        _totalService = _totalService.add(1);
        serviceMap[_totalService] = Service(_totalService, _serviceDescription, HTTPMethod(_serviceHTTPMethod), 
        serviceURL, ContentType(_serviceContentType), RAWDataType(_serviceRAWDataType), msg.sender);
    }
    
    function getService(uint  _serviceCode) public view returns (uint, string memory, HTTPMethod, 
        string memory, ContentType, RAWDataType, address) {
        return (_serviceCode, 
            serviceMap[_serviceCode].serviceDescription,
            serviceMap[_serviceCode].serviceHTTPMethod,
            serviceMap[_serviceCode].serviceURL,
            serviceMap[_serviceCode].serviceContentType,
            serviceMap[_serviceCode].serviceRAWDataType,
            serviceMap[_serviceCode].serviceOwner
        );
    }    
    */
    //-------Service Parameter-------
    
    /*
    function totalServiceParameter(uint _serviceCode) public view returns (uint) {
        return _totalServiceParameter[_serviceCode];
    }

    function setServiceParameter(uint  _serviceCode, string memory _parameterKey, 
        string memory _parameterValue, string memory _parameterDescription) public returns (bool) {
        if(msg.sender==serviceMap[_serviceCode].serviceOwner)
        {
            MissionsSoSService.Parameter memory parameter = Parameter(_parameterKey, _parameterValue, _parameterDescription);
            _totalServiceParameter[_serviceCode]=_totalServiceParameter[_serviceCode].add(1);
            serviceParameterMap[_serviceCode].push(parameter);
            return true;
        }else
        {
            return false;
        }
    }
        
    function getServiceParameter(uint  _serviceCode, uint _parameterCode) public view 
        returns (string memory, string memory, string memory) {

        return (serviceParameterMap[_serviceCode][_parameterCode].parameterKey,
            serviceParameterMap[_serviceCode][_parameterCode].parameterValue,
            serviceParameterMap[_serviceCode][_parameterCode].parameterDescription
        );
    }
*/


}