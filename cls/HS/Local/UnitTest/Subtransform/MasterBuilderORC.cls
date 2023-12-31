Class HS.Local.UnitTest.Subtransform.MasterBuilderORC Extends %RegisteredObject
{

// Set pFilePath = "C:\Users\topfr\Desktop\DOLPHIN\MasterTestOutput"

// Set pFacilityName = "LEADNORTHLLC"

// Set pTransformName = "XMLtoDTLTest"

// Set pSelectedSubTransformName = "UnitTestMSHSubtransform"

// Set pSelectedSubTransformName = "UnitTestPIDSubtransform"

// Set pSelectedSubTransformName = "UnitTestPV1Subtransform"

// Set pNamespace = "TEAM2SANDBOX"

// Do ##class(DOLPHIN.XMLMaster).GenerateDTLExportXML()

// Do ##class(DOLPHIN.MasterXML).GenerateDTLExportXML(pFilePath, pFacilityName, pTransformName, pSelectedSubTransformName, pNamespace)

// Could not find a way to get all subtransforms without this

Parameter DolphinMSH = "%XML.Adaptor(XMLNAMESPACE = ""http://www.intersystems.com/dtl"")";

Parameter DolphinPID = "%XML.Adaptor(XMLNAMESPACE = ""http://www.intersystems.com/dtl"")";

Parameter DolphinPV1 = "%XML.Adaptor(XMLNAMESPACE = ""http://www.intersystems.com/dtl"")";

Parameter DolphinSUBS = "%XML.Adaptor(XMLNAMESPACE = ""http://www.intersystems.com/dtl"")";

/// Method to generate Export XML for a DTL transformation and save it to a local file.
ClassMethod GenerateDTLExportXML(pFilePath As %String = "", pFacilityName As %String = "", pTransformName As %String = "", pSelectedSubTransformName As %String = "", pNamespace As %String = "") As %Status
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

    If pSelectedSubTransformName = "" {
        Read !, "ENTER desired Subtransform: ", pSelectedSubTransformName
    }

    // Access the XData block directly based on pSelectedSubTransformName
    Set xdataBlock = pSelectedSubTransformName

    // Debug: Output the value of xdataBlock
    Write "xdataBlock: ", xdataBlock, !

    // Check if the selected subtransform name is valid
    If '$data(xdataBlock) {
        Write "Selected Subtransform Name is not valid."
        Quit $$$ERROR($$$GeneralError, "Invalid Subtransform Name")
    }

    If pNamespace = "" {
        Read !, "ENTER Namespace: ", pNamespace
    }

    // Create the output file
    Set OutFile = ..ReturnOutputFile(pFilePath_"/"_pTransformName_".cls")
    Quit:(OutFile = $$$NULLOREF)

    // Initialize the file content stream with the selected XData content
    Set tSC = ..getStream(xdataBlock, .pStream)
    //Write "pStream: ", pStream, ! 


    // Get Data from Multiple files
    #; $$$ThrowOnError(##class(Ens.Util.URLStream).GetUTLStream("xdata://"_..%ClassName(1) _".CDATransform:XSLT", .tCDATransform ))

    #; $$$ThrowOnError(##class(%XML.XSLT.CompiliedStyleSheet).CreateFromStream("tCDATransform, .CompiliedStyleSheet ))

    #; $$$HSTRACE("OriginalCCD before transform", "tOriginalCDASource", tOriginalCDASource)
    
    #; $$$ThrowOnError(##class(%XML.XSLT.Transformer).TransformStreamWithCompiledXSL("tOriginalCDASource, tCompiliedStyleSheet, tTransformedCDASource ))
    
    #; $$$HSTRACE("CCD after transform", "tTransformedCDASource", tTransformedCDASource)



    // Parse out the content from in between the <transform> tags
    Set transformContent = ""
    Set insideTransform = 0

    While 'pStream.AtEnd {
    Set line = pStream.ReadLine()
    
    If $find(line, "<Implementation><![CDATA[") {
        #; If $find(line, "sourceClass='EnsLib.HL7.Segment'") {
        #;     Set insideTransform = 1
        #; } ElseIf $find(line, "sourceClass='EnsLib.HL7.Message'") {
        #;     Set insideTransform = 1
        #; }
    }

        If insideTransform {
            Set transformContent = transformContent_line_$c(13,10)
            If $find(line, "</transform>") {
                Set insideTransform = 0
                Quit
            }
        }
    }

    // Generate the header and class definition
    Set header = "Class "_pFacilityName_"."_pNamespace_"."_pTransformName_" Extends Ens.DataTransformDTL [ DependsOn = EnsLib.HL7.Message ]"_$c(13,10)_"{"_$c(13,10)
    Set parameters = "Parameter IGNOREMISSINGSOURCE = 1;"_$c(13,10)_$c(13,10)
    Set parameters = parameters_"Parameter REPORTERRORS = 1;"_$c(13,10)_$c(13,10)
    Set parameters = parameters_"Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;"_$c(13,10)_$c(13,10)
    Set xdataHeader = "XData DTL [ XMLNamespace = ""http://www.intersystems.com/dtl"" ]"_$c(13,10)_"{"_$c(13,10)
    Set xdataFooter = $c(13,10)_$c(13,10)_"}"_$c(13,10)_$c(13,10)_"}"

    // Combine the header, parameters, xdataHeader, and transformContent
    Set updatedContent = header_parameters_xdataHeader_transformContent_xdataFooter

    // Replace placeholders with actual values
    Set updatedContent = $replace(updatedContent, "{FacilityName}", pFacilityName)
    Set updatedContent = $replace(updatedContent, "{TransformName}", pTransformName)
    Set updatedContent = $replace(updatedContent, "{Namespace}", pNamespace)


    // Write the updated content to the output file
    Set tSC = OutFile.Write(updatedContent)

    // Close the output file
    Do OutFile.Close()
    Quit:$$$ISERR(tSC)

    Quit tSC
}

