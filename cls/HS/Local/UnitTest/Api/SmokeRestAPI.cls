Class HS.Local.UnitTest.Api.SmokeRestAPI Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONVERTINPUTSTREAM = 1;

Parameter CONTENTTYPE = "application/json";

Parameter Version = "1.0.0";

Parameter HandleCorsRequest = 1;

// Logan

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/subtransform" Method="POST" Call="UnitTestMSHSubtransform"/>
</Routes>
}

// ClassMethod TestSuiteBuilderGenerator(pFacilityID As %String = "", pFilePath As %String = "", pFileName As %String = "", pFacilityName As %String = "", pNamespace As %String = "", pSelectedUnitTestNames As %List = "") As %Status

ClassMethod UnitTestMSHSubtransform() As %Status
{
  #dim tSC As %Status = $$$OK

  Set inputParams = {}.%FromJSON(%request.Content)
    
    //Log to check received inputs 
    Write "Received Input Parameters: ", inputParams.%ToJSON(), !

    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"
    Set status = []
    Set item = {}

    Try {
        Set pFacilityID = inputParams.pFacilityID
        Set pFilePath = inputParams.pFilePath
        Set pFileName = inputParams.pFileName
        Set pFacilityName = inputParams.pFacilityName
        set pNamespace = inputParams.pNamespace
        Set pSelectedUnitTestNames = inputParams.pSelectedUnitTestNames
       
    
        Set item.Message = "Inputs successfully gathered"


        do ##class(HS.Local.UnitTest.Builder.MasterSuite).TestSuiteBuilderGenerator(pFacilityID, pFilePath, pFileName, pFacilityName, pNamespace,pSelectedUnitTestNames)
        // Log to check the status
        Write "Status from GenerateDTLExportXML:", status.%ToJSON(), !
        // Check for errors from GenerateDTLExportXML method
        
        
     
        
    } Catch ex {
        Set %response.Status = 500
        Set item.message = "Test Suite Builder failed"
        Write "Error in BuildMasterSuite method: ", ex.DisplayString(), !
    }
#;Set status = ##class(HS.Local.UnitTest.Api.SmokeRestAPI).GetUnitTestMSHSubtransform(pFilePath, pFacilityName, pTransformName, pNamespace, pSelectedSubTransformNames)
    
    Do status.%Push(item)
    Write status.%ToJSON()

    Quit tSC
}

}

