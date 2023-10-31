Class HS.API.REST.REST.service.PipelineService Extends %CSP.REST
{

ClassMethod GetAll() As %Status
{
    Set qry = "SELECT * FROM DOLPHIN_DB_Pipeline.Details"
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
        Set item.Name = rset.Name
        Set item.SourceConnection = rset.SourceConnection
        Set item.TargetConnection = rset.TargetConnection
        Set item.Status = rset.Status
        Do result.%Push(item)
    }

    Write result.%ToJSON()
    Quit tSC
}

ClassMethod GetOne(id As %String) As %Status
{
    #dim tSC As %Status = $$$OK
    Set qry = "SELECT * FROM DOLPHIN_DB_Pipeline.Details WHERE Name = '"_id_"'"


    Set tStatement = ##class(%SQL.Statement).%New()  
    Set qStatus = tStatement.%Prepare(qry)
    If tSC'=1 {WRITE "%Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
    Set rset = tStatement.%Execute()
    
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Set result = []

    While rset.%Next() {
        Set item = {}
        Set item.Name = rset.Name
        Set item.SourceConnection = rset.SourceConnection
        Set item.TargetConnection = rset.TargetConnection
        Set item.Status = rset.Status
        Do result.%Push(item)
    }

    Write result.%ToJSON()
    Quit tSC
}

ClassMethod Create() As %Status
{
    #dim tSC As %Status = $$$OK

    Set data = {}.%FromJSON(%request.Content)

    if ('data.Name || 'data.SourceConnection || 'data.TargetConnection || 'data.Status) {
        Set %response.Status = 400
        set st1 = $System.Status.Error(400,"Missing fields")
        Quit st1
    }

    Set qry = "INSERT INTO DOLPHIN_DB_Pipeline.Details (Name, SourceConnection, TargetConnection, Status) VALUES ('"_data.Name_"', '"_data.SourceConnection_"', '"_data.TargetConnection_"', '"_data.Status_"')"


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
    #; Set qry = "DELETE FROM DOLPHIN_DB_Pipeline.Details WHERE Name = '"_id_"'"


    #; Set tStatement = ##class(%SQL.Statement).%New()  
    #; Set qStatus = tStatement.%Prepare(qry)
    #; If tSC'=1 {WRITE "%Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
    #; Set rset = tStatement.%Execute()
    
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Set result = []

    #; While rset.%Next() {
        #; Set item = {}
        #; Set item.message = "Item updated successfully"
    #; }

    Set item = {}
    Set item.message = "This is not working yet"

    Do result.%Push(item)

    Write result.%ToJSON()
    Quit tSC
}

ClassMethod Delete(id As %String) As %Status
{
    #dim tSC As %Status = $$$OK
    Set qry = "DELETE FROM DOLPHIN_DB_Pipeline.Details WHERE Name = '"_id_"'"


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

