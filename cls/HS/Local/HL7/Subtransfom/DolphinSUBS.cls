Class HS.Local.HL7.Subtransfom.DolphinSUBS Extends Ens.DataTransformDTL [ DependsOn = EnsLib.HL7.Message ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Message' targetClass='EnsLib.HL7.Message' sourceDocType='2.8:ORU_R01' targetDocType='2.8:ORU_R01' create='new' language='objectscript' >
<assign value='source' property='target' action='set' />
<subtransform class='TEAM2SANDBOXPKG.DolphinMSH' targetObj='target.{MSH}' sourceObj='source.{MSH}' />
<assign value='source.{SFT()}' property='target.{SFT()}' action='set' />
<assign value='source.{UAC}' property='target.{UAC}' action='set' />
<assign value='source.{PIDgrpgrp()}' property='target.{PIDgrpgrp()}' action='set' />
<subtransform class='TEAM2SANDBOXPKG.DolphinPID' targetObj='target.{PIDgrpgrp().PIDgrp.PID}' sourceObj='source.{PIDgrpgrp().PIDgrp.PID}' />
<if condition='source.{PIDgrpgrp().PIDgrp.PID:LastUpdateFacility}=""' >
<true>
<assign value='target.{MSH:SendingFacility}' property='target.{PIDgrpgrp().PIDgrp.PID:LastUpdateFacility}' action='set' />
</true>
</if>
<assign value='source.{PIDgrpgrp().PIDgrp.PV1grp.PV1:VisitNumber}' property='target.{PIDgrpgrp().PIDgrp.PID:PatientAccountNumber}' action='set' />
<subtransform class='TEAM2SANDBOXPKG.DolphinPV1' targetObj='target.{PIDgrpgrp().PIDgrp.PV1grp.PV1}' sourceObj='source.{PIDgrpgrp().PIDgrp.PV1grp.PV1}' />
<if condition='source.{PIDgrpgrp().PIDgrp.PV1grp.PV1:HospitalService}=""' >
<true>
<assign value='target.{MSH:SendingFacility}' property='target.{PIDgrpgrp().PIDgrp.PV1grp.PV1:HospitalService}' action='set' />
</true>
</if>
<assign value='source.{PIDgrpgrp().ORCgrpgrp()}' property='target.{PIDgrpgrp().ORCgrpgrp()}' action='set' />
<assign value='source.{DSC}' property='target.{DSC}' action='set' />
</transform>
}

}

