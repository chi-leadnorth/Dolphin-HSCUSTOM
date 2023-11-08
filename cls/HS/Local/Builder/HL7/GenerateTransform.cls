Class HS.Local.Builder.GenerateTransform Extends %RegisteredObject
{

// Do ##class(TEAM2SANDBOXPKG.DolphinBuilder.DolphinBuilder).GenerateDTLExportXML()

// C:\DOLPHINTHINGS\BuilderTool\Testing\ConstructedItems

Parameter DolphinMSH = "%XML.Adaptor(XMLNAMESPACE = ""http://www.intersystems.com/dtl"")";

Parameter DolphinPID = "%XML.Adaptor(XMLNAMESPACE = ""http://www.intersystems.com/dtl"")";

Parameter DolphinPV1 = "%XML.Adaptor(XMLNAMESPACE = ""http://www.intersystems.com/dtl"")";

Parameter DolphinSUBS = "%XML.Adaptor(XMLNAMESPACE = ""http://www.intersystems.com/dtl"")";

/// Method to generate Export XML for a DTL transformation and save it to a local file.
/// Method to generate Export XML for a DTL transformation and save it to a local file.
ClassMethod GenerateDTLExportXML(pFilePath As %String = "", pFacilityName As %String = "", pTransformName As %String = "", pNamespace As %String = "", pSelectedSubTransformNames As %List = "") As %Status
{
    Set tSC = $$$OK

    // If any of the parameters are empty, prompt for input
    If pFilePath = "" {
        Read !, "ENTER the File Path: ", pFilePath
    }
    if pFilePath = "" {
        Write "File Path cannot be empty"
        $$$ThrowStatus($$$ERROR($$$GeneralError, "File Path cannot be empty"))
    }

    If pFacilityName = "" {
        Read !, "ENTER the Facility Name: ", pFacilityName
    }
    if pFacilityName = "" {
        Write "Facility Name cannot be empty"
        $$$ThrowStatus($$$ERROR($$$GeneralError, "Facility Name cannot be empty"))
    }

    If pTransformName = "" {
        Read !, "ENTER the Transform Name: ", pTransformName
    }
    if pTransformName = "" {
        Write "Transform Name cannot be empty"
        $$$ThrowStatus($$$ERROR($$$GeneralError, "Transform Name cannot be empty"))
    }

    If pNamespace = "" {
        Read !, "ENTER the Namespace Name: ", pNamespace
    }
    if pNamespace = "" {
        Write "Namespace cannot be empty"
        $$$ThrowStatus($$$ERROR($$$GeneralError, "Namespace cannot be empty"))
    }

    // Initialize pSelectedSubTransformNames as an empty list
    Set pSelectedSubTransformNames = ""

    // Check if pSelectedSubTransformNames is empty or doesn't contain at least one item
    If pSelectedSubTransformNames = "" {
        Read !, "Enter the Desired Subtransform Names (comma separated): ", pSelectedSubTransformNames
    }

    // Convert the input to a list
    Set pSelectedSubTransformNames = $LISTFROMSTRING(pSelectedSubTransformNames, ",")

    // Check if the list is still empty
    If $LISTLENGTH(pSelectedSubTransformNames) = 0 {
        Write "Minimum of 1 Selection Required"
        $$$ThrowStatus($$$ERROR($$$GeneralError, "Must use at least 1 subtransformation"))
    }

    // Create the output file
    Set OutFile = ..ReturnOutputFile(pFilePath_"/"_pTransformName_".cls")
    Quit:(OutFile = $$$NULLOREF)

    // Initialize updatedContent as an empty string
    Set updatedContent = ""

    Set length = $LISTLENGTH(pSelectedSubTransformNames)

    // Iterate over the selected subtransform names
    For i = 1:1:length {
        Set pSelectedSubTransformName = $LIST(pSelectedSubTransformNames, i)
        Write "Processing subtransform: ", pSelectedSubTransformName, !

        // Access the XData block directly based on pSelectedSubTransformName
        Set xdataBlock = ##class(%Dictionary.XDataDefinition).%OpenId(pSelectedSubTransformName)

        // Debug: Output the value of xdataBlock
        Write "xdataBlock: ", xdataBlock, !

        // Check if the selected subtransform name is valid
        If '$data(xdataBlock) {
            Write "Selected Subtransform Name is not valid."
            Quit:$$$ERROR($$$GeneralError, "Invalid Subtransform Name")
        }

        // Parse the content from the XData block
        Set tSC = ..getStream(pSelectedSubTransformName, .pStream)
        Write "pStream: ", pStream, !

        // Parse out the content from in between the <transform> tags
        Set transformContent = ""
        Set insideTransform = 0

        While 'pStream.AtEnd {
        Set line = pStream.ReadLine()

        If $find(line, "<assign value='source' property='target' action='set' />") {
            // Check if we are not inside a transformation
            If 'insideTransform {
                Set insideTransform = 1
                // Skip the opening line
                Continue
            }
        }

        If insideTransform {
            // Append each line to transformContent
            If $find(line, "</transform>") {
                Set insideTransform = 0
            } Else {
                Set transformContent = transformContent_line_$c(13,10)
            }
        }
    }
    // Append transformContent to updatedContent
    Set updatedContent = updatedContent_transformContent_$c(13,10)
    }
    Set transformType = "sourceClass='EnsLib.HL7.Message' targetClass='EnsLib.HL7.Message' sourceDocType='2.8:ORU_R01' targetDocType='2.8:ORU_R01' create='new' language='objectscript' >"
    // Set source to target only once by appending directly
    Set stCopy = "<assign value='source' property='target' action='set' />"
    Set updatedContent = "<transform "_transformType_$c(13,10)_stCopy_$c(13,10)_updatedContent_"</transform>"
    // Generate the header and class definition
    Set header = "Class "_pNamespace_"."_pFacilityName_"."_pTransformName_" Extends Ens.DataTransformDTL [ DependsOn = EnsLib.HL7.Message ]"_$c(13,10)_"{"_$c(13,10)
    Set parameters = "Parameter IGNOREMISSINGSOURCE = 1;"_$c(13,10)_$c(13,10)
    Set parameters = parameters_"Parameter REPORTERRORS = 1;"_$c(13,10)_$c(13,10)
    Set parameters = parameters_"Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;"_$c(13,10)_$c(13,10)
    Set xdataHeader = "XData DTL [ XMLNamespace = ""http://www.intersystems.com/dtl"" ]"_$c(13,10)_"{"_$c(13,10)
    Set xdataFooter = $c(13,10)_$c(13,10)_"}"_$c(13,10)_$c(13,10)_"}"

    // Combine the header, parameters, xdataHeader, and transformContent
    Set updatedContent = header_parameters_xdataHeader_updatedContent_xdataFooter

    // Replace placeholders with actual values
    #; Set updatedContent = $replace(updatedContent, "{FacilityName}", pFacilityName)
    #; Set updatedContent = $replace(updatedContent, "{TransformName}", pTransformName)
    #; Set updatedContent = $replace(updatedContent, "{Namespace}", pNamespace)
    

    // Write the updated content to the output file
    Set tSC = OutFile.Write(updatedContent)

    // Close the output file
    Do OutFile.Close()
    Quit:$$$ISERR(tSC)

    Quit tSC
}

