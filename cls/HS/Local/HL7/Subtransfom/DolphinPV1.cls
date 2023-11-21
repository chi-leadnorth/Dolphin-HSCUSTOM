Class HS.Local.HL7.Subtransfom.DolphinPV1 Extends Ens.DataTransformDTL [ DependsOn = EnsLib.HL7.Segment ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Segment' targetClass='EnsLib.HL7.Segment' sourceDocType='2.8:PV1' targetDocType='2.8:PV1' create='new' language='objectscript' >
<assign value='source' property='target' action='set' />
<foreach property='source.{ReferringDoctor()}' key='k1' >
<assign value='source.{ReferringDoctor(k1)}' property='target.{ReferringDoctor(k1)}' action='set' key='k1' />
<break/>
</foreach>
<foreach property='source.{AdmittingDoctor()}' key='k2' >
<assign value='source.{AdmittingDoctor(k2)}' property='target.{AdmittingDoctor(k2)}' action='set' key='k2' />
<break/>
</foreach>
</transform>
}

}

