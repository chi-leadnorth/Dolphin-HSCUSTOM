Class HS.Local.Builder.HL7.HL7Installer Extends (HS.HC.Util.Installer, HS.Util.Installer.Kit.PostInstall.Base)
{

ClassMethod AddHL7Pipeline(pFacility As %String = "", pSchemaCategory As %String = "") As %Status
{
	try {
		#; various things that need to be setup in a facility installation
		Set tSC = $$$OK

		If pFacility = "" { 
			Read !, "ENTER the Facility ID: ", pFacility
		
		}

		if pFacility = "" {
			Write "Facility ID and OID require non-empty values"
			$$$ThrowStatus($$$ERROR($$$GeneralError, "Facility ID and OID require non-empty values"))
		}

		
		//Add items to HSROUTER
        // call the InstallRouter or whatever....
		Set tSC =  ..AddProductionItems(pFacility, "RouterItems")
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	
	Quit tSC
}

ClassMethod InstallRouter() As %Status
{
	Set tSC = $$$OK

	
	//Set up HSROUTER production
	Set tSC =  ..AddProductionItems("TEAM2SANDBOX", "RouterItems")
    Set tSC =  ..AddProductionItems("TEAM2SANDBOX", "FileServiceItems")
    Set tSC =  ..AddProductionItems("TEAM2SANDBOX", "FileOperation")

	quit tSC
}

/// XData for HSRouter import
/// CNR: This item is just a dummy example - replace with your production items
XData RouterItems
{
<Item Name="MsgRouter" Category="" ClassName="EnsLib.HL7.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="This handles message routing logic." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Validation"></Setting>
    <Setting Target="Host" Name="BusinessRuleName">TEAM1SANDBOXPKG.D.DOLP.RoutingRule</Setting>
    <Setting Target="Host" Name="BadMessageHandler">BadMessageHandler</Setting>
  </Item>
}

XData FileServiceItems
{
<Item Name="HL7FileService" Category="" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="This is a default HL7 File Service." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">MsgRouter</Setting>
    <Setting Target="Host" Name="MessageSchemaCategory">2.8</Setting>
    <Setting Target="Adapter" Name="ArchivePath">C:\DOLPHIN PROJECT\in\archive\</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\DOLPHIN PROJECT\in\</Setting>
    <Setting Target="Adapter" Name="WorkPath"></Setting>
  </Item>
}

XData FileOperation
{
<Item Name="HL7FileOperation" Category="" ClassName="EnsLib.HL7.Operation.FileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="This is a default HL7 File Operation." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Filename">DOLPHIN</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\DOLPHIN PROJECT\out\</Setting>
  </Item>
}

/// XData for Gateway import
/// XData for HSBUS import
XData InstallIntro
{
<text>
A new HealthShare CCDA Pipeline for Facility {FacilityId} is installed and running.
To process CCAS, copy the files 
into {p1}EG{FacilityId}\CCDIn (on HSROUTER)

</text>
}

ClassMethod Install(pNamespace As %String, pFacility As %String) As %Library.Status
{
        // Set the target namespace
        //Set $namespace = pNamespace
        
        // Install and configure InterSystems Cache and HL7 components for the given namespace
        Set status = ""
        Set status = ..AddHL7Pipeline(pFacility)
        If 'status {
            Write "Failed to load HL7Production",!
            Quit
        }
        
        
        //Write "HL7 Production has been set up in namespace: ", $namespace, !
        
        // You can add more configuration steps here
        
        // Create a new HL7 Service
        #; Set hl7Service = ##class(HL7.Service).%New()
        #; Set hl7Service.Name = "HL7Service"
        #; Set hl7Service.Port = 12345
        #; Set hl7Service.Start = 1
        #; Set status = hl7Service.%Save()
        
        #; If 'status {
        #;     Write "Failed to create HL7 Service.",!
        #;     Quit
        #; }
        
        Write "HL7 Service has been created and configured in namespace: ", $namespace, !
        
        // Create and configure your HL7 router, business services, and business processes
        // Add code to configure your specific components here
        
        Write "HL7 end-to-end setup completed in namespace: ", $namespace, !
        
        // Create and configure Facility
        #; Set facility = ##class(Facility).%New()
        #; Set facility.Name = facilityName
        #; Set status = facility.%Save()
        
        #; If 'status {
        #;     Write "Failed to create Facility.",!
        #;     Quit
        #; }
        
        Write "Facility '", facilityName, "' has been created in namespace: ", $namespace, !
}

/// CNR: All this down below are helper methods that you most likely don't need to change
/// Add Production Items from XDATA block
ClassMethod AddProductionItems(pNamespace As %String = "", pBlockItems As %String = "")
{
	try {
		Set tSC=$$$OK
		Write "  Installing components in <"_pNamespace_"> namespace",!
		Set tSC= ..ProductionMods(pNamespace,pBlockItems,1) Quit:$$$ISERR(tSC)
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

XData ProductionDefinition
{
<Production Name="TEAM1SANDBOXPKG.D.DOLP" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
</Production>
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

}

