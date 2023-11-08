<<<<<<< HEAD
Class HS.Local.UnitTest.Subtransform.UnitTestClassTwo Extends %UnitTest.TestCase
=======
Class HS.Local.Unit.DOLPHIN.UnitTestClasses.UnitTestClassTwo Extends %UnitTest.TestCase
>>>>>>> 7c97b8415f5531b2180e3ea138a1b16f3fb26899
{

/// Description
/// Creating the first method to test
Method TestORUTransformations()
{

    //create a transformation class instance
     set Transformation = ##class(HS.LeadNorthTransforms.R01).%New()
   // sample HL7 Input message
     set InputMessage = ##class(EnsLib.HL7.Message).%New()       
      set HL7Message=     
      "MSH|^~\&|EPIC|LMC|||20110808000317|146640|ORU^R01|99180|P|2.3|||"_$C(13,10)_
      "PID|1|TZ3456|0003664369||SALLYMAE^SAMANTHA^T||19700209|F|SALLYMAE^SAMANTHA|J|9709 FIRST BLVD^^JACKSON^ND^14671^USA^^^ORANGE|ORANGE|(687)887-9635|||M||369666810440|319-84-2112||||"_$C(13,10)_
      "PV1||E/O/I|EDOC^ER06^06^^^^^^^^||||P937554^SCHAEFER^VIOLET^^^^^^^^^^|^^^^^^^^^^^^||E/R|||||||^^^^^^^^^^^^|E|369666810440|||||||||||||||||||||||||20110807|||||||V"_$C(13,10)_
      "ORC|SC|75546923^EPC|OC11DX18307^EPC||Exam Begun||^^^201108080003^^STAT||201108080003|P423826^SIMPSON^VIOLET||P716472^O'RIELLY^HANNAH|3010014^^^3010^^^^^OCM EDOC-EMERGENCY|(708)527-8982||"_$C(13,10)_
      "OBR|1|75546923^EPC|OC11DX18307^EPC|IXR000009^XR ABDOMEN SERIES (INCLUDES CHEST 1 VIEW)^^^XR ABDOMEN S||201108080000||||||||||P716472^O'RIELLY^HANNAH^^^^^^^^^^|(701)250-3459|||||||RG|Exam Begun||^^^201108080003^^STAT||||^ABDOMINAL PAIN|||P423826^SIMPSON^VIOLET|^|201108080005|||||||||"_$C(14,50)_
      "OBX|1|ST|M0196^Comments^L||Bacterial growth of doubtful significance.|||L|||P"_$C(13,10)_
      "OBX|2|ST|M0922^LEFT PERIPHERAL SAMPLE^L||Negative|||L|||P"_$C(13,10)_
      "NTE|1||Is patient pregnant?->NO||"_$C(13,10)
      

     //set InputMessage.DocType = "2.3:ORU_R01" 
      //set DocType = "ORU^R01" 
      //Set InputMessage.MessageType = "ORU^R01"
     //set HL7MessageParser = ##class(EnsLib.HL7.Message).%New()  
      //set hl7Schema = ##class(EnsLib.HL7.Schema).%New()

      //Set InputMessage.Schema = hl7Schema 
      set InputMessage=##class(EnsLib.HL7.Message).ImportFromString(HL7Message,.sc) $$$ThrowOnError(sc)
      set status = Transformation.Transform(InputMessage,.OutputMessage)    
      set OutputMessage.DocType="ADT_A01"
      w OutputMessage.OutputToString()
   
    ; Access fields and segments in the HL7 message     
    set SendingFacility = OutputMessage.GetValueAt("MSH:4")
    set sendingApp = OutputMessage.GetValueAt("MSH:3")
    set ReceivingApplication = OutputMessage.GetValueAt("MSH:5", "|") 
    set PatientLastName = OutputMessage.GetValueAt("PID:5.1")  
    set PatientFirstName = OutputMessage.GetValueAt("PID:5.2") 
    set PatientDateofBirth = OutputMessage.GetValueAt("PID:7") 
    set PatientGender = OutputMessage.GetValueAt("PID:8") 
    set PatientAddress = OutputMessage.GetValueAt("PID:11") 
    set OrderType = OutputMessage.GetValueAt("ORC:5", "|")
    set NotesSection = OutputMessage.GetValueAt("NTE:3.1", "|")
    set Results = OutputMessage.GetValueAt("OBR:2.1", "|")      
        
   
     //write "SendingFacility: ", OutputMessage.GetSegmentAt("MSH:4"), !
     write "ReceivingApplication: ", OutputMessage.GetSegmentAt("MSH:5"), !
     Write "sendingApp: ", OutputMessage.GetValueAt("MSH:3:"), !    
     Write "PatientLastName: ", OutputMessage.GetValueAt("PID:5.1"), ! 
     Write "PatientFirstName: ", OutputMessage.GetValueAt("PID:5.2"), !  
     Write "Patient ID: ", OutputMessage.GetValueAt("PID:3:1"), !
     Write "PatientDateofBirth: ", OutputMessage.GetValueAt("PID:7"), !
     Write "PatientGender: ", OutputMessage.GetValueAt("PID:8"), !
     Write "PatientAddress: ", OutputMessage.GetValueAt("PID:11"), ! 
     Write "PlaceofVisit: ", OutputMessage.GetValueAt("PV1:2"), !
     Write "OrderType: ", OutputMessage.GetValueAt("ORC:5"), !
     
     Write "NotesSection: ", OutputMessage.GetValueAt("NTE:3.1"), !
     Write "Results: ", OutputMessage.GetValueAt("OBR:2.1"), !
     w $$$AssertEquals("SALLYMAE", PatientLastName)
     w $$$AssertEquals("SAMANTHA", PatientFirstName)
     w $$$AssertEquals("LEADNORTHLLC", SendingFacility)
     w $$$AssertEquals("19700209", PatientDateofBirth)

      // Loop through segments
    #; Set segmentCount = OutputMessage.SegmentCount()
    #;  w segmentCount
    #; For i = 1:1:segmentCount {
    #;     Write "Segment ", i, ": ", OutputMessage.GetSegmentAt(i), !
    #; }
    #;  w PatientName
     //w $$$AssertEquals("SALLYMAE", PatientName)
     
    //Write "PatientName: ", OutputMessage.GetValueAt("PID:5:1"), !
    //Write "Patient ID: ", OutputMessage.GetValueAt("PID:3:1"), !
    
   
      //set TransformResult = OutputMessage.OutputToString()
      //w TransformResult

    #;  SET string1="123 Primrose Path"
    #;  SET len=$LENGTH(string1)
    #;  FOR index=1:1:len-1 {
    #;  WRITE $EXTRACT(string1,index)
    #; }
    #; set segments = HL7Message.segments
    #; w segments
}

}

