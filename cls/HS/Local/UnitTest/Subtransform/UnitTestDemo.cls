Class HS.Local.Unit.DOLPHIN.UnitTestClasses.UnitTestDemo Extends %UnitTest.TestCase
{

/// /Class DOLPHIN.UnitTestDemo Extends (%Library.Persistent, %RegisteredObject, %UnitTest.TestCase)
/// Description
/// Creating the first method to test
Method TestORUTransformations()
{

    //create a transformation class instance
     //set Transformation = ##class(HS.LeadNorthTransforms.R01).%New()
     set Transformation = ##class(TEAM2SANDBOXPKG.DolphinSUBS).%New()

   // sample HL7 Input message
     set InputMessage = ##class(EnsLib.HL7.Message).%New()
     
    //set InputMessage.DocType = "2.3:ORU_R01" 
   //Set InputMessage.MessageType = "ORU^R01"
   //set HL7MessageParser = ##class(EnsLib.HL7.Message).%New()      
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
    // Set DocType and category and build map
        //set HL7Message.DocType= "2.8:ORU_R01"
        //set tSC=HL7Message.BuildMap() $$$ThrowOnError(tSC) ;Send the HL7 message to Targets         
      
      //set InputFilemsg = ##class(EnsLib.HL7.Message).ImportFromFile("C:\unittests\mytests\HL7Message\ORU_R01")    
  
      //set Segment = HL7Message.split($C(13,10))
      //w Segment 
      set status = Transformation.Transform(InputMessage,.OutputMessage)
      //// *We have an issue with the schema*
      //set status = Transformation.Transform(InputFilemsg,.OutputMessage)
      set OutputMessage.DocType="2.8:ORU_R30" // chi
      //BPO may be different according to Chi-

      //set InputFilemsg.DocType="2.8:ADT_A01"
      //set OutputMessage.DocType="LeadNorthLLC_2.8:ORU_R01"

      w OutputMessage.OutputToString()
    ; Access fields and segments in the HL7 message     
    set SendingFacility = OutputMessage.GetValueAt("MSH:4")
    set SendingApp = OutputMessage.GetValueAt("MSH:3")
    set ReceivingApplication = OutputMessage.GetValueAt("MSH:5", "|") 
    set DateTimeofMessage = OutputMessage.GetValueAt("MSH:7", "|")
    set MessageType = OutputMessage.GetValueAt("MSH:9", "|")
    set MessageControllerID = OutputMessage.GetValueAt("MSH:10", "|")
    set PatientLastName = OutputMessage.GetValueAt("PID:5.1")  
    set PatientFirstName = OutputMessage.GetValueAt("PID:5.2") 
        Set PatientDateofBirth = OutputMessage.GetValueAt("PID:7") 
    Set AdministrativeSex = OutputMessage.GetValueAt("PID:8") 
    Set PatientAddress = OutputMessage.GetValueAt("PID:11") 
    Set PatientAccountNumber = OutputMessage.GetValueAt("PID:18") 
    Set PlaceofVisit = OutputMessage.GetValueAt("PV1:2") 
    Set VisitNumber = OutputMessage.GetValueAt("PV1:19") 
    set OrderType = OutputMessage.GetValueAt("ORC:5", "|")    
    set PlacerOrderNumber = OutputMessage.GetValueAt("OBR:2.1", "|")
    set FillerOrderNumber = OutputMessage.GetValueAt("OBR:3.1", "|")
    set UniversalServiceIdentifier = OutputMessage.GetValueAt("OBR:4", "|")
    set RequestedDateTime = OutputMessage.GetValueAt("OBR:6", "|")
    set OrderingProvider = OutputMessage.GetValueAt("OBR:16", "|")
    set ResultStatus = OutputMessage.GetValueAt("OBR:25", "|")       
    set NotesSection = OutputMessage.GetValueAt("NTE:3.1", "|") 
    set ObservationValue = OutputMessage.GetValueAt("OBX:5", "|")       
        
   ///Here we are logging in the values from the message 
    Write "SendingApp: ", OutputMessage.GetValueAt("MSH:3:"), !
    write "SendingFacility: ", OutputMessage.GetSegmentAt("MSH:4"), !
    write "ReceivingApplication: ", OutputMessage.GetSegmentAt("MSH:5"), !    
    Write "DateTimeofMessage: ", OutputMessage.GetValueAt("MSH:7:"), !
    Write "MessageType: ", OutputMessage.GetValueAt("MSH:9:"), !  
    Write "MessageContollerID: ", OutputMessage.GetValueAt("MSH:10:"), !    
    Write "PatientLastName: ", OutputMessage.GetValueAt("PID:5.1"), ! 
    Write "PatientFirstName: ", OutputMessage.GetValueAt("PID:5.2"), !    
    Write "Patient ID: ", OutputMessage.GetValueAt("PID:3:1"), !
    Write "PatientDateofBirth: ", OutputMessage.GetValueAt("PID:7"), !
    Write "AdministrativeSex: ", OutputMessage.GetValueAt("PID:8"), !
    Write "PatientAddress: ", OutputMessage.GetValueAt("PID:11"), !
    Write "PatientAccountNumber: ", OutputMessage.GetValueAt("PID:18"), !
    Write "OrderType: ", OutputMessage.GetValueAt("ORC:5"), !
    Write "PlaceofVisit: ", OutputMessage.GetValueAt("PV1:2"), ! 
    Write "VisitNumber: ", OutputMessage.GetValueAt("PV1:19"), ! 
    Write "PlacerOrderNumber: ", OutputMessage.GetValueAt("OBR:2.1"), !
    write "FillerOrderNumber: ", OutputMessage.GetValueAt("OBR:3.1"), !
    Write "UniversalserviceIdentifier: ", OutputMessage.GetValueAt("OBR:4"), !
    Write "RequestedDateTime: ", OutputMessage.GetValueAt("OBR:6"), !     
    write "OrderingProvider: ", OutputMessage.GetValueAt("OBR:16"), ! 
    write "ResultStatus: ", OutputMessage.GetValueAt("OBR:25"), !    
    Write "NotesSection: ", OutputMessage.GetValueAt("NTE:3.1"), !
    Write "ObservationValue: ", OutputMessage.GetValueAt("OBX:5"), !

     /// Write the Sending Facility
     w $$$AssertEquals("LEADNORTHLLC", SendingFacility)
      w $$$AssertEquals("ALLSCRIPTS", ReceivingApplication)
      // Write Patient Name
     w $$$AssertEquals("MENDEZ", PatientLastName)
     w $$$AssertEquals("ALVIN", PatientFirstName)
     w $$$AssertEquals("M", AdministrativeSex)
     w $$$AssertEquals("20110808073803", DateTimeofMessage)
     w $$$AssertEquals("99273", MessageControllerID)
     //w $$$AssertEquals("ORU^R01", MessageType)
     //w $$$AssertEquals("T", PatientMiddleName)
     ///Write Patient Address (Ref #49)
     /// Write Place of Visit
    
    //w $$$AssertEquals("Emergency", PlaceofVisit)
     ///set InputMessage=##class(EnsLib.HL7.Message).ImportFromFile(HL7Message,.sc) $$$ThrowOnError(sc)
     ///do ##class(%UnitTest.Manager).RunTest("mytests\UnitTestclass", "/nodelete")
}

}

