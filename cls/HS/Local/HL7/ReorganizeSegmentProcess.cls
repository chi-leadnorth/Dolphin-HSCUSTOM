Class HS.Local.HL7.ReorganizeSegmentProcess Extends (Ens.BusinessProcess, EnsLib.HL7.Util.IOFraming)
{

/// Reorganize Segments: These segments are unexpected in the HL7 schema and will be moved to the 
/// Trailing ZEX segments section to allow HL7 message to parse.<p/>
/// Format of the parameter is a pipe-delimited string. <p/> 
/// Example1: ZIN|ZXT|AL1 will push ZIN, ZXT, and AL1 segments to the trailing end of the message<p/>
/// Example2: Z* indicates all Z-segments will be moved to the trailing section <p/>
/// Example3: ROL|Z* will push ROL segments and all Z segments to the trailing section </p> 
Property ReorganizeSegments As %String(MAXLEN = 1000) [ InitialExpression = "Z*" ];

/// AL1 Reorg On Discharge: For A03 messages, the AL1 segment is expected before the OBX segments in HL7 standard schemas. </p>
/// This order is commonly reversed, causing schema failure. If this option is checked, the AL1 segment is moved before OBX
/// ONLY on A03 messages. 
Property AL1ReorgOnDischarge As %Boolean [ InitialExpression = 0 ];

/// DG1 Reorg On Discharge: For A03 messages, the DG1 segments are expected before the OBX segments in HL7 standard schemas. </p>
/// This order is commonly reversed, causing schema failure. If this option is checked, the DG1 segments are moved before OBX
/// ONLY on A03 messages. 
Property DG1ReorgOnDischarge As %Boolean [ InitialExpression = 0 ];

/// Configuration item(s) to which to send file stream messages
Property TargetConfigNames As %String(MAXLEN = 1000);

/// Category to apply to incoming message types to produce a complete DocType specification.<p/>
/// Combines with the document type Name (MSH:9) to produce a MessageType specification which is then used 
/// to look up a MessageStructure/DocType in the MessageTypes section of the given HL7 schema category.<p/>
/// This setting may also contain multiple comma-separated type Names followed by = and then a 
/// DocTypeCategory or full DocType value to apply to HL7 messages containing that type Name.<p/>
/// A trailing asterisk (*) at the end of a given partial type Name will match any types with that beginning part.<p/>
/// For example: MessageSchemaCategory='2.3.1, ADT_*=2.5, BAR_P10=2.4, ORM_O01_6=2.4:RDE_O01' <br>
/// Note that a DocType assignment may be needed for Validation or SearchTableClass indexing.
Property MessageSchemaCategory As %String(MAXLEN = 1000) [ InitialExpression = "2.5.1" ];

/* (override comments, display lists and defaults for setting inherited from base class) */
/// HL7 inbound message framing protocol. The options are: <br/><ul>
/// <li>Flexible: Determine framing style from the content of received data of each message received. </li>
/// <li>Flexible!: Determine framing style from the content of received data of the first message and require subsequent messages to have that same framing style. </li>
/// <li>None: No framing - Each line that begins with 'MSH' is the start of a new message. </li>
/// <li>MLLP: Minimal Lower Level Protocol - Frame each HL7 message with ASCII code 11 prefix and ASCII code 28,13 suffix. </li>
/// <li>MLLPN/M: Minimal Lower Level Protocol - Frame each HL7 message with ASCII code N prefix, and ASCII code M suffix followed by an additional ASCII code 13. </li>
/// <li>AsciiLF: Frame messages with ASCII code 10 (Line Feed) separating each message from the subsequent one. </li>
/// <li>AsciiCR: Frame messages with an extra ASCII code 13 (Carriage Return) separating each message from the subsequent one. </li>
/// <li>AsciiM: Frame messages with ASCII code M suffix character(s) separating each message from the subsequent one. </li>
/// <li>AsciiN/M: Frame messages with ASCII code N prefix character(s) before each message and ASCII code M suffix character(s), but no trailing ASCII code 13 as in MLLPN/M. </li>
/// <li>LLP: Lower Level Protocol - (Obsolete) Frame each HL7 message in a redundant checksum block. </li></ul><p/>
/// Notes: <br/>
/// - ASCII code N is a sequence of one or more characters represented by their ASCII code, separated by comma in case of more than one character. <br/>
/// - All ASCII codes should be given in decimal. <br/>
/// - ASCII code 120 (character 'x') is not allowed as a framing character. <br/>
Property Framing As %String(DISPLAYLIST = ",Flexible,Flexible!,None,MLLP,MLLP11/28,AsciiLF,AsciiCR,Ascii11,Ascii11/28,LLP") [ InitialExpression = "Flexible" ];

/// Store a set of searchable properties associated with each HL7 message processed. <br/>
/// These records will be stored in the named SearchTable class, if any.
Property SearchTableClass As %String(MAXLEN = 128) [ InitialExpression = "EnsLib.HL7.SearchTable" ];

/// How to resolve a DocType based on the message type from MSH:9.  The options are: <br/><ul>
/// <li>Standard: Combine the effective MessageSchemaCategory value with a message structure name looked up for the MSH:9 message type value in the corresponding schema category. This is the default. </li>
/// <li>Ignore 9.3: Like 'Standard' but if MSH:9 has 3 or more pieces, ignore the additional ones. The standard behavior is to use piece 3 as part of the type name if it has no sub-pieces because some schemas contain 3-part type names. </li>
/// <li>Use 9.3: Like 'Standard' but if MSH:9 has 3 or more pieces, use the additional piece as the literal name of the document structure within the applicable schema category. Use with caution because messages may arrive with MSH:9.3 values for which no structure is present in the chosen schema category. </li>
/// <li>Literal: Combine the effective MessageSchemaCategory value with the literal MSH:9 message type value interpreted as the name of a message structure. Use only with custom schemas where every message type has a corresponding structure definition. </li></ul>
Property DocTypeResolution As %String(DISPLAYLIST = ",Standard,Ignore 9.3,Use 9.3,Literal", VALUELIST = ",Std,Ign,Use,Lit") [ InitialExpression = "Std", Required ];

Parameter SETTINGS = "ReorganizeSegments:Basic,AL1ReorgOnDischarge:Basic,DG1ReorgOnDischarge:Basic,TargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},SearchTableClass::selector?context={Ens.ContextSearch/SearchTableClasses?host=EnsLib.HL7.Service.Standard},Framing:Connection:selector?context={Ens.ContextSearch/getDisplayList?host=@currHostId&prop=Framing},MessageSchemaCategory:Basic:selector?context={Ens.ContextSearch/SchemaCategories?host=EnsLib.HL7.Service.Standard},DefCharEncoding::selector?context={Ens.ContextSearch/CharacterSets},DocTypeResolution";

Method OnRequest(pRequest As EnsLib.HL7.Message, Output pResponse As EnsLib.HL7.Message) As %Status
{
        Set tSC = $$$OK
        #Dim tMSH as EnsLib.HL7.Segment   
        Try {
           
            Set tSeparators = "|^~\&"_$Char(13,10)
            Set inputStream = ##class(%Stream.GlobalCharacter).%New()
            Set doAL1Reorg = 0
            Set doDG1Reorg = 0
            Set savedAL1 = ""
            Set savedDG1 = ""
            
            do pRequest.OutputToLibraryStream(.inputStream, tSeparators) 

            do inputStream.Rewind()

            //Convert the EnsLib.HL7.Message to a Stream
            //do pRequest.OutputToLibraryStream(.inputStream)

            Set pResponse = ##class(Ens.StreamContainer).%New()
           
            Set outputStream = ##class(%Stream.GlobalCharacter).%New()
            Set extensionStream = ##class(%Stream.GlobalCharacter).%New()
            
            if ..ReorganizeSegments["Z*" {
                Set StripAllZSegments = 1
            }
            else {
                Set StripAllZSegments = 0
            }

            // Initial check of event type
            
            if (..AL1ReorgOnDischarge = 1 || ..DG1ReorgOnDischarge) && 'inputStream.AtEnd{
                
                Set line = inputStream.ReadLine()
                Set eventType = ..GetEventType(line)
                if eventType = "A03" {
                    set doAL1Reorg = ..AL1ReorgOnDischarge
                    set doDG1Reorg = ..DG1ReorgOnDischarge
                }

                do inputStream.Rewind()
            }
            
            While 'inputStream.AtEnd {
                Set line = inputStream.ReadLine()

                // AL1 on Discharge treated as a special case.
                // If option is selected and message is discharge 
                // On AL1 segment content is saved
                // and will be re-inserted before first OBX after main reorg is done 
                // Hackish. Sorry
                If doAL1Reorg && ($Extract(line,1,3) = "AL1") {
                    Set savedAL1 = line
                    Continue                        
                }

                // DG1 on Discharge treated as a special case.
                // If option is selected and message is discharge 
                // On DG1 segment content is saved, appending current DG1 to any previous content
                // All DG1s will be re-inserted before first OBX after main reorg is done 
                // Even MORE Hackish. Sorry
                If doDG1Reorg && ($Extract(line,1,3) = "DG1") {
                    if savedDG1'="" {
                        Set savedDG1 = $Char(13,10)_savedDG1
                    }
                    Set savedDG1 = line_savedDG1
                    Continue                        
                }

                If StripAllZSegments && ($Extract(line, 1) = "Z") {
                    //write to extension stream
                    $$$ThrowOnError(extensionStream.Write("ZEX|"))
                    $$$ThrowOnError(extensionStream.Write(line_$Char(13,10)))
                    Continue  
                }

                // Next check all values. If the reorganize segments list contains current line segment id, 
                // then move the line to the extensions at the end
                If ..ReorganizeSegments[$Extract(line, 1,3) {
                    //write to extension stream
                    $$$ThrowOnError(extensionStream.Write("ZEX|"))
                    $$$ThrowOnError(extensionStream.Write(line_$Char(13,10)))
                    Continue  
                }
                ;Append the line to the output stream
                $$$ThrowOnError(outputStream.Write(line_$Char(13,10)))
            }
            do outputStream.Rewind()

            //Special AL1 reorg on A03 messages
            if (doAL1Reorg'=0) && (savedAL1'="") {
                $$$ThrowOnError(..InsertSegment(outputStream, savedAL1, .outputStream)) ;replacing outputStream in this call
                do outputStream.Rewind()
            }

            //Special DG1 reorg on A03 messages
            if (doDG1Reorg'=0) && (savedDG1'="") {
                $$$ThrowOnError(..InsertSegment(outputStream, savedDG1, .outputStream)) ;replacing outputStream in this call
                do outputStream.Rewind()
            }

            do extensionStream.Rewind()
           
            $$$ThrowOnError(..appendStreams(outputStream,extensionStream,.combinedStream))
            // Create HL7 message object
            //set hl7Message=##class(EnsLib.HL7.Message).ImportFromLibraryStream(outputStream,.tSC) $$$ThrowOnError(tSC)
            set hl7Message=##class(EnsLib.HL7.Message).ImportFromLibraryStream(combinedStream,.tSC) $$$ThrowOnError(tSC)
        
            // Determine DocType from MSH
            set tMSH=hl7Message.getSegmentByIndex(1)
            set tName=tMSH.GetValueAt(9,":_~\&")
            set tDocType=##class(EnsLib.HL7.Schema).ResolveSchemaTypeToDocType(..MessageSchemaCategory,tName, tSC, ..DocTypeResolution) $$$ThrowOnError(tSC)
        
            // Set DocType and category and build map
            set hl7Message.DocType=tDocType
            //set tSC=hl7Message.BuildMap(1)    $$$ThrowOnError(tSC)
        
            ;Send the HL7 message to Targets
            For iTarget=1:1:$L(..TargetConfigNames, ",") { 
                Set tOneTarget=$ZStrip($P(..TargetConfigNames,",",iTarget),"<>W")  Continue:""=tOneTarget
	    	    $$$sysTRACE("Sending HL7 Message "_outputStream_"("_outputStream.Size_")"_" Sync to '"_tOneTarget_"'")
		    
			    Set tSC1=..SendRequestSync(tOneTarget,hl7Message, .pResponse)  Set:$$$ISERR(tSC1) tSC=$$$ADDSC(tSC,tSC1)

	        }
            ;Set the modified stream as the response
            Set pResponse = hl7Message
        }
        Catch ex {
            // Handle any exceptions here
            Set tSC = ex.AsStatus()
		    $$$LOGERROR(tSC)
        }
        
        Quit tSC
}

