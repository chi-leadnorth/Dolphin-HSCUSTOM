Class HS.Local.DOLPHIN.BuilderClass
{

Property SendingApplication As %String;

Property SendingFacility As %String;

Property PatientLastName As %String;

Property PatientFirstName As %String;

Property PatientID As %Numeric;

Property PatientDateofBirth As %Numeric;

Property PatientAddress As %Numeric;

Property DOB As %Date;

ClassMethod TestORUTransformations() As %String
{
}

/// Return the MRN Number
/// Print the Patient DOB
/// Print the Patient Address
/// Creating an EmptyFile
ClassMethod CreateEmptyFile(filename As %String) As %String
{
    set returnVal = ""
    set dir=##class(%File).GetDirectory(filename)
    do ##class(%File).CreateDirectoryChain(dir)
    Set fileObj = ##class(%File).%New(filename)
    Set status = fileObj.Open("WSN")
    do fileObj.Create(filename) /// added this line
    If ($SYSTEM.Status.IsError(status)) {
        do $system.Status.DisplayError(status)
        quit $$$NULLOREF
    }
     do fileObj.Close()
     set returnVal = "File opened: "_filename
     Quit returnVal
}

/// / Writing Content to File
ClassMethod WriteContentToFile(pOutputFile As %String, pContent As %String)
{
    set returnVal = ""
   set dir=##class(%File).GetDirectory(pOutputFile)
   do ##class(%File).CreateDirectoryChain(dir)
    Set fileObj = ##class(%File).%New(pOutputFile)
    Set status = fileObj.Open("WSN") // this was done for me
    do fileObj.Write(pContent)
    If ($SYSTEM.Status.IsError(status)) {
        do $system.Status.DisplayError(status)
        quit $$$NULLOREF
    }
     do fileObj.Close()
     set returnVal = "File opened: "_pOutputFile
     Quit returnVal
}

/// do ##class(DOLPHIN.BuilderClass).WriteContentToFile("C:\unittests\mytests\FileWriter\James.txt", "Morris$Amir$Brielle")
/// do ##class(HS.Local.Util.FileWriter).WriteContentToFile("C:\unittests\mytests\FileWriter\James.txt", "Morris$Amir")
/// 
ClassMethod WriteClassToFile(pOutputFile As %String, pClassName As %String, pProperty As %String)
{
    set returnVal = ""
    set dir=##class(%File).GetDirectory(pOutputFile)
    do ##class(%File).CreateDirectoryChain(dir)
    Set fileObj = ##class(%File).%New(pOutputFile)
    Set status = fileObj.Open("WSN") // this was done for me

    set body = "Class "_pClassName_" Extends Ens.Response \n{\n"
    set body = body_"Property "_pProperty_" ProjectCMS.cls;\n"
    set mind = body_"Property "_pProperty_" ProjectCMS.cls;\n"
    set body = mind_"Property "_pProperty_" ProjectCMS.cls;\n"
    set church = mind_"Property "_pProperty_" ProjectCMS.cls;\n"
    set body = church_"Property "_pProperty_" ProjectCMS.cls;\n"
    set body = body_"}"
    
    do fileObj.Write(body)
    
     do fileObj.Close()
     Quit returnVal
}

/// do ##class(DOLPHIN.BuilderClass).WriteClassToFile("C:\unittests\mytests\FileWriter\James.txt","Data", "Nathan")
/// do ##class(DOLPHIN.BuilderClass).WriteClassToFile("C:\unittests\mytests\FileWriter\James.txt","Music", "NathanBirthday")
/// Description
Method Iterate() As %Status
{
    Set sc = $$$OK
    // do something here

    set rootDirectory = "C:\unittests\mytests\RootUnitTest"
                set filePattern = "*.cls" ; Change this to match the files you want

                set folderIterator = ##class(%File).FileSet(rootDirectory, filePattern)
            while 'folderIterator.AtEnd {
             set filePath = folderIterator.Next()
                write "File Path: ", filePath, !
    ; Process the file here
    ; Don't forget to close the folderIterator when you're done
            do folderIterator.Close()
            }
    Return sc
}

}

