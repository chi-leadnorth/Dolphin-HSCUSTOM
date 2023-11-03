Class HS.Local.DOLPHIN.LeadNorthCallBackMethod
{

// Morris Obiri-Creating a CallBack Method to Update some of the entries in the Registry, EdgeGateway and the XUA Configurations for purposes of various implementations

ClassMethod Run(tEdgeGateway As %Status, tIdentityCode As %Status, tDescription As %Status, tOID As %Status, tPort As %Status, tRepositoryOID As %Status) As %Status
{
    #dim tSC As %Status = $$$OK
	#dim e As %Exception.AbstractException
    Try {
		
		If $System.Mirror.IsBackup() {
			w !,"Configuration not executing on Mirror Backup member"
			Quit
		}
			// MKO:These are the entries needed to update the configurations:	
		s tEdgeGateway = ""
		s tIdentityCode = ""
		s tDescription = ""
		s tOID = ""
		s tPort = ""
		// Morris Obiri:03/15/23-Searched for this OID in all the environments, it was not used-so I picked it
		s tRepositoryOID = ""
		
		// Morris Obiri: Need to follow up with Josh whether deleting the OCHINQOLHS will have any impact for LEADNORTH: After follow up-Josh Approved (03/16/23)		
		
		// SAML creator class is hard-coded as it's typically the same per HS instance.
		s tSAMLProcessorClass = "LEADNORTH.IHE.XUA.CPSC.Processor"
		
		if ##class(%SYS.System).GetUniqueInstanceName() = "AL-HIE-E1DAPP01:ALCENTRAL001"{
			$$$ThrowOnError(..CreateCredentials("DEV",tEdgeGateway))
			
			$$$ThrowOnError(..CreateOID(tIdentityCode,tDescription,tOID))
			 
			
			$$$ThrowOnError(..CreateOIDRepo(tEdgeGateway,tDescription,tRepositoryOID))
			
			
		;	$$$ThrowOnError(..CreateFacility(tIdentityCode,tDescription,tEdgeGateway))
		
			
			$$$ThrowOnError(..UpdateSystemDefaultsHSBUS(tIdentityCode_"="_tEdgeGateway))
		
			
			$$$ThrowOnError(..UpdateSystemDefaultsHSREGISTRY(tIdentityCode))
			
			
			$$$ThrowOnError(..CreateRegistryService("DEV",tEdgeGateway,tIdentityCode,tPort))
			
			$$$ThrowOnError(..CreateXUAConfig(tIdentityCode,tSAMLProcessorClass))
			
		} elseif ##class(%SYS.System).GetUniqueInstanceName() = "E1BTESTAPP01:ALCENTRAL001" { 
			//Test configuration
			$$$ThrowOnError(..CreateCredentials("TEST",tEdgeGateway))
			
			$$$ThrowOnError(..CreateOID(tIdentityCode,tDescription,tOID))
			
			
			$$$ThrowOnError(..CreateOIDRepo(tEdgeGateway,tDescription,tRepositoryOID))
			
			
		;	$$$ThrowOnError(..CreateFacility(tIdentityCode,tDescription,tEdgeGateway))
		
			
			$$$ThrowOnError(..UpdateSystemDefaultsHSBUS(tIdentityCode_"="_tEdgeGateway))
			
			
			$$$ThrowOnError(..UpdateSystemDefaultsHSREGISTRY(tIdentityCode))
			
			
			$$$ThrowOnError(..CreateRegistryService("TEST",tEdgeGateway,tIdentityCode,tPort))
			
			$$$ThrowOnError(..CreateXUAConfig(tIdentityCode,tSAMLProcessorClass))
			
			
		} elseif  ##class(%SYS.System).GetUniqueInstanceName() = "W1BSTAGEHIE01:ALCENTRAL001" {
			//Stage configuration
			$$$ThrowOnError(..CreateCredentials("STAGE",tEdgeGateway))
			
			$$$ThrowOnError(..CreateOID(tIdentityCode,tDescription,tOID))
			
			
			$$$ThrowOnError(..CreateOIDRepo(tEdgeGateway,tDescription,tRepositoryOID))
			
			
		;	$$$ThrowOnError(..CreateFacility(tIdentityCode,tDescription,tEdgeGateway))
		
			
			$$$ThrowOnError(..UpdateSystemDefaultsHSBUS(tIdentityCode_"="_tEdgeGateway))
			
			$$$ThrowOnError(..UpdateSystemDefaultsHSREGISTRY(tIdentityCode))
			
			
			$$$ThrowOnError(..CreateRegistryService("STAGE",tEdgeGateway,tIdentityCode,tPort))
			
			$$$ThrowOnError(..CreateXUAConfig(tIdentityCode,tSAMLProcessorClass))
			
			
		} elseif ##class(%SYS.System).GetUniqueInstanceName() = "W1BPRODHIE01:ALCENTRAL001" {
			//Prod configuration
			$$$ThrowOnError(..CreateCredentials("PROD",tEdgeGateway))
			
			$$$ThrowOnError(..CreateOID(tIdentityCode,tDescription,tOID))
			
			
			$$$ThrowOnError(..CreateOIDRepo(tEdgeGateway,tDescription,tRepositoryOID))
			
			
		;	$$$ThrowOnError(..CreateFacility(tIdentityCode,tDescription,tEdgeGateway))
		
			
			$$$ThrowOnError(..UpdateSystemDefaultsHSBUS(tIdentityCode_"="_tEdgeGateway))
			
			
			$$$ThrowOnError(..UpdateSystemDefaultsHSREGISTRY(tIdentityCode))
			
			
			$$$ThrowOnError(..CreateRegistryService("PROD",tEdgeGateway,tIdentityCode,tPort))
			
			$$$ThrowOnError(..CreateXUAConfig(tIdentityCode,tSAMLProcessorClass))
			
		}		
		
	} catch e {
		s tSC = e.AsStatus()
		w !,!,"Error Description: "_e.DisplayString()
	}
	Quit tSC
}

