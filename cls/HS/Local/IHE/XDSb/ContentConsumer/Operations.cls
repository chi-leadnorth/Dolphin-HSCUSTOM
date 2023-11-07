/// Custom ContentConsumer with Accelerator Code
/// Implements the functionality needed to consume documents created by XDS-MS, XDS-LAB, XPHR, and other documents created by content creators defined in IHE's PCC domain
Class HS.Local.IHE.XDSb.ContentConsumer.Operations Extends (HS.Util.SOAPClient.Operations, HS.Util.XSLTTransformer, HS.Util.Trace.Helper) [ Inheritance = right, ProcedureBlock ]
{

Property Target As Ens.DataType.ConfigName [ InitialExpression = "HS.Gateway.ECR.Manager" ];

Property PreprocessorXsltPath As %String(MAXLEN = 500) [ InitialExpression = "CUSTOM/CDA/CDAPreprocessor.xsl" ];

Property CdaToSdaXsltPath As %String(MAXLEN = 500) [ InitialExpression = "SDA3/CCDA-to-SDA.xsl" ];

Property IsDebug As %Boolean [ InitialExpression = "0" ];

Property DebugFileLocation As %String;

Parameter SETTINGS = "Target,IsDebug:Debug,DebugFileLocation:Debug,PreprocessorXsltPath:XSLT,CdaToSdaXsltPath:XSLT,AlwaysAddPatient:Patient,TransformDoc:Transformation,UpdateEncounterWard:ENCOUNTER,FilterDataBeforeDate:FILTER/DELETE,IgnoreExternalID:FILTER/DELETE,UpdateEncounterNumbers:ENCOUNTER,DeleteProbEncounter:FILTER/DELETE,DeleteProcedureEncounter:FILTER/DELETE,DeleteObsEncounter:FILTER/DELETE,RemoveEncounterReason:FILTER/DELETE,RemoveEmptyEncounter:FILTER/DELETE,MoveObsToProcedures:OBSERVATIONS,RemoveEmptyProblems:FILTER/DELETE,FixFacilityCodeInDocument:TRANSFORMATION,FixFacilityCodeInHeader:TRANSFORMATION,NonConsSections:FILTER/DELETE,GenerateVaccineID:VACCINATIONS,DeleteVacEncounter:VACCINATIONS,DeleteVitSignEncounter:FILTER/DELETE,ECRTarget,StoreUsingGlobalPatientIdentifier,DebugOutputFile,CopyPatientIdentifierToSDATransform";

Property ECRTarget As Ens.DataType.ConfigName [ InitialExpression = "HS.Gateway.ECR.Manager" ];

/// When consuming a document, that document's patient ID can in theory be different than the global patient identifier found in the XDSb RegisterDocumentSet header.
/// Set this to 'True' to force HealthShare to use the XDSb RegisterDocumentSet header's patient ID, guaranteeing that the ECR and Patient Registry are 'linked' by the same patient ID.
Property StoreUsingGlobalPatientIdentifier As %Boolean [ InitialExpression = 1 ];

/// If set to a valid, fully-qualified file name (path + file), HealthShare will output the source document (ie, CCD) to this file before it attempts to consume it.
Property DebugOutputFile As %String;

Property CopyPatientIdentifierToSDATransform As %String(MAXLEN = 250) [ InitialExpression = "IHE/XDSb/Version1/CopyPatientIdentifierToSDA.xsl" ];

// Transformation parameters

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

/// SDA Sections to not consume. This is a bit of a misnomer as the sections are consumed from the CDA, but are removed from the SDA. Options included (as a list): Patient,Encounter,Alert,AdvanceDirective,Allergy,IllnessHistory,SocialHistory,FamilyHistory,Guarantor, Problem,Diagnosis,Observation,ObservationGroup,Problem,PhysicalExam,Procedure,Document,LabOrder,RadOrder, OtherOrder,Medication,Vaccination,Appointment,Referral,ClinicalRelationship,ProgramMembership,MemberEnrollment, MedicalClaim,GenomicsOrder,CarePlan,HealthConcern,Goal,SocialDeterminant. If all sections are to be included, leave blank. 
Property NonConsSections As %String;

/// Generate Vaccine IDs for Placer and Filler IDs, based on OrderItem.Code and Date Administered if it's blank. Uses the order code and the vaccine FromTime (with punctuation removed).
Property GenerateVaccineID As %Boolean;

/// When set, encounter number from vaccination will be removed
Property DeleteVacEncounter As %Boolean;

/// Delete encounter IDs from Observations that have Observation Codes that are the LOINC Codes listed. 
Property DeleteVitSignEncounter As %String(MAXLEN = 500) [ InitialExpression = "34566-0,8867-4,9279-1,,8480-6,8462-4,8310-5,8302-2,8361-8,80339-5" ];

Method OnInit() As %Status
{
	#dim eException As %Exception.AbstractException
	
	Try {
		Set tStatus = $$$OK

		#; Invoke super class's version of OnInit() first, and throw an error (if any)
		$$$ThrowOnError(##super())
		
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

	}
	Catch eException {		
		Set tStatus = eException.AsStatus()
	}
	
	Quit tStatus
}

Method OnMessage(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		Set pResponse = ##class(HS.Message.XMLMessage).%New()

		If pRequest.%IsA("HS.Message.XMLMessage") {
			If (pRequest.Name = "XDSb_ConsumeAndStoreRequest") {
				Set tStatus = ..ConsumeDocument(pRequest, .tConsumeReponse) $$$ThrowOnError(tStatus)
				Set tStatus = ..StoreSDA(tConsumeReponse, .pResponse) $$$ThrowOnError(tStatus)
			}
			ElseIf (pRequest.Name = "XDSb_ConsumeRequest") {
				Set tStatus = ..ConsumeDocument(pRequest, .pResponse) $$$ThrowOnError(tStatus)
			}
			Else {
				Set tStatus = $$$ERROR($$$GeneralError, "Request type not handled:  " _ pRequest.Name) $$$ThrowOnError(tStatus)
			}
		}
		Else {
			Set tStatus = $$$ERROR($$$GeneralError, "Request type not handled:  " _ pRequest.%ClassName(1)) $$$ThrowOnError(tStatus)
		}
		
	
		
	}
	Catch eException {
		Set pResponse.Name = $Replace(pRequest.Name, "Request", "Response")
		Do pResponse.ContentStream.Write("<Error>" _ eException.DisplayString() _ "</Error>")
		
		Set tStatus = eException.AsStatus()
	}
	
	Quit tStatus
}

Method ConsumeDocument(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		Set pResponse.Name = "XDSb_ConsumeResponse"

		If 'pRequest.StreamCollection.Count() Set tStatus = $$$ERROR($$$GeneralError, "No documents found in input request") $$$ThrowOnError(tStatus)
		If 'pRequest.StreamCollection.GetAt(1).Body.Size Set tStatus = $$$ERROR($$$GeneralError, "Empty document found in input request") $$$ThrowOnError(tStatus)

		#; Get document body
		Set tDocumentStream = pRequest.StreamCollection.GetAt(1).Body
		
		#; If there's a debug file configured, output document body to it
		If (..DebugOutputFile ] "") {
			Open ..DebugOutputFile:"WNS":1
			If '$Test $$$ThrowStatus($$$ERROR($$$GeneralError, "Unable to open debug file:  " _ ..DebugOutputFile))

			Set tDevice = $IO Use ..DebugOutputFile Do tDocumentStream.Rewind(), tDocumentStream.OutputToDevice() Write ! Use tDevice

			Close ..DebugOutputFile
		}

		#; Transform document body to SDA
		///Set tStatus = ##class(HS.IHE.CodedEntry).GetFormatToSDA(pRequest.AdditionalInfo.GetAt("documentFormatCode"), pRequest.AdditionalInfo.GetAt("documentFormatScheme"), .tTransform) $$$ThrowOnError(tStatus)
		///If (tTransform = "") $$$ThrowStatus($$$ERROR($$$GeneralError, "No SDA transformation defined for format code '" _ pRequest.AdditionalInfo.GetAt("documentFormatCode") _ "'"))
		///Set tStatus = ..Transform(tDocumentStream, tTransform, .tSDAStream) $$$ThrowOnError(tStatus)

		///Set pResponse.ContentStream = tSDAStream
		
			/// ********* Process CDA Code ************
		
		Set cdaStream = ##class(%Stream.TmpCharacter).%New()
        $$$ThrowOnError(cdaStream.CopyFrom(tDocumentStream))
        $$$ThrowOnError(cdaStream.Rewind())

		
		  Set transformer = ##class(HS.Util.XSLTTransformer).%New()

        //do the transformation using the XSLT specified in the properties. This is the XSLT that gets updated when creating a new property. 
        //$$$ThrowOnError(transformer.Transform(cdaStream, ..PreprocessorXsltPath, .processedCda, .params))

        //Trace to view the pre/post XSLT transform. 
        //$$$HSTRACE("CDA Preprocessor Content", "Original,Preprocessed", cdaStream, processedCda)
        //send the Processed CDA to a file. DEBUGGING ONLY.
        If ..IsDebug {
            Set file=##class(%Stream.FileBinary).%New()
            Set file.Filename=..DebugFileLocation_"1-CDA_PostXSLT.xml"
            $$$ThrowOnError(cdaStream.Rewind())
            Do file.CopyFromAndSave(cdaStream)
        }

        //transform from CDA to SDA, results are put into a ##class(%Stream.TmpCharacter)
        //$$$ThrowOnError(transformer.Transform(processedCda, ..CdaToSdaXsltPath, .tSDAStream))
		$$$ThrowOnError(transformer.Transform(cdaStream, ..CdaToSdaXsltPath, .tSDAStream))

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

		//CNR: Had to comment out because don't have the RAJHelper classes loaded
        //check aux:
        //Set tAuxStr = ##class(HS.Local.RAJHelperClasses.Helpers).printArrayObjectAsJSONString(aux)
        //$$$HSTRACE("SDA PostProcess","Aux",tAuxStr)
      
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


		Set pResponse.ContentStream = tSDAAfterDTLStream
      	

    	//send the SDA to a file. DEBUGGING ONLY.
      	If ..IsDebug {
        	Set file=##class(%Stream.FileBinary).%New()
        	Set file.Filename=..DebugFileLocation_"3-SDA_Final.xml"
        	$$$ThrowOnError(tSDAAfterDTLStream.Rewind())
        	Do file.CopyFromAndSave(tSDAAfterDTLStream)
      	}
		
		//CNR: resume standard code
		Set pResponse.AdditionalInfo = pRequest.AdditionalInfo
		Set pResponse.SAMLData = pRequest.SAMLData.%ConstructClone()
	}
	Catch eException {
		Set tStatus = eException.AsStatus()
	}
	
	Quit tStatus
}

