Include HS.Common

Class HS.Local.Util.CCDHelper
{

/// This method takes a coded entry type (e.g., "TypeCode", "FormatCode", etc)
/// as input and returns a default CodedValue object for MHD for the type.
/// The default value is stored in the Configuration Registry.  The key name
/// is "\IHE\Default\" plus the coded type.  The value is expected to be
/// the default Code and the default Scheme, separated by caret (^).
ClassMethod GetCodedEntryDefaultValue(pCodeType As %String, ByRef pCodedValue As HS.IHE.XDSb.Types.CodedValue) As %Status
{
	Set tSC = $$$OK
	
	Try {
		Set pCodedValue = ""
		Set tKey = "\IHE\Default\"_pCodeType
		Set tValue = ##class(HS.Registry.Config).GetKeyValue(tKey)
		If tValue'="" {
			Set tCode = $Piece(tValue, "^", 1)
			Set tScheme = $Piece(tValue, "^", 2)
			Set tDescription = $Piece(tValue, "^", 3)
            /*
        	Set tStatement = ##class(%SQL.Statement).%New()
			Set tStatement.%SelectMode=2
			Set tQuery = "SELECT Description FROM HS_IHE.CodedEntry WHERE CodeType=? AND Code=? AND CodingScheme=?"
			Set tStatus = tStatement.%Prepare(tQuery)
			Set tResultSet = tStatement.%Execute(pCodeType, tCode, tScheme)
			While tResultSet.%Next() {
				Set tDescription = tResultSet.Description
			}
            */
			Set pCodedValue = ##class(HS.IHE.XDSb.Types.CodedValue).%New(tCode, tScheme, tDescription)
		}
	} Catch eException {
		Set tSC = eException.AsStatus()
	}
		
	Quit tSC
}

}