Method CreateCredentials(pEdgeGateway As %Status, pEnv As %Status) As %Status
{
    
	#dim tSC As %Status = $$$OK
	#dim e As %Exception.AbstractException
	
	Try {
		ZN pEdgeGateway
		
		if pEnv = "DEV" {   //adding this to dev
			s tSC = ##class(Ens.Config.Credentials).SetCredential("HS_Services","HS_Services","pSwDXXXX",1)
			w !,tSC
		}
		elseIf pEnv = "TEST" {
			s tSC = ##class(Ens.Config.Credentials).SetCredential("HS_Services","HS_Services","pSwDXXXX",1)
			w !,tSC
		}
		elseIf pEnv = "STAGE" {
			s tSC = ##class(Ens.Config.Credentials).SetCredential("HS_Services","HS_Services","pSwDXXXX",1)
			w !,tSC
		}
		elseIf pEnv = "PROD" {
			s tSC = ##class(Ens.Config.Credentials).SetCredential("HS_Services","HS_Services","pSwDXXXX",1)
			w !,tSC
		}
		
		ZN "HSCUSTOM"
		
	} catch e {
		s tSC = e.AsStatus()
	}
	Quit tSC
}

Method CreateXUAConfig(pIdentityCode As %Status, pSAMLProcessorClass As %Status)
{
#dim tSC As %Status = $$$OK
	#dim e As %Exception.AbstractException	
	
	Try {
		ZN "HSREGISTRY"
		
		// Get OID object
 		s tOROID = ##class(HS.Data.OIDMap).GetOIDForCode(pIdentityCode, "")
		if (tOROID '= "")
		{
			s tOROIDObject = ##class(HS.Data.OIDMap).ObjectForOID(tOROID)
			s tXUAConfig = ##class(HS.IHE.XUA.Config).FindConfiguration(tOROID)
		}
		if ((tXUAConfig = "") && $D(tOROIDObject))
		{
			s tXUAConfig = ##class(HS.IHE.XUA.Config).%New()
			s tXUAConfig.DomainPrefix = "%HS"
			s tXUAConfig.Name = pIdentityCode
			s tXUAConfig.Issuer = "OU=Entrust NFI Test Shared Service Provider,OU=Certification Authorities,O=Entrust,C=US"
			s tXUAConfig.SAMLCreatorClass = "LEADNORTH.IHE.XUA.Creator"
			s tXUAConfig.SAMLProcessorClass = pSAMLProcessorClass
			s tXUAConfig.RequireSignature = 0
			s tXUAConfig.SignCreatedAssertion = 0
			s tXUAConfig.UseWSSSignature = 1
			s tXUAConfig.CheckSignerIdentity = 0
			s tXUAConfig.OrganizationOID = tOROIDObject
			s tXUAConfig.DefaultSecurityDomain = "SAML"
			s tSC = tXUAConfig.%Save()
			
			w !, "XUA Registry Configuration complete"
		} else {
			w !, "XUA Registry Configuration for "_pIdentityCode_" already exists."
			w !, "Must be manually updated to avoid overwriting with old configurations."
		}
		
		ZN "HSCUSTOM"	
	} catch e {
		s tSC = e.AsStatus()
	}
	Quit tSC
}

Method CreateOID(pIdentityCode As %Status, pDescription As %Status, pOID As %Status)
{
    
	
	#dim tSC As %Status = $$$OK
	#dim e As %Exception.AbstractException
	
	Try {
		ZN "HSREGISTRY"
		s tOID = pOID
		s tName = pDescription
		s tCode = pIdentityCode
		s tType = "AssigningAuthority"
		s tAdditionalTypes = "Facility,Device"
		s tSC = ##class(HS.Data.OIDMap).FileOID(tCode,tType,tOID,tName,tAdditionalTypes,)
		if 'tSC {
			w !,$System.Status.GetErrorText(tSC)
		} else {
			w !,pDescription_" OID created successfully."
		}
		ZN "HSCUSTOM"	
		
	} catch e {
		s tSC = e.AsStatus()
	}
	Quit tSC
}

