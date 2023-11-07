Class HS.Local.ZAUTHENTICATE Extends HS.Util.IAuthenticate [ Abstract ]
{

ClassMethod OnBeforeAA(ServiceName, ByRef Namespace, ByRef Username, ByRef password) As %Status
{
	Quit $$$OK
   //Quit $$$OK
}

ClassMethod OnAfterAA(ServiceName, Namespace, Username, password, tSC, ByRef tResponse) As %Status
{
	Quit $$$OK
}

ClassMethod OnAfterProperties(ServiceName, Namespace, ByRef tResponse, ByRef Properties) As %Status
{
	Quit $$$OK
}

ClassMethod OnBeforeValidatePW(OldPassword, Username, LoginToken, ByRef NewPassword, ByRef LoginDomain, ByRef LoginUser) As %Status
{
	Quit $$$OK
}

ClassMethod OnBeforeUpdatePW(LoginDomain, LoginUser, UserName, ByRef NewPassword, ByRef pLoginToken, ByRef OldPassword) As %Status
{
	Quit $$$OK
}

ClassMethod OnGetCredentials(ByRef Username, ByRef Password, ServiceName, Namespace, ByRef Credentials) As %Status
{
 /* This entry point is called whenever Delegated authentication for a service is enabled
 which requires that a username and password be entered. 
 
 This entry point is called before the user is prompted for a username and password. Instead
 of getting a username and password from the user, the username and password are assigned 
 by this entry point and returned to the caller. The username and password returned are
 then authenticated in the normal manner as if the user entered them in the browser or terminal.
 
 The username and password returned from this entry point can be obtained by any mechanism the
 user chooses; It could be obtained from a global, an external DLL or LDAP call, or simply set right
 in the routine. If the service is a terminal connection, the user could even do their own
 prompting for the username/pw combination. (Note that a CSP application would traditionally have
 their own custom CSP login page defined if they wanted to do their own prompting.)
 
 If an error status is returned by this entry point, then the error is logged in the audit log,
 and the user is denied access to the system. The one exception to this is if the error status
 
 $SYSTEM.Status.Error($$$GetCredentialsFailed)
 
 is returned, then the normal username/password prompting will be executed.
 
 If a success status is returned by the entry point, but the variables Username and Password
 are not set, then the user will be denied access to the system, and an error written to the
 audit log.
 
 If a success status is returned along with the Username and Password, the Username 
 and Password are then validated using Delegated authentication for the Service. If the
 Username and Password fail authentication, then the user will be denied access, and the error
 logged to the audit log.
 
 If the call to this entry point fails because it is either not defined, or there is a PARAMETER 
 error, or the ZAUTHENTICATE routine does not exist, or there is an unhandled error in the
 entry point, then then the normal username/password prompting will be executed.
 
 A common use of this mechanism would be to set up your services to use Delegated Authentication,
 then set some Username and Password here, and then in the ZAUTHENTICATE Delegated authentication 
 entry point above, set the $roles for the process. 
 
 Parameters:
  ServiceName - Name of the service the user is connecting to. This 
                could be %Service_Console, %Service_Bindings, etc.
  Namespace - Namespace specified as part of the connection string when connecting
              via the Bindings service, or through a CSP application. If neither of these, then
              passed in as "".
  Username (by reference) - Username returned by the function to authenticate against
           the system security tables.
  Password (by reference) - Password returned by the function to authenticate against
           the system security tables.
  Credentials (by reference) - Not currently used, reserved for future use.
 
 Return values:
  Success - $SYSTEM.Status.OK() - Username/Password combination returned
  Failure - $SYSTEM.Status.Error($$$ERRORCODE,Param1,...) - Username/Password combination 
            not returned.
  */
	Quit $SYSTEM.Status.Error(1419 /*$$$GetCredentialsFailed*/)  // By default, we allow the system to do its normal Username/Password prompting.
}

ClassMethod OnSendTwoFactorToken(Username, ServiceName, Namespace, Application, ByRef Credentials, ByRef SecurityToken, ByRef TwoFactorTimeout, ByRef UserPhoneNumber) As %Status
{
 /* This function creates a new security token, and sends it to the mobile phone of 
 the user. The security token is returned to the caller along with the two-factor timeout duration
 and User's phone number. This function is always called when Two Factor Authentication is enabled
 for a service.
 Input parameters:
    Username - name of user being sent the security token
    ServiceName - Name of the service the user is logging in on
    Namespace - namespace the user will be in
    Application - CSP Application or routine the user will be running
    Credentials - Not currently used
    SecurityToken - (byRef) the sent security token
    TwoFactorTimeout - (byRef) The timeout duration before the security token expires
    PhoneNumber - (byRef) Phone number of the user. A value for this must be returned, or ""
 Return value:  Status
 
 Notes: This sample SendTwoFactorToken() code will send the same message to a mobile phone as the
 system default. The parameters Username, Servicename, Namespace, and Application may be examined, 
 and their values used to modify the message sent to the mobile phone.
 If the service is %Service_WebGateway, the Application will be in the form "/csp/appname/". If the service is
 %Service_Console or %Service_Telnet, the Application will be in the form "Tag^Routine". If the service 
 is %Service_Bindings, then the application will be an executable name like "ODBC.EXE".
 
 This code is called during login while the process has the %All privilege, and is in the %SYS namespace.
 $username is set to the username the user has entered, and the password has been validated.
 */
 New $Namespace
 Set $Namespace="%SYS"
 s $zt="Error"
 //We must own the %Admin_Security:Use resource to run this
 i '$SYSTEM.Security.Check($$$AdminSecureResourceName,$$$PermUseName) q $$$ERROR($$$OperationRequires,$$$AdminSecureResourceName_":"_$$$PermUseName)
 // First get the user properties, and the phone provider info , and make sure they are set to something valid
 // Note that this was set into the user record by the Properties() array returned by the ZAUTHENTICATE record above.
 s Status=##Class(Security.Users).Get(Username,.UserProperties)
 i Status'=$SYSTEM.Status.OK() q Status
 i UserProperties("PhoneNumber")="" quit $$$ERROR($$$TwoFactUserNotConfig,Username)
 // Make sure the phone number is returned
 s UserPhoneNumber=UserProperties("PhoneNumber")
 i UserProperties("PhoneProvider")="" quit $$$ERROR($$$TwoFactUserNotConfig,Username)	
 s Status=##class(%SYS.PhoneProviders).Get(UserProperties("PhoneProvider"),.ProviderProperties)
 i Status'=$SYSTEM.Status.OK() q Status
 s Status=##Class(Security.System).Get("SYSTEM",.SystemProperties)
 i Status'=$SYSTEM.Status.OK() q Status
 // Now set up the SMTP authentication
 s SMTP=##class(%Net.SMTP).%New()
 i '$isobject(SMTP) q %objlasterror
 i $l(SystemProperties("SMTPUsername"))&&$l(SystemProperties("SMTPPassword")) {
	s Auth=##class(%Net.Authenticator).%New()
	i '$isobject(Auth) q %objlasterror
	s Auth.UserName=SystemProperties("SMTPUsername")
	s Auth.Password=SystemProperties("SMTPPassword")
	s SMTP.authenticator=Auth
 }
 s SMTP.smtpserver=SystemProperties("SMTPServer")
 s Message=##class(%Net.MailMessage).%New()
 i '$isobject(Message) q %objlasterror
 s Message.From=SystemProperties("TwoFactorFrom")
 d Message.To.Insert(UserProperties("PhoneNumber")_"@"_ProviderProperties("SMSGateway"))
 s SecurityToken=$System.Encryption.GenCryptToken()
 s TwoFactorTimeout=SystemProperties("TwoFactorTimeout")
 s Message.Charset="iso-8859-1"
 // Here is where you may want to test the passed parameters, and modify the
 // text message sent to the user. For example
 // i Namespace="BANKING" {
 // 	s TwoFactorTimeout=600 ; Set timeout to 10 minutes
 //		s Message.Subject=""
 //		s Text="Bank of MyBank Security Token is: "_SecurityToken
 // 	s Text=Text_" Your Security Token is good for "_(TwoFactorTimeout/60)_" minutes. "
 // 	s Text=Text_"Do not respond to this message."
 // 	d Message.TextData.Write(Text)
 // } 
 s Message.Subject="Security Token"
 d Message.TextData.Write(SecurityToken)
 q SMTP.Send(Message)
Error //Handle any COS errors here
 //Reset error trap to avoid infinite loop
 s $zt=""
 //Return the generalized COS error message #5002
 q $SYSTEM.Status.Error(5002,$ze)
}

ClassMethod OnBeforeForgotPassword(Namespace, ServiceName, SessionId, ByRef Username, ByRef Password) As %Status
{
	Quit $$$OK
}

ClassMethod OnAfterForgotPassword(ServiceName, Username, tSC, ByRef pErrText) As %Status
{
	Set:$$$ISERR(tSC) pErrText= $System.Status.GetErrorText(tSC)
	Quit $$$OK
}

/// Callback to allow customers to intercept calls to the main ^ZAUTHENTICATE entry point,
/// which includes the arguments to that entry point.
/// If the main ^ZAUTHENTICATE logic for HealthShare should NOT be executed,
/// set <var>AuthenticationDelegated</var> to 1, and ensure that all of the values
/// in <var>Properties</var> are correctly initialized.
ClassMethod OnZAUTHENTICATE(ByRef AuthenticationDelegated As %Boolean = 0, ServiceName As %String, Namespace As %String, Username As %String, Password As %String, ByRef Credentials, ByRef Properties) As %Status
{
	Set AuthenticationDelegated = 0
	Quit $$$OK
}

}

