Class HS.Custom.DolphinUnitTest Extends %UnitTest.TestCase
{

Method TestMethodName() As %Status
{
    Set sc = $$$OK
    // do something
    Return sc
   //What can I do to make this work?
}

/// XData HL7 Inbound Test Data
XData HL7InboundTestData
{
<text>
MSH|^~\&|HL7LabIn|MMC|SCM||20101129083613||ORU^R01|20103330003677|P|2.3
PID||MTN5698|70158365^^^MRN||WEISS^MALVINA^""|^^""|19290323|F|^^||700 Timber Oaks Lane Apt 50^Arlingotn^TX^76010^^^^^^^^^^|||||||501275849
PV1||IP|PMCU^G726^01^MMC||||00544^FUCHS^MICHAEL^|^||||||||||IP|501275849^^^Account|||||||||||||||||||||||||201011220000|
ORC|RE|001ZNZ153^SCM||||||||||00544^&^MICHAEL^^^^^^^^^^^^^&
OBR||001ZNZ153^SCM||URC^URINE CULTURE^LAB|||20101126155900|||^|N|||20101127114300||00544^FUCHS^MICHAEL^||||F9328||||MC|F||^^^^^RO|^~^~^|||
OBX|1|ST|SDES^SPECIMEN DESCRIPTION^LAB||URINE  URINE BLADDER||||||F|||201011271143|MC^MICROBIOLOGY|1165^AMAYA^ALICIA|
OBX|2|ST|SREQ^SPECIAL REQUESTS^LAB||NONE||||||F|||201011271143|MC^MICROBIOLOGY|1165^AMAYA^ALICIA|

</text>
}

}

