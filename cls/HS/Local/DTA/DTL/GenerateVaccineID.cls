Class HS.Local.DTA.DTL.GenerateVaccineID Extends Ens.DataTransformDTL [ DependsOn = EnsLib.EDI.XML.Document, Not ProcedureBlock ]
{

Parameter IGNOREMISSINGSOURCE = 0;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.EDI.XML.Document' sourceDocType='HS.SDA3:Container' targetDocType='HS.SDA3:Container' create='existing' language='objectscript' >
<annotation>Generate Vaccine IDs based on OrderItem.Code and Date Administered if it's blank. Uses the order code and the vaccine FromTime (with punctuation removed).</annotation>
<foreach property='source.{Vaccinations()}' key='k1' >
<if condition='target.{Vaccinations(k1).PlacerId}=""' >
<true>
<assign value='source.{Vaccinations(k1).OrderItem.Code}_"_"_..Strip(source.{Vaccinations(k1).Administrations(1).FromTime},"*P")' property='target.{Vaccinations(k1).PlacerId}' action='set' />
</true>
</if>
<if condition='target.{Vaccinations(k1).FillerId}=""' >
<true>
<assign value='source.{Vaccinations(k1).OrderItem.Code}_"_"_..Strip(source.{Vaccinations(k1).Administrations(1).FromTime},"*P")' property='target.{Vaccinations(k1).FillerId}' action='set' />
</true>
</if>
</foreach>
</transform>
}

}

