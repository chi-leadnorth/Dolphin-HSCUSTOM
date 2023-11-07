Include (HS.Common, %ZHSLIB, %syPrompt)

Class HS.Local.Util.HL7RoutingRuleBuilder Extends (HS.HC.Util.Installer, HS.Util.Installer.Kit.PostInstall.Base)
{

/// Utility class that writes a routing rule class and saves into specified package location
/// Method to Write an XML String from an XDATA block out to a file. The contents inside the XML String
/// are replaced with the input parameters for the RuleName, Transform, and Namespace
/// If the parameters are empty, the method will prompt for them. The method is desiged to run 
/// automated and interactive - for extreme user-friendliness and educational purposes
/// Example of how to run from terminal:
/// do ##class(HS.Local.Util.HL7RoutingRuleBuilder).WriteRoutingRuleFile("C:/temp/DOLPHIN","RoutingRules", "TransformLibertyADT", "EGLIBERTY") 
ClassMethod WriteRoutingRuleFile(pFilePath As %String = "", pRuleName As %String = "", pTransform As %String = "", pNamespace As %String = "") As %Status
{
    Set tSC = $$$OK

    /* Interactive Section: Check the input parameters. If any are empty, prompt for them.*/
	If pFilePath = "" { 
		Read !, "ENTER the File Path: ", pFilePath	
	}

	if pFilePath = "" {
		Write "File Path cannot be empty"
		$$$ThrowStatus($$$ERROR($$$GeneralError, "File Path cannot be empty"))
	}

    If pRuleName = "" { 
		Read !, "ENTER the Rule Name: ", pRuleName
	}

	if pRuleName = "" {
		Write "Rule Name cannot be empty"
		$$$ThrowStatus($$$ERROR($$$GeneralError, "Rule Name cannot be empty"))
	}

    If pNamespace = "" { 
		Read !, "ENTER the Namespace: ", pNamespace
	}

	if pNamespace = "" {
		Write "Namespace cannot be empty"
		$$$ThrowStatus($$$ERROR($$$GeneralError, "Namespace cannot be empty"))
	}

    If pTransform = "" { 
		Read !, "ENTER the Transform class name: ", pTransform
	}
    /// Transform is allowed to be empty because this will mean a passthrough route will be set up

    //prepare an output file
    Set OutFile = ..ReturnOutputFile(pFilePath_"/"_pRuleName_".cls")
    if (OutFile = $$$NULLOREF) quit

    //initialize the file content stream with contents of the RuleContents XDATA block
    Set tSC = ..getStream("RuleContents",.pStream)
   
    //Parse out the content from in between the <text> tags
    set content=pStream.Read(32000),content=$p(content,"<text>",2,99999),content=$p(content,"</text>")

    do ..searchAndReplace(content, "{RuleName}", pRuleName, .updatedContent)
    do ..searchAndReplace(updatedContent, "{Namespace}", pNamespace, .updatedContent)
    do ..searchAndReplace(updatedContent, "{Transform}", pTransform, .updatedContent)

    //Write the content to the output file
    Set tSC = OutFile.Write(updatedContent) 
    Do OutFile.Close()
	Quit:$$$ISERR(tSC)
	

    return tSC
}

/// helper method used file builder
ClassMethod getStream(pLocation As %String, Output pStream) As %Status
{
	If pLocation '[ "://" Set pLocation = "xdata://"_..%ClassName(1)_":"_pLocation
	Quit ##class(HS.Util.XMLUtils).GetXDataAsStreamWithSubstitutions(pLocation,.pStream)
}

// helper method which takes a string and performs a search and replace operation

ClassMethod searchAndReplace(pInput As %String, pSearch As %String, pReplace As %String, ByRef pOutput As %String)
{
	If pInput[ pSearch  
    {
		Set pOutput = $p(pInput, pSearch,1) _ pReplace _ $p(pInput,pSearch,2)
	}
	Else {
		Set pOutput = pInput
	}
}

/// Set up the output file
/// 1. Create the directory structure for the file
/// 2. Create a file object
/// 3. Open the file for writing
/// 4. Return a handle to the file object
ClassMethod ReturnOutputFile(filename As %String) As %File
{
    set dir=##class(%File).GetDirectory(filename)
    do ##class(%File).CreateDirectoryChain(dir)
    Set fileObj = ##class(%File).%New(filename)
    Set status = fileObj.Open("WSN")
    If ($SYSTEM.Status.IsError(status)) {
        do $system.Status.DisplayError(status)
        quit $$$NULLOREF
    }
    quit fileObj
}

XData RuleContents
{
<text>
Class HL7.Router.{RuleName} Extends Ens.Rule.Definition
{

    Parameter RuleAssistClass = "EnsLib.HL7.MsgRouter.RuleAssist";

    XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
    {
        <ruleDefinition alias="" context="EnsLib.HL7.MsgRouter.RoutingEngine" production="{Namespace}PKG.EdgeGatewayProduction">
        <ruleSet name="" effectiveBegin="" effectiveEnd="">
            <rule name="Transform">
                <when condition="1">
                    <send transform="{Transform}" target="HS.Gateway.HL7.InboundProcess"></send>
                </when>
            </rule>
        </ruleSet>
        </ruleDefinition>
    }

}
</text>
}

}