Method WriteFile(pFilePath As %String, pContent As %String) As %Status
{
    Try {
        // Open the file for writing
        Set file = ##class(%File).%New(pFilePath)
        Set status = file.Open("WSN")
        If ($SYSTEM.Status.IsError(status)) {
            Do $system.Status.DisplayError(status)
            Quit:$$$ERROR($$$GeneralError, "Failed to open the file for writing")
        }

        // Write the content to the file
        Set tSC = file.Write(pContent)
        If $$$ISERR(tSC) {
            Do $system.Status.DisplayError(tSC)
        }

        // Close the file
        Set closeStatus = file.%Close()
        If ($SYSTEM.Status.IsError(closeStatus)) {
            Do $system.Status.DisplayError(closeStatus)
            Quit:$$$ISOK(tSC)  // Return file write error if the close operation also fails
        }
    }
    Catch ex {
        Do file.%Close()
        Set tSC = ex.AsStatus()
    }

    Quit tSC
}

ClassMethod getStream(pLocation As %String, ByRef pStream) As %Status
{
    If pLocation '[ "://" Set pLocation = "xdata://"_..%ClassName(1)_":"_pLocation
    Quit ##class(HS.Util.XMLUtils).GetXDataAsStreamWithSubstitutions(pLocation, .pStream)
}

