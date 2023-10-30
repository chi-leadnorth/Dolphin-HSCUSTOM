Class HS.API.REST.REST.RESTMap Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONVERTINPUTSTREAM = 1;

Parameter CONTENTTYPE = "application/json";

Parameter Version = "1.0.0";

Parameter HandleCorsRequest = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<!-- Server Info -->
<Route Url="/" Method="GET" Call="GetInfo" Cors="true"/>
<!-- Swagger specs -->
<Route Url="/_spec" Method="GET" Call="SwaggerSpec" />

<!-- Log in -->
<Route Url="/login" Method="GET" Call="LogIn" />


<!-- List all facilities -->
<Route Url="/facilities" Method="GET" Call="GetAllFacilities" />
<!-- Get a facility -->
<Route Url="/facilities/:id" Method="GET" Call="GetFacility" />
<!-- Create new facility -->
<Route Url="/facilities" Method="POST" Call="CreateFacility" />
<!-- Update a facility -->
<Route Url="/facilities/:id" Method="PUT" Call="UpdateFacility" />
<!-- Delete a facility -->
<Route Url="/facilities/:id" Method="DELETE" Call="DeleteFacility" />

<!-- List all connection profiles -->
<Route Url="/connection/profile" Method="GET" Call="GetAllConnectionProfiles" />
<!-- Get a connection profile -->
<Route Url="/connection/profile/:id" Method="GET" Call="GetConnectionProfile" />
<!-- Create new connection profile -->
<Route Url="/connection/profile" Method="POST" Call="CreateConnectionProfile" />
<!-- Update a connection profile -->
<Route Url="/connection/profile/:id" Method="PUT" Call="UpdateConnectionProfile" />
<!-- Delete a connection profile -->
<Route Url="/connection/profile/:id" Method="DELETE" Call="DeleteConnectionProfile" />

<!-- List all connection details -->
<Route Url="/connection/details" Method="GET" Call="GetAllConnectionDetails" />
<!-- Get a connection details -->
<Route Url="/connection/details/:id" Method="GET" Call="GetConnectionDetail" />
<!-- Create new connection details -->
<Route Url="/connection/details" Method="POST" Call="CreateConnectionDetail" />
<!-- Update a connection details -->
<Route Url="/connection/details/:id" Method="PUT" Call="UpdateConnectionDetail" />
<!-- Delete a connection details -->
<Route Url="/connection/details/:id" Method="DELETE" Call="DeleteConnectionDetail" />

<!-- List all pipelines -->
<Route Url="/pipeline" Method="GET" Call="GetAllPipelines" />
<!-- Get a pipeline -->
<Route Url="/pipeline/:id" Method="GET" Call="GetPipeline" />
<!-- Create new pipeline -->
<Route Url="/pipeline" Method="POST" Call="CreatePipeline" />
<!-- Update a pipeline -->
<Route Url="/pipeline/:id" Method="PUT" Call="UpdatePipeline" />
<!-- Delete a pipeline -->
<Route Url="/pipeline/:id" Method="DELETE" Call="DeletePipeline" />


</Routes>
}

/// Log in
ClassMethod LogIn() As %Status
{
  Return ##class(HS.API.REST.REST.service.AuthenticationService).LogIn()
}

/// List facilities
ClassMethod GetAllFacilities() As %Status
{
  Return ##class(HS.API.REST.REST.service.FacilityService).GetAll()
}

/// Get a facility
ClassMethod GetFacility(id As %String) As %Status
{
  Return ##class(HS.API.REST.REST.service.FacilityService).GetOne(id)
}

// Create a new facility

ClassMethod CreateFacility() As %Status
{
  Return ##class(HS.API.REST.REST.service.FacilityService).Create()
}

// Update a facility

ClassMethod UpdateFacility(id As %String) As %Status
{
  Return ##class(HS.API.REST.REST.service.FacilityService).Update(id)
}

// Delete a facility

ClassMethod DeleteFacility(id As %String) As %Status
{
  Return ##class(HS.API.REST.REST.service.FacilityService).Delete(id)
}

/// List connection profiles
ClassMethod GetAllConnectionProfiles() As %Status
{
  Return ##class(HS.API.REST.REST.service.ConnectionProfileService).GetAll()
}

/// Get a connection profile
ClassMethod GetConnectionProfile(id As %String) As %Status
{
  Return ##class(HS.API.REST.REST.service.ConnectionProfileService).GetOne(id)
}

// Create a new connection profile

ClassMethod CreateConnectionProfile() As %Status
{
  Return ##class(HS.API.REST.REST.service.ConnectionProfileService).Create()
}

