Class HS.Local.UnitTest.Builder.MasterSuiteIntegrationTest Extends %RegisteredObject
{

// Set pFacilityId = "7054"    

// Set pFacilityName = "EPMC"

// Set pTransformName = "ORUTransformation"

// Set SubtransformName = "UnitTestMSHSubtransform"

// set pFilePath = "C:\Users\topfr\Desktop\DOLPHIN\IntegrationTestOutput"

// Set pNameSpace = "HSCUSTOM"

// do ##class(HS.Local.UnitTest.Builder.MasterSuiteIntegrationTest).UnitTestGenerator()

// do ##class(HS.Local.UnitTest.Builder.MasterSuiteIntegrationTest).UnitTestGenerator(pFacilityId, pFacilityName, pTransformName, pSubtransformName, pFilePath, pNameSpace)

ClassMethod UnitTestGenerator(pFacilityId As %String = "", pFacilityName As %String = "", pTransformName As %String = "", pSubtransformName As %String = "", pFilePath As %String = "", pNameSpace As %List = "") As %Status
{
        // CallMasterSuite

    // Pass
    //FacilityId, TransformName, SubtransformName, FilePath,Namespace
    // to Build HL7 Interface in an edge gateway namespace (EG<FacilityId>)

    // GenerateUnitTests returns Status $$$OK or $$$ERROR

    // GenerateUnitTests creates a subtransform class and method for each Subtransform in the list.

    // All the Subtransform classes are located in FilePath/test. 

    Set tSC = $$$OK

    // If any of the parameters are empty, prompt for input
    If pFacilityId = "" {
        Read !, "ENTER the Facility ID: ", pFacilityId
    }
    if pFacilityId = "" {
        Write "Facility ID cannot be empty"
        $$$ThrowStatus($$$ERROR($$$GeneralError, "Facility ID cannot be empty"))
    }
    If pFacilityName = "" {
        Read !, "ENTER the Facility Name: ", pFacilityName
    }
    if pFacilityName = "" {
        Write "Facility Name cannot be empty"
        $$$ThrowStatus($$$ERROR($$$GeneralError, "Facility Name cannot be empty"))
    }
    If pTransformName = "" {
        Read !, "ENTER the TransformName: ", pTransformName
    }
    if pTransformName = "" {
        Write "TransformName cannot be empty"
        $$$ThrowStatus($$$ERROR($$$GeneralError, "TransformName cannot be empty"))
    }
    set pSubtransformName = pSubtransformName_"()"

    If pSubtransformName = "" {
        Read !, "ENTER the SubtransformName: ", pSubtransformName
    }
    if pSubtransformName = "" {
        Write "SubtransformName cannot be empty"
        $$$ThrowStatus($$$ERROR($$$GeneralError, "SubtransformNamee cannot be empty"))
    }
    If pFilePath = "" {
        Read !, "ENTER the File Path: ", pFilePath
    }
    if pFilePath = "" {
        Write "File Path cannot be empty"
        $$$ThrowStatus($$$ERROR($$$GeneralError, "File Path cannot be empty"))
    }
    
    If pNameSpace = "" {
        Read !, "ENTER the Namespace: ", pNameSpace
    }
    if pNameSpace = "" {
        Write "File Path cannot be empty"
        $$$ThrowStatus($$$ERROR($$$GeneralError, "Namespace cannot be empty"))
    }

    // Initialize pSubtransformName as an empty list
    Set pSubtransformName = ""

    // Check if pSubtransformName is empty or doesn't contain at least one item
    If pSubtransformName = "" {
        Read !, "Enter the desired SubtransformName (comma separated): ", pSubtransformName
    }
    // Convert the input to a list
    Set pSubtransformName = $LISTFROMSTRING(pSubtransformName, ",")

    // Check if the list is still empty
    If $LISTLENGTH(pSubtransformName) = 0 {
        Write "Minimum of 1 Selection Required"
        $$$ThrowStatus($$$ERROR($$$GeneralError, "Must use at least 1 UnitTestName"))
    }

    // Create the output file
    Set OutFile = ..ReturnOutputFile(pFilePath_"/"_pSubtransformName_".cls")
    Quit:(OutFile = $$$NULLOREF)

    // Initialize the file content stream
    Set updatedContent = ""

    Set length = $LISTLENGTH(pSubtransformName)
    // Iterate over the selected subtransform names
    For i = 1:1:length {
        Set pSubtransformName = $LIST(pSubtransformName, i)
        Write "Processing SubtransformName: ", pSubtransformName, !
        // Access the XData block directly based on pSelectedSubTransformName
        Set xdataBlock = ##class(%Dictionary.XDataDefinition).%OpenId(pSubtransformName)

        // Debug: Output the value of xdataBlock
        Write "xdataBlock: ", xdataBlock, !

        // Check if the selected subtransform name is valid
        If '$data(xdataBlock) {
            Write "Selected SubtransformName is not valid."
            Quit:$$$ERROR($$$GeneralError, "Invalid SubtransformName")
        }

    // Parse the content from the XData block
    Set tSC = ..getStream(pSubtransformName, .pStream)
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
        //Set header = "Class "_pFacilityName_"."_pNamespace_"."_pUnitTestName_" Extends %UnitTest.TestCase "_$c(13,10)_"{"_$c(13,10)
        Set parameters = "Parameter IGNOREMISSINGSOURCE = 1;"_$c(13,10)_$c(13,10)
        Set parameters = parameters_"Parameter REPORTERRORS = 1;"_$c(13,10)_$c(13,10)
        Set parameters = parameters_"Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;"_$c(13,10)_$c(13,10)
        //Set methodHeader = "Method "_pTestMethodName_$c(13,10)_"{"_$c(13,10)
        Set xdataFooter = $c(13,10)_$c(13,10)_"}"_$c(13,10)_$c(13,10)_"}"
        // Combine the header, parameters, xdataHeader, and transformContent
        //Set updatedContent = header_parameters_methodHeader_unitTestContent_xdataFooter       

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

}

