Class HS.Local.DOLPHIN.UnitTestClasses.MasterBuilderPID Extends %RegisteredObject
{

// Set pFilePath = "C:\Users\topfr\Desktop\DOLPHIN\MasterTestOutput"

// Set pFacilityName = "LEADNORTHLLC"

// Set pTestMethodName = "GenerateDTLExportXML"

// Set pUnitTestName = "UnitTestPIDSubtransform"

// Set pNamespace = "TEAM2SANDBOX"

// do ##class(DOLPHIN.MasterBuilderPID).GenerateDTLExportXML()

// Do ##class(DOLPHIN.MasterBuilderPID).GenerateDTLExportXML(pFilePath, pFacilityName, pTestMethodName, pUnitTestName, pNamespace)

Parameter UnitTestPIDSubtransform = "%XML.Adaptor(XMLNAMESPACE = ""http://www.intersystems.com/dtl"")";

// set content=pStream.Read(32000),content=$p(content,"<text>",2,99999),content=$p(content,"</text>")

ClassMethod GenerateDTLExportXML(pFilePath As %String = "", pFacilityName As %String = "", pTestMethodName As %String = "", pUnitTestName As %String = "", pNamespace As %String = "", pSelectedUnitTestNames As %List = "") As %Status
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
    If pTestMethodName = "" {
        Read !, "ENTER the ClassTestMethod Name: ", pTestMethodName
    }
    if pTestMethodName = "" {
        Write "Test Method Name cannot be empty"
        $$$ThrowStatus($$$ERROR($$$GeneralError, "Test Method Name cannot be empty"))
    }
    set pTestMethodName = pTestMethodName_"()"

    If pUnitTestName = "" {
        Read !, "ENTER the UnitTestName: ", pUnitTestName
    }
    if pUnitTestName = "" {
        Write "UnitTestName cannot be empty"
        $$$ThrowStatus($$$ERROR($$$GeneralError, "UnitTestName cannot be empty"))
    }
    If pNamespace = "" {
        Read !, "ENTER the Namespace Name: ", pNamespace
    }
    if pNamespace = "" {
        Write "Namespace cannot be empty"
        $$$ThrowStatus($$$ERROR($$$GeneralError, "Namespace cannot be empty"))
    }

    // Initialize pSelectedSubTransformNames as an empty list
    Set pSelectedUnitTestNames = ""

    // Check if pSelectedSubTransformNames is empty or doesn't contain at least one item
    If pSelectedUnitTestNames = "" {
        Read !, "Enter the Desired UnitTestSubtransformNames (comma separated): ", pSelectedUnitTestNames
    }

    // Convert the input to a list
    Set pSelectedUnitTestNames = $LISTFROMSTRING(pSelectedUnitTestNames, ",")

    // Check if the list is still empty
    If $LISTLENGTH(pSelectedUnitTestNames) = 0 {
        Write "Minimum of 1 Selection Required"
        $$$ThrowStatus($$$ERROR($$$GeneralError, "Must use at least 1 UnitTestName"))
    }

    // Create the output file
    Set OutFile = ..ReturnOutputFile(pFilePath_"/"_pUnitTestName_".cls")
    Quit:(OutFile = $$$NULLOREF)

    // Initialize the file content stream
    Set updatedContent = ""

    Set length = $LISTLENGTH(pSelectedUnitTestNames)
    // Iterate over the selected subtransform names
    For i = 1:1:length {
        Set pSelectedUnitTestName = $LIST(pSelectedUnitTestNames, i)
        Write "Processing UnitTestName: ", pSelectedUnitTestName, !
        // Access the XData block directly based on pSelectedSubTransformName
        Set xdataBlock = ##class(%Dictionary.XDataDefinition).%OpenId(pSelectedUnitTestName)

        // Debug: Output the value of xdataBlock
        Write "xdataBlock: ", xdataBlock, !

        // Check if the selected subtransform name is valid
        If '$data(xdataBlock) {
            Write "Selected UnitTestName is not valid."
            Quit:$$$ERROR($$$GeneralError, "Invalid UnitTestName")
        }

    // Parse the content from the XData block
    Set tSC = ..getStream(pSelectedUnitTestName, .pStream)
        Write "pStream: ", pStream, !

        // Parse out the content from in between the <transform> tags
        Set unitTestContent = ""
        Set insideUnitTest = 0

        While 'pStream.AtEnd {
            Set line = pStream.ReadLine()

            If $find(line, "<Implementation><![CDATA[") {
                If 'insideUnitTest {
                    Set insideUnitTest = 1
                    Continue
                }    
            }

            If insideUnitTest {
                If $find(line, "]]></Implementation>") {
                    Set insideUnitTest = 0
                } Else {
                    Set unitTestContent = unitTestContent_line_$c(13,10)
                }
            }
        }
    }
        
        // Generate the header and class definition
        Set header = "Class "_pFacilityName_"."_pNamespace_"."_pUnitTestName_" Extends %UnitTest.TestCase "_$c(13,10)_"{"_$c(13,10)
        Set parameters = "Parameter IGNOREMISSINGSOURCE = 1;"_$c(13,10)_$c(13,10)
        Set parameters = parameters_"Parameter REPORTERRORS = 1;"_$c(13,10)_$c(13,10)
        Set parameters = parameters_"Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;"_$c(13,10)_$c(13,10)
        Set methodHeader = "Method "_pTestMethodName_$c(13,10)_"{"_$c(13,10)
        Set xdataFooter = $c(13,10)_$c(13,10)_"}"_$c(13,10)_$c(13,10)_"}"
        // Combine the header, parameters, xdataHeader, and transformContent
        Set updatedContent = header_parameters_methodHeader_unitTestContent_xdataFooter       

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

}