Method CreateOIDRepo(pIdentityCode As %Status, pDescription As %Status, pRepoOID As %Status)
{
        
	#dim tSC As %Status = $$$OK
	#dim e As %Exception.AbstractException
	
	Try {
		ZN "HSREGISTRY"
		
		s tOID = pRepoOID
		s tName = pDescription
		s tCode = pIdentityCode
		s tType = "Repository"
		s tSC = ##class(HS.Data.OIDMap).FileOID(tCode,tType,tOID,tName,,)
		if 'tSC {
			w !,$System.Status.GetErrorText(tSC)
		} else {
			w !, pIdentityCode_" Repository OID created successfully."
		}
	
		ZN "HSCUSTOM"
	
	} catch e {
		s tSC = e.AsStatus()
	}
	Quit tSC
}

Method CreateFacility(pIdentityCode As %Status, pDescription As %Status, pEdgeGateway As %Status)
{
    #dim tSC As %Status = $$$OK
	#dim e As %Exception.AbstractException
	
	Try {
		//this needs to be done after edgegateway's -HS_Services password has been completed
		ZN "HSREGISTRY"
		s tGWId=""
		s tQueryEG = "%"_pEdgeGateway
		&sql(select Id into :tGWId from hs_gateway.config where Name like :tQueryEG)
		if SQLCODE '= 0 {
			w !,"Gateway for "_pEdgeGateway_" not found: "_SQLCODE 
			QUIT
		}
		s tGateway=##class(HS.Gateway.Config).%OpenId(tGWId)	
		
		// Get OID Object to build Facility
		Set tOROID = ##class(HS.Data.OIDMap).GetOIDForCode(pIdentityCode, "")
		If (tOROID '= "")
		{
			s tOROIDObject = ##class(HS.Data.OIDMap).ObjectForOID(tOROID)
			s tXUAConfig = ##class(HS.IHE.XUA.Config).FindConfiguration(tOROID)
		}
		
		s (tFacId) = ""
		&sql(select id into :tFacId from HS_Facility.Config where FacilityCode = pIdentityCode)
		if SQLCODE '= 0 s tFacId=""
		
		if tFacId = "" {
		
			s tFacility = ##class(HS.Facility.Config).%New()
			s tFacility.FacilityCode=pIdentityCode
			s tFacility.Name=pIdentityCode
			s tFacility.Description=pDescription
			s tFacility.Gateway=tGateway
			//s tFacility.FacilityId = ""
			s tFacility.AssigningAuthority=1
			s tFacility.OID=tOROID	
			
			s tSC=tFacility.%Save()
			
			w !,pDescription_" facility created."
		} else {
			w !,pDescription_" facility already exists.  Must be manually updated."
		}
		ZN "HSCUSTOM"
	} catch e {
		s tSC = e.AsStatus()
	}
	Quit tSC
}

