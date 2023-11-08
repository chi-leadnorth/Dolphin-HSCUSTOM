Class HS.Local.DTA.DTL.DeleteVacEncounter Extends Ens.DataTransformDTL [ DependsOn = EnsLib.EDI.XML.Document, Not ProcedureBlock ]
{

Parameter IGNOREMISSINGSOURCE = 0;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.EDI.XML.Document' sourceDocType='HS.SDA3:Container' targetDocType='HS.SDA3:Container' create='existing' language='objectscript' >
<annotation>Removes encounter numbers from vaccines.</annotation>
<foreach property='source.{Vaccinations()}' key='k1' >
<assign value='""' property='target.{Vaccinations(k1).EncounterNumber}' action='set' key='k1' />
</foreach>
</transform>
}

}

