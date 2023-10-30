Class HS.API.REST.REST.service.ConnectionDetailsService Extends %CSP.REST
{

ClassMethod GetAll() As %Status
{
    Set qry = "SELECT * FROM DOLPHIN_DB_Connection.Details"
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
        Set item.ConnectionName = rset.ConnectionName
        Set item.HostName = rset.HostName
        Set item.Port = rset.Port
        Set item.InputDirectory = rset.InputDirectory
        Set item.FileName = rset.FileName
        Do result.%Push(item)
    }

    Write result.%ToJSON()
    Quit tSC
}

ClassMethod GetOne(id As %String) As %Status
{
    #dim tSC As %Status = $$$OK
    Set qry = "SELECT * FROM DOLPHIN_DB_Connection.Details WHERE ConnectionName = '"_id_"'"


    Set tStatement = ##class(%SQL.Statement).%New()  
    Set qStatus = tStatement.%Prepare(qry)
    If tSC'=1 {WRITE "%Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
    Set rset = tStatement.%Execute()
    
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Set result = []

    While rset.%Next() {
        Set item = {}
        Set item.ConnectionName = rset.ConnectionName
        Set item.HostName = rset.HostName
        Set item.Port = rset.Port
        Set item.InputDirectory = rset.InputDirectory
        Set item.FileName = rset.FileName
        Do result.%Push(item)
    }

    Write result.%ToJSON()
    Quit tSC
}

ClassMethod Create() As %Status
{
    #dim tSC As %Status = $$$OK

    Set data = {}.%FromJSON(%request.Content)
    
    if ('data.ConnectionName || 'data.HostName || 'data.Port || 'data.InputDirectory || 'data.FileName) {
        Set %response.Status = 400
        set st1 = $System.Status.Error(400,"Missing fields")
        Quit st1
    }
    
    Set qry = "INSERT INTO DOLPHIN_DB_Connection.Details (ConnectionName, HostName, Port, InputDirectory, FileName) VALUES ('"_data.ConnectionName_"', '"_data.HostName_"', "_data.Port_", '"_data.InputDirectory_"', '"_data.FileName_"')"


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
    #; Set qry = "DELETE FROM DOLPHIN_DB_Connection.Details WHERE ConnectionName = '"_id_"'"


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
    Set qry = "DELETE FROM DOLPHIN_DB_Connection.Details WHERE ConnectionName = '"_id_"'"


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