// set content=pStream.Read(32000),content=$p(content,"<text>",2,99999),content=$p(content,"</text>")

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

XData UnitTestMSHSubtransform
{
<text>
<?xmlversion="1.0" encoding="UTF-8"?>
<Export generator="IRIS" version="26" zv="IRIS for Windows (x86-64) 2022.1.2 (Build 574_0_22407U)" ts="2023-10-19 09:39:49">
<Class name="DOLPHIN.UnitTestMSHSubtransform">
<Super>%UnitTest.TestCase</Super>
<TimeChanged>66766,34663.3172064</TimeChanged>
<TimeCreated>66764,41853.4245155</TimeCreated>

<Method name="TestMSH">
<Description>
Creating the first method to test</Description>
<Implementation><![CDATA[
    //create a transformation class instance, input message sample

   set Transformation = ##class(TEAM2SANDBOXPKG.DolphinMSH).%New()
     //set Transformation = ##class(HS.LeadNorthTransforms.R01).%New()
     set InputMessage = ##class(EnsLib.HL7.Message).%New() 
     //set InputMessage = ##class(EnsLib.HL7.Segment).%New() 
    #;  set InputMessage.MessageType="ORU_R01" 
    #;  set InputMessage.DocType="2.8:ADT_A01"         
     set HL7Message=     
      "MSH|^~\&|EPIC|MHS|||20110808073803|121732|ORU^R01|99273|P|2.3|||"_$C(13,10)_
      "PID|1|E2890060|E2890060^^^^EPI~0009526875^^^O^MRN||MENDEZ^ALVIN||19420406|M||K|6494 CLINTON COURT^^PUEBLO^SC^22954^USA^^^ORANGE|ORANGE|(868)706-8760|||S||RT-348794|497-54-8410||Rodgers^Alycia^^||"_$C(13,10)_
      "PV1||E|EDOC^ER09^09^OCM^R^^^^^^||||P676146^ZWEIFELHOFER^CHRISTEN|||E/R|||||||||309562814464|||||||||||||||||||||||||20110806|||||||V"_$C(13,10)_
      "ORC|RE|81738228^EPC|OC11US18192^EPC||P||^^^201108062114^201108062147^STAT||201108080738|P249130^ROGERS^DIANE||P676146^ZWEIFELHOFER^CHRISTEN|3010014^^^3010^^^^^OCM EDOC-EMERGENCY|(280)454-7052||"_$C(13,10)_
      "OBR|1|81738228^EPC|OC11US18192^EPC|IUS000063^US TESTICULAR^^^US TESTICULA||201108062115|||||O|||||P676146^ZWEIFELHOFER^CHRISTEN|(977)692-9023|309562814464||||201108080737||US|P||^^^201108062114^201108062147^STAT||||^Torsion||P094529^LEE^BENJAMIN^C^|P630889^DRABEK^EMMA|121732^MENDEZ TRANSCRIPTIONIST^MICHELE^^|201108062115|||||||||"_$C(13,10)_
      "NTE|1||Indication:->Torsion||"_$C(13,10)_
      "OBX|1|ST|&GDT|1|TESTICULAR ULTRASOUND: 08/06/2011||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|2|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|3|ST|&GDT|1|HISTORY:  Left testicular pain radiating to the left lower quadrant of the abdomen.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|4|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|5|ST|&GDT|1|COMPARISON: None.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|6|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|7|ST|&GDT|1|FINDINGS: The right testicle measures 4.5 cm in length. Left testicle measures 4.7 cm in length. Both testicles demonstrate normal color Doppler flow. No testicular mass lesions are seen.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|8|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|9|ST|&GDT|1|Multiple punctate echogenic foci are seen, unclear if this is artifactual or may represent testicular microlithiasis. ||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|10|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|11|ST|&GDT|1|The epididymides are unremarkable in appearance bilaterally.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)    
      
    set InputMessage=##class(EnsLib.HL7.Message).ImportFromString(HL7Message,.sc) $$$ThrowOnError(sc)
    
    //set tDocType=##class(EnsLib.HL7.Schema).ResolveSchemaTypeToDocType("2.3",.sc) $$$ThrowOnError(sc)      
    
    set status = Transformation.Transform(InputMessage,.OutputMessage)
    
    set OutputMessage.DocType="2.8:ORU_R01"
    //set OutputMessage.MessageType = "ORU"
    write OutputMessage.OutputToString()
    ; Access fields and segments in the HL7 message     
    set SendingApplication = OutputMessage.GetValueAt("MSH:3")
    set SendingFacility = OutputMessage.GetValueAt("MSH:4")    
    set ReceivingApplication = OutputMessage.GetValueAt("MSH:5", "|") 
    set ReceivingFacility = OutputMessage.GetValueAt("MSH:6", "|") 
    set DateTimeofMessage = OutputMessage.GetValueAt("MSH:7", "|")
    set MessageType = OutputMessage.GetValueAt("MSH:9", "|")
    set MessageControllerID = OutputMessage.GetValueAt("MSH:10", "|")    
        
   ///Here we are logging in the values from the message 
    Write "SendingApplication: ", OutputMessage.GetValueAt("MSH:3:"), !     
    Write "DateTimeofMessage: ", OutputMessage.GetValueAt("MSH:7:"), !
    Write "MessageType: ", OutputMessage.GetValueAt("MSH:9:"), !  
    Write "MessageContollerID: ", OutputMessage.GetValueAt("MSH:10:"), !      

     /// Write the Sending Facility
    write $$$AssertEquals("LEADNORTHLLC", SendingFacility)
    write $$$AssertEquals("CLOVERLEAF", ReceivingApplication)
    write $$$AssertEquals("DTA-PHARMACY", ReceivingFacility)     
     
     ///do ##class(%UnitTest.Manager).RunTest("mytests\UnitTestMSHSubtransform", "/nodelete")
]]></Implementation>
</Method>
<XData name="MSHSegment">
</XData>
</Class>
</Export>
</text>
}

