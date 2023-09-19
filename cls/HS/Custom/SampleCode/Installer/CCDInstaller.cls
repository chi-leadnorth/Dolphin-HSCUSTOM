Include (HS.Common, %ZHSLIB, %syPrompt)

/// Installation tools for HealthShare
Class HS.Custom.SampleCode.Installer.CCDInstaller Extends (HS.HC.Util.Installer, HS.Util.Installer.Kit.PostInstall.Base)
{

// Need method to set up services, OID, assigning authority, facility id for a new facility

// set up infrastructure routes - run one time but will not overwrite if run again, script should check if components exist

// based on facility ID, set up CCDA route 

// after installing components, drop a CCDA file to run a smoke test 

/* Methods for FOB - set up CCDA setup 
   The "Setup" methods are to be run once initially
   The "Add Participant" methods are to be run when a new participant is onboarded

*/

// To run:

// HSLIB> w ##class(HS.Custom.Util.CCDInstaller).InitialFramework()

// Then run: 

// HSREGISTRY> w ##class(HS.Custom.Util.CCDInstaller).AddParticipantFacility()

// For both these scripts, there is the option to pass in all required parameters or run without arguments and get prompted. 

// Main method for initial setup: Calls the methods to install the required infrastructure in HSROUTER, HSREGISTRY, HSBUS

ClassMethod InitialFramework() As %Status
{
	Set tSC = $$$OK
	//SetupHomeCommunity Keys first
	Set tSC = ..SetupHomeCommunity()

	//Configuration keys in Registry needed for PNR Header
	Set tSC = ..SetupConfigurationKeys()

	//Bus repository Key on HSROUTER
	Set tSC = ..SetupBusRepositoryKey("HSROUTER")

	//Bus repository on Registry
	Set tSC = ..SetupBusRepositoryKey("HSREGISTRY")

	//Add items to BUS
	Set tSC =  ..AddProductionItems("HSBUS", "BusItems")

	//Set up HSROUTER production
	Set tSC =  ..AddProductionItems("HSROUTER", "RouterItems")

	//Set up HS.IHE.CodedEntry for CCDA Testing
	Set tSC = ##class(HS.IHE.CodedEntry).SetupCDA()

	quit tSC
}

/// CNR: There is some trickery around using a pSubstitutionValues as a lookup
/// because of loose typing it's not clear from code what the datatype of pSubstitutionValues is
/// so in order to use the trickery I have to figure out how to set up the lookup based
/// on haunted code - I don't make the rules....
ClassMethod SetupHomeCommunity(pHomeCommunity As %String = "", pOID As %String = "") As %Status
{
	try {
		#; various things that need to be setup in a bus installation
		Set tSC = $$$OK

		If pHomeCommunity = "" { 
			Read !, "ENTER the Home Community Name: ", pHomeCommunity
			Read !, "ENTER the registered OID value for the Home Community: ", pOID
		}

		if pOID="" || pHomeCommunity = "" {
			Write "Home Community and OID require non-empty values"
			$$$ThrowStatus($$$ERROR($$$GeneralError, "Home Community and OID require non-empty values"))
		}

		ZN "HSREGISTRY"	
		Write "  Setting Home Community entries in HSREGISTRY",!
		Do ##class(HS.Data.OIDMap).FileOID(pHomeCommunity,"AssigningAuthority",pOID,"Home Community","HomeCommunity" )
		Do ##class(HS.IHE.Util).SetAffinityDomain(pHomeCommunity)
		Do ##class(HS.IHE.Util).SetHomeCommunity(pHomeCommunity)
		
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

// Method to set up keys in HSROUTER for IHE codes in configuration key table 

ClassMethod SetupConfigurationKeys(Namespace As %String = "HSROUTER") As %Status
{
	#; Default config key values used to set up PnR header for participants who just send the CCDA via file transfer
	Set CLASSCODE = "\IHE\Default\ClassCode"	
	Set CLASSCODEVALUE = "SUMMARY^1.3.6.1.4.1.19376.1.2.6.1^Summary"
 	Set CONFIDENTIALITYCODE = "\IHE\Default\ConfidentialityCode"	
	Set CONFIDENTIALITYCODEVALUE = "N^2.16.840.1.113883.5.25^Normal"
 	Set CONTENTTYPECODE = "\IHE\Default\ContentTypeCode"	
	Set CONTENTTYPECODEVALUE = "34117-2^2.16.840.1.113883.6.1^History and Physical Note"
 	Set FORMATCODE = "\IHE\Default\FormatCode"	
	Set FORMATCODEVALUE = "2.16.840.1.113883.10.20.1^2.16.840.1.113883.3.88^HL7 CCD Document"
 	Set HEALTHCAREFACILITYTYPECODE = "\IHE\Default\HealthcareFacilityTypeCode"	
	Set HEALTHCAREFACILITYTYPECODEVALUE = "OF^2.16.840.1.113883.5.11^Outpatient facility"
 	Set PRACTICESETTINGCODE = "\IHE\Default\PracticeSettingCode"	
	Set PRACTICESETTINGCODEVALUE = "394802001^2.16.840.1.113883.6.96^General Medicine"
	Set TYPECODE = "\IHE\Default\TypeCode"	
	Set TYPECODEVALUE = "11506-3^2.16.840.1.113883.6.1^Progress note"
	

	Set tSC = $$$OK
	#; Change namespace to where the configuration keys should be set
	ZN Namespace

	#; Set Configuration Key values for minimal header required for PnR
	$$$ThrowOnError(##class(HS.Registry.Config).AddUpdateKeyValue(CLASSCODE , CLASSCODEVALUE))
	$$$ThrowOnError(##class(HS.Registry.Config).AddUpdateKeyValue(CONFIDENTIALITYCODE , CONFIDENTIALITYCODEVALUE))
	$$$ThrowOnError(##class(HS.Registry.Config).AddUpdateKeyValue(CONTENTTYPECODE , CONTENTTYPECODEVALUE))
	$$$ThrowOnError(##class(HS.Registry.Config).AddUpdateKeyValue(FORMATCODE , FORMATCODEVALUE))
	$$$ThrowOnError(##class(HS.Registry.Config).AddUpdateKeyValue(HEALTHCAREFACILITYTYPECODE , HEALTHCAREFACILITYTYPECODEVALUE))
	$$$ThrowOnError(##class(HS.Registry.Config).AddUpdateKeyValue(PRACTICESETTINGCODE , PRACTICESETTINGCODEVALUE))
	$$$ThrowOnError(##class(HS.Registry.Config).AddUpdateKeyValue(TYPECODE , TYPECODEVALUE))
	Write "  Setting Coniguration Keys in HSROUTER",!
	Quit tSC
}

// Method to set up services in HSROUTER for the XDSb.Repository setting in the Service Registry

ClassMethod SetupBusRepositoryKey(pNamespace As %String = "HSROUTER") As %Status
{
	#; Default config key values used to set up PnR header for participants who just send the CCDA via file transfer	
	Set tHostAndPort = ..GetCustomHostAndPort()
	

	Set tSC = $$$OK
	#; Change namespace to where the service key should be set
	ZN pNamespace

	#; Set Service Key value to forward CCDs 
	if pNamespace = "HSROUTER" {
		Write "  Setting Repository Entries in HSROUTER",!
		Set tEntries = "BusRegistryEntriesRouter"
		$$$ThrowOnError(..SetupServiceRegistry(pNamespace, tEntries))
	}
	else {
		Write "  Setting Repository Entries in HSREGISTRY",!
		Set tEntries = "BusRegistryEntries"
		$$$ThrowOnError(..SetupServiceRegistry(pNamespace, tEntries))
	}
	
	Quit tSC
}

/// SetupServiceRegistry
ClassMethod SetupServiceRegistry(pNamespace = "", pEntryName = "")
{
	
	Set tHostAndPort = ..GetCustomHostAndPort()
	try {
		Set tSubVals("CustomHostAndPort")=tHostAndPort
		Set tObj = ..%New()
		Set tSC = tObj.AddRegistryEntries(pNamespace,pEntryName, .tSubVals) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Write "  Setting BUS Registry Entries in <"_pNamespace_">",!
	Quit tSC
}

// Need method to set up services, OID, assigning authority, facility id for a new facility

ClassMethod AddParticipantFacility(pFacility As %String = "", pOID As %String = "", pDescription As %String = "", pType As %String = "AssigningAuthority", pNamespace = "") As %Status
{
	try {
		#; various things that need to be setup in a facility installation
		Set tSC = $$$OK

		If pFacility = "" { 
			Read !, "ENTER the Facility ID: ", pFacility
			Read !, "ENTER the registered OID value for the Facility: ", pOID
			Read !, "ENTER the description for the Service registry: ", pDescription
		}

		if pOID="" || pFacility = "" {
			Write "Facility ID and OID require non-empty values"
			$$$ThrowStatus($$$ERROR($$$GeneralError, "Facility ID and OID require non-empty values"))
		}

		ZN "HSREGISTRY"	
		Write "  Setting Facility entries in HSREGISTRY",!
		Do ##class(HS.Data.OIDMap).FileOID(pFacility,pType,pOID,pDescription,"Facility" )
		
		#; Default config key values used to set up PnR header for participants who just send the CCDA via file transfer
		Set SERVICENAME = pFacility_".XDSb.Repository"	
		Set HOST = ##class(%SYS.System).GetNodeName(1)
		Set WEBSERVERPORT = ^%SYS("WebServer","Port")
		Set HOSTURL = "http://"_HOST_":"_WEBSERVERPORT 
		Set SERVICEURL = "/csp/healthshare/EG"_pFacility_"/services/HS.IHE.XDSb.Repository.Services.cls"
	
		
		Set tEndpoint = HOSTURL_SERVICEURL
		
		Set pNamespace = "HSREGISTRY"
		#; Create Repository OID for EG{FacilityId}
		Write "  Create Repository OID for EG{FacilityId} in <"_pNamespace_">",!
		$$$ThrowOnError(..AddParticipantRepository(pNamespace, pFacility))

		#; Set Service Key value to forward CCDs from HSBUS to EG{FacilityId}
		Write "   BUS Registry Entries in <"_pNamespace_">",!
		$$$ThrowOnError(..AddParticipantServiceRegistry(pNamespace, pFacility))
		
		
		//Add items to edge
		Do ..AddProductionItems("EG"_pFacility, "EdgeGatewayItems")


	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// Helper method to return the Custom Host and Port. Example DEVSERVER:52773
ClassMethod GetCustomHostAndPort() As %String
{
 	Set tHost = ##class(%SYS.System).GetNodeName(1)
	Set tWebserverPort = ^%SYS("WebServer","Port")
	Set tCustomHostAndPort = tHost_":"_tWebserverPort
	Quit tCustomHostAndPort
}

// Add new Participant Repository on EDGE 

// The scheme to assign the OIDs for Repository EDGE is to take the HomeCommunity OID and add a subOID

ClassMethod AddParticipantRepository(pNamespace As %String, pFacility As %String) As %Status
{
	
	Set tSC = $$$OK
	ZN pNamespace
	//Get the Home Community value from the Configuration Registry
	Set tKey = "\IHE\HomeCommunity"
	Set tHomeCommunity = ##class(HS.Registry.Config).GetKeyValue(tKey)
	w "tHomeCommunity: "_tHomeCommunity
	//Get the Home Community OID
	Set tHomeCommunityOID = ##class(HS.Data.OIDMap).GetOIDForCode(tHomeCommunity)
	w "tHomeCommunityOID: "_tHomeCommunityOID

	//Then get a count of current repositories and iterate by 1 to create a new repository OID
	//This number is just an internal identification scheme for XDS protocol

	/// Given a Type Repository, find the count of existing Repos and append count+1 to the HomeCommunityOID 
	/// to assign the Repository OID
	Set tDefault="Repository"
	&sql(select Count(OID) into :tOIDCount from HS_Data.OIDMap where Types = 'Repository' )
	If 'SQLCODE  {
		Set tOIDCount = tOIDCount+1
		Set tRepositoryOID = tHomeCommunityOID_"."_tOIDCount
		w "tRepositoryOID: " _ tRepositoryOID
	}
	else {
		W SQLCODE
		$$$ThrowStatus($$$ERROR($$$GeneralError, $$$CurrentMethod_" Unable to Get Repository Count to assign OID"))
	}
	
	
	/// Make sure that OID doesn't already exist - GetCodeForOID returns the OID if no code found
	If ##class(HS.Data.OIDMap).GetCodeForOID(tRepositoryOID)=tRepositoryOID {
		Set tSC = ##class(HS.Data.OIDMap).FileOID("EG"_pFacility, "Repository", tRepositoryOID, "EDGE REPOSITORY For Participant: "_pFacility)
		If $$$ISERR(tSC) Quit tSC
	}
	else {
		$$$ThrowStatus($$$ERROR($$$GeneralError, $$$CurrentMethod_" OID for repository <"_tRepositoryOID_"> already exists. Cannot generate new Edge Repository in HSREGISTRY"))
	}
	Quit tSC
}

/// This will only work where all namespaces are on the same system.  Use individual calls 
ClassMethod AddParticipantServiceRegistry(pNamespace As %String, pFacility As %String)
{
	try {
		Set tObj = ..%New()

		Set tHostAndPort=..GetCustomHostAndPort()

		Set tSubVals("CustomHostAndPort")=tHostAndPort
		Set tSubVals("FacilityId")=pFacility
		Set tSC = ..%New().AddRegistryEntries($Namespace,"RegistryEntries",.tSubVals) Quit:$$$ISERR(tSC)
		/// AddRegistryEntries is defined in parent class HS.Util.Installer.Kit.Base and contains ByRef parameter pSub
		Set tSC = tObj.AddRegistryEntries(pNamespace,"RegistryEntries",.tSubVals) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// Helper method - add facility configuration key
ClassMethod AddFacilityConfig(pFacilityId As %String = "", pGateway As %String = "") As %Status
{
	try {
		Set tSC = $$$OK
		
		/// see if the Facility config already exists
		Set tFacility = ##class(HS.Facility.Config).%OpenId(pFacilityId)
		If '$IsObject(tFacility) Set tFacility=##class(HS.Facility.Config).%New()
		Set tFacility.FacilityCode=pFacilityId
		Set tFacility.Name=pFacilityId
		Set tFacility.AssigningAuthority=1
		Set tSC = ..DemoFindGatewayByName(pGateway,.tGWID)
		Do tFacility.GatewaySetObjectId(tGWID)
		Set tSC=tFacility.%Save() Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

// Helper method - update Service registry to add device and gateway

ClassMethod UpdateServiceRegistryConfig()
{
	// CNR: need to fix - Get Existing Service Entry or Create if one doesnt exist
	Set tService = ##class(HS.Registry.Service.HTTP).EndPointForNameType(tServiceName, tServiceType)
	If tService="" {
		Set tService = ##class(HS.Registry.Service.HTTP).%New()
		Set tService.Name = tServiceName
		Set tService.Type = tServiceType
	}
	Set tService.SSLConfig = tSSLConfigName
	Set tSC = tService.ParseURL(tIssuerURL)
	Quit:$$$ISERR(tSC)
	Set tService.DeviceFunction = tDeviceFunction
	Set tSC = tService.%Save()
	Kill tService
}

/// Method override to search for FacilityId and other parameterized keys to replace
/// Parameter replacements needed in EndPoint, Name, OIDMapCodeItem
ClassMethod AddRegistryEntries(pNS As %String = "", pItems = "RegistryEntries", ByRef pSubstitutionValues) As %Status
{
	try {
		Set tSC=$$$OK
		Set tWhere = $Namespace Set:pNS]"" $Namespace=pNS 
		Set:pNS="" pNS=$Namespace
		IF '$$$IsHub Set tSC=$$$ERROR($$$GeneralError,"Registry entries are only filed in registry namespace") Quit
		Set tSC	= ..getStream(pItems, .tItemsXData) Quit:$$$ISERR(tSC)
		
		set tReader = ##class(%XML.Reader).%New()
		Set tSC = tReader.OpenStream(tItemsXData,.tObjects) Quit:$$$ISERR(tSC)
		
		// Initialize XPATH Document from tItemsXData
		Set tSC = ##class(%XML.XPATH.Document).CreateFromStream(tItemsXData, .tDocument)
		Quit:$$$ISERR(tSC)
		
		#; web services
		Do tReader.Correlate("WebService","HS.Registry.Service.SOAP")
		Set tSC=##class(%RoutineMgr).GetWebServerPort(.tPort) Quit:'tSC
		Set tHostAndPort=$ZCVT($$$HSNetworkHostName,"L")_":"_tPort
		//
		// Initialize counter for SOAP items
		Set i=0
		//
		While tReader.Next(.tItem, .tSC) {
			
			/*
				Properties with Defaults
				
				Abstract:
				Status
				Push
				SystemGenerated
				
				HTTP:
				Abstract's properties
				ProxyHTTPS
				ProxyHTTPTunnel
				ProxyHTTPSSLConnect
				SSLCheckServerIdentity
				
				SOAP:
				HTTP's properties
				MTOM
				SendSAMLAssertion
			*/
			
			Set i=i+1 // Keep track of which item being processed to grab the corresponding item from the XDATA
			For tProp="Push","SystemGenerated","ProxyHTTPS","ProxyHTTPTunnel","ProxyHTTPSSLConnect","SSLCheckServerIdentity","MTOM","SendSAMLAssertion" {
				Set tSC=tDocument.EvaluateExpression("/Items/WebService[i]/"_tProp, "text()", .tResults)
				Quit:$$$ISERR(tSC)
				If $G(tResults.Data(1))="" { // No input property, so clear default from tItem
					Set $Property(tItem, tProp) = ""
				}
			}

			//The Name of the Webservice is parameterized so we need to update the Name
			Set tName = tItem.Name
			if tName [ "{" 
			{	
				If tName[ "{FacilityId}" && ($D(pSubstitutionValues("FacilityId"))) {
					Set tItem.Name = pSubstitutionValues("FacilityId") _ $p(tName,"{FacilityId}",2)
					w "tItem.Name is: "_tItem.Name
				}
				Else {
					$$$ThrowStatus($$$ERROR($$$GeneralError, $$$CurrentMethod_" Facility Id Required"))
				}
			}

			//The OIDMapCodeItem is also parameterized so we need to update the OIDMapCodeItem
			/// Assume one instance is fine
			Set tOIDMapItem = tItem.OIDMapCode.GetAt("Repository")
			if tOIDMapItem [ "{" 
			{	
				If tOIDMapItem[ "{FacilityId}" && ($D(pSubstitutionValues("FacilityId"))) {
					do tItem.OIDMapCode.SetAt($p(tOIDMapItem,"{FacilityId}",1)_pSubstitutionValues("FacilityId"),"Repository")
					w "tItem.OIDMapCode Repository is: "_tItem.OIDMapCode.GetAt("Repository")
					
				}
				Else {
					$$$ThrowStatus($$$ERROR($$$GeneralError, $$$CurrentMethod_" Facility Id Required"))
				}
			}


			Set tEP = ##class(HS.Registry.Service.SOAP).EndPointForNameType(tItem.Name,"SOAP")
			If '$IsObject(tEP) Set tEP=tItem
			Set tEndPoint = tItem.EndPoint
			If tEndPoint ["{" {
				If tEndPoint[ "{HostAndPort}" {
					Set tEndPoint = $p(tEndPoint,"{HostAndPort}",1) _ tHostAndPort _ $p(tEndPoint,"{HostAndPort}",2)
				} ElseIf tEndPoint[ "{CustomHostAndPort}" && ($D(pSubstitutionValues("CustomHostAndPort"))) {
					Set tEndPoint = $p(tEndPoint,"{CustomHostAndPort}",1) _ pSubstitutionValues("CustomHostAndPort") _ $p(tEndPoint,"{CustomHostAndPort}",2)
				} ElseIf tEndPoint[ "{CustomURL}" && ($D(pSubstitutionValues("CustomURL"))) {
					Set tEndPoint = pSubstitutionValues("CustomURL")
				} Else {
					Set tSystemName = $p($p(tEndPoint,"{",2),"}")
					Set tHost = ..GetSystemItem(tSystemName,"Host")
					Set tPort = ..GetSystemItem(tSystemName,"WebPort")
					Set tEndPoint = $p(tEndPoint,"{"_tSystemName_"}",1) _ tHost_":"_tPort _ $p(tEndPoint,"{"_tSystemName_"}",2)
				}
				If tEndPoint["{Namespace}" {
					Set tEndPoint = $p(tEndPoint,"{Namespace}",1) _ $namespace _ $p(tEndPoint,"{Namespace}",2)
				}

				///The endpoint also needs to search and replace FacilityId
			
				if tEndPoint [ "{" 
				{	
					If tEndPoint[ "{FacilityId}" && ($D(pSubstitutionValues("FacilityId"))) {
						Set tEndPoint = $p(tEndPoint,"{FacilityId}",1) _ pSubstitutionValues("FacilityId") _ $p(tEndPoint,"{FacilityId}",2)
					}
					Else {
						$$$ThrowStatus($$$ERROR($$$GeneralError, $$$CurrentMethod_" Facility Id Required"))
					}
				}
			}				
			Set tSC = tItem.ParseURL(tEndPoint)
			Set tSC = tEP.UpdateFrom(tItem,tEP)
			Quit:$$$ISERR(tSC)
			Set tEP.Type="SOAP"
			Set tSC=tEP.%Save()
			Quit:$$$ISERR(tSC)
		}
		
		#; tcp services
		Do tReader.Rewind()
		Do tReader.Correlate("TCPService","HS.Registry.Service.TCP")
		// Initialize counter for TCP Items
		Set i=0
		While tReader.Next(.tItem, .tSC) {
			
			/*
				Properties with Defaults
				
				Abstract:
				Status
				Push
				SystemGenerated
				
			*/
			
			Set i=i+1 // Keep track of which item being processed to grab the corresponding item from the XDATA

			For tProp="Push","SystemGenerated" {
				Set tSC=tDocument.EvaluateExpression("/Items/WebService[i]/"_tProp, "text()", .tResults)
				Quit:$$$ISERR(tSC)
				If $G(tResults.Data(1))="" { // No input property, so clear default from tItem
					Set $Property(tItem, tProp) = ""
				}
			}


			Set tEP = ##class(HS.Registry.Service.TCP).EndPointForNameType(tItem.Name,"TCP")
			If '$IsObject(tEP) Set tEP=tItem
			Set tSC = tEP.UpdateFrom(tItem,tEP)
			Quit:$$$ISERR(tSC)
			Set tEP.Type="TCP"
			Set tSC=tEP.%Save()
			Quit:$$$ISERR(tSC)
		}
		
		#; http services
		Do tReader.Rewind()
		Do tReader.Correlate("HTTPService","HS.Registry.Service.HTTP")
		Set tSC=##class(%RoutineMgr).GetWebServerPort(.tPort) Quit:'tSC
		Set tHostAndPort=$ZCVT($$$HSNetworkHostName,"L")_":"_tPort
		// Initialize counter for HTTP Items
		Set i=0
		While tReader.Next(.tItem, .tSC) {
			
			/*
				Properties with Defaults
				
				Abstract:
				Status
				Push
				SystemGenerated
				
				HTTP:
				Abstract's properties
				ProxyHTTPS
				ProxyHTTPTunnel
				ProxyHTTPSSLConnect
				SSLCheckServerIdentity
				
			*/
			
			Set i=i+1 // Keep track of which item being processed to grab the corresponding item from the XDATA
			For tProp="Push","SystemGenerated","ProxyHTTPS","ProxyHTTPTunnel","ProxyHTTPSSLConnect","SSLCheckServerIdentity" {
				Set tSC=tDocument.EvaluateExpression("/Items/WebService[i]/"_tProp, "text()", .tResults)
				Quit:$$$ISERR(tSC)
				If $G(tResults.Data(1))="" { // No input property, so clear default from tItem
					Set $Property(tItem, tProp) = ""
				}
			}


			Set tEP = ##class(HS.Registry.Service.HTTP).EndPointForNameType(tItem.Name,"HTTP")
			If '$IsObject(tEP) Set tEP=tItem
			Set tEndPoint = tItem.EndPoint
			If tEndPoint ["{" {
				If tEndPoint[ "{HostAndPort}" {
					Set tEndPoint = $p(tEndPoint,"{HostAndPort}",1) _ tHostAndPort _ $p(tEndPoint,"{HostAndPort}",2)
				} ElseIf tEndPoint[ "{CustomHostAndPort}" && ($D(pSubstitutionValues("CustomHostAndPort"))) {
					Set tEndPoint = $p(tEndPoint,"{CustomHostAndPort}",1) _ pSubstitutionValues("CustomHostAndPort") _ $p(tEndPoint,"{CustomHostAndPort}",2)
				} ElseIf tEndPoint[ "{CustomURL}" && ($D(pSubstitutionValues("CustomURL"))) {
					Set tEndPoint = pSubstitutionValues("CustomURL")
				} Else {
					Set tSystemName = $p($p(tEndPoint,"{",2),"}")
					Set tHost = ..GetSystemItem(tSystemName,"Host")
					Set tPort = ..GetSystemItem(tSystemName,"WebPort")
					Set tEndPoint = $p(tEndPoint,"{"_tSystemName_"}",1) _ tHost_":"_tPort _ $p(tEndPoint,"{"_tSystemName_"}",2)
				}
				If tEndPoint["{Namespace}" {
					Set tEndPoint = $p(tEndPoint,"{Namespace}",1) _ $namespace _ $p(tEndPoint,"{Namespace}",2)
				}
				If tEndPoint["{CustomURL}" {
					Set tEndPoint = $p(tEndPoint,"{CustomURL}",1) _ pSubstitutionValues("CustomURL") _ $p(tEndPoint,"{CustomURL}",2)
				}
			}				
			Set tSC = tItem.ParseURL(tEndPoint)
			Quit:$$$ISERR(tSC)
			Set tSC = tEP.UpdateFrom(tItem,tEP)
			Quit:$$$ISERR(tSC)
			Set tEP.Type="HTTP"
			Set tSC=tEP.%Save()
			Quit:$$$ISERR(tSC)
		}
		
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Set $Namespace=tWhere
	Quit tSC
}

/*

ClassMethod HasSetting(pItem, pSettingName) As %Boolean
{
	set tIndex="",tFound=0 
	for  {
		set tIndex = pItem.Settings.Next(tIndex)  quit:tIndex=""
		set tOneSetting = pItem.Settings.GetAt(tIndex)
		If tOneSetting.Name = pSettingName Set tFound=1 Quit
	}
	;
	set tTargetClassname("Host") = pItem.ClassName
	set tTargetClassname("Adapter") = pItem.AdapterClassName()
	set tTarget="" 
	for  {
		set tTarget=$o(tTargetClassname(tTarget),1,tClassname) quit:tTarget=""
		set rs = ##class(%ResultSet).%New()
		set rs.ClassName = tClassname
		set rs.QueryName = "EnumerateSettings"
		if ('rs.QueryIsValid()) continue
		set tSC = rs.Execute()
		while (rs.Next()) {
			set tName = $G(rs.Data("Name"))
			If tName = pSettingName Set tFound=1 Quit
		}
	}
	quit tFound
}
*/

/*
ClassMethod Add(pNamespaces As HS.Util.Installer.Kit.Namespaces = {$$$NULLOREF}, pRegistryNS As %String = "HSREGISTRY", pBusNS As %String = "HSBUS", pEdgeNS = "HSEDGE1", pAccessNS = "HSACCESS") As %Status
{
	Set tWhere = $Namespace
	try {
		//Set $Namespace = pRegistryNS Set tSC = ..AddHub(pNamespaces) Quit:$$$ISERR(tSC)
		
		Set $Namespace = pEdgeNS Set tSC = ..AddEdgeGateway(pNamespaces) Quit:$$$ISERR(tSC)
		//Set $Namespace = pAccessNS Set tSC = ..AddAccessGateway(pNamespaces) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Set $Namespace = tWhere
	Quit tSC
}
*/
/// Add Production Items from XDATA block
ClassMethod AddProductionItems(pNamespace As %String = "", pBlockItems As %String = "")
{
	try {
		Set tSC=$$$OK
		Write "  Installing components in <"_pNamespace_"> namespace",!
		Set tSC= ..ProductionMods(pNamespace,pBlockItems,0) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// Helper method frequently used in Install Kit classes to update productions
ClassMethod ProductionMods(pNS As %String = {$namespace}, pItems As %String = "", pUpdate As %Boolean = 0, pProductionClass = "", pAddItemsString = "") As %Status
{
	try {
		Set tSC=$$$OK
		Set tWhere = $Namespace Set:pNS]"" $Namespace=pNS
		Set tSC=..GetProduction(.tProdRef,pProductionClass) Quit:$$$ISERR(tSC)
		If pAddItemsString="" {
			Set tSC	= ..getStream(pItems, .tProduction) Quit:$$$ISERR(tSC)
		} Else {
			Set tProduction = ##class(%Stream.GlobalCharacter).%New()
			Do tProduction.Write("<Items>"_pAddItemsString_"</Items>"),tProduction.Rewind()
		}
		set tReader = ##class(%XML.Reader).%New()
		Set tSC = tReader.OpenStream(tProduction,.tObject) Quit:$$$ISERR(tSC)
		Do tReader.Correlate("Item","Ens.Config.Item")
		While tReader.Next(.tItem, .tSC) {
			//There is 

			Set tSC=..AddUpdateConfigItem(tItem,tProdRef,pUpdate) 
			Quit:$$$ISERR(tSC)
		}
		Set tSC=##class(HS.Util.Installer.Upgrade.Abstract).SaveProduction(tProdRef)
		
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Set $Namespace=tWhere
	Quit tSC
}

/// Helper method used in installs
/// find the first production which starts out with this namespace name
ClassMethod GetProduction(Output pProdRef As Ens.Config.Production, pProductionClass = "") As %Status
{
	Try {
		Set tSC=$$$OK
		Set:pProductionClass="" pProductionClass = ##class(HS.Util.Installer.ConfigItem).ProductionGetStored($namespace)
		If pProductionClass="" {
			Set tRS=##class(%ResultSet).%New("%Library.ClassDefinition:SubclassOf")     
			Set tSC=tRS.Execute("HS.Util.AbstractProduction")
			Quit:$$$ISERR(tSC)
			While tRS.%Next() {
				Set tItem=tRS.Get("Name")
				If $p(tItem,".")=$Namespace Set pProductionClass=tItem Quit
				If $p(tItem,".")=($Namespace_"PKG") Set pProductionClass=tItem Quit
			}
			If pProductionClass="" Do ##class(Ens.Director).ParseConfigItemName("",.pProductionClass)
		}
		If pProductionClass="" Set tSC=$$$ERROR($$$GeneralError,"Production Item not found") Quit
		Set pProdRef=##class(Ens.Config.Production).%OpenId(pProductionClass)
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// helper method used in installs
ClassMethod getStream(pLocation As %String, Output pStream) As %Status
{
	If pLocation '[ "://" Set pLocation = "xdata://"_..%ClassName(1)_":"_pLocation
	Quit ##class(HS.Util.XMLUtils).GetXDataAsStreamWithSubstitutions(pLocation,.pStream)
}

/// helper method used to update production items
ClassMethod AddUpdateConfigItem(pItem As Ens.Config.Item, pToProd As Ens.Config.Production, pUpdate) As %Status
{
	#dim tItem As Ens.Config.Item
	#dim tFromItem As Ens.Config.Item
	try {
		Set tFound=0,tSC=$$$OK
		For tI=1:1:pToProd.Items.Count() {
			Set tItem=pToProd.Items.GetAt(tI)
			If tItem.ClassName=pItem.ClassName && (tItem.Name = pItem.Name) && (tItem.Comment = pItem.Comment) {Set tFound=1 Quit}
		}
		If tFound && 'pUpdate Quit   //already there, done if not updating it
		If 'tFound {
			Set tSC=pToProd.Items.Insert(pItem)
			Quit
		} Else {
			For tProperty = "Category","ClassName","PoolSize","Enabled","Foreground","DisableErrorTraps","InactivityTimeout","Comment","LogTraceEvents","Schedule" {
				Set $zobjProperty(tItem,tProperty)=$zobjProperty(pItem,tProperty)
			}
		}

		Set tIdx=""
		For {
			Set tSetting = pItem.Settings.GetNext(.tIdx) Quit:tIdx=""
			Set tIdx2="",tSettingFound=0
			For  {
				Set tSetting2 = tItem.Settings.GetNext(.tIdx2) Quit:tIdx2=""
				If tSetting2.Name = tSetting.Name {
					Set tSetting2.Value = tSetting.Value,tSetting2.Target = tSetting.Target,tSettingFound=1
				}
			}
			If 'tSettingFound Do tItem.Settings.Insert(tSetting)
		}
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

/// More helper methods
/// Returns the object's class name. The <var>fullname</var> determines how the
/// class name is represented. If it is 1 then it returns the full class name
/// including any package qualifier. If it is 0 (the default) then it returns the
/// name of the class without the package, this is mainly for backward compatibility
/// with the pre-package behaviour of %ClassName.
ClassMethod %ClassName(fullname As %Boolean) As %String [ ServerOnly = 0 ]
{
	Quit $select($get(fullname,0):$$$objClass,1:$$$ClassCompatibleName($$$objClass))
}

ClassMethod Notes()
{
	set dir=##class(%File).NormalizeDirectory($system.Util.InstallDirectory()_"\Data")
	do ..DisplayNotes("InstallIntro",dir)
	read !?60,"<Enter>",y
}

ClassMethod SetupFacility(pCode, pName, pExternalOrGateway) As %Status
{
	If ##class(HS.Facility.Config).%ExistsId(pCode) Quit $$$OK

	Write !,"Setup facility "_pCode
	Set tFacility=##class(HS.Facility.Config).%New()
	Set tFacility.FacilityCode=pCode
	Set tFacility.Name=pName
	If pExternalOrGateway = 1 {
		Set tFacility.ExternalHIE = 1
	} Else {
		Set tSC = ##class(HS.Gateway.Config).FindByName(pExternalOrGateway, .tGWID) Quit:$$$ISERR(tSC) tSC
		If tGWID="" Quit $$$ERROR($$$GeneralError,"Gateway not found: "_pExternalOrGateway) 
		Do tFacility.GatewaySetObjectId(tGWID)
	}
	Quit tFacility.%Save()
}

ClassMethod DisplayNotes(pXdata As %String = "DemoNotes", p1 As %String = "")
{
 if p1="" set p1=##class(%File).NormalizeDirectory($system.Util.InstallDirectory()_"\Data")
 set tSC=##class(Ens.Util.URLStream).GetURLStream("xdata://HS.Util.Installer:"_pXdata, .notes) Quit:$$$ISERR(tSC)
 set note=notes.Read(32000),note=$p(note,"<text>",2,99999),note=$p(note,"</text>")
 while note["{p1}" {set note=$p(note,"{p1}")_p1_$p(note,"{p1}",2,99999)}
 while $l(note) {
	set n1=$p(note,$c(13,10),1,24),note=$p(note,$c(13,10),25,99999)
	write !,n1
	if $l(note) read !?60,"<Enter>",y
 }
}

/// Create a directory
/// Deprecated - do not use
ClassMethod CreateDir(pPath As %String) As %Status
{
 set tSC=$$$OK
 set tOK=##class(%File).CreateDirectoryChain(pPath)  
 if 'tOK set tSC=$$$ERROR($$$DirectoryCannotCreate,pPath)
 quit tSC
}

/// Copy a directory
/// Deprecated - do not use
ClassMethod CopyDir(pSrc As %String, pTarget As %String) As %Status
{
 set %objlasterror = $$$OK,tSC=$$$OK
 set tOK=##class(%File).CopyDir(pSrc, pTarget,1)
 if 'tOK {
	if $$$ISERR(%objlasterror) {set tSC=%objlasterror}
	else {set tSC=$$$ERROR($$$FileCanNotCopy,pSrc,pTarget)}
 }
 quit tSC
}

/// Copy a file
ClassMethod CopyFile(pSrc As %String, pTarget As %String) As %Status
{
 set tSC=$$$OK
 set tOK=$zu(140,11,pSrc,pTarget) // 0 = success
 if tOK'=0 set tSC=$$$ERROR($$$FileCanNotCopy,pSrc,pTarget)
 quit tSC
}

/*
ClassMethod AddHub(pNamespaces As HS.Util.Installer.Kit.Namespaces = {$$$NULLOREF}, pNS = {$Namespace}, pAddBusEntries = 0)
{
	try {
		Set tObj = ..%New()
		Set tSC = tObj.AddRegistryEntries(pNS,"RegistryEntries") Quit:$$$ISERR(tSC)
		If 'pAddBusEntries && $isObject(pNamespaces) {
			For tIdx = 1:1:pNamespaces.Namespace.Count() {
				Set tNamespace = pNamespaces.Namespace.GetAt(tIdx)
				If tNamespace.Type = "Bus" Set pAddBusEntries=1 Quit
			}
		}
		Set:pAddBusEntries tSC = tObj.AddRegistryEntries(pNS,"BusRegistryEntries") Quit:$$$ISERR(tSC)
		Set tSC = ##class(HS.Util.Installer.Kit.IHE.PIXPDQ).AddHub(pAddBusEntries) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}
*/

/*
ClassMethod AddBus(pNamespaces As HS.Util.Installer.Kit.Namespaces = {$$$NULLOREF}, pNS = "")
{
	try {
		Set tSC = ..ProductionMods(pNS,"BusItems",1) Quit:$$$ISERR(tSC)
		Set tSC = ##class(HS.Util.Installer.Kit.IHE.PIXPDQ).AddBus(pNamespaces) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}
*/
/// replaced $namespace
XData RegistryEntries
{
<Items>
<WebService>
<Name>{FacilityId}.XDSb.Repository</Name>
<Push>1</Push>
<SSLConfig></SSLConfig>
<EndPoint>http://{HostAndPort}/csp/healthshare/EG{FacilityId}/services/HS.IHE.XDSb.Repository.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
<OIDMapCode>
<OIDMapCodeItem OIDMapCodeKey="Repository">EG{FacilityId}</OIDMapCodeItem>
</OIDMapCode>
<MTOM>1</MTOM>
<DeviceFunction>XDSb.Retrieve</DeviceFunction>
</WebService>
</Items>
}

XData BusRegistryEntries
{
<Items>
<WebService>
<Name>BUS.XDSb.Repository</Name>
<SSLConfig></SSLConfig>
<EndPoint>http://{HostAndPort}/csp/healthshare/hsbus/services/HS.IHE.XDSb.Repository.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>
<WebService>
<Name>BUS.XDSb.Registry</Name>
<SSLConfig></SSLConfig>
<EndPoint>http://{HostAndPort}/csp/healthshare/hsbus/services/HS.IHE.XDSb.Registry.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>
</Items>
}

XData BusRegistryEntriesRouter
{
<Items>
<WebService>
<Name>BUS.XDSb.Repository</Name>
<SSLConfig></SSLConfig>
<EndPoint>http://{HostAndPort}/csp/healthshare/hsbus/services/HS.IHE.XDR.Recipient.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>
<WebService>
<Name>BUS.XDSb.Registry</Name>
<SSLConfig></SSLConfig>
<EndPoint>http://{HostAndPort}/csp/healthshare/hsbus/services/HS.IHE.XDSb.Registry.Services.cls</EndPoint>
<UsernameTokenProfileConfig>HS_Services</UsernameTokenProfileConfig>
</WebService>
</Items>
}

XData RouterItems
{
<Items>
  <Item Name="HS.IHE.XDR.Recipient.Services" Category="" ClassName="HS.IHE.XDR.Recipient.Services" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.IHE.XDR.Recipient.DirectProcess" Category="" ClassName="HS.IHE.XDR.Recipient.DirectProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="DeliveryTarget">HS.IHE.XDSb.Repository.Operations</Setting>
  </Item>
  <Item Name="HS.IHE.XDSb.Registry.Services" Category="" ClassName="HS.IHE.XDSb.Registry.Services" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.IHE.XDSb.Repository.Process" Category="" ClassName="HS.IHE.XDSb.Repository.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.IHE.XDSb.Registry.Operations" Category="" ClassName="HS.IHE.XDSb.Registry.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="XDSbRegistryServiceName">BUS.XDSb.Registry</Setting>
  </Item>
  <Item Name="HS.Test.Service" Category="" ClassName="HS.Test.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="XDSbSourceOperations">HS.IHE.XDSb.Repository.Operations</Setting>
    <Setting Target="Host" Name="SourceOperations">HS.IHE.PIXv3.Source.Operations</Setting>
    <Setting Target="Host" Name="PIXConsumerOperations">HS.IHE.PIXv3.Manager.Operations</Setting>
  </Item>
  <Item Name="HS.IHE.PIXv3.Source.Operations" Category="" ClassName="HS.IHE.PIXv3.Source.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Device">PIXv3SourceDevice</Setting>
    <Setting Target="Host" Name="ServiceName">BUS.PIXv3.Manager</Setting>
  </Item>
  <Item Name="HS.IHE.PIXv3.Manager.Operations" Category="" ClassName="HS.IHE.PIXv3.Manager.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ServiceName">PIXv3.Manager</Setting>
  </Item>
  <Item Name="HS.IHE.XDSb.Repository.Operations" Category="" ClassName="HS.IHE.XDSb.Repository.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="XDSbRepositoryServiceName">BUS.XDSb.Repository</Setting>
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
    <Setting Target="Host" Name="XDSbRegistryServiceName">BUS.XDSb.Registry</Setting>
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="EnsLib.XML.FileService" Category="" ClassName="EnsLib.XML.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">HS.Custom.IHE.XDSb.AddHeader.Process</Setting>
    <Setting Target="Adapter" Name="ArchivePath">C:\CCD\Archive\</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\CCD\In\</Setting>
    <Setting Target="Adapter" Name="WorkPath">C:\CCD\Workpath\</Setting>
  </Item>
  <Item Name="HS.IHE.XDSb.DocumentSource.Operations" Category="" ClassName="HS.IHE.XDSb.DocumentSource.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="XDSbRepositoryServiceName">BUS.XDSb.Repository</Setting>
    <Setting Target="Host" Name="ServiceName"></Setting>
    <Setting Target="Host" Name="XDSbRegistryServiceName">BUS.XDSb.Registry</Setting>
    
  </Item>
  <Item Name="HS.Custom.IHE.XDSb.AddHeader.Process" Category="" ClassName="HS.Custom.IHE.XDSb.AddHeader.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">HS.IHE.XDSb.DocumentSource.Operations</Setting>
  </Item>
</Items>
}

XData BusItems
{
<Items>
<Item Name="HS.Bus.Identification.Services" Category="" ClassName="HS.Bus.Identification.Services" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="RegistrationTarget">HUB</Setting>
    <Setting Target="Host" Name="GatewayType">B</Setting>
  </Item>
  <Item Name="HS.Bus.Identification.Operations" Category="" ClassName="HS.Bus.Identification.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="ServiceName">HSREGISTRY</Setting>
  </Item>
  <Item Name="HS.Bus.Data.Services" Category="" ClassName="HS.Bus.Data.Services" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
  </Item>
  <Item Name="HS.Bus.Data.Operations" Category="" ClassName="HS.Bus.Data.Operations" PoolSize="2" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
  </Item>
  <Item Name="HS.Bus.Security.Services" Category="" ClassName="HS.Bus.Security.Services" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
  </Item>
  <Item Name="HS.Bus.Security.Operations" Category="" ClassName="HS.Bus.Security.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="ServiceName">HSREGISTRY</Setting>
  </Item>
  <Item Name="HUB" Category="" ClassName="HS.Hub.HSWS.RemoteOperations" PoolSize="0" Enabled="true" Foreground="false" DisableErrorTraps="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="ServiceName">HSREGISTRY</Setting>
  </Item>
  <Item Name="HS.Util.MaintenanceService" Category="" ClassName="HS.Util.MaintenanceService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">60</Setting>
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.IHE.PIXv3.Manager.Services" Category="" ClassName="HS.IHE.PIXv3.Manager.Services" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="PIXv3AddTarget">HS.IHE.PIXv3.Manager.Operations</Setting>
    <Setting Target="Host" Name="PIXv3MergeTarget">HS.IHE.PIXv3.Manager.Operations</Setting>
    <Setting Target="Host" Name="PIXv3QueryTarget">HS.IHE.PIXv3.Manager.Operations</Setting>
    <Setting Target="Host" Name="PIXv3ReviseTarget">HS.IHE.PIXv3.Manager.Operations</Setting>
  </Item>
  <Item Name="HS.IHE.PIXv3.Manager.Operations" Category="" ClassName="HS.IHE.PIXv3.Manager.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="ServiceName">PIXv3.Manager</Setting>
  </Item>
  <Item Name="HS.IHE.PIXv3.Consumer.Services" Category="" ClassName="HS.IHE.PIXv3.Consumer.Services" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="PIXv3ReviseTarget">PIXv3.NotificationOperations</Setting>
  </Item>
  <Item Name="PIXv3.NotificationOperations" Category="" ClassName="HS.Util.SOAPClient.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="ServiceName">PIXv3.Consumer</Setting>
  </Item>
  <Item Name="HS.IHE.PDQv3.Supplier.Services" Category="" ClassName="HS.IHE.PDQv3.Supplier.Services" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="PDQv3CancelTarget">HS.IHE.PDQv3.Consumer.Operations</Setting>
    <Setting Target="Host" Name="PDQv3ContinueTarget">HS.IHE.PDQv3.Consumer.Operations</Setting>
    <Setting Target="Host" Name="PDQv3QueryTarget">HS.IHE.PDQv3.Consumer.Operations</Setting>
  </Item>
  <Item Name="HS.IHE.PDQv3.Consumer.Operations" Category="" ClassName="HS.IHE.PDQv3.Consumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="ServiceName">PDQv3.Supplier</Setting>
  </Item>
  <Item Name="HS.IHE.XDSb.Registry.Services" Category="" ClassName="HS.IHE.XDSb.Registry.Services" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="XDSbQueryTarget">HS.IHE.XDSb.Registry.Operations</Setting>
    <Setting Target="Host" Name="XDSbRegisterTarget">HS.IHE.XDSb.Registry.Operations</Setting>
    <Setting Target="Host" Name="PIXv3ManagerTarget">HS.IHE.PIXv3.Manager.Operations</Setting>
  </Item>
  <Item Name="HS.IHE.XDSb.Registry.Operations" Category="" ClassName="HS.IHE.XDSb.Registry.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="XDSbRegistryServiceName">XDSb.Registry</Setting>
  </Item>
  <Item Name="HS.IHE.XDSb.Repository.Services" Category="" ClassName="HS.IHE.XDSb.Repository.Services" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="XDSbProvideAndRegisterTarget">HS.Custom.IHE.XDSb.DocumentSource.Operations</Setting>
    <Setting Target="Host" Name="XDSbRetrieveTarget">HS.IHE.XDSb.Repository.Router</Setting>
  </Item>
  <Item Name="HS.IHE.XDSb.Repository.Router" Category="" ClassName="HS.IHE.XDSb.Repository.Router" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
  </Item>
  <Item Name="HS.IHE.XDSb.Repository.Operations" Category="" ClassName="HS.IHE.XDSb.Repository.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="XDSbRepositoryServiceName"></Setting>
    <Setting Target="Host" Name="ReplyCodeActions">E=R</Setting>
  </Item>
  <Item Name="HS.IHE.XCA.RespondingGateway.Services" Category="" ClassName="HS.IHE.XCA.RespondingGateway.Services" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="XCAQueryTarget">HS.IHE.XCA.RespondingGateway.Process</Setting>
    <Setting Target="Host" Name="XCARetrieveTarget">HS.IHE.XCA.RespondingGateway.Process</Setting>
  </Item>
  <Item Name="HS.IHE.XCA.RespondingGateway.Process" Category="" ClassName="HS.IHE.XCA.RespondingGateway.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="XDSbRegistryOperations">HS.IHE.XDSb.Registry.Operations</Setting>
    <Setting Target="Host" Name="XCARespondingGatewayOperations">HS.IHE.XCA.RespondingGateway.Operations</Setting>
    <Setting Target="Host" Name="XDSbRepositoryProcess">HS.IHE.XDSb.Repository.Process</Setting>
  </Item>
  <Item Name="HS.IHE.XCA.RespondingGateway.Operations" Category="" ClassName="HS.IHE.XCA.RespondingGateway.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
  </Item>
  <Item Name="HS.IHE.XDSb.Repository.Process" Category="" ClassName="HS.IHE.XDSb.Repository.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
  </Item>
  <Item Name="HS.IHE.XCPD.RespondingGateway.Services" Category="" ClassName="HS.IHE.XCPD.RespondingGateway.Services" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="XCPDDiscoveryTarget">HS.IHE.XCPD.RespondingGateway.Process</Setting>
  </Item>
  <Item Name="HS.IHE.XCPD.RespondingGateway.Process" Category="" ClassName="HS.IHE.XCPD.RespondingGateway.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
  </Item>
  <Item Name="HS.IHE.XCPD.RespondingGateway.Operations" Category="" ClassName="HS.IHE.XCPD.RespondingGateway.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
  </Item>
  <Item Name="HS.IHE.XDSb.DocumentSource.Operations" Category="" ClassName="HS.Custom.IHE.XDSb.DocumentSource.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="XDSbRepositoryServiceName"></Setting>
  </Item>
  <Item Name="HS.IHE.XDR.Source.Operations" Category="" ClassName="HS.IHE.XDR.Source.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.Custom.IHE.XDSb.DocumentSource.Operations" Category="" ClassName="HS.Custom.IHE.XDSb.DocumentSource.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="XDSbRepositoryServiceName"></Setting>
  </Item>
  <Item Name="HS.IHE.XDR.Recipient.Services" Category="" ClassName="HS.IHE.XDR.Recipient.Services" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="ProvideAndRegisterTarget">HS.IHE.XDR.Recipient.CommonProcess</Setting>
    
  </Item>
  <Item Name="HS.IHE.XDR.Recipient.CommonProcess" Category="" ClassName="HS.IHE.XDR.Recipient.CommonProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="MessageTarget">HS.IHE.XDSb.DocumentSourceRouter</Setting>
    <Setting Target="Host" Name="CustomProcessor"></Setting>
  </Item>
  <Item Name="HS.IHE.XDSb.DocumentSourceRouter" Category="" ClassName="HS.Custom.IHE.XDSb.DocumentSourceRouter" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Items>
}

/// XData for Edge Gateway import
XData EdgeGatewayItems
{
<Items>
  <Item Name="HS.IHE.XDSb.Repository.Services" Category="" ClassName="HS.IHE.XDSb.Repository.Services" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="XDSbProvideAndRegisterTarget">HS.IHE.XDSb.Repository.Process</Setting>
    <Setting Target="Host" Name="XDSbRetrieveTarget">HS.IHE.XDSb.Repository.Process</Setting>
  </Item>
  <Item Name="HS.IHE.XDSb.Repository.Process" Category="" ClassName="HS.IHE.XDSb.Repository.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="RepositoryOperations">HS.IHE.XDSb.Repository.Operations</Setting>
    <Setting Target="Host" Name="RegistryOperations">HS.IHE.XDSb.Repository.Operations</Setting>
  </Item>
  <Item Name="HS.IHE.XDSb.Repository.Operations" Category="" ClassName="HS.IHE.XDSb.Repository.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="XDSbRegistryServiceName">XDSb.Registry</Setting>
    <Setting Target="Host" Name="ReplyCodeActions">E=R</Setting>
    <Setting Target="Host" Name="XDSbRepositoryServiceName"></Setting>
    <Setting Target="Host" Name="ContentConsumerTarget">HS.IHE.XDSb.ContentConsumer.Operations</Setting>
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HS.IHE.XDSb.Consumer.Operations" Category="" ClassName="HS.IHE.XDSb.Consumer.Operations" PoolSize="2" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="XDSbRegistryServiceName">XDSb.Registry</Setting>
  </Item>
  <Item Name="HS.IHE.XDSb.ContentConsumer.Operations" Category="" ClassName="HS.Custom.IHE.XDSb.ContentConsumer.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Items>
}

/// XData for HSROUTER import
/// XData for HSBUS import
XData InstallIntro
{
<text>
A new HealthShare CCDA Pipeline for Facility {FacilityId} is installed and running.
To process CCAS, copy the files 
into {p1}EG{FacilityId}\CCDIn (on HSROUTER)

</text>
}

}