Method StoreSDA(pRequest As HS.Message.XMLMessage, Output pResponse As HS.Message.XMLMessage) As %Status
{
	#dim eException As %Exception.AbstractException
	
	Set tStatus = $$$OK
	
	Try {
		Set pResponse = ##class(HS.Message.XMLMessage).%New()
		Set pResponse.Name = "XDSb_ConsumeAndStoreResponse"
		
		If (..StoreUsingGlobalPatientIdentifier = 1) {
			Set tXSLArguments("patientGlobalAssigningAuthority") = "'" _ pRequest.AdditionalInfo.GetAt("patientGlobalAssigningAuthority") _ "'"
			Set tXSLArguments("patientGlobalID") = "'" _ pRequest.AdditionalInfo.GetAt("patientGlobalID") _ "'"
			Set tXSLArguments("repositoryOID") = "'" _ pRequest.AdditionalInfo.GetAt("repositoryOID") _ "'"
			// Transform XDSb Consume and Store Request to extract Patient Identifiers to SDA
			Set tStatus = ..Transform(pRequest.ContentStream, ..CopyPatientIdentifierToSDATransform /*"IHE/XDSb/Version1/CopyPatientIdentifierToSDA.xsl"*/, .tSDAStream, .tXSLArguments) $$$ThrowOnError(tStatus)
		}
		Else { Set tSDAStream = pRequest.ContentStream }
		
		#dim tECRRequest as HS.Message.ECRUpdateRequest
		Set tECRRequest = ##class(HS.Message.ECRUpdateRequest).%New()
		Set tECRRequest.ContentStream = tSDAStream
		Set tECRRequest.StreamContentType="SDA3"
		
		#dim tECRResponse As HS.Message.ECRUpdateResponse
		Set tStatus = ..SendRequestSync(..ECRTarget, tECRRequest, .tECRResponse) $$$ThrowOnError(tStatus)
		
		#; ECRResponse is always null.  Need long-term fix, but for now force success
		Set tECRResponse.PatientID = 1
		Do pResponse.ContentStream.Write("<Status>" _ $Case(tECRResponse.PatientID = "", 0:"success", :"failure") _ "</Status>")
	}
	Catch eException {
		Do pResponse.ContentStream.Write("<Status>failure</Status>")
		
		Set tStatus = eException.AsStatus()
	}
	
	Quit tStatus
}

}

