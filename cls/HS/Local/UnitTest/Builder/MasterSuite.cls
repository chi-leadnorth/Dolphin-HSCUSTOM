Class HS.Local.UnitTest.Builder.MasterSuite Extends %RegisteredObject
{

ClassMethod TestSuiteBuilder(pFacilityID As %String = "", pFilePath As %String = "", pFileName As %String = "", pFacilityName As %String = "", pNamespace As %String = "", pSelectedUnitTestNames As %List = "") As %Status
{
    Set tSC = $$$OK
    Set pSelectedUnitTestNames = $LISTFROMSTRING(pSelectedUnitTestNames, ",")
    If $LISTLENGTH(pSelectedUnitTestNames) = 0 {
        Write "Minimum of 1 Selection Required"
        $$$ThrowStatus($$$ERROR($$$GeneralError, "Must use at least 1 UnitTestName"))
    } 
    Set updatedContent = ""
    Set header = "Class "_pFacilityName_""_pFacilityID_"."_pNamespace_"."_pFileName_" Extends %UnitTest.TestCase "_$c(13,10)_"{"_$c(13,10)
    Set parameters = "Parameter IGNOREMISSINGSOURCE = 1;"_$c(13,10)_$c(13,10)
    Set parameters = parameters_"Parameter REPORTERRORS = 1;"_$c(13,10)_$c(13,10)
    Set parameters = parameters_"Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;"_$c(13,10)_$c(13,10)

    For i = 1:1:$LISTLENGTH(pSelectedUnitTestNames) {  
        Set pSelectedUnitTestName = $LIST(pSelectedUnitTestNames, i)
        Write "Processing UnitTestName: ", pSelectedUnitTestName, !        

        do ##class(Ens.Util.URLStream).GetURLStream("xdata://" _ ..%ClassName(1)_"."_pSelectedUnitTestName_":UnitTestContent", .pStream)
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

        Set methodHeader = "Method "_"Test"_pSelectedUnitTestName_"()"_$c(13,10)_"{"_$c(13,10)        
        Set xdataFooter = $c(13,10)_$c(13,10)_"}"_$c(13,10)_$c(13,10)
        Set updatedContent = updatedContent_methodHeader_unitTestContent_xdataFooter_$c(13,10,13,10)
    }

    Set updatedContent = header_parameters_updatedContent_$c(13,10)_"}"
    Set OutFile = ..ReturnOutputFile(pFilePath_"/"_pFileName_".cls")
    Quit:(OutFile = $$$NULLOREF)
    Set tSC = OutFile.Write(updatedContent)        
    Do OutFile.Close()
    Quit tSC
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

