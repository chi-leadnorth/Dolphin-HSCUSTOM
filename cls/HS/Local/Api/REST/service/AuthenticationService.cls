Class HS.Local.Api.REST.service.AuthenticationService Extends %CSP.REST
{

/// CNR: Method Login
ClassMethod LogIn() As %Status
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
}

// NH: LogOut method

ClassMethod LogOut() As %Status
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
}

}

