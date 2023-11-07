Include (HS.Common, %ZHSLIB, %syPrompt)

Class HS.Local.Util.HL7InstallerTemplate Extends (HS.HC.Util.Installer, HS.Util.Installer.Kit.PostInstall.Base)
{

/*	///The endpoint also needs to search and replace FacilityId
			
				if tEndPoint [ "{" 
				{	
					If tEndPoint[ "{FacilityId}" && ($D(pSubstitutionValues("FacilityId"))) {
						Set tEndPoint = $p(tEndPoint,"{FacilityId}",1) _ pSubstitutionValues("FacilityId") _ $p(tEndPoint,"{FacilityId}",2)
					}
					Else {
						$$$ThrowStatus($$$ERROR($$$GeneralError, $$$CurrentMethod_" Facility Id Required"))
					}
				}



*/
/// CNR: Hey Nathan, This code snippet is an example of search and replacing the 
/// bracketed parameter
/// tEndpoint is a String that might contain brackets
/// CNR: Nathan, this is example of how to set up pSubstitutionValues as the lookup where tFacilityIdValue is your replacement value 
/// Set  pSubstitutionValues("FacilityId")=tFacilityIdValue
/// 
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

	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

ClassMethod InstallRouter() As %Status
{
	Set tSC = $$$OK

	
	//Set up HSROUTER production
	Set tSC =  ..AddProductionItems("HSROUTER", "RouterItems")


	quit tSC
}

/// XData for HSROUTER import
/// CNR: This item is just a dummy example - replace with your production items
XData RouterItems
{
<Items>
  <Item Name="HS.IHE.XDSb.Repository.Services" Category="" ClassName="HS.IHE.XDSb.Repository.Services" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="XDSbProvideAndRegisterTarget">HS.IHE.XDSb.Repository.Process</Setting>
    <Setting Target="Host" Name="XDSbRetrieveTarget">HS.IHE.XDSb.Repository.Process</Setting>
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

