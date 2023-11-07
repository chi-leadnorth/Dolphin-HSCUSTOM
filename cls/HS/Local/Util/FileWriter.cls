Include HS.Common

Class HS.Local.Util.FileWriter
{

/// This class contains utility methods for writing files
/// Set up the input file
/// 1. Create a file object
/// 2. Open the file for reading
/// 3. Return a handle to the file object
ClassMethod ReturnInputFile(filename As %String) As %File
{
    Set fileObj = ##class(%File).%New(filename)
    Set status = fileObj.Open("RU")
    if $$$ISERR(status) { 
        do $system.Status.DisplayError(status) 
        quit $$$NULLOREF
    }
    quit fileObj
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

/// Creates an empty file in a location for teting
/// 1. Create the directory structure for the file
/// 2. Create a file 
ClassMethod CreateEmptyFile(filename As %String) As %String
{
    set returnVal = ""
    set dir=##class(%File).GetDirectory(filename)
    do ##class(%File).CreateDirectoryChain(dir)
    Set fileObj = ##class(%File).%New(filename)
    Set status = fileObj.Open("WSN")
    If ($SYSTEM.Status.IsError(status)) {
        do $system.Status.DisplayError(status)
        quit $$$NULLOREF
    }
     do fileObj.Close()
     set returnVal = "File opened: "_filename
     Quit returnVal
}

// Nathan

/// Writes a line to an output file
/// Your challenge -- Complete this method to write a content string to an output file
/// The ProcessFile method below gives you clues
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

/// do ##class(HS.Local.Util.FileWriter).WriteContentToFile("C:\unittests\mytests\FileWriter\James.txt", "Morris$Amir")
/// Process one line, using $REPLACE to perform a series of substitutions on the line
ClassMethod ProcessLine(line As %String = "") As %String
{
    set newline = line

    set newline = $REPLACE(newline, "Original", "Jamaican-Style")
    set newline = $REPLACE(newline, "traditional", "innovative")
    set newline = $REPLACE(newline, "orange juice", "lime juice")
    set newline = $REPLACE(newline, "orange zest", "ginger")
    set newline = $REPLACE(newline, "white sugar", "light brown sugar")

    quit newline
}

/// CNR: Kind of a silly example I found online - you'll need to create an input file with some test data in order to try this out
/// Process an input file, performing a series of substitutions on the content and
/// writing the new content to an output file
ClassMethod ProcessFile(inputfilename As %String = "", outputfilename As %String = "")
{
    // Make sure filenames were passed in
    if (inputfilename="") || (outputfilename="") {
        write !, "ERROR: missing file name"
        quit
    }

    // Open input file for reading
    set inputfile = ..ReturnInputFile(inputfilename)
    if (inputfile = $$$NULLOREF) quit

    // Open output file for writing
    set outputfile = ..ReturnOutputFile(outputfilename)
    if (outputfile = $$$NULLOREF) quit

    // Loop over each line in the input file
    // While not at the end of the file:
    // 1. Read a line from the file
    // 2. Call ProcessLine() to process the line
    // 3. Write the new contents of the line to the output file
    while (inputfile.AtEnd = 0) {
        set line = inputfile.ReadLine(,.status)
         if $$$ISERR(status) { 
             do $system.Status.DisplayError(status) 
         }
         else {
             set newline = ..ProcessLine(line)
             do outputfile.WriteLine(newline)
         }
    }
    
    // Close the input and output files
     do inputfile.Close()
     do outputfile.Close()
}

}

