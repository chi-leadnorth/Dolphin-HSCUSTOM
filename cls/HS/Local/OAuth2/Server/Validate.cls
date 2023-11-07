/// Custom class to implement available callbacks in super class. <br />
/// ONLY methods marked with @API.Overrideable in the super class can be overridden. <br />
/// This SHOULD NEVER have methods present in it on a new install. ALL methods
/// MUST only be defined in the super class. This is so that on upgrades, changes
/// to methods can be reflected in the super class as code in HS.Local classes
/// is left unchanged. <br />
Class HS.Local.OAuth2.Server.Validate Extends HS.OAuth2.Server.Custom.Validate
{

}

