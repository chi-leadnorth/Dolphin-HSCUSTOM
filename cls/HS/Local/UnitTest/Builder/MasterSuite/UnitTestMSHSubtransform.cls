Class HS.Local.UnitTest.Builder.MasterSuite.UnitTestMSHSubtransform Extends %UnitTest.TestCase
{

/// Creating the first method to test
Method TestMSH()
{
    //create a transformation class instance, input message sample

  //set Transformation = ##class(TEAM2SANDBOXPKG.DolphinMSH).%New()
   set Transformation = ##class(HS.Local.HL7.Shared.MSH).%New()
    set Transformation = ##class(HS.LeadNorthTransforms.R01).%New()
     set InputMessage = ##class(EnsLib.HL7.Message).%New() 
     //set InputMessage = ##class(EnsLib.HL7.Segment).%New() 
    #;  set InputMessage.MessageType="ORU_R01" 
    #;  set InputMessage.DocType="2.8:ADT_A01"         
     set HL7Message=     
      "MSH|^~\&|EPIC|MHS|||20110808073803|121732|ORU^R01|99273|P|2.3|||"_$C(13,10)_
      "PID|1|E2890060|E2890060^^^^EPI~0009526875^^^O^MRN||MENDEZ^ALVIN||19420406|M||K|6494 CLINTON COURT^^PUEBLO^SC^22954^USA^^^ORANGE|ORANGE|(868)706-8760|||S||RT-348794|497-54-8410||Rodgers^Alycia^^||"_$C(13,10)_
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
    
    #; set tMSH=HL7Message.getSegmentByIndex(1)
    #; set tName=tMSH.GetValueAt(9,":_~\&")
    #; set tDocType=##class(EnsLib.HL7.Schema).ResolveSchemaTypeToDocType(..MessageSchemaCategory,tName, tSC, ..DocTypeResolution) $$$ThrowOnError(tSC)
        
    set status = Transformation.Transform(InputMessage,.OutputMessage)
    
    set OutputMessage.DocType="2.8:ORU_R01"
    //set OutputMessage.MessageType = "ORU"
    write OutputMessage.OutputToString()
    ; Access fields and segments in the HL7 message     
    set SendingApplication = OutputMessage.GetValueAt("MSH:3")
    set SendingFacility = OutputMessage.GetValueAt("MSH:4")    
    set ReceivingApplication = OutputMessage.GetValueAt("MSH:5", "|") 
    set ReceivingFacility = OutputMessage.GetValueAt("MSH:6", "|") 
    set DateTimeofMessage = OutputMessage.GetValueAt("MSH:7", "|")
    set MessageType = OutputMessage.GetValueAt("MSH:9", "|")
    set MessageControllerID = OutputMessage.GetValueAt("MSH:10", "|")    
        
   ///Here we are logging in the values from the message 
    Write "SendingApplication: ", OutputMessage.GetValueAt("MSH:3:"), !     
    Write "DateTimeofMessage: ", OutputMessage.GetValueAt("MSH:7:"), !
    Write "MessageType: ", OutputMessage.GetValueAt("MSH:9:"), !  
    Write "MessageContollerID: ", OutputMessage.GetValueAt("MSH:10:"), !      

     /// Write the Sending Facility

    write $$$AssertEquals("LEADNORTHLLC", SendingFacility)
    write $$$AssertEquals("CLOVERLEAF", ReceivingApplication)
    write $$$AssertEquals("DTA-PHARMACY", ReceivingFacility)
      
     
     ///do ##class(%UnitTest.Manager).RunTest("mytests\UnitTestMSHSubtransform", "/nodelete")
}

XData UnitTestContent
{
<text>
<?xmlversion="1.0" encoding="UTF-8"?>
<Export generator="IRIS" version="26" zv="IRIS for Windows (x86-64) 2022.1.2 (Build 574_0_22407U)" ts="2023-10-19 09:39:49">
<Class name="DOLPHIN.UnitTestMSHSubtransform">
<Super>%UnitTest.TestCase</Super>
<TimeChanged>66766,34663.3172064</TimeChanged>
<TimeCreated>66764,41853.4245155</TimeCreated>

<Method name="TestMSH">
<Description>
Creating the first method to test</Description>
<Implementation><![CDATA[
    //create a transformation class instance, input message sample

   set Transformation = ##class(TEAM2SANDBOXPKG.DolphinMSH).%New()
     //set Transformation = ##class(HS.LeadNorthTransforms.R01).%New()
     set InputMessage = ##class(EnsLib.HL7.Message).%New() 
     //set InputMessage = ##class(EnsLib.HL7.Segment).%New() 
    #;  set InputMessage.MessageType="ORU_R01" 
    #;  set InputMessage.DocType="2.8:ADT_A01"         
     set HL7Message=     
      "MSH|^~\&|EPIC|MHS|||20110808073803|121732|ORU^R01|99273|P|2.3|||"_$C(13,10)_
      "PID|1|E2890060|E2890060^^^^EPI~0009526875^^^O^MRN||MENDEZ^ALVIN||19420406|M||K|6494 CLINTON COURT^^PUEBLO^SC^22954^USA^^^ORANGE|ORANGE|(868)706-8760|||S||RT-348794|497-54-8410||Rodgers^Alycia^^||"_$C(13,10)_
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
    
    set OutputMessage.DocType="2.8:ORU_R01"
    //set OutputMessage.MessageType = "ORU"
    write OutputMessage.OutputToString()
    ; Access fields and segments in the HL7 message     
    set SendingApplication = OutputMessage.GetValueAt("MSH:3")
    set SendingFacility = OutputMessage.GetValueAt("MSH:4")    
    set ReceivingApplication = OutputMessage.GetValueAt("MSH:5", "|") 
    set ReceivingFacility = OutputMessage.GetValueAt("MSH:6", "|") 
    set DateTimeofMessage = OutputMessage.GetValueAt("MSH:7", "|")
    set MessageType = OutputMessage.GetValueAt("MSH:9", "|")
    set MessageControllerID = OutputMessage.GetValueAt("MSH:10", "|")    
        
   ///Here we are logging in the values from the message 
    Write "SendingApplication: ", OutputMessage.GetValueAt("MSH:3:"), !     
    Write "DateTimeofMessage: ", OutputMessage.GetValueAt("MSH:7:"), !
    Write "MessageType: ", OutputMessage.GetValueAt("MSH:9:"), !  
    Write "MessageContollerID: ", OutputMessage.GetValueAt("MSH:10:"), !      

     /// Write the Sending Facility
    write $$$AssertEquals("LEADNORTHLLC", SendingFacility)
    write $$$AssertEquals("CLOVERLEAF", ReceivingApplication)
    write $$$AssertEquals("DTA-PHARMACY", ReceivingFacility)
      
     
     ///do ##class(%UnitTest.Manager).RunTest("mytests\UnitTestMSHSubtransform", "/nodelete")
  ]]></Implementation>
  </Method>
  <XData name="MSHSegment">
  </XData>
  </Class>
  </Export>
  </text>
}

}

