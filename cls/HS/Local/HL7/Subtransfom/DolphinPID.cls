Class HS.Local.HL7.Subtransfom.DolphinPID Extends Ens.DataTransformDTL [ DependsOn = EnsLib.HL7.Segment ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Segment' targetClass='EnsLib.HL7.Segment' sourceDocType='2.8:PID' targetDocType='2.8:PID' create='new' language='objectscript' >
<assign value='source' property='target' action='set' />
<if condition='source.{PatientID.1}&apos;="" ' >
<true>
<if condition='..Contains(source.{PatientID},"MR" , "MRN" , "PI" , "")' >
<true>
<assign value='source.{PatientID}' property='target.{PatientID}' action='set' />
</true>
</if>
</true>
</if>
<comment>
<annotation>PID3 and PID4 NEED REVIEW</annotation>
</comment>
<foreach property='source.{PatientName()}' key='k1' >
<assign value='source.{PatientName(k1)}' property='target.{PatientName(k1)}' action='set' key='k1' />
<break/>
</foreach>
<foreach property='source.{MothersMaidenName()}' key='k2' >
<if condition='source.{MothersMaidenName(k2)}&apos;=""' >
<true>
<assign value='source.{MothersMaidenName(k2)}' property='target.{MothersMaidenName(k2)}' action='set' />
</true>
</if>
<break/>
</foreach>
<foreach property='source.{Race()}' key='k3' >
<if condition='source.{Race(k3).Identifier}&apos;="" || source.{Race(k3).Text}&apos;=""' >
<true>
<assign value='source.{Race(k3)}' property='target.{Race(k3)}' action='set' key='k3' />
</true>
</if>
<break/>
</foreach>
<if condition='source.{MaritalStatus.Identifier}&apos;="" || source.{MaritalStatus.Text}&apos;=""' >
<true>
<assign value='source.{MaritalStatus}' property='target.{MaritalStatus}' action='set' />
</true>
</if>
<if condition='source.{Religion.Identifier}&apos;="" || source.{Religion.Text}&apos;=""' >
<true>
<assign value='source.{Religion}' property='target.{Religion}' action='set' />
</true>
</if>
<comment>
<annotation>PID18, PID19, PID20 NEED REVIEW
</annotation>
</comment>
<foreach property='source.{EthnicGroup()}' key='k4' >
<if condition='source.{EthnicGroup(k4).Identifier}&apos;="" || source.{EthnicGroup(k4).Text}&apos;=""' >
<true>
<assign value='source.{EthnicGroup(k4)}' property='target.{EthnicGroup(k4)}' action='set' key='k4' />
</true>
</if>
<break/>
</foreach>
<foreach property='source.{Citizenship(k5)}' key='k5' >
<assign value='source.{Citizenship(k5)}' property='target.{Citizenship(k5)}' action='set' key='k5' />
<break/>
</foreach>
<if condition='source.{Citizenship()}=""' >
<true>
<assign value='source.{Nationality}' property='target.{Nationality}' action='set' />
</true>
</if>
</transform>
}

}

