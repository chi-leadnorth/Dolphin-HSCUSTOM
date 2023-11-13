Class HS.Local.Api.REST.service.HL7Service Extends %CSP.REST
{

ClassMethod Create() As %Status
{
    #dim tSC As %Status = $$$OK

    Set data = {}.%FromJSON(%request.Content)

    #; if ('data.FacilityId || 'data.Name || 'data.Contact) {
    #;     Set %response.Status = 400
    #;     set st1 = $System.Status.Error(400,"Missing fields")
    #;     Quit st1
    #; }
    #;  FacilityId, ConnectionType, Namespace

    
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"
    Set result = []
    Set item = {}

    try {
        set facilityId = data.FacilityId
        set connectionType = data.ConnectionType
        set namespace = data.Namespace

        #; do 
        
        Set item.message = "HL7 interface created successfully"
    } catch {
        Set %response.Status = 500
        set st1 = $System.Status.Error(500,"HL7 interface failed")
        Set item.message = "HL7 interface failed"
    }

    Do result.%Push(item)

    Write result.%ToJSON()
    Quit tSC
}

}

