Class HS.Local.DTA.DTL.IgnoreExternalID Extends Ens.DataTransformDTL [ DependsOn = EnsLib.EDI.XML.Document ]
{

Parameter IGNOREMISSINGSOURCE = 0;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.EDI.XML.Document' targetClass='EnsLib.EDI.XML.Document' sourceDocType='HS.SDA3:Container' targetDocType='HS.SDA3:Container' create='existing' language='objectscript' >
<!--Original Transform: A comma separated list removes all except those listed, and never removes from patient. 
Updating to be a list of those to be removed. All will remove everything but patient. 
Blank removes none. -->
<!--Encounters-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"Encounters")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{Encounters()}' key='k1' >
<if condition='source.{Encounters(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{Encounters(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>

</if>


<!--Alerts-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"Alerts")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{Alerts()}' key='k1' >
<if condition='source.{Alerts(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{Alerts(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>


<!--AdvanceDirectives-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"AdvanceDirectives")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{AdvanceDirectives()}' key='k1' >
<if condition='source.{AdvanceDirectives(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{AdvanceDirectives(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>


<!--Allergies-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"Allergies")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{Allergies()}' key='k1' >
<if condition='source.{Allergies(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{Allergies(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>


<!--IllnessHistories-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"IllnessHistories")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{IllnessHistories()}' key='k1' >
<if condition='source.{IllnessHistories(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{IllnessHistories(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>


<!--SocialHistories-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"SocialHistories")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{SocialHistories()}' key='k1' >
<if condition='source.{SocialHistories(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{SocialHistories(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--FamilyHistories-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"FamilyHistories")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{FamilyHistories()}' key='k1' >
<if condition='source.{FamilyHistories(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{FamilyHistories(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--Guarantors-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"Guarantors")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{Guarantors()}' key='k1' >
<if condition='source.{Guarantors(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{Guarantors(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--Diagnoses-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"Diagnoses")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{Diagnoses()}' key='k1' >
<if condition='source.{Diagnoses(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{Diagnoses(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--Observations-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"Observations")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{Observations()}' key='k1' >
<if condition='source.{Observations(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{Observations(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--Problems-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"Problems")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{Problems()}' key='k1' >
<if condition='source.{Problems(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{Problems(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--PhysicalExams-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"PhysicalExams")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{PhysicalExams()}' key='k1' >
<if condition='source.{PhysicalExams(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{PhysicalExams(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--Procedures-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"Procedures")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{Procedures()}' key='k1' >
<if condition='source.{Procedures(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{Procedures(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--Documents-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"Documents")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{Documents()}' key='k1' >
<if condition='source.{Documents(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{Documents(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--LabOrders-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"LabOrders")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{LabOrders()}' key='k1' >
<if condition='source.{LabOrders(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{LabOrders(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--RadOrders-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"RadOrders")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{RadOrders()}' key='k1' >
<if condition='source.{RadOrders(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{RadOrders(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--OtherOrders-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"OtherOrders")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{OtherOrders()}' key='k1' >
<if condition='source.{OtherOrders(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{OtherOrders(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--Medications-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"Medications")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{Medications()}' key='k1' >
<if condition='source.{Medications(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{Medications(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--Vaccinations-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"Vaccinations")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{Vaccinations()}' key='k1' >
<if condition='source.{Vaccinations(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{Vaccinations(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--Appointments-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"Appointments")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{Appointments()}' key='k1' >
<if condition='source.{Appointments(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{Appointments(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--Referrals-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"Referrals")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{Referrals()}' key='k1' >
<if condition='source.{Referrals(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{Referrals(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--ClinicalRelationships-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"ClinicalRelationships")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{ClinicalRelationships()}' key='k1' >
<if condition='source.{ClinicalRelationships(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{ClinicalRelationships(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--ProgramMemberships-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"ProgramMemberships")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{ProgramMemberships()}' key='k1' >
<if condition='source.{ProgramMemberships(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{ProgramMemberships(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--MemberEnrollments-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"MemberEnrollments")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{MemberEnrollments()}' key='k1' >
<if condition='source.{MemberEnrollments(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{MemberEnrollments(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--MedicalClaims-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"MedicalClaims")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{MedicalClaims()}' key='k1' >
<if condition='source.{MedicalClaims(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{MedicalClaims(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--PharmacyClaims-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"PharmacyClaims")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{PharmacyClaims()}' key='k1' >
<if condition='source.{PharmacyClaims(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{PharmacyClaims(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--MedicalExplanationOfBenefits-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"MedicalExplanationOfBenefits")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{MedicalExplanationOfBenefits()}' key='k1' >
<if condition='source.{MedicalExplanationOfBenefits(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{MedicalExplanationOfBenefits(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--PharmacyExplanationOfBenefits-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"PharmacyExplanationOfBenefits")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{PharmacyExplanationOfBenefits()}' key='k1' >
<if condition='source.{PharmacyExplanationOfBenefits(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{PharmacyExplanationOfBenefits(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--DeviceItems-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"DeviceItems")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{DeviceItems()}' key='k1' >
<if condition='source.{DeviceItems(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{DeviceItems(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--CustomObjects-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"CustomObjects")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{CustomObjects()}' key='k1' >
<if condition='source.{CustomObjects(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{CustomObjects(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--GenomicsOrders-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"GenomicsOrders")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{GenomicsOrders()}' key='k1' >
<if condition='source.{GenomicsOrders(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{GenomicsOrders(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--CarePlans-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"CarePlans")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{CarePlans()}' key='k1' >
<if condition='source.{CarePlans(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{CarePlans(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--HealthConcerns-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"HealthConcerns")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{HealthConcerns()}' key='k1' >
<if condition='source.{HealthConcerns(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{HealthConcerns(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--Goals-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"Goals")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{Goals()}' key='k1' >
<if condition='source.{Goals(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{Goals(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--SocialDeterminants-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"SocialDeterminants")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{SocialDeterminants()}' key='k1' >
<if condition='source.{SocialDeterminants(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{SocialDeterminants(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--Tasks-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"Tasks")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{Tasks()}' key='k1' >
<if condition='source.{Tasks(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{Tasks(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>

<!--Provenances-->
<if condition='((..Contains(aux.GetAt("IgnoreExternalID"),"Provenances")) || (..Contains(aux.GetAt("IgnoreExternalID"),"All")))'>
<true>
<foreach property='source.{Provenances()}' key='k1' >
<if condition='source.{Provenances(k1).ExternalId}&apos;=""' >
<true>
<assign value='' property='target.{Provenances(k1).ExternalId}' action='remove' key='k1' />
</true>
</if>
</foreach>
</true>
</if>


</transform>
}

}