XData UnitTestPIDSubtransform
{
<text>
    <?xmlversion="1.0" encoding="UTF-8"?>
<Export generator="IRIS" version="26" zv="IRIS for Windows (x86-64) 2022.1.2 (Build 574_0_22407U)" ts="2023-10-19 10:43:07">
<Class name="DOLPHIN.UnitTestPIDSubtransform">
<Super>%UnitTest.TestCase</Super>
<TimeChanged>66766,38533.1188206</TimeChanged>
<TimeCreated>66764,44249.5526742</TimeCreated>

<Method name="TestPID">
<Implementation><![CDATA[
    //create a transformation class instance, input message sample to parse

     set Transformation = ##class(TEAM2SANDBOXPKG.DolphinPID).%New()
     //set Transformation = ##class(HS.LeadNorthTransforms.R01).%New()
     set InputMessage = ##class(EnsLib.HL7.Message).%New()          
     set HL7Message=     
      "MSH|^~\&|EPIC|MHS|||20110808073803|121732|ORU^R01|99273|P|2.3|||"_$C(13,10)_
      "PID|1|E2890060|E2890060^^^^EPI~0009526875^^^O^MRN||Mendez^Gonzalez-Choloma^D||19420406|M||K|6494 CLINTON COURT^^PUEBLO^SC^22954^USA^^^ORANGE|ORANGE|(868)706-8760|||S||DTA348794|497-54-8410||Rodgers^Alycia^^||"_$C(13,10)_
      "PV1||E|EDOC^ER09^09^OCM^R^^^^^^||||P676146^ZWEIFELHOFER^CHRISTEN|||E/R|||||||||309562814464|||||||||||||||||||||||||20110806|||||||V"_$C(13,10)_
      "ORC|RE|81738228^EPC|OC11US18192^EPC||P||^^^201108062114^201108062147^STAT||201108080738|P249130^ROGERS^DIANE||P676146^ZWEIFELHOFER^CHRISTEN|3010014^^^3010^^^^^OCM EDOC-EMERGENCY|(280)454-7052||"_$C(13,10)_
      "OBR|1|81738228^EPC|OC11US18192^EPC|IUS000063^US TESTICULAR^^^US TESTICULA||201108062115|||||O|||||P676146^ZWEIFELHOFER^CHRISTEN|(977)692-9023|309562814464||||201108080737||US|P||^^^201108062114^201108062147^STAT||||^Torsion||P094529^LEE^BENJAMIN^C^|P630889^DRABEK^EMMA|121732^MENDEZ TRANSCRIPTIONIST^MICHELE^^|201108062115|||||||||"_$C(13,10)_
      "NTE|1||Indication:->Torsion||"_$C(13,10)_
      "OBX|1|ST|&GDT|1|TESTICULAR ULTRASOUND: 08/06/2011||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|2|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|3|ST|&GDT|1|HISTORY:  Left testicular pain radiating to the left lower quadrant of the abdomen.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|4|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|5|ST|&GDT|1|COMPARISON: None.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|6|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|7|ST|&GDT|1|FINDINGS: The right testicle measures 4.5 cm in length. Left testicle measures 4.7 cm in length. Both testicles demonstrate normal color Doppler flow. No testicular mass lesions are seen.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|8|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|9|ST|&GDT|1|Multiple punctate echogenic foci are seen, unclear if this is artifactual or may represent testicular microlithiasis. ||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|10|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|11|ST|&GDT|1|The epididymides are unremarkable in appearance bilaterally.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)    
      
    set InputMessage=##class(EnsLib.HL7.Message).ImportFromString(HL7Message,.sc) $$$ThrowOnError(sc)
    //set tDocType=##class(EnsLib.HL7.Schema).ResolveSchemaTypeToDocType("2.3",.sc) $$$ThrowOnError(sc)     
    set status = Transformation.Transform(InputMessage,.OutputMessage)
    
    set OutputMessage.DocType="2.8:ORU_R30"
    write OutputMessage.OutputToString()
    ; Access fields and segments in the HL7 message     
    set PatientLastName = OutputMessage.GetValueAt("PID:5.1")  
    set PatientFirstName = OutputMessage.GetValueAt("PID:5.2") 
    set PatientMiddleName = OutputMessage.GetValueAt("PID:5.3")
    Set PatientDateofBirth = OutputMessage.GetValueAt("PID:7") 
    Set PatientGender = OutputMessage.GetValueAt("PID:8")
    Set PatientAddress = OutputMessage.GetValueAt("PID:11")
    Set PatientAccountNumber = OutputMessage.GetValueAt("PID:18")        
        
   ///Here we are logging in the values from the message 
    Write "PatientLastName: ", OutputMessage.GetValueAt("PID:5.1:"), !     
    Write "PatientFirstName: ", OutputMessage.GetValueAt("PID:5.2:"), !
    Write "PatientMiddleName: ", OutputMessage.GetValueAt("PID:5.3:"), !  
    Write "PatientDateofBirth: ", OutputMessage.GetValueAt("PID:7:"), !  
    Write "PatientGender: ", OutputMessage.GetValueAt("PID:8:"), ! 
    Write "PatientAddress: ", OutputMessage.GetValueAt("PID:11:"), !  
    Write "PatientAccountNumber: ", OutputMessage.GetValueAt("PID:18:"), !    
 
     ///do ##class(%UnitTest.Manager).RunTest("mytests\UnitTestPIDSubtransform", "/nodelete")
]]></Implementation>
   </Method>
   <XData name="PIDSegment">
   </XData>
   </Class>  
   </Export>
 </text>
}

