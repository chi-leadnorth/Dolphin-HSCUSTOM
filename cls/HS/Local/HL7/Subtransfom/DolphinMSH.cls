Class HS.Local.HL7.Subtransfom.DolphinMSH Extends Ens.DataTransformDTL [ DependsOn = EnsLib.HL7.Segment ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Segment' targetClass='EnsLib.HL7.Segment' sourceDocType='2.8:MSH' targetDocType='2.8:MSH' create='new' language='objectscript' >
<assign value='source' property='target' action='set' />
<assign value='..ToUpper("LeadNorthLLC")' property='target.{SendingFacility}' action='set' />
<assign value='"2.8"' property='target.{VersionID}' action='set' />
</transform>
}

}

