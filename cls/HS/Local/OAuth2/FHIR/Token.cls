Class HS.Local.OAuth2.FHIR.Token
{

/// This class method is called from HS.ODS.FHIR.OAuth2Token. It is a hook that facilitates
/// customizing processing of token introspection that would otherwise be handled by base
/// product logic in <class>HS.FHIRServer.Util.OAuth2Token</class>.<br>
/// <br>
/// When implemented, this method MUST return pJWTObj as a JSON object that holds information
/// about the specified access token (pTokenString).<br>
/// <br>
/// RFC 7762 (https://datatracker.ietf.org/doc/html/rfc7662#section-2.2) states 'active' as a
/// REQUIRED property for the returned object. 'active' is a boolean that indicates whether
/// the token is well-formed, known by the server (if an introspection endpoint is being used),
/// and not expired. RFC 7662 lists "scope" as OPTIONAL. However, for FHIRServer processing
/// it is REQUIRED and must be included in pJWTObj.<br>
/// <br>
/// When returned, pJWTObj MUST hold the token scopes in the 'scope' property, as a space-delimited
/// string. If the tokens being handled by this class are expected to hold scopes in an alternate
/// property and/or in an alternate format, you may need to override this method to ensure that the
/// scopes are moved and/or reformatted into the 'scope' property. Base product logic handles only
/// one common alternate scenario, where the token object scopes are found in property 'scp', as
/// either a JSON array or space-delimited string. Other alternate scenarios must be handled via
/// override of this method.<br>
/// <br>
/// @API.Method<br>
/// @API.Overrideable<br>
/// @Argument	pOAuthClient OAuth 2.0 Client name, as defined in System Administration > Security > OAuth 2.0 > Client.<br>
/// @Argument	pTokenString Access token string.<br>
/// @Output		pJWTObj JSON object that holds information about the token.<br>
/// @Return		%Status return value.
ClassMethod GetIntrospection(pOAuthClient As %String, pTokenString As %String, ByRef pJWTObj) As %Status
{
	Return $$$ERROR($$$NotImplemented)
}

}

