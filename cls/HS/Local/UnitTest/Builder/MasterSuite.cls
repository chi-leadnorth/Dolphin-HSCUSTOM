Class HS.Local.UnitTest.Builder.MasterSuite Extends %RegisteredObject
{

// MKO: To develop a Builder that generates Unit Test Suite Classes and reads the contents of the Subtransform classes from each class folder

// do ##class(HS.Local.UnitTest.Builder.MasterSuite).TestSuiteBuilderGenerator()

// Set pFilePath = "C:\Users\topfr\Desktop\DOLPHIN\MasterTestOutput"

// set pFileName = "TEST"

// Set pFacilityName = "JPS"

// Set pNamespace = "HSCUSTOM"

// Set pTestMethodName = "TestSuiteBuilderGenerator"

// Set pSelectedUnitTestNames = "UnitTestMSHSubtransform,UnitTestPIDSubtransform,UnitTestPV1Subtransform,UnitTestORCSubtransform,UnitTestOBRSubtransform"

ClassMethod TestSuiteBuilderGenerator(pFacilityID As %String = "", pFilePath As %String = "", pFileName As %String = "", pFacilityName As %String = "", pNamespace As %String = "", pSelectedUnitTestNames As %List = "") As %Status
{
    Set tSC = $$$OK

    // If any of the parameters are empty, prompt for input
    If pFacilityID = "" {
        Read !, "ENTER the FacilityID: ", pFacilityID
    }
    if pFacilityID = "" {
        Write "FacilityID cannot be empty"
        $$$ThrowStatus($$$ERROR($$$GeneralError, "FacilityIDcannot be empty"))
    }

    If pFilePath = "" {
        Read !, "ENTER the File Path: ", pFilePath
    }
    if pFilePath = "" {
        Write "File Path cannot be empty"
        $$$ThrowStatus($$$ERROR($$$GeneralError, "File Path cannot be empty"))
    }
    If pFileName = "" {
        Read !, "Enter the File Name: ", pFileName
    }
    if pFileName = "" {
        Write "File Name cannot be empty"
        $$$ThrowStatus($$$ERROR($$$GeneralError, "File Name cannot be empty"))
    }
    If pFacilityName = "" {
        Read !, "ENTER the Facility Name: ", pFacilityName
    }
    if pFacilityName = "" {
        Write "Facility Name cannot be empty"
        $$$ThrowStatus($$$ERROR($$$GeneralError, "Facility Name cannot be empty"))
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
       
    // Initialize the file content stream
    Set updatedContent = ""

    Set length = $LISTLENGTH(pSelectedUnitTestNames)
    // Iterate over the selected subtransform names
    For i = 1:1:length {  

        // Initialize the file content stream
        Set updatedContent = ""
        Set pSelectedUnitTestName = $LIST(pSelectedUnitTestNames, i)
        Write "Processing UnitTestName: ", pSelectedUnitTestName, !        
        // Create the output file
        write "About to open file"
        Set OutFile = ..ReturnOutputFile(pFilePath_"/"_pSelectedUnitTestName_".cls")
        Quit:(OutFile = $$$NULLOREF)

         write "The file has been opened"        

        // Parse the content from the XData block
        //Chi & Morris 11/03/23
        
        do ##class(Ens.Util.URLStream).GetURLStream("xdata://" _ ..%ClassName(1)_"."_pSelectedUnitTestName_":UnitTestContent", .pStream)
        write "xdata://" _ ..%ClassName(1)_"."_pSelectedUnitTestName_":UnitTestContent"      
          
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
        
        // Generate the Header and Class Definition
        Set header = "Class "_pFacilityName_""_pFacilityID_"."_pNamespace_"."_pSelectedUnitTestName_" Extends %UnitTest.TestCase "_$c(13,10)_"{"_$c(13,10)
        Set parameters = "Parameter IGNOREMISSINGSOURCE = 1;"_$c(13,10)_$c(13,10)
        Set parameters = parameters_"Parameter REPORTERRORS = 1;"_$c(13,10)_$c(13,10)
        Set parameters = parameters_"Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;"_$c(13,10)_$c(13,10)
        Set methodHeader = "Method "_pSelectedUnitTestName_"()"_$c(13,10)_"{"_$c(13,10)        
        Set xdataFooter = $c(13,10)_$c(13,10)_"}"_$c(13,10)_$c(13,10)_"}"
        // Combine the header, parameters, xdataHeader, and transformContent
        Set updatedContent = header_parameters_methodHeader_unitTestContent_xdataFooter       

        // Replace placeholders with actual values
        Set updatedContent = $replace(updatedContent, "{FacilityName}", pFacilityName)    
    
        // Write the updated content to the output file
        Set tSC = OutFile.Write(updatedContent)        
        Do OutFile.Close()
        Quit:$$$ISERR(tSC)
    }
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
        Else {Set pOutput = pInput
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

/// MKO: This method will be reading contents of the classes
Method ReadClasses(folderPath As %String) As %File
{
    
        #dim fileSpec As %String = folderPath _ "*.cls"
        #dim fileIterator As %String = ##class(%File).FileSet(fileSpec)
        #dim fileContent As %String

        While 'fileIterator.AtEnd {
            #dim filePath As %String = fileIterator.Next()
            
            If ##class(%File).Exists(filePath) {
                #dim fileStream As %Stream.GlobalBinary
                Set fileStream = ##class(%Stream.GlobalBinary).%New()
                Do fileStream.LinkToFile(filePath)
                
                Set fileContent = ""
                While 'fileStream.AtEnd {
                    Set fileContent = fileContent _ fileStream.Read(32767)
                }
                
                Do fileStream.%Close()
                Write "File Path: ", filePath, !
                Write "File Content:", !, fileContent, !
            }
            
        }
        Do fileIterator.Close()
}

}