XData UnitTestPV1Subtransform
{
<text>
    <?xmlversion="1.0" encoding="UTF-8"?>
<Export generator="IRIS" version="26" zv="IRIS for Windows (x86-64) 2022.1.2 (Build 574_0_22407U)" ts="2023-10-26 10:42:26">
<Class name="DOLPHIN.UnitTestPV1Subtransform">
<Super>%UnitTest.TestCase</Super>
<TimeChanged>66773,38465.4821254</TimeChanged>
<TimeCreated>66764,44336.3416844</TimeCreated>

<Method name="TestPV1">
<Description>
Creating the first method to test</Description>
<Implementation><![CDATA[
    Set tSC = $$$OK
    //create a transformation class instance
     //set Transformation = ##class(HS.LeadNorthTransforms.R01).%New()
     set Transformation = ##class(TEAM2SANDBOXPKG.DolphinPV1).%New()

   // sample HL7 Input message
     set InputMessage = ##class(EnsLib.HL7.Message).%New()
         
     set HL7Message=     
      "MSH|^~\&|EPIC|MHS|||20110808073803|121732|ORU^R01|99273|P|2.3|||"_$C(13,10)_
      "PID|1|E2890060|E2890060^^^^EPI~0009526875^^^O^MRN||MENDEZ^ALVIN||19420406|M||K|6494 CLINTON COURT^^PUEBLO^SC^22954^USA^^^ORANGE|ORANGE|(868)706-8760|||S||RT-348794|497-54-8410||Rodgers^Alycia^^||"_$C(13,10)_
      "PV1||E|EDOC^ER09^09^OCM^R^^^^^^||||P676146^ZWEIFELHOFER^CHRISTEN|||E/R|||||||||309562814464|||||||||||||||||||||||||20110806|||||||V"_$C(13,10)_
      "ORC|RE|81738228^EPC|OC11US18192^EPC||P||^^^201108062114^201108062147^STAT||201108080738|P249130^ROGERS^DIANE||P676146^ZWEIFELHOFER^CHRISTEN|3010014^^^3010^^^^^OCM EDOC-EMERGENCY|(280)454-7052||"_$C(13,10)_
      "OBR|1|81738228^EPC|OC11US18192^EPC|IUS000063^US TESTICULAR^^^US TESTICULA||201108062115|||||O|||||P676146^ZWEIFELHOFER^CHRISTEN|(977)692-9023|309562814464||||201108080737||US|P||^^^201108062114^201108062147^STAT||||^Torsion||P094529^LEE^BENJAMIN^C^|P630889^DRABEK^EMMA|121732^MENDEZ TRANSCRIPTIONIST^MICHELE^^|201108062115|||||||||"_$C(13,10)_
      "NTE|1||Indication:->Torsion||"_$C(13,10)_
      "OBX|1|ST|&GDT|1|TESTICULAR ULTRASOUND: 08/06/2011||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|2|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|3|ST|&GDT|1|HISTORY:  Left testicular pain radiating to the left lower quadrant of the abdomen.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|4|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|5|ST|&GDT|1|COMPARISON: None.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|6|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|7|ST|&GDT|1|FINDINGS: The right testicle measures 4.5 cm in length. Left testicle measures 4.7 cm in length. Both testicles demonstrate normal color Doppler flow. No testicular mass lesions are seen.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|8|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|9|ST|&GDT|1|Multiple punctate echogenic foci are seen, unclear if this is artifactual or may represent testicular microlithiasis. ||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|10|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|11|ST|&GDT|1|The epididymides are unremarkable in appearance bilaterally.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)    
      
    set InputMessage=##class(EnsLib.HL7.Message).ImportFromString(HL7Message,.sc) $$$ThrowOnError(sc) 
    
    set status = Transformation.Transform(InputMessage,.OutputMessage)
    set OutputMessage.DocType="2.5.1:ADT_A01"     
    //set OutputMessage.DocType="2.5.1:ORU_R01"    
    write OutputMessage.OutputToString()
    ; Access fields and segments in the HL7 message  
    
    Set PlaceofVisit = OutputMessage.GetValueAt("PV1:2") 
    Set AttendingDoctor = OutputMessage.GetValueAt("PV1:7") 
    Set VisitNumber = OutputMessage.GetValueAt("PV1:19")         
        
   ///Here we are logging in the values from the message 
    
    Write "PlaceofVisit: ", OutputMessage.GetValueAt("PV1:2"), ! 
    Write "AttendingDoctor: ", OutputMessage.GetValueAt("PV1:7"), ! 
    Write "VisitNumber: ", OutputMessage.GetValueAt("PV1:19"), ! 
   
     ///do ##class(%UnitTest.Manager).RunTest("mytests\UnitTestPV1Subtransform", "/nodelete")
]]></Implementation>
</Method>

<XData name="PV1Segment">
</XData>
</Class>
</Export>
</text>
}