/// Helper Method to check for A03 in MSH:9 using string parsing
/// Returns Empty String "" if the first three characters of the Segment are not MSH
/// Field Delimiter can be passed in. Default value is pipe "|"
ClassMethod GetEventType(Segment As %String, FieldDelimiter As %String = "|", SubFieldDelimiter As %String = "^") As %String
{
    if ($Extract(Segment, 1,3) = "MSH") {
        Set EventType = $PIECE(Segment, FieldDelimiter, 9)
        Set EventType = $PIECE(EventType,SubFieldDelimiter,2)
        Quit EventType
    }
    else {
        Quit ""
    }
}

/// Helper method takes a Stream and segement content as string. 
/// Loops through stream line by line, inserting a segment before first OBX
/// If this is used to reorder AL1 and DG1, AL1 should be done first and then DG1
/// Updated Stream is returned
ClassMethod InsertSegment(inputStream As %Stream.GlobalCharacter, segmentContent As %String, ByRef outputStream As %Stream.GlobalCharacter) As %Status
{
    Set tSC = $$$OK
    Set outputStream = ##class(%Stream.GlobalCharacter).%New()
    Set foundFirstOBX = 0

    while 'inputStream.AtEnd {
        Set line = inputStream.ReadLine()
        If ($Extract(line,1,3) = "OBX") && 'foundFirstOBX {
            ;Append the inserted segment to the output stream
            $$$ThrowOnError(outputStream.Write(segmentContent_$Char(13,10)))
            ;Then append the current line to the output stream
            $$$ThrowOnError(outputStream.Write(line_$Char(13,10)))
            Set foundFirstOBX = 1                        
        }
        else {
            ;Just append the current line to the output stream
            $$$ThrowOnError(outputStream.Write(line_$Char(13,10)))
        }
    }
    Quit tSC
}

