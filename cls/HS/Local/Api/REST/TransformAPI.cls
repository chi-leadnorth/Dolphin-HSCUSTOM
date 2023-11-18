/// V6
Class HS.Local.Api.REST.TransformAPI Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONVERTINPUTSTREAM = 1;

Parameter CONTENTTYPE = "application/json";

Parameter Version = "1.0.0";

Parameter HandleCorsRequest = 1;

/// 
/// URL Map for Postman 
XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
 <!-- To call the methods independently -->
 <Route Url="/buildTransform" Method="POST" Call="BuildTransform" />
 <Route Url="/buildTestSuite" Method="POST" Call="BuildMasterSuite" />
</Routes>
}

/// Method to call GenerateTransform class 
ClassMethod BuildTransform() As %Status
{
    #dim tSC As %Status = $$$OK

    Set inputParams = {}.%FromJSON(%request.Content)

    Write "Received input parameters: ", inputParams.%ToJSON(), !

    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"
    Set status = []
    Set item = {}

    Try {
        Set pFilePath = inputParams.pFilePath
        Set pFacilityName = inputParams.pFacilityName
        Set pTransformName = inputParams.pTransformName
        Set pNamespace = inputParams.pNamespace
        Set pSelectedSubTransformNames = inputParams.pSelectedSubTransformNames
        
        /// Log to check validity of the list 
        Write "Subtransformations being passed into method: ", pSelectedSubTransformNames, !

        /// Pass corresponding items in JSON payload to builder
        do ##class(HS.Local.Builder.GenerateTransform).GenerateDTLExportXML(pFilePath, pFacilityName, pTransformName, pNamespace, pSelectedSubTransformNames)

        // Log to check the status
        Write !, "Status from GenerateDTLExportXML:", status.%ToJSON(), !


    } Catch ex {
        Set %response.Status = 500
        Set item.message = "Transform Builder failed"
        Write "Error in BuildTransform method: ", ex.DisplayString(), !
    }
    
    Do status.%Push(item)
    Write status.%ToJSON()

    Quit tSC
}

/// Method to call GenerateUnitTest class
ClassMethod BuildMasterSuite() As %Status
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

        /// Pass corresponding items in JSON payload to builder
        do ##class(HS.Local.UnitTest.Builder.MasterSuite).TestSuiteBuilder(pFacilityID, pFilePath, pFileName, pFacilityName, pNamespace, pSelectedUnitTestNames)

        // Log to check the status
        Write "Status from GenerateDTLExportXML:", status.%ToJSON(), !
            
    } Catch ex {
        Set %response.Status = 500
        Set item.message = "Test Suite Builder failed"
        Write "Error in BuildMasterSuite method: ", ex.DisplayString(), !
    }
    
    Do status.%Push(item)
    Write status.%ToJSON()

    Quit tSC
}

}

