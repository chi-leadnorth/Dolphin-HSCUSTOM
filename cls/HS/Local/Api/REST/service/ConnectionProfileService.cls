Class HS.Local.Api.REST.service.ConnectionProfileService Extends %CSP.REST
{

ClassMethod GetAll() As %Status
{
    Set qry = "SELECT * FROM DOLPHIN_DB_ConnectionProfile"
    #dim tSC As %Status = $$$OK


    Set tStatement = ##class(%SQL.Statement).%New()  
    Set qStatus = tStatement.%Prepare(qry)
    If tSC'=1 {WRITE "%Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
    Set rset = tStatement.%Execute()
    
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Set result = []

    While rset.%Next() {
        Set item = {}
        Set item.FacilityId = rset.FacilityId
        Set item.Name = rset.Name
        Set item.Contact = rset.Contact
        Do result.%Push(item)
    }

    Write result.%ToJSON()
    Quit tSC
}

ClassMethod GetOne(id As %String) As %Status
{
    #dim tSC As %Status = $$$OK
    Set qry = "SELECT * FROM DOLPHIN_DB_ConnectionProfile WHERE FacilityId = '"_id_"'"


    Set tStatement = ##class(%SQL.Statement).%New()  
    Set qStatus = tStatement.%Prepare(qry)
    If tSC'=1 {WRITE "%Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
    Set rset = tStatement.%Execute()
    
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Set result = []

    While rset.%Next() {
        Set item = {}
        Set item.FacilityId = rset.FacilityId
        Set item.Name = rset.Name
        Set item.Contact = rset.Contact
        Do result.%Push(item)
    }

    Write result.%ToJSON()
    Quit tSC
}

ClassMethod Create() As %Status
{
    #dim tSC As %Status = $$$OK

    Set data = {}.%FromJSON(%request.Content)
    
    Set qry = "INSERT INTO DOLPHIN_DB_ConnectionProfile (FacilityId, Name, Contact) VALUES ('"_data.FacilityId_"', '"_data.Name_"', '"_data.Contact_"')"


    Set tStatement = ##class(%SQL.Statement).%New()  
    Set qStatus = tStatement.%Prepare(qry)
    If tSC'=1 {WRITE "%Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
    Set rset = tStatement.%Execute()
    
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Set result = []

    While rset.%Next() {
        Set item = {}
        Set item.message = "Item created successfully"
        Do result.%Push(item)
    }

    Write result.%ToJSON()
    Quit tSC
}

ClassMethod Update(id As %String) As %Status
{
    #dim tSC As %Status = $$$OK
    #; Set qry = "DELETE FROM DOLPHIN_DB_ConnectionProfile WHERE FacilityId = '"_id_"'"


    #; Set tStatement = ##class(%SQL.Statement).%New()  
    #; Set qStatus = tStatement.%Prepare(qry)
    #; If tSC'=1 {WRITE "%Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
    #; Set rset = tStatement.%Execute()
    
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Set result = []

    Set item = {}
    Set item.message = "This is not working yet"

    Do result.%Push(item)

    Write result.%ToJSON()
    Quit tSC
}

ClassMethod Delete(id As %String) As %Status
{
    #dim tSC As %Status = $$$OK
    Set qry = "DELETE FROM DOLPHIN_DB_ConnectionProfile WHERE FacilityId = '"_id_"'"


    Set tStatement = ##class(%SQL.Statement).%New()  
    Set qStatus = tStatement.%Prepare(qry)
    If tSC'=1 {WRITE "%Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
    Set rset = tStatement.%Execute()
    
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Set result = []

    While rset.%Next() {
        Set item = {}
        Set item.message = "Item deleted successfully"
    }

    Write result.%ToJSON()
    Quit tSC
}

}

