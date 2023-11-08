Class HS.Local.UnitTest.Subtransform.MorrisRuleBuilder Extends %RegisteredObject
{

// do ##class(DOLPHIN.MorrisRuleBuilder).ReadCLSFiles()

ClassMethod ReadCLSFiles() As %Status
{
    Set sc = $$$OK
    // do something
    Return sc

    Set folderPath = "your_folder_path_here"
    Set folder = ##class(%File).%New(folderPath)
    Set fileList = folder.GetFiles("*.cls")

    For i = 1:1:fileList.Count() {
    Set filePath = folderPath _ "\" _ fileList.GetAt(i)
    Set fileStream = ##class(%Stream.FileBinary).%New()
    Set extract = 0  // Flag to indicate whether to extract lines
    
    If fileStream.LinkToFile(filePath) {
        While 'fileStream.AtEnd {
            Set line = fileStream.ReadLine()
            
            // Define markers or conditions for the start and end of the section
            If line["StartMarker" {
                Set extract = 1
                // You can optionally start storing lines or printing here
            }

            // If extract flag is set, print or process lines
            If extract {
                Write line, !
            }
            If line["EndMarker" {
                Set extract = 0
                // You can optionally stop storing lines or printing here
            }
        }

    }

    }
}

}