Method UpdateSystemDefaultsHSBUS(pSystemDefaultHSBUS As %Status)
{
#dim tSC As %Status = $$$OK
	#dim e As %Exception.AbstractException
	
	Try {
		ZN "HSBUS"
				
		s tDefault = ##class(Ens.Config.DefaultSettings).%New()
		s tDefault.ProductionName = "HSBUSPKG.BusProduction"	
		s tDefault.ItemName = "LEADNORTH.HS.IHE.XDSb.Repository.ProvideRouter"
		s tDefault.SettingName = "SourceToRepository"
		s tDefault.Deployable = 1
		s tDelim = $C(10)
		s tSC = ##class(Ens.Config.DefaultSettings).%GetSetting(tDefault.ProductionName,tDefault.ItemName,"*","",tDefault.SettingName,.tSettingValues)
		if tSC {
			s tSettingValueExists = 0
			// loop through the Setting Values to find if pSystemDefaultHSBUS already exists and add it if it doesn't.
			s tSettingValueList = $LFS(tSettingValues,tDelim)
			s tSettingValueListLength = $LISTLENGTH(tSettingValueList)
			if tSettingValueListLength > 0 {
				w !,"Setting Value List Length: "_tSettingValueListLength
				For tCounter = 1:1:tSettingValueListLength{
					s tSettingValue = ""
					s tSettingValue = $LI(tSettingValueList,tCounter)
					if tSettingValue = pSystemDefaultHSBUS {
						w !,"Setting Value "_pSystemDefaultHSBUS_" already exists."
						s tSettingValueExists = 1
					}
				}
				if tSettingValueExists = 0 {
					s tDefault.SettingValue = tSettingValues_tDelim_pSystemDefaultHSBUS
					w !,"Added Setting Value to current list "_tDefault.SettingValue
					$$$ThrowOnError(..SaveDefault(tDefault))
				}
			}
			
		} else {
			s tDefault.SettingValue = pSystemDefaultHSBUS
			$$$ThrowOnError(..SaveDefault(tDefault))
		}		
		
		zn "HSCUSTOM"
		
		w !,"HSBUS System Default Settings Update Completed."
	} catch e {
		s tSC = e.AsStatus()
	}
	Quit tSC
}

Method UpdateSystemDefaultsHSREGISTRY(pSystemDefaultHSREGISTRY As %Status)
{
    #dim tSC As %Status = $$$OK
	#dim e As %Exception.AbstractException
	
	Try {
		zn "HSREGISTRY"
				
		s tDefault = ##class(Ens.Config.DefaultSettings).%New()
		s tDefault.ProductionName = "HSREGISTRYPKG.HubProduction"	
		s tDefault.ItemName = "LEADNORTH.HS.Hub.MPIPostProcessor"
		s tDefault.SettingName = "ForwardUpdateAsADT"
		s tDefault.Deployable = 1
		s tDelim = ","
		s tSC = ##class(Ens.Config.DefaultSettings).%GetSetting(tDefault.ProductionName,tDefault.ItemName,"*","",tDefault.SettingName,.tSettingValues)
		if tSC {
			s tSettingValueExists = 0
			// loop through the Setting Values to find if pSystemDefaultHSREGISTRY already exists and add it if it doesn't.
			s tSettingValueList = $LFS(tSettingValues,tDelim)
			s tSettingValueListLength = $LISTLENGTH(tSettingValueList)
			if tSettingValueListLength > 0 {
				w !,"Setting Value List Length: "_tSettingValueListLength
				For tCounter = 1:1:tSettingValueListLength{
					s tSettingValue = ""
					s tSettingValue = $LI(tSettingValueList,tCounter)
					if tSettingValue = pSystemDefaultHSREGISTRY {
						w !,"Setting Value "_pSystemDefaultHSREGISTRY_" already exists."
						s tSettingValueExists = 1
					}
				}
				if tSettingValueExists = 0 {
					s tDefault.SettingValue = tSettingValues_tDelim_pSystemDefaultHSREGISTRY
					w !,"Added Setting Value to current list "_tDefault.SettingValue
					$$$ThrowOnError(..SaveDefault(tDefault))
				}
			}
			
		} else {
			s tDefault.SettingValue = pSystemDefaultHSREGISTRY
			$$$ThrowOnError(..SaveDefault(tDefault))
		}
		
		
		
	zn "HSCUSTOM"
	
	w !,"HSREGISTRY System Default Settings Update Completed."
	} catch e {
		s tSC = e.AsStatus()
	}
	Quit tSC
}