// Update a connection profile

ClassMethod UpdateConnectionProfile(id As %String) As %Status
{
  Return ##class(HS.API.REST.REST.service.ConnectionProfileService).Update(id)
}

// Delete a connection profile

ClassMethod DeleteConnectionProfile(id As %String) As %Status
{
  Return ##class(HS.API.REST.REST.service.ConnectionProfileService).Delete(id)
}

/// List connection details
ClassMethod GetAllConnectionDetails() As %Status
{
  Return ##class(HS.API.REST.REST.service.ConnectionDetailsService).GetAll()
}

/// Get a connection detail
ClassMethod GetConnectionDetail(id As %String) As %Status
{
  Return ##class(HS.API.REST.REST.service.ConnectionDetailsService).GetOne(id)
}

// Create a new connection detail

ClassMethod CreateConnectionDetail() As %Status
{
  Return ##class(HS.API.REST.REST.service.ConnectionDetailsService).Create()
}

// Update a connection detail

ClassMethod UpdateConnectionDetail(id As %String) As %Status
{
  Return ##class(HS.API.REST.REST.service.ConnectionDetailsService).Update(id)
}

// Delete a connection detail

ClassMethod DeleteConnectionDetail(id As %String) As %Status
{
  Return ##class(HS.API.REST.REST.service.ConnectionDetailsService).Delete(id)
}

/// List pipelines
ClassMethod GetAllPipelines() As %Status
{
  Return ##class(HS.API.REST.REST.service.PipelineService).GetAll()
}

/// Get a pipeline
ClassMethod GetPipeline(id As %String) As %Status
{
  Return ##class(HS.API.REST.REST.service.PipelineService).GetOne(id)
}

// Create a new pipeline

ClassMethod CreatePipeline() As %Status
{
  Return ##class(HS.API.REST.REST.service.PipelineService).Create()
}

// Update a pipeline

ClassMethod UpdatePipeline(id As %String) As %Status
{
  Return ##class(HS.API.REST.REST.service.PipelineService).Update(id)
}

// Delete a pipeline

ClassMethod DeletePipeline(id As %String) As %Status
{
  Return ##class(HS.API.REST.REST.service.PipelineService).Delete(id)
}

/// List facilities categories
/// General information
ClassMethod GetInfo() As %Status
{
  SET version = ..#Version
  SET fmt=##class(%SYS.NLS.Format).%New("ptbw")
  
  SET info = {
    "Service": "Facility API",
    "version": (version),
    "Developer": "Yuri Gomes",
    "Status": "Ok",
    "Date": ($ZDATETIME($HOROLOG))
  }
  Set %response.ContentType = ..#CONTENTTYPEJSON
  Set %response.Headers("Access-Control-Allow-Origin")="*"

  Write info.%ToJSON()
  Quit $$$OK
}

ClassMethod %ProcessResult(pStatus As %Status = {$$$OK}, pResult As %DynamicObject = "") As %Status [ Internal ]
{
  #dim %response As %CSP.Response
  SET tSC = $$$OK
  IF $$$ISERR(pStatus) {
    SET %response.Status = 500
    SET tSC = ..StatusToJSON(pStatus, .tJSON)
    IF $isobject(tJSON) {
      SET pResult = tJSON
    } ELSE {
      SET pResult = { "errors": [ { "error": "Unknown error parsing status code" } ] }
    }
  } 
  ELSEIF pStatus=1 {
    IF '$isobject(pResult){
      SET pResult = {
      }
    }
  }
  ELSE {
    SET %response.Status = pStatus
    SET error = $PIECE(pStatus, " ", 2, *)
    SET pResult = {
      "error": (error)
    }
  }
  
  IF pResult.%Extends("%Library.DynamicAbstractObject") {
    WRITE pResult.%ToJSON()
  }
  ELSEIF pResult.%Extends("%JSON.Adaptor") {
    DO pResult.%JSONExport()
  }
  ELSEIF pResult.%Extends("%Stream.Object") {
    DO pResult.OutputToDevice()
  }
  
  QUIT tSC
}

ClassMethod SwaggerSpec() As %Status
{
  Set tSC = ##class(%REST.API).GetWebRESTApplication($NAMESPACE, %request.Application, .swagger)
  Do swagger.info.%Remove("x-ISC_Namespace")
  Set swagger.basePath = "/facility-api" 
  Set swagger.info.title = "Facility API"
  Set swagger.info.version = "1.0"
  Set swagger.host = "localhost:52773"
  Return ..%ProcessResult($$$OK, swagger)
}

}

