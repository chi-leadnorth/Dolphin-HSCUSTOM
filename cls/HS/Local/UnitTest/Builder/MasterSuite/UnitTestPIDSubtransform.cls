Class HS.Local.UnitTest.Builder.MasterSuite.UnitTestPIDSubtransform Extends %UnitTest.TestCase
{

Method TestPID()
{
    //create a transformation class instance, input message sample to parse

    #;  set Transformation = ##class(TEAM2SANDBOXPKG.DolphinPID).%New()
     set Transformation = ##class(HS.Local.HL7.Shared.MSH).%New()

     //set Transformation = ##class(HS.LeadNorthTransforms.R01).%New()
     set InputMessage = ##class(EnsLib.HL7.Message).%New()          
     set HL7Message=     
      "MSH|^~\&|EPIC|MHS|||20110808073803|121732|ORU^R01|99273|P|2.3|||"_$C(13,10)_
      "PID|1|E2890060|E2890060^^^^EPI~0009526875^^^O^MRN||Mendez^Gonzalez-Choloma^D||19420406|M||K|6494 CLINTON COURT^^PUEBLO^SC^22954^USA^^^ORANGE|ORANGE|(868)706-8760|||S||DTA348794|497-54-8410||Rodgers^Alycia^^||"_$C(13,10)_
      "PV1||E|EDOC^ER09^09^OCM^R^^^^^^||||P676146^ZWEIFELHOFER^CHRISTEN|||E/R|||||||||309562814464|||||||||||||||||||||||||20110806|||||||V"_$C(13,10)_
      "ORC|RE|81738228^EPC|OC11US18192^EPC||P||^^^201108062114^201108062147^STAT||201108080738|P249130^ROGERS^DIANE||P676146^ZWEIFELHOFER^CHRISTEN|3010014^^^3010^^^^^OCM EDOC-EMERGENCY|(280)454-7052||"_$C(13,10)_
      "OBR|1|81738228^EPC|OC11US18192^EPC|IUS000063^US TESTICULAR^^^US TESTICULA||201108062115|||||O|||||P676146^ZWEIFELHOFER^CHRISTEN|(977)692-9023|309562814464||||201108080737||US|P||^^^201108062114^201108062147^STAT||||^Torsion||P094529^LEE^BENJAMIN^C^|P630889^DRABEK^EMMA|121732^MENDEZ TRANSCRIPTIONIST^MICHELE^^|201108062115|||||||||"_$C(13,10)_
      "NTE|1||Indication:->Torsion||"_$C(13,10)_
      "OBX|1|ST|&GDT|1|TESTICULAR ULTRASOUND: 08/06/2011||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|2|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|3|ST|&GDT|1|HISTORY:  Left testicular pain radiating to the left lower quadrant of the abdomen.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|4|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|5|ST|&GDT|1|COMPARISON: None.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|6|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|7|ST|&GDT|1|FINDINGS: The right testicle measures 4.5 cm in length. Left testicle measures 4.7 cm in length. Both testicles demonstrate normal color Doppler flow. No testicular mass lesions are seen.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|8|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|9|ST|&GDT|1|Multiple punctate echogenic foci are seen, unclear if this is artifactual or may represent testicular microlithiasis. ||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|10|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|11|ST|&GDT|1|The epididymides are unremarkable in appearance bilaterally.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)    
      
    set InputMessage=##class(EnsLib.HL7.Message).ImportFromString(HL7Message,.sc) $$$ThrowOnError(sc)
    //set tDocType=##class(EnsLib.HL7.Schema).ResolveSchemaTypeToDocType("2.3",.sc) $$$ThrowOnError(sc)     
    set status = Transformation.Transform(InputMessage,.OutputMessage)
    
    set OutputMessage.DocType="2.8:ORU_R30"
    write OutputMessage.OutputToString()
    ; Access fields and segments in the HL7 message     
    set PatientLastName = OutputMessage.GetValueAt("PID:5.1")  
    set PatientFirstName = OutputMessage.GetValueAt("PID:5.2") 
    set PatientMiddleName = OutputMessage.GetValueAt("PID:5.3")
    Set PatientDateofBirth = OutputMessage.GetValueAt("PID:7") 
    Set PatientGender = OutputMessage.GetValueAt("PID:8")
    Set PatientAddress = OutputMessage.GetValueAt("PID:11")
    Set PatientAccountNumber = OutputMessage.GetValueAt("PID:18")        
        
   ///Here we are logging in the values from the message 
    Write "PatientLastName: ", OutputMessage.GetValueAt("PID:5.1:"), !     
    Write "PatientFirstName: ", OutputMessage.GetValueAt("PID:5.2:"), !
    Write "PatientMiddleName: ", OutputMessage.GetValueAt("PID:5.3:"), !  
    Write "PatientDateofBirth: ", OutputMessage.GetValueAt("PID:7:"), !  
    Write "PatientGender: ", OutputMessage.GetValueAt("PID:8:"), ! 
    Write "PatientAddress: ", OutputMessage.GetValueAt("PID:11:"), !  
    Write "PatientAccountNumber: ", OutputMessage.GetValueAt("PID:18:"), !    
 
     ///do ##class(%UnitTest.Manager).RunTest("mytests\UnitTestPIDSubtransform", "/nodelete")
}

XData UnitTestContent
{
<text>
<?xmlversion="1.0" encoding="UTF-8"?>
<Export generator="IRIS" version="26" zv="IRIS for Windows (x86-64) 2022.1.2 (Build 574_0_22407U)" ts="2023-10-19 10:43:07">
<Class name="DOLPHIN.UnitTestPIDSubtransform">
<Super>%UnitTest.TestCase</Super>
<TimeChanged>66766,38533.1188206</TimeChanged>
<TimeCreated>66764,44249.5526742</TimeCreated>

<Method name="TestPID">
<Implementation><![CDATA[
    //create a transformation class instance, input message sample to parse

      set Transformation = ##class(TEAM2SANDBOXPKG.DolphinPID).%New()
     //set Transformation = ##class(HS.LeadNorthTransforms.R01).%New()
     set InputMessage = ##class(EnsLib.HL7.Message).%New()          
     set HL7Message=     
      "MSH|^~\&|EPIC|MHS|||20110808073803|121732|ORU^R01|99273|P|2.3|||"_$C(13,10)_
      "PID|1|E2890060|E2890060^^^^EPI~0009526875^^^O^MRN||Mendez^Gonzalez-Choloma^D||19420406|M||K|6494 CLINTON COURT^^PUEBLO^SC^22954^USA^^^ORANGE|ORANGE|(868)706-8760|||S||DTA348794|497-54-8410||Rodgers^Alycia^^||"_$C(13,10)_
      "PV1||E|EDOC^ER09^09^OCM^R^^^^^^||||P676146^ZWEIFELHOFER^CHRISTEN|||E/R|||||||||309562814464|||||||||||||||||||||||||20110806|||||||V"_$C(13,10)_
      "ORC|RE|81738228^EPC|OC11US18192^EPC||P||^^^201108062114^201108062147^STAT||201108080738|P249130^ROGERS^DIANE||P676146^ZWEIFELHOFER^CHRISTEN|3010014^^^3010^^^^^OCM EDOC-EMERGENCY|(280)454-7052||"_$C(13,10)_
      "OBR|1|81738228^EPC|OC11US18192^EPC|IUS000063^US TESTICULAR^^^US TESTICULA||201108062115|||||O|||||P676146^ZWEIFELHOFER^CHRISTEN|(977)692-9023|309562814464||||201108080737||US|P||^^^201108062114^201108062147^STAT||||^Torsion||P094529^LEE^BENJAMIN^C^|P630889^DRABEK^EMMA|121732^MENDEZ TRANSCRIPTIONIST^MICHELE^^|201108062115|||||||||"_$C(13,10)_
      "NTE|1||Indication:->Torsion||"_$C(13,10)_
      "OBX|1|ST|&GDT|1|TESTICULAR ULTRASOUND: 08/06/2011||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|2|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|3|ST|&GDT|1|HISTORY:  Left testicular pain radiating to the left lower quadrant of the abdomen.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|4|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|5|ST|&GDT|1|COMPARISON: None.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|6|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|7|ST|&GDT|1|FINDINGS: The right testicle measures 4.5 cm in length. Left testicle measures 4.7 cm in length. Both testicles demonstrate normal color Doppler flow. No testicular mass lesions are seen.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|8|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|9|ST|&GDT|1|Multiple punctate echogenic foci are seen, unclear if this is artifactual or may represent testicular microlithiasis. ||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|10|ST|&GDT|1|||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)_
      "OBX|11|ST|&GDT|1|The epididymides are unremarkable in appearance bilaterally.||||||P|||||P630889^DRABEK^EMMA"_$C(13,10)    
      
    set InputMessage=##class(EnsLib.HL7.Message).ImportFromString(HL7Message,.sc) $$$ThrowOnError(sc)
    //set tDocType=##class(EnsLib.HL7.Schema).ResolveSchemaTypeToDocType("2.3",.sc) $$$ThrowOnError(sc)     
    set status = Transformation.Transform(InputMessage,.OutputMessage)
    
    set OutputMessage.DocType="2.8:ORU_R30"
    write OutputMessage.OutputToString()
    ; Access fields and segments in the HL7 message     
    set PatientLastName = OutputMessage.GetValueAt("PID:5.1")  
    set PatientFirstName = OutputMessage.GetValueAt("PID:5.2") 
    set PatientMiddleName = OutputMessage.GetValueAt("PID:5.3")
    Set PatientDateofBirth = OutputMessage.GetValueAt("PID:7") 
    Set PatientGender = OutputMessage.GetValueAt("PID:8")
    Set PatientAddress = OutputMessage.GetValueAt("PID:11")
    Set PatientAccountNumber = OutputMessage.GetValueAt("PID:18")        
        
   ///Here we are logging in the values from the message 
    Write "PatientLastName: ", OutputMessage.GetValueAt("PID:5.1:"), !     
    Write "PatientFirstName: ", OutputMessage.GetValueAt("PID:5.2:"), !
    Write "PatientMiddleName: ", OutputMessage.GetValueAt("PID:5.3:"), !  
    Write "PatientDateofBirth: ", OutputMessage.GetValueAt("PID:7:"), !  
    Write "PatientGender: ", OutputMessage.GetValueAt("PID:8:"), ! 
    Write "PatientAddress: ", OutputMessage.GetValueAt("PID:11:"), !  
    Write "PatientAccountNumber: ", OutputMessage.GetValueAt("PID:18:"), !    
 
     ///do ##class(%UnitTest.Manager).RunTest("mytests\UnitTestPIDSubtransform", "/nodelete")
]]></Implementation>
</Method>
<XData name="PIDSegment">
</XData>
</Class>
</Export>
</text>
}

}