Method SaveDefault(pDefault As %Status)
{
    #dim tSC As %Status = $$$OK
	#dim e As %Exception.AbstractException
	
	Try {
		If ##class(Ens.Config.DefaultSettings).%ExistsId(pDefault.ProductionName_"||"_pDefault.ItemName_"||"_pDefault.HostClassName_"||"_pDefault.SettingName) {
			// modify
			Set tExistingItem = ##class(Ens.Config.DefaultSettings).%OpenId(pDefault.ProductionName_"||"_pDefault.ItemName_"||"_pDefault.HostClassName_"||"_pDefault.SettingName)
			Set tDifferent = 0
			Set tDifferent = ((tExistingItem.Deployable '= pDefault.Deployable)||(tExistingItem.Description '= pDefault.Description)||(tExistingItem.SettingValue '= pDefault.SettingValue))
			If tDifferent {
				Set tExistingItem.Deployable = pDefault.Deployable
				Set tExistingItem.Description = pDefault.Description
				Set tExistingItem.SettingValue = pDefault.SettingValue
				Set tSC = tExistingItem.%Save()
			}
			#; Remember ID of existing whether changes or not
			Set tID = tExistingItem.%Id()
		} Else {
			Set tSC = pDefault.%Save()
			Set tID = pDefault.%Id()
		}
		
		if 'tSC w !,$System.Status.GetErrorText(tSC)
		
		s tSC = ##class(Ens.Director).EnableConfigItem(pDefault.ItemName,0,1)
		if 'tSC w !,$System.Status.GetErrorText(tSC)
		
		s tSC = ##class(Ens.Director).EnableConfigItem(pDefault.ItemName,1,1)
		if 'tSC w !,$System.Status.GetErrorText(tSC)		
	} catch e {
		s tSC = e.AsStatus()
	}
	Quit tSC
}

Method CreateAlertsAnalyticsSettingsPROD(pEdgeGateway As %Status)
{
#dim tSC As %Status = $$$OK
	#dim e As %Exception.AbstractException
	
	Try {
		//***BE SURE TO ALSO ADD and DEPLOY BUSINESS ITEM "Ens.Alert" for the edge
		
		ZN pEdgeGateway
		//ClassMethod SetEdgeDefaults(pEDGE As %String,pADTIF As %String,pNQueryIF As %String) As %Status
		set tSC = ##class(LEADNORTH.Util.Deployment).SetEdgeDefaults(pEdgeGateway,"0","1")
			
		ZN "HSCUSTOM"	
			
		w !, pEdgeGateway_" Alerts, Analytics, N&Q Defaults Created and Deployed"
	} catch e {
		s tSC = e.AsStatus()
	}
	Quit tSC
}

Method CreateRegistryService(pEnv As %Status, pEdgeGateway As %Status, pIdentityCode As %Status, pPort As %Status)
{
    #dim tSC As %Status = $$$OK
	#dim e As %Exception.AbstractException
	
	Try {
		if pEnv = "" {Quit}
		
		zn "HSREGISTRY"
		s tRepository = pEdgeGateway_".XDSb.Respository"
		s tRetrieve = pEdgeGateway_".XDSb.Retrieve"
		s tPIXConsumer = "PIXv2.Consumer."_pIdentityCode
		s tEdgeGatewayLower = $ZCONVERT(pEdgeGateway,"l")
		s (tRepoId,tRetvId,tPIX) = ""
		&sql(select id into :tRepoId from HS_Registry_Service.SOAP where Name = :tRepository)
		if SQLCODE '= 0 s tRepoId=""
		&sql(select id into :tRetvId from HS_Registry_Service.SOAP where Name = :tRetrieve)
		if SQLCODE '= 0 s tRetvId=""
		&sql(select id into :tPIX from HS_Registry_Service.TCP where Name = :tPIXConsumer)
		if SQLCODE '= 0 s tPIX=""	
		
		if tRepoId '= "" { s tRepoService = ##class(HS.Registry.Service.SOAP).%OpenId(tRepoId) } else {s tRepoService = ##class(HS.Registry.Service.SOAP).%New()}
		if tRetvId '= "" { s tRetvService = ##class(HS.Registry.Service.SOAP).%OpenId(tRetvId) } else {s tRetvService = ##class(HS.Registry.Service.SOAP).%New()}
		if tPIX '= "" { s tPIXService = ##class(HS.Registry.Service.TCP).%OpenId(tPIX) } else {s tPIXService = ##class(HS.Registry.Service.TCP).%New()}
		
	
		s tRepoService.Name = tRepository
		s tRepoService.DeviceFunction = "XDSb.NotifyAndQueryEdge"
		s tRepoService.Host = $CASE(pEnv,"DEV":"al-hie-e1dapp01","TEST":"e1btestapp01","STAGE":"w1bstagehie01","PROD":"w1bprodhie01",:"")
		s tRepoService.Port = $CASE(pEnv,"DEV":"57772","TEST":"57772","STAGE":"57772","PROD":"57772",:"")
		s tRepoService.URL = "/csp/healthshare/"_tEdgeGatewayLower_"/services/HS.IHE.XDSb.Repository.Services.cls"
		s tRepoService.UsernameTokenProfileConfig = "HS_Services"
		s tRepoService.SendSAMLAssertion = 0
		s tRepoService.SSLCheckServerIdentity = 1
		d tRepoService.OIDMapCode.SetAt(pEdgeGateway,"Repository")
		
		s tSC = tRepoService.%Save()
		if 'tSC w !,$System.Status.GetErrorText(tSC)
	
		s tRetvService.Name = tRetrieve
		s tRetvService.DeviceFunction = "XDSb.Retrieve"	
		s tRetvService.Host = $CASE(pEnv,"DEV":"al-hie-e1dapp01","TEST":"e1btestapp01","STAGE":"w1bstagehie01","PROD":"w1bprodhie01",:"")
		s tRetvService.Port = $CASE(pEnv,"DEV":"57772","TEST":"57772","STAGE":"57772","PROD":"57772",:"")
		s tRetvService.URL = "/csp/healthshare/"_tEdgeGatewayLower_"/services/HS.IHE.XDSb.Repository.Services.cls"
		s tRetvService.UsernameTokenProfileConfig = "HS_Services"
		s tRetvService.SendSAMLAssertion = 0
		s tRetvService.SSLCheckServerIdentity = 1
		d tRetvService.OIDMapCode.SetAt(pEdgeGateway,"Repository")
		
		s tSC = tRetvService.%Save()
		if 'tSC w !,$System.Status.GetErrorText(tSC)
		
		s tPIXService.Name = tPIXConsumer
		d tPIXService.OIDMapCode.SetAt(pIdentityCode,"Device")
		s tPIXService.DeviceFunction = "PIXv2.Consumer"
		s tPIXService.Host = "localhost"
		s tPIXService.Port = pPort
		s tPIXService.Type = "TCP"		
		d tPIXService.OIDMapCode.SetAt(pIdentityCode,"ReceivingFacility")
		s tPIXService.StayConnected = 0
			
		s tSC = tPIXService.%Save()
		if 'tSC w !,$System.Status.GetErrorText(tSC)
	
	
		w !, "Service Registry Configuration complete"
		
		zn "HSCUSTOM"
	} catch e {
		s tSC = e.AsStatus()
	}
	Quit tSC
}

Method CreateClassificationCodeEntry(pCode As %String, pCodeType As %String, pCodingScheme As %String, pDescription As %String, pToHTML As %String, pToSDA As %String)
{
    #dim tSC As %Status = $$$OK
	#dim e As %Exception.AbstractException
	
	Try {
		zn "HSREGISTRY"
		
		s tClassificationCode = ##class(HS.IHE.CodedEntry).%New()
		
		$$$ThrowOnError(tClassificationCode.Create(pCodeType, pCodingScheme, pCode, pDescription,pToSDA,pToHTML))
		if 'tSC {
			w !,$System.Status.GetErrorText(tSC)
		} else {
			w !,"Classification Code added or exists: "_pCode_"; "_pCodeType_"; "_pCodingScheme_"; "_pDescription
		}
		
		zn "HSCUSTOM"	
	
	} catch e {
		s tSC = e.AsStatus()
	}
	Quit tSC
}

}