/// FILE IO helper methods
/// For debugging, esp. when catching carriage return/newline issues
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

ClassMethod WriteOutToFile(filename As %String, message As %Stream)
{
    Set FileWriter = ..ReturnOutputFile(filename)
    Do FileWriter.Write(message)
    Do FileWriter.Close()
}

ClassMethod appendStreams(pStream1 As %Stream.Object, pStream2 As %Stream.Object, ByRef pOutputStream As %Stream.Object) As %Status
{
    Set tSC = $$$OK
    Set pOutputStream = ##class(%Stream.GlobalCharacter).%New()

    Set tSC = pOutputStream.Write(pStream1.Read())
    Set tSC = pOutputStream.Write(pStream2.Read())
    //CNR: I'm just paranoid about rewinding 
    do pStream1.Rewind()
    do pStream2.Rewind()
    do pOutputStream.Rewind()

    Quit tSC
}

Storage Default
{
<Data name="StripSegmentProcessDefaultData">
<Subscript>"StripSegmentProcess"</Subscript>
<Value name="1">
<Value>TargetConfigNames</Value>
</Value>
<Value name="2">
<Value>%Parser</Value>
</Value>
<Value name="3">
<Value>MessageSchemaCategory</Value>
</Value>
<Value name="4">
<Value>Framing</Value>
</Value>
<Value name="5">
<Value>SearchTableClass</Value>
</Value>
<Value name="6">
<Value>DocTypeResolution</Value>
</Value>
<Value name="7">
<Value>DefCharEncoding</Value>
</Value>
<Value name="8">
<Value>%outFraming</Value>
</Value>
<Value name="9">
<Value>ReorganizeSegments</Value>
</Value>
<Value name="10">
<Value>AL1ReorgOnDischarge</Value>
</Value>
<Value name="11">
<Value>DG1ReorgOnDischarge</Value>
</Value>
</Data>
<DefaultData>StripSegmentProcessDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

