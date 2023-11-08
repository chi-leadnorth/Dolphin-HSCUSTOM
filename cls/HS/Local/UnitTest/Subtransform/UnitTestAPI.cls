Class HS.Local.UnitTest.Subtransform.UnitTestAPI Extends %CSP.REST
{

// 200 -Good

// 400 - Client Error

// 500-Server Error

// Parameter CHARSET = "utf-8";

// Parameter CONVERTINPUTSTREAM = 1;

// Parameter CONTENTTYPE = "application/json";

// Parameter Version = "1.0.0";

// Parameter HandleCorsRequest = 1;

// do ##class(HS.Local.DOLPHIN.UnitTestAPI).TestMSHSubtransfor()

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
     <!--List the Subtransforms-->
    
    <!--Get a Subtransform-->
    
    <Route Url="/TestMSHSubtransform" Method="GET" Call="TestMSH" />
    <!--Create a new Subtransform-->

    <Route Url="/UnitTestMSHSubtransform" Method="POST" Call="TestMSHL" />
    
    <!--Update a Subtransform-->
    <Route Url="/UnitTestMSHSubtransform" Method="PUT" Call="TestMSH" />

    <!--Delete a Subtransform-->
    <Route Url="/UnitTestMSHSubtransform" Method="DELETE" Call="TestMSH" />

    <Route Url="/UnitTestPIDSubtransform" Method="GET" Call="TestPID" />
    <Route Url="/UnitTestPIDSubtransform" Method="POST" Call="TestPID" />
    <Route Url="/UnitTestPIDSubtransform" Method="PUT" Call="TestPID" />
    <Route Url="/UnitTestPIDSubtransform" Method="DELETE" Call="TestPID" />

    <Route Url="/UnitTestPV1Subtransform" Method="GET" Call="TestPV1" />
    <Route Url="/UnitTestPV1Subtransform" Method="POST" Call="TestPV1" />
    <Route Url="/UnitTestPV1Subtransform" Method="PUT" Call="TestPV1" />
    <Route Url="/UnitTestPV1Subtransform" Method="DELETE" Call="TestPV1" />

</Routes>
}

ClassMethod CallGenerateDTLExportXML() As %Status
{
        Set tSC = $$$OK
        Set request = {}.%FromJSON(%request.Content)
        Try {
            Set filePath = request.%Get("FilePath")
            Set facilityName = request.%Get("FacilityName")
            Set transformName = request.%Get("TransformName")
            Set namespace = request.%Get("Namespace")
            Set selectedSubTransformNames = request.%Get("SelectedSubTransformNames")
    // hard code all values
            // Call the GenerateDTLExportXML method in the DolphinBuilder class
            Set tSC = ##class(HS.Local.DOLPHIN.MasterSuite).TestSuiteBuilderGenerator(filePath, facilityName, transformName, namespace, selectedSubTransformNames)

            // Handle the response as needed
            If $$$ISERR(tSC) {
                // Handle the error
                // Return an error response to the client
            } else {
                // Return a success response to the client
                // Provide additional information if needed
            }
        } Catch ex {
            // Handle exceptions
            Set tSC = ex.AsStatus()
        }

        Quit tSC
}

ClassMethod TestMSHSubtransform() As %Status
{
    Set tSC = $$$OK
    Quit tSC
    Return ##class(HS.Local.DOLPHIN.UnitTestMSHSubtransform).TestMSH()
}

ClassMethod TestPIDSubtransform() As %Status
{
    Set tSC = $$$OK
    Quit tSC
    Return ##class(HS.Local.DOLPHIN.UnitTestPIDSubtransform).TestPID()
}

ClassMethod TestPV1Subtransform() As %Status
{
    set tSC = $$$OK
    Quit tSC
    Return ##class(HS.Local.DOLPHIN.UnitTestPV1Subtransform).TestPV1()
}

}

