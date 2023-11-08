Include (HS.Common, %ZHSLIB)

Class HS.Local.DTA.ProcessCda Extends (Ens.BusinessProcess, HS.HC.Util.Trace.Helper)
{

Property Target As Ens.DataType.ConfigName [ InitialExpression = "HS.Gateway.ECR.Manager" ];

Property PreprocessorXsltPath As %String(MAXLEN = 500) [ InitialExpression = "CUSTOM/CDAPreprocessor.xsl" ];

Property CdaToSdaXsltPath As %String(MAXLEN = 500) [ InitialExpression = "SDA3/CCDAv21-to-SDA.xsl" ];

Property IsDebug As %Boolean [ InitialExpression = "0" ];

Property DebugFileLocation As %String;

Parameter SETTINGS = "Target,IsDebug:Debug,DebugFileLocation:Debug,PreprocessorXsltPath:XSLT,CdaToSdaXsltPath:XSLT,AlwaysAddPatient:Patient,TransformDoc:Transformation,UpdateEncounterWard:ENCOUNTER,FilterDataBeforeDate:FILTER/DELETE,IgnoreExternalID:FILTER/DELETE,UpdateEncounterNumbers:ENCOUNTER,DeleteProbEncounter:FILTER/DELETE,DeleteProcedureEncounter:FILTER/DELETE,DeleteObsEncounter:FILTER/DELETE,RemoveEncounterReason:FILTER/DELETE,RemoveEmptyEncounter:FILTER/DELETE,MoveObsToProcedures:OBSERVATIONS,RemoveEmptyProblems:FILTER/DELETE,FixFacilityCodeInDocument:TRANSFORMATION,FixFacilityCodeInHeader:TRANSFORMATION,NonConsSections:FILTER/DELETE,GenerateVaccineID:VACCINATIONS,DeleteVacEncounter:VACCINATIONS,DeleteVitSignEncounter:FILTER/DELETE";

Method OnRequest(request As Ens.StreamContainer, response As HS.Message.ECRUpdateResponse) As %Status
{
    
    Set status = $$$OK
    Try {
        Set response = ##class(HS.Message.ECRUpdateResponse).%New()
        Set cdaStream = ##class(%Stream.TmpCharacter).%New()
        $$$ThrowOnError(cdaStream.CopyFrom(request.Stream))
        $$$ThrowOnError(cdaStream.Rewind())

        //cdaStream is the CDA XML.

        //params are used by the XSLT transformation. 
        #; SET PARAMS HERE - DO NOT REMOVE THIS COMMENT. USED FOR AUTOMATIC ADDITION OF NEW PARAMETER/PROPERTY. IF IT MUST BE CHANGED/REMOVED, UPDATE CODE IN HS.LOCAL.DTA.PRODPROPERTYHELPER.CLS


        Set params("FixFacilityCodeInHeader")= ..FixFacilityCodeInHeader
        Set params("FixFacilityCodeInDocument")= ..FixFacilityCodeInDocument
        Set params("RemoveEmptyProblems")= ..RemoveEmptyProblems
        Set params("MoveObsToProcedures")= ..MoveObsToProcedures
        Set params("RemoveEmptyEncounter")= ..RemoveEmptyEncounter
        Set params("RemoveEncounterReason")= ..RemoveEncounterReason
        Set params("DeleteObsEncounter")= ..DeleteObsEncounter
        Set params("DeleteProcedureEncounter")= ..DeleteProcedureEncounter
        Set params("DeleteProbEncounter")= ..DeleteProbEncounter
        Set params("UpdateEncounterNumbers")= ..UpdateEncounterNumbers
        Set params("FilterDataBeforeDate")= ..FilterDataBeforeDate
        Set params("UpdateEncounterWard")= ..UpdateEncounterWard
        Set params("TransformDoc")= ..TransformDoc
        Set params("AlwaysAddPatient")= ..AlwaysAddPatient 


        Set transformer = ##class(HS.Util.XSLTTransformer).%New()

        //do the transformation using the XSLT specified in the properties. This is the XSLT that gets updated when creating a new property. 
        $$$ThrowOnError(transformer.Transform(cdaStream, ..PreprocessorXsltPath, .processedCda, .params))

        //Trace to view the pre/post XSLT transform. 
        $$$HSTRACE("CDA Preprocessor Content", "Original,Preprocessed", cdaStream, processedCda)
        //send the Processed CDA to a file. DEBUGGING ONLY.
        If ..IsDebug {
            Set file=##class(%Stream.FileBinary).%New()
            Set file.Filename=..DebugFileLocation_"1-CDA_PostXSLT.xml"
            $$$ThrowOnError(processedCda.Rewind())
            Do file.CopyFromAndSave(processedCda)
        }

        //transform from CDA to SDA, results are put into a ##class(%Stream.TmpCharacter)
        $$$ThrowOnError(transformer.Transform(processedCda, ..CdaToSdaXsltPath, .tSDAStream))

        Set tSDA=##class(EnsLib.EDI.XML.Document).ImportFromLibraryStream(tSDAStream)
   
        $$$HSTRACE("SDA PreProcess", "SDA",tSDA)
                //send the Processed CDA to a file. DEBUGGING ONLY.
        If ..IsDebug {
            Set file=##class(%Stream.FileBinary).%New()
            Set file.Filename=..DebugFileLocation_"2-SDA_BeforeDTL.xml"
            Set tSDAPreDTL=##class(%Stream.TmpCharacter).%New()
            Set tSC=tSDA.OutputToLibraryStream(.tSDAPreDTL)
           // $$$ThrowOnError(tSDA.Rewind())
            Do file.CopyFromAndSave(tSDAPreDTL)
        }          

        
        //build aux for DTL. 
        Set aux = ##class(%ArrayOfDataTypes).%New()
        //aux.SetAt(value,key) Key is DTL full name. Value is whatever the value is for the DTL class (not for the parent dtl). 1/0 or a string
        #; SET AUX FOR DTl HERE 
        Do aux.SetAt(..DeleteVitSignEncounter,"DeleteVitSignEncounter")
        Do aux.SetAt(..DeleteVacEncounter,"DeleteVacEncounter")
        Do aux.SetAt(..GenerateVaccineID,"GenerateVaccineID")
        Do aux.SetAt(..NonConsSections,"NonConsSections")
        Do aux.SetAt(..IgnoreExternalID,"IgnoreExternalID")

        //check aux:
        Set tAuxStr = ##class(HS.Local.RAJHelperClasses.Helpers).printArrayObjectAsJSONString(aux)
        $$$HSTRACE("SDA PostProcess","Aux",tAuxStr)
      
        //call parent DTL.  

        Set tSDAAfterDTL = ##class(EnsLib.EDI.XML.Document).%New()
        //Set tSC=##class(HS.Local.DTA.DTL.ParentDTL).Transform(tSDA,.tSDASAfterDTL,.aux)

        //$$$ThrowOnError($CLASSMETHOD("HS.Local.DTA.DTL.ParentDTL", "Transform", tSDA, .tSDASAfterDTL, .aux))
        Set tSC = $CLASSMETHOD("HS.Local.DTA.DTL.ParentDTL", "Transform", tSDA, .tSDAAfterDTL, .aux)
        $$$HSTRACE("SDA PostProcess1", "SDA1",tSDAAfterDTL)

        

        //Back to stream - Copying what's in HS.Gateway.SDA3.InboundProcess.
        Set tSDAAfterDTLStream=##class(%Stream.TmpCharacter).%New()
       // Set sdaStream = ##class(%Stream.TmpCharacter).%New()
        //Set tSC= tSDAAfterDTL.XMLExportToStream(.tSDAAfterDTLStream)
        Set tSC=tSDAAfterDTL.OutputToLibraryStream(.tSDAAfterDTLStream)
        $$$HSTRACE("SDA PostProcess2", "SDA2",tSDAAfterDTLStream)

        //build the ecr request. 
        Set ecrUpdateRequest = ##class(HS.Message.ECRUpdateRequest).%New()
        Set ecrUpdateRequest.StreamContentType="SDA3"
        Set ecrUpdateRequest.ContentStream =tSDAAfterDTLStream //?



        #; Uncomment to send to ECR manager
        Do ..SendRequestSync(..Target, ecrUpdateRequest, .response)

      //send the SDA to a file. DEBUGGING ONLY.
      If ..IsDebug {
        Set file=##class(%Stream.FileBinary).%New()
        Set file.Filename=..DebugFileLocation_"3-SDA_Final.xml"
        $$$ThrowOnError(tSDAAfterDTLStream.Rewind())
        Do file.CopyFromAndSave(tSDAAfterDTLStream)
      }

    } Catch ex {
        Set status = ex.AsStatus()
        $$$LOGERROR("error: " _ status)
    }
    Quit status
}

// Setting to set debug or not. Debug writes the CDA after XSLT, SDA after CDA-> SDA transformation, and SDA after DTLs. This should only be used 

// in non-production or high volume situations. 

/// Always Add Patient from XDS
Property AlwaysAddPatient As %Boolean [ InitialExpression = "0" ];

/// Any data before this date will be filtered
Property FilterDataBeforeDate As %String;

/// If the facility is on the list, then the lookup table will be used to know what transform to do
Property TransformDoc As %String;

/// Update the encounter ward
Property UpdateEncounterWard As %Boolean;

/// When Set, encounter number from problems will be removed
Property DeleteProbEncounter As %Boolean;

/// When set, ExternalIds will be removed from all objects in the CDA. External IDs are only imported to SDA from CDA if ImportProfile.xsl configuration item $generalImportConfiguration/sdaActionCodes/overrideExternalId is set to 1
Property IgnoreExternalID As %String;

/// Updates encounter number to use the effectiveDate_NPI, if NPI is blank or not present, effectiveDate will be used 
Property UpdateEncounterNumbers As %Boolean;

/// When set, observation encounter is removed
Property DeleteObsEncounter As %Boolean;

/// When set, encounter number from procedures will be removed
Property DeleteProcedureEncounter As %Boolean;

/// Determines whether or not to use the identifier information from the header in the document
Property FixFacilityCodeInDocument As %Integer [ InitialExpression = "0" ];

/// Use the identifier information from the document and not the header
Property FixFacilityCodeInHeader As %Integer [ InitialExpression = "0" ];

/// When set, observations will be copied into procedures
Property MoveObsToProcedures As %Boolean;

/// Removes empty encounters
Property RemoveEmptyEncounter As %Boolean;

/// Removes empty problems
Property RemoveEmptyProblems As %Boolean;

/// remove Encounter.EncounterCodedType. which is displayed as Reason for Visit
Property RemoveEncounterReason As %Boolean;

Storage Default
{
<Data name="ProcessCdaDefaultData">
<Subscript>"ProcessCda"</Subscript>
<Value name="1">
<Value>Target</Value>
</Value>
<Value name="2">
<Value>PreprocessorXsltPath</Value>
</Value>
<Value name="3">
<Value>CdaToSdaXsltPath</Value>
</Value>
<Value name="4">
<Value>AlwaysAddPatient</Value>
</Value>
<Value name="5">
<Value>FilterDataBeforeDate</Value>
</Value>
<Value name="7">
<Value>TransformDoc</Value>
</Value>
<Value name="8">
<Value>UpdateEncounterWard</Value>
</Value>
<Value name="9">
<Value>DeleteProbEncounter</Value>
</Value>
<Value name="12">
<Value>IgnoreExternalID</Value>
</Value>
<Value name="13">
<Value>UpdateEncounterNumbers</Value>
</Value>
<Value name="14">
<Value>DeleteObsEncounter</Value>
</Value>
<Value name="15">
<Value>DeleteProcedureEncounter</Value>
</Value>
<Value name="17">
<Value>FixFacilityCodeInDocument</Value>
</Value>
<Value name="18">
<Value>FixFacilityCodeInHeader</Value>
</Value>
<Value name="19">
<Value>MoveObsToProcedures</Value>
</Value>
<Value name="20">
<Value>RemoveEmptyEncounter</Value>
</Value>
<Value name="21">
<Value>RemoveEmptyProblems</Value>
</Value>
<Value name="22">
<Value>RemoveEncounterReason</Value>
</Value>
<Value name="24">
<Value>TraceOperations</Value>
</Value>
<Value name="25">
<Value>IsDebug</Value>
</Value>
<Value name="26">
<Value>DebugFileLocation</Value>
</Value>
<Value name="27">
<Value>NonConsSections</Value>
</Value>
<Value name="28">
<Value>GenerateVaccineID</Value>
</Value>
<Value name="29">
<Value>DeleteVacEncounter</Value>
</Value>
<Value name="30">
<Value>DeleteVitSignEncounter</Value>
</Value>
</Data>
<DefaultData>ProcessCdaDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

/// SDA Sections to not consume. This is a bit of a misnomer as the sections are consumed from the CDA, but are removed from the SDA. Options included (as a list): Patient,Encounter,Alert,AdvanceDirective,Allergy,IllnessHistory,SocialHistory,FamilyHistory,Guarantor, Problem,Diagnosis,Observation,ObservationGroup,Problem,PhysicalExam,Procedure,Document,LabOrder,RadOrder, OtherOrder,Medication,Vaccination,Appointment,Referral,ClinicalRelationship,ProgramMembership,MemberEnrollment, MedicalClaim,GenomicsOrder,CarePlan,HealthConcern,Goal,SocialDeterminant. If all sections are to be included, leave blank. 
Property NonConsSections As %String;

/// Generate Vaccine IDs for Placer and Filler IDs, based on OrderItem.Code and Date Administered if it's blank. Uses the order code and the vaccine FromTime (with punctuation removed).
Property GenerateVaccineID As %Boolean;

/// When set, encounter number from vaccination will be removed
Property DeleteVacEncounter As %Boolean;

/// Delete encounter IDs from Observations that have Observation Codes that are the LOINC Codes listed. 
Property DeleteVitSignEncounter As %String(MAXLEN = 500) [ InitialExpression = "34566-0,8867-4,9279-1,,8480-6,8462-4,8310-5,8302-2,8361-8,80339-5" ];

}

