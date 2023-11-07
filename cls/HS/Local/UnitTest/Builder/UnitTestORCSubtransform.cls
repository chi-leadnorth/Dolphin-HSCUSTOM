Class HS.Local.Unit.DOLPHIN.MasterSuite.UnitTestORCSubtransform Extends %UnitTest.TestCase
{

/// Creating the first method to test
Method TestORCSegment()
{

    //create a transformation class instance
     set Transformation = ##class(HS.LeadNorthTransforms.R01).%New()
     //set Transformation = ##class(TEAM2SANDBOXPKG.DolphinSUBS).%New()

   // sample HL7 Input message
     set InputMessage = ##class(EnsLib.HL7.Message).%New()
         
     set HL7Message=     
      "MSH|^~\&|EPIC|MHS|||20110808073803|121732|ORU^R01|99273|P|2.3|||"_$C(13,10)_
      "PID|1|E2890060|E2890060^^^^EPI~0009526875^^^O^MRN||MENDEZ^ALVIN||19420406|M||K|6494 CLINTON COURT^^PUEBLO^SC^22954^USA^^^ORANGE|ORANGE|(868)706-8760|||S||RT-348794|497-54-8410||Rodgers^Alycia^^||"_$C(13,10)_
      "PV1||E|EDOC^ER09^09^OCM^R^^^^^^||||P676146^ZWEIFELHOFER^CHRISTEN|||E/R|||||||||309562814464|||||||||||||||||||||||||20110806|||||||V"_$C(13,10)_
      "ORC|SC|81738228^EPC|OC11US18192^EPC||Exam Began||^^^201108062114^201108062147^STAT||201108080738|P249130^ROGERS^DIANE||P676146^ZWEIFELHOFER^CHRISTEN|3010014^^^3010^^^^^OCM EDOC-EMERGENCY|(280)454-7052||"_$C(13,10)_
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
    
    set status = Transformation.Transform(InputMessage,.OutputMessage)
     
    set OutputMessage.DocType="2.8:ORU_R30"

      //set InputFilemsg.DocType="2.8:ADT_A01"
      //set OutputMessage.DocType="LeadNorthLLC_2.8:ORU_R01"

    write OutputMessage.OutputToString()
    ; Access fields and segments in the HL7 message     
    set OrderControl = OutputMessage.GetValueAt("ORC:1", "|")
    set PlaceOrderNumber = OutputMessage.GetValueAt("ORC:2", "|")   
    set FillerOrderNumber = OutputMessage.GetValueAt("ORC:3", "|")     
    set OrderType = OutputMessage.GetValueAt("ORC:5", "|")  
    set DateofTransaction = OutputMessage.GetValueAt("ORC:9", "|")
    set EnteredBy = OutputMessage.GetValueAt("ORC:10", "|") 
    set OrderingProvider = OutputMessage.GetValueAt("ORC:12", "|") 
          
        
   ///Here we are logging in the values from the message 
    Write "OrderControl: ", OutputMessage.GetValueAt("ORC:1"), !
    Write "PlaceOrderNumber: ", OutputMessage.GetValueAt("ORC:2"), !
    Write "FillerOrderNumber: ", OutputMessage.GetValueAt("ORC:3"), !
    Write "OrderType: ", OutputMessage.GetValueAt("ORC:5"), !
    Write "DateofTransaction: ", OutputMessage.GetValueAt("ORC:9"), !
    Write "EnteredBy: ", OutputMessage.GetValueAt("ORC:10"), !
    Write "OrderingProvider: ", OutputMessage.GetValueAt("ORC:12"), !


     write $$$AssertEquals("SC", OrderControl)
     write $$$AssertEquals("Exam Began", OrderType)
    
     ///do ##class(%UnitTest.Manager).RunTest("mytests\UnitTestORCSubtransform", "/nodelete")
}

XData UnitTestContent
{
<text>
<?xmlversion="1.0" encoding="UTF-8"?>
<Export generator="IRIS" version="26" zv="IRIS for Windows (x86-64) 2022.1.2 (Build 574_0_22407U)" ts="2023-10-19 11:16:51">
<Class name="DOLPHIN.UnitTestORCSubtransform">
<Super>%UnitTest.TestCase</Super>
<TimeChanged>66766,40536.3179781</TimeChanged>
<TimeCreated>66764,44374.8256578</TimeCreated>

<Method name="TestORCSegment">
<Description>
Creating the first method to test</Description>
<Implementation><![CDATA[

    //create a transformation class instance
     set Transformation = ##class(HS.LeadNorthTransforms.R01).%New()
     //set Transformation = ##class(TEAM2SANDBOXPKG.DolphinSUBS).%New()

   // sample HL7 Input message
     set InputMessage = ##class(EnsLib.HL7.Message).%New()
         
     set HL7Message=     
      "MSH|^~\&|EPIC|MHS|||20110808073803|121732|ORU^R01|99273|P|2.3|||"_$C(13,10)_
      "PID|1|E2890060|E2890060^^^^EPI~0009526875^^^O^MRN||MENDEZ^ALVIN||19420406|M||K|6494 CLINTON COURT^^PUEBLO^SC^22954^USA^^^ORANGE|ORANGE|(868)706-8760|||S||RT-348794|497-54-8410||Rodgers^Alycia^^||"_$C(13,10)_
      "PV1||E|EDOC^ER09^09^OCM^R^^^^^^||||P676146^ZWEIFELHOFER^CHRISTEN|||E/R|||||||||309562814464|||||||||||||||||||||||||20110806|||||||V"_$C(13,10)_
      "ORC|SC|81738228^EPC|OC11US18192^EPC||Exam Began||^^^201108062114^201108062147^STAT||201108080738|P249130^ROGERS^DIANE||P676146^ZWEIFELHOFER^CHRISTEN|3010014^^^3010^^^^^OCM EDOC-EMERGENCY|(280)454-7052||"_$C(13,10)_
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
    
    set status = Transformation.Transform(InputMessage,.OutputMessage)
     
    set OutputMessage.DocType="2.8:ORU_R30"

      //set InputFilemsg.DocType="2.8:ADT_A01"
      //set OutputMessage.DocType="LeadNorthLLC_2.8:ORU_R01"

    write OutputMessage.OutputToString()
    ; Access fields and segments in the HL7 message     
    set OrderControl = OutputMessage.GetValueAt("ORC:1", "|")
    set PlaceOrderNumber = OutputMessage.GetValueAt("ORC:2", "|")   
    set FillerOrderNumber = OutputMessage.GetValueAt("ORC:3", "|")     
    set OrderType = OutputMessage.GetValueAt("ORC:5", "|")  
    set DateofTransaction = OutputMessage.GetValueAt("ORC:9", "|")
    set EnteredBy = OutputMessage.GetValueAt("ORC:10", "|") 
    set OrderingProvider = OutputMessage.GetValueAt("ORC:12", "|") 
          
        
   ///Here we are logging in the values from the message 
    Write "OrderControl: ", OutputMessage.GetValueAt("ORC:1"), !
    Write "PlaceOrderNumber: ", OutputMessage.GetValueAt("ORC:2"), !
    Write "FillerOrderNumber: ", OutputMessage.GetValueAt("ORC:3"), !
    Write "OrderType: ", OutputMessage.GetValueAt("ORC:5"), !
    Write "DateofTransaction: ", OutputMessage.GetValueAt("ORC:9"), !
    Write "EnteredBy: ", OutputMessage.GetValueAt("ORC:10"), !
    Write "OrderingProvider: ", OutputMessage.GetValueAt("ORC:12"), !


     write $$$AssertEquals("SC", OrderControl)
     write $$$AssertEquals("Exam Began", OrderType)
    
     ///do ##class(%UnitTest.Manager).RunTest("mytests\UnitTestORCSubtransform", "/nodelete")
]]></Implementation>
</Method>
<XData name="ORCSegment">
</XData>
</Class>
</Export>
 </text>
}

}