XData UnitTestORCSubtransform
{
<text>
    
<?xmlversion="1.0" encoding="UTF-8"?>
<Export generator="IRIS" version="26" zv="IRIS for Windows (x86-64) 2022.1.2 (Build 574_0_22407U)" ts="2023-10-19 11:16:51">
<Class name="DOLPHIN.UnitTestORCSubtransform">
<Super>%UnitTest.TestCase</Super>
<TimeChanged>66766,40536.3179781</TimeChanged>
<TimeCreated>66764,44374.8256578</TimeCreated>

<Method name="TestORCSegment">
<Description>
Creating the first method to test</Description>
<Implementation><![CDATA[

    //create a transformation class instance
     set Transformation = ##class(HS.LeadNorthTransforms.R01).%New()
     //set Transformation = ##class(TEAM2SANDBOXPKG.DolphinSUBS).%New()

   // sample HL7 Input message
     set InputMessage = ##class(EnsLib.HL7.Message).%New()
         
     set HL7Message=     
      "MSH|^~\&|EPIC|MHS|||20110808073803|121732|ORU^R01|99273|P|2.3|||"_$C(13,10)_
      "PID|1|E2890060|E2890060^^^^EPI~0009526875^^^O^MRN||MENDEZ^ALVIN||19420406|M||K|6494 CLINTON COURT^^PUEBLO^SC^22954^USA^^^ORANGE|ORANGE|(868)706-8760|||S||RT-348794|497-54-8410||Rodgers^Alycia^^||"_$C(13,10)_
      "PV1||E|EDOC^ER09^09^OCM^R^^^^^^||||P676146^ZWEIFELHOFER^CHRISTEN|||E/R|||||||||309562814464|||||||||||||||||||||||||20110806|||||||V"_$C(13,10)_
      "ORC|SC|81738228^EPC|OC11US18192^EPC||Exam Began||^^^201108062114^201108062147^STAT||201108080738|P249130^ROGERS^DIANE||P676146^ZWEIFELHOFER^CHRISTEN|3010014^^^3010^^^^^OCM EDOC-EMERGENCY|(280)454-7052||"_$C(13,10)_
      "OBR|1|81738228^EPC|OC11US18192^EPC|IUS000063^US TESTICULAR^^^US TESTICULA||201108062115|||||O|||||P676146^ZWEIFELHOFER^CHRISTEN|(977)692-9023|309562814464||||201108080737||US|P||^^^201108062114^201108062147^STAT||||^Torsion||P094529^LEE^BENJAMIN^C^|P630889^DRABEK^EMMA|121732^MENDEZ TRANSCRIPTIONIST^MICHELE^^|201108062115|||||||||"_$C(13,10)_
      "NTE|1||Indication:->Torsion||"_$C(13,10)_
      "OBX|1|ST|&GDT|1|TESTICULAR ULTRASOUND: 08/06/2011||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|2|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|3|ST|&GDT|1|HISTORY:  Left testicular pain radiating to the left lower quadrant of the abdomen.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|4|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|5|ST|&GDT|1|COMPARISON: None.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|6|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|7|ST|&GDT|1|FINDINGS: The right testicle measures 4.5 cm in length. Left testicle measures 4.7 cm in length. Both testicles demonstrate normal color Doppler flow. No testicular mass lesions are seen.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|8|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|9|ST|&GDT|1|Multiple punctate echogenic foci are seen, unclear if this is artifactual or may represent testicular microlithiasis. ||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|10|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|11|ST|&GDT|1|The epididymides are unremarkable in appearance bilaterally.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)    
      
    set InputMessage=##class(EnsLib.HL7.Message).ImportFromString(HL7Message,.sc) $$$ThrowOnError(sc) 
    
    set status = Transformation.Transform(InputMessage,.OutputMessage)
     
    set OutputMessage.DocType="2.8:ORU_R30"

      //set InputFilemsg.DocType="2.8:ADT_A01"
      //set OutputMessage.DocType="LeadNorthLLC_2.8:ORU_R01"

    write OutputMessage.OutputToString()
    ; Access fields and segments in the HL7 message     
    set OrderControl = OutputMessage.GetValueAt("ORC:1", "|")
    set PlaceOrderNumber = OutputMessage.GetValueAt("ORC:2", "|")   
    set FillerOrderNumber = OutputMessage.GetValueAt("ORC:3", "|")     
    set OrderType = OutputMessage.GetValueAt("ORC:5", "|")  
    set DateofTransaction = OutputMessage.GetValueAt("ORC:9", "|")
    set EnteredBy = OutputMessage.GetValueAt("ORC:10", "|") 
    set OrderingProvider = OutputMessage.GetValueAt("ORC:12", "|")        
        
   ///Here we are logging in the values from the message 
    Write "OrderControl: ", OutputMessage.GetValueAt("ORC:1"), !
    Write "PlaceOrderNumber: ", OutputMessage.GetValueAt("ORC:2"), !
    Write "FillerOrderNumber: ", OutputMessage.GetValueAt("ORC:3"), !
    Write "OrderType: ", OutputMessage.GetValueAt("ORC:5"), !
    Write "DateofTransaction: ", OutputMessage.GetValueAt("ORC:9"), !
    Write "EnteredBy: ", OutputMessage.GetValueAt("ORC:10"), !
    Write "OrderingProvider: ", OutputMessage.GetValueAt("ORC:12"), !

    write $$$AssertEquals("SC", OrderControl)
    write $$$AssertEquals("Exam Began", OrderType)
    
     ///do ##class(%UnitTest.Manager).RunTest("mytests\UnitTestORCSubtransform", "/nodelete")
]]></Implementation>
</Method>

<XData name="ORCSegmentXData">
<Data><![CDATA[
<?xml version="1.0" encoding="UTF-8"?>
<Export generator="IRIS" version="26" zv="IRIS for Windows (x86-64) 2022.1.2 (Build 574_0_22407U)" ts="2023-10-17 15:49:10">
<Class name="DOLPHIN.UnitTestORCSubtransform">
<Super>%UnitTest.TestCase</Super>
<TimeChanged>66764,56796.194625</TimeChanged>
<TimeCreated>66764,44374.8256578</TimeCreated>

<Method name="TestORCSegment">
<Description>
Creating the first method to test</Description>
<Implementation><![CDATA[

    //create a transformation class instance
     set Transformation = ##class(HS.LeadNorthTransforms.R01).%New()
     //set Transformation = ##class(TEAM2SANDBOXPKG.DolphinSUBS).%New()

   // sample HL7 Input message
     set InputMessage = ##class(EnsLib.HL7.Message).%New()
         
     set HL7Message=     
      "MSH|^~\&|EPIC|MHS|||20110808073803|121732|ORU^R01|99273|P|2.3|||"_$C(13,10)_
      "PID|1|E2890060|E2890060^^^^EPI~0009526875^^^O^MRN||MENDEZ^ALVIN||19420406|M||K|6494 CLINTON COURT^^PUEBLO^SC^22954^USA^^^ORANGE|ORANGE|(868)706-8760|||S||RT-348794|497-54-8410||Rodgers^Alycia^^||"_$C(13,10)_
      "PV1||E|EDOC^ER09^09^OCM^R^^^^^^||||P676146^ZWEIFELHOFER^CHRISTEN|||E/R|||||||||309562814464|||||||||||||||||||||||||20110806|||||||V"_$C(13,10)_
      "ORC|SC|81738228^EPC|OC11US18192^EPC||Exam Began||^^^201108062114^201108062147^STAT||201108080738|P249130^ROGERS^DIANE||P676146^ZWEIFELHOFER^CHRISTEN|3010014^^^3010^^^^^OCM EDOC-EMERGENCY|(280)454-7052||"_$C(13,10)_
      "OBR|1|81738228^EPC|OC11US18192^EPC|IUS000063^US TESTICULAR^^^US TESTICULA||201108062115|||||O|||||P676146^ZWEIFELHOFER^CHRISTEN|(977)692-9023|309562814464||||201108080737||US|P||^^^201108062114^201108062147^STAT||||^Torsion||P094529^LEE^BENJAMIN^C^|P630889^DRABEK^EMMA|121732^MENDEZ TRANSCRIPTIONIST^MICHELE^^|201108062115|||||||||"_$C(13,10)_
      "NTE|1||Indication:->Torsion||"_$C(13,10)_
      "OBX|1|ST|&GDT|1|TESTICULAR ULTRASOUND: 08/06/2011||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|2|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|3|ST|&GDT|1|HISTORY:  Left testicular pain radiating to the left lower quadrant of the abdomen.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|4|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|5|ST|&GDT|1|COMPARISON: None.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|6|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|7|ST|&GDT|1|FINDINGS: The right testicle measures 4.5 cm in length. Left testicle measures 4.7 cm in length. Both testicles demonstrate normal color Doppler flow. No testicular mass lesions are seen.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|8|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|9|ST|&GDT|1|Multiple punctate echogenic foci are seen, unclear if this is artifactual or may represent testicular microlithiasis. ||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|10|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|11|ST|&GDT|1|The epididymides are unremarkable in appearance bilaterally.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)    
      
    set InputMessage=##class(EnsLib.HL7.Message).ImportFromString(HL7Message,.sc) $$$ThrowOnError(sc) 
    
    set status = Transformation.Transform(InputMessage,.OutputMessage)
     
    set OutputMessage.DocType="2.8:ORU_R30"

      //set InputFilemsg.DocType="2.8:ADT_A01"
      //set OutputMessage.DocType="LeadNorthLLC_2.8:ORU_R01"

    write OutputMessage.OutputToString()
    ; Access fields and segments in the HL7 message     
    set OrderControl = OutputMessage.GetValueAt("ORC:1", "|")
    set PlaceOrderNumber = OutputMessage.GetValueAt("ORC:2", "|")   
    set FillerOrderNumber = OutputMessage.GetValueAt("ORC:3", "|")     
    set OrderType = OutputMessage.GetValueAt("ORC:5", "|")  
    set DateofTransaction = OutputMessage.GetValueAt("ORC:9", "|")
    set EnteredBy = OutputMessage.GetValueAt("ORC:10", "|") 
    set OrderingProvider = OutputMessage.GetValueAt("ORC:12", "|") 
          
        
   ///Here we are logging in the values from the message 
    Write "OrderControl: ", OutputMessage.GetValueAt("ORC:1"), !
    Write "PlaceOrderNumber: ", OutputMessage.GetValueAt("ORC:2"), !
    Write "FillerOrderNumber: ", OutputMessage.GetValueAt("ORC:3"), !
    Write "OrderType: ", OutputMessage.GetValueAt("ORC:5"), !
    Write "DateofTransaction: ", OutputMessage.GetValueAt("ORC:9"), !
    Write "EnteredBy: ", OutputMessage.GetValueAt("ORC:10"), !
    Write "OrderingProvider: ", OutputMessage.GetValueAt("ORC:12"), !
   
    
     ///do ##class(%UnitTest.Manager).RunTest("mytests\UnitTestORCSubtransform", "/nodelete")
]]]]><![CDATA[></Implementation>
</Method>
</Class>
</Export>
]]></Data>
</XData>
</Class>
</Export>
</text>
}

}