ClassMethod searchAndReplace(pInput As %String, pSearch As %String, pReplace As %String, ByRef pOutput As %String)
{
    If pInput[ pSearch {
        Set pOutput = $p(pInput, pSearch, 1) _ pReplace _ $p(pInput, pSearch, 2)
    }
    Else {
        Set pOutput = pInput
    }
}

ClassMethod ReturnOutputFile(filename As %String) As %File
{
    Set dir = ##class(%File).GetDirectory(filename)
    Do ##class(%File).CreateDirectoryChain(dir)
    Set fileObj = ##class(%File).%New(filename)
    Set status = fileObj.Open("WSN")
    If ($SYSTEM.Status.IsError(status)) {
        Do $system.Status.DisplayError(status)
        Quit $$$NULLOREF
    }
    Do fileObj.%Close()
    Quit fileObj
}

XData DolphinMSH
{
<text>
    <!-- Fix issue in the header -->
    <?xmlversion="1.0" encoding="UTF-8"?>
    <Export generator="IRIS" version="26" zv="IRIS for Windows (x86-64) 2022.1.2 (Build 574_0_22407U)" ts="2023-10-09 13:45:00">
    <Class name="TEAM2SANDBOXPKG.DolphinMSH">
    <Super>Ens.DataTransformDTL</Super>
    <TimeChanged>66756,32308.3307889</TimeChanged>
    <TimeCreated>66743,9823.0756333</TimeCreated>
    <DependsOn>EnsLib.HL7.Segment</DependsOn>

    <Parameter name="IGNOREMISSINGSOURCE">
    <Default>1</Default>
    </Parameter>

    <Parameter name="REPORTERRORS">
    <Default>1</Default>
    </Parameter>

    <Parameter name="TREATEMPTYREPEATINGFIELDASNULL">
    <Default>0</Default>
    </Parameter>

    <XData name="DTL">
    <XMLNamespace>http://www.intersystems.com/dtl</XMLNamespace>
    <Data><![CDATA[
    <transform sourceClass='EnsLib.HL7.Segment' targetClass='EnsLib.HL7.Segment' sourceDocType='2.8:MSH' targetDocType='2.8:MSH' create='new' language='objectscript' >
    <assign value='source' property='target' action='set' />
    <assign value='..ToUpper("LeadNorthLLC")' property='target.{MSH:SendingFacility}' action='set' />
    <assign value='"2.8"' property='target.{MSH:VersionID}' action='set' />
    </transform>
    ]]></Data>
    </XData>
    </Class>
    </Export>
</text>
}

XData DolphinPID
{
<text>
    <Export generator="IRIS" version="26" zv="IRIS for Windows (x86-64) 2022.1.2 (Build 574_0_22407U)" ts="2023-10-09 13:45:00">
    <Class name= "TEAM2SANDBOXPKG.DolphinPID">
    <Super>Ens.DataTransformDTL</Super>
    <TimeChanged>66756,32179.6117263</TimeChanged>
    <TimeCreated>66743,49972.8190605</TimeCreated>
    <DependsOn>EnsLib.HL7.Segment</DependsOn>

    <Parameter name="IGNOREMISSINGSOURCE">
    <Default>1</Default>
    </Parameter>

    <Parameter name="REPORTERRORS">
    <Default>1</Default>
    </Parameter>

    <Parameter name="TREATEMPTYREPEATINGFIELDASNULL">
    <Default>0</Default>
    </Parameter>

    <XData name="DTL">
    <XMLNamespace>http://www.intersystems.com/dtl</XMLNamespace>
    <Data><![CDATA[
    <transform sourceClass='EnsLib.HL7.Segment' targetClass='EnsLib.HL7.Segment' sourceDocType='2.8:ORU' targetDocType='2.8:ORU' create='new' language='objectscript' >
    <assign value='source' property='target' action='set' />
    <if condition='source.{PIDgrpgrp().PIDgrp.PID:PatientID.1}&apos;="" ' >
    <true>
    <if condition='..Contains(source.{PIDgrpgrp().PIDgrp.PID:PatientID},"MR" , "MRN" , "PI" , "")' >
    <true>
    <assign value='source.{PIDgrpgrp().PIDgrp.PID:PatientID}' property='target.{PIDgrpgrp().PIDgrp.PID:PatientID}' action='set' />
    </true>
    </if>
    </true>
    </if>
    <comment>
    <annotation>PID3 and PID4 NEED REVIEW</annotation>
    </comment>
    <foreach property='source.{PIDgrpgrp().PIDgrp.PID:PatientName()}' key='k1' >
    <assign value='source.{PIDgrpgrp().PIDgrp.PID:PatientName(k1)}' property='target.{PIDgrpgrp().PIDgrp.PID:PatientName(k1)}' action='set' key='k1' />
    <break/>
    </foreach>
    <foreach property='source.{PIDgrpgrp().PIDgrp.PID:MothersMaidenName()}' key='k2' >
    <if condition='source.{PIDgrpgrp().PIDgrp.PID:MothersMaidenName(k2)}&apos;=""' >
    <true>
    <assign value='source.{PIDgrpgrp().PIDgrp.PID:MothersMaidenName(k2)}' property='target.{PIDgrpgrp().PIDgrp.PID:MothersMaidenName(k2)}' action='set' />
    </true>
    </if>
    <break/>
    </foreach>
    <foreach property='source.{PIDgrpgrp().PIDgrp.PID:Race()}' key='k3' >
    <if condition='source.{PIDgrpgrp().PIDgrp.PID:Race(k3).Identifier}&apos;="" || source.{PIDgrpgrp().PIDgrp.PID:Race(k3).Text}&apos;=""' >
    <true>
    <assign value='source.{PIDgrpgrp().PIDgrp.PID:Race(k3)}' property='target.{PIDgrpgrp().PIDgrp.PID:Race(k3)}' action='set' key='k3' />
    </true>
    </if>
    <break/>
    </foreach>
    <if condition='source.{PIDgrpgrp().PIDgrp.PID:MaritalStatus.Identifier}&apos;="" || source.{PIDgrpgrp().PIDgrp.PID:MaritalStatus.Text}&apos;=""' >
    <true>
    <assign value='source.{PIDgrpgrp().PIDgrp.PID:MaritalStatus}' property='target.{PIDgrpgrp().PIDgrp.PID:MaritalStatus}' action='set' />
    </true>
    </if>
    <if condition='source.{PIDgrpgrp().PIDgrp.PID:Religion.Identifier}&apos;="" || source.{PIDgrpgrp().PIDgrp.PID:Religion.Text}&apos;=""' >
    <true>
    <assign value='source.{PIDgrpgrp().PIDgrp.PID:Religion}' property='target.{PIDgrpgrp().PIDgrp.PID:Religion}' action='set' />
    </true>
    </if>
    <comment>
    <annotation>PID18, PID19, PID20 NEED REVIEW</annotation>
    </comment>
    <foreach property='source.{PIDgrpgrp().PIDgrp.PID:EthnicGroup()}' key='k4' >
    <if condition='source.{PIDgrpgrp().PIDgrp.PID:EthnicGroup(k4).Identifier}&apos;="" || source.{PIDgrpgrp().PIDgrp.PID:EthnicGroup(k4).Text}&apos;=""' >
    <true>
    <assign value='source.{PIDgrpgrp().PIDgrp.PID:EthnicGroup(k4)}' property='target.{PIDgrpgrp().PIDgrp.PID:EthnicGroup(k4)}' action='set' key='k4' />
    </true>
    </if>
    <break/>
    </foreach>
    <foreach property='source.{PIDgrpgrp().PIDgrp.PID:Citizenship(k5)}' key='k5' >
    <assign value='source.{PIDgrpgrp().PIDgrp.PID:Citizenship(k5)}' property='target.{PIDgrpgrp().PIDgrp.PID:Citizenship(k5)}' action='set' key='k5' />
    <break/>
    </foreach>
    <if condition='source.{PIDgrpgrp().PIDgrp.PID:Citizenship()}=""' >
    <true>
    <assign value='source.{PIDgrpgrp().PIDgrp.PID:Nationality}' property='target.{PIDgrpgrp().PIDgrp.PID:Nationality}' action='set' />
    </true>
    </if>
    </transform>
    ]]></Data>
    </XData>
    </Class>
    </Export>
</text>
}

XData DolphinPV1
{
<text>
    <Export generator="IRIS" version="26" zv="IRIS for Windows (x86-64) 2022.1.2 (Build 574_0_22407U)" ts="2023-10-09 13:45:00">
    <Class name="TEAM2SANDBOXPKG.DolphinPV1">
    <Super>Ens.DataTransformDTL</Super>
    <TimeChanged>66744,35418.8222977</TimeChanged>
    <TimeCreated>66744,35201.8870921</TimeCreated>
    <DependsOn>EnsLib.HL7.Segment</DependsOn>

    <Parameter name="IGNOREMISSINGSOURCE">
    <Default>1</Default>
    </Parameter>

    <Parameter name="REPORTERRORS">
    <Default>1</Default>
    </Parameter>

    <Parameter name="TREATEMPTYREPEATINGFIELDASNULL">
    <Default>0</Default>
    </Parameter>

    <XData name="DTL">
    <XMLNamespace>http://www.intersystems.com/dtl</XMLNamespace>
    <Data><![CDATA[
    <transform sourceClass='EnsLib.HL7.Segment' targetClass='EnsLib.HL7.Segment' sourceDocType='2.8:PV1' targetDocType='2.8:PV1' create='new' language='objectscript' >
    <assign value='source' property='target' action='set' />
    <foreach property='source.{PIDgrpgrp().PIDgrp.PV1grp.PV1:ReferringDoctor()}' key='k1' >
    <assign value='source.{PIDgrpgrp().PIDgrp.PV1grp.PV1:ReferringDoctor(k1)}' property='target.{PIDgrpgrp().PIDgrp.PV1grp.PV1:ReferringDoctor(k1)}' action='set' key='k1' />
    <break/>
    </foreach>
    <foreach property='source.{PIDgrpgrp().PIDgrp.PV1grp.PV1:AdmittingDoctor()}' key='k2' >
    <assign value='source.{PIDgrpgrp().PIDgrp.PV1grp.PV1:AdmittingDoctor(k2)}' property='target.{PIDgrpgrp().PIDgrp.PV1grp.PV1:AdmittingDoctor(k2)}' action='set' key='k2' />
    <break/>
    </foreach>
    </transform>
    ]]></Data>
    </XData>
    </Class>
    </Export>
</text>
}

XData DolphinSUBS
{
<text>
    <Export generator="IRIS" version="26" zv="IRIS for Windows (x86-64) 2022.1.2 (Build 574_0_22407U)" ts="2023-10-09 13:45:00">
    <Class name= "TEAM2SANDBOXPKG.DolphinSUBS">
    <Super>Ens.DataTransformDTL</Super>
    <TimeChanged>66756,49299.6640331</TimeChanged>
    <TimeCreated>66744,35450.7495479</TimeCreated>
    <DependsOn>EnsLib.HL7.Message</DependsOn>

    <Parameter name="IGNOREMISSINGSOURCE">
    <Default>1</Default>
    </Parameter>

    <Parameter name="REPORTERRORS">
    <Default>1</Default>
    </Parameter>

    <Parameter name="TREATEMPTYREPEATINGFIELDASNULL">
    <Default>0</Default>
    </Parameter>

    <XData name="DTL">
    <XMLNamespace>http://www.intersystems.com/dtl</XMLNamespace>
    <Data><![CDATA[
    <transform sourceClass='EnsLib.HL7.Message' targetClass='EnsLib.HL7.Message' sourceDocType='2.8:ORU_R01' targetDocType='2.8:ORU_R01' create='new' language='objectscript' >
    <assign value='source' property='target' action='set' />
    <subtransform class='TEAM2SANDBOXPKG.DolphinMSH' targetObj='target.{MSH}' sourceObj='source.{MSH}' />
    <assign value='source.{SFT()}' property='target.{SFT()}' action='set' />
    <assign value='source.{UAC}' property='target.{UAC}' action='set' />
    <assign value='source.{PIDgrpgrp()}' property='target.{PIDgrpgrp()}' action='set' />
    <subtransform class='TEAM2SANDBOXPKG.DolphinPID' targetObj='target.{PIDgrpgrp().PIDgrp.PID}' sourceObj='source.{PIDgrpgrp().PIDgrp.PID}' />
    <if condition='source.{PIDgrpgrp().PIDgrp.PID:LastUpdateFacility}=""' >
    <true>
    <assign value='target.{MSH:SendingFacility}' property='target.{PIDgrpgrp().PIDgrp.PID:LastUpdateFacility}' action='set' />
    </true>
    </if>
    <assign value='source.{PIDgrpgrp().PIDgrp.PV1grp.PV1:VisitNumber}' property='target.{PIDgrpgrp().PIDgrp.PID:PatientAccountNumber}' action='set' />
    <subtransform class='TEAM2SANDBOXPKG.DolphinPV1' targetObj='target.{PIDgrpgrp().PIDgrp.PV1grp.PV1}' sourceObj='source.{PIDgrpgrp().PIDgrp.PV1grp.PV1}' />
    <if condition='source.{PIDgrpgrp().PIDgrp.PV1grp.PV1:HospitalService}=""' >
    <true>
    <assign value='target.{MSH:SendingFacility}' property='target.{PIDgrpgrp().PIDgrp.PV1grp.PV1:HospitalService}' action='set' />
    </true>
    </if>
    <assign value='source.{PIDgrpgrp().ORCgrpgrp()}' property='target.{PIDgrpgrp().ORCgrpgrp()}' action='set' />
    <assign value='source.{DSC}' property='target.{DSC}' action='set' />
    </transform>
    ]]></Data>
    </XData>
    </Class>
    </Export>
</text>
}

}

