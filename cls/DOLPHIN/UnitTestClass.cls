Class DOLPHIN.UnitTestClass Extends %UnitTest.TestCase
{

/// Description
/// Creating the first method to test
/// //do ##class(%UnitTest.Manager).RunTest("mytests\UnitTestClass", "/nodelete")
Method TestORUTransformations()
{

    //create a transformation class instance
     set Transformation = ##class(HS.LeadNorthTransforms.R01).%New()
   // sample HL7 Input message
     set InputMessage = ##class(EnsLib.HL7.Message).%New()
    //set InputMessage.DocType = "2.3:ORU_R01" 
   //Set InputMessage.MessageType = "ORU^R01"
   //set HL7MessageParser = ##class(EnsLib.HL7.Message).%New()      
     set HL7Message=     
      "MSH|^~\&|EPIC|LMC|||20110808000317|146640|ORU^R01|99180|P|2.3|||"_$C(13,10)_
      "PID|1|TZ3456|0003664369||SALLYMAE^SAMANTHA^T||19700209|F|SALLYMAE^SAMANTHA|J|9709 FIRST BLVD^^JACKSON^ND^14671^USA^^^ORANGE|ORANGE|(687)887-9635|||M||369666810440|319-84-2112||||"_$C(13,10)_
      "PV1||Emergency|EDOC^ER06^06^^^^^^^^||||P937554^SCHAEFER^VIOLET^^^^^^^^^^|^^^^^^^^^^^^||E/R|||||||^^^^^^^^^^^^|E|369666810440|||||||||||||||||||||||||20110807|||||||V"_$C(13,10)_
      "ORC|SC|75546923^EPC|OC11DX18307^EPC||Exam Begun||^^^201108080003^^STAT||201108080003|P423826^SIMPSON^VIOLET||P716472^O'RIELLY^HANNAH|3010014^^^3010^^^^^OCM EDOC-EMERGENCY|(708)527-8982||"_$C(13,10)_
      "OBR|1|75546923^EPC|OC11DX18307^EPC|IXR000009^XR ABDOMEN SERIES (INCLUDES CHEST 1 VIEW)^^^XR ABDOMEN S||201108080000||||||||||P716472^O'RIELLY^HANNAH^^^^^^^^^^|(701)250-3459|||||||RG|Exam Begun||^^^201108080003^^STAT||||^ABDOMINAL PAIN|||P423826^SIMPSON^VIOLET|^|201108080005|||||||||"_$C(140,150)_
      "NTE|1||Is patient pregnant?->NO||"_$C(13,10)

    set HL7MessageTest= 
      "MSH|^~\&amp;||PHLS|||||ORU^R01|||2.5"_$C(13,10)_
      "PID|||LAB572046^^^PHLS^MR||Smith^John||19301019|M|||1 Memorial Drive^^Cambridge^MA^02142||||||||063070516"_$C(13,10)_
      "PV1||Outpatient|||||ISCGP001^Moore^James|||||||EO|||||HSVN00008|||||||||||||||||||||||||\ZHSDate-83\090700|\ZHSDate-83\090700"_$C(13,10)_
      "ORC||00002-001|0606:C00928S||||^^^\ZHSDate-83\0910||\ZHSDate-83\0912|||ISCGP001^Moore^James|PHLS||||||||PHLS||||||||LAB"_$C(13,10)_
      "OBR||00002-001|0606:C00928S|RGL^Random GLucose^L|||\ZHSDate-83\1214|||||||\ZHSDate-83\0937||ISCGP001^Moore^James||||||\ZHSDate-83\1227|||F"_$C(130,100)_
      "OBX||NM|GLU^GLUCOSE||12.3|mmol/l|70-99||||F|||\ZHSDate-83\1214"_$C(13,10)
      
    set InputMessage=##class(EnsLib.HL7.Message).ImportFromString(HL7MessageTest,.sc) $$$ThrowOnError(sc)          
      
      //set InputFilemsg = ##class(EnsLib.HL7.Message).ImportFromFile("C:\unittests\mytests\HL7Message\ORU_R01")
      //w InputFilemsg
  
      //set Segment = HL7Message.split($C(13,10))
      //w Segment 
      set status = Transformation.Transform(InputMessage,.OutputMessage)
      //set status = Transformation.Transform(InputFilemsg,.OutputMessage)
      set OutputMessage.DocType="2.8:ORU_R30"
      //set InputFilemsg.DocType="2.8:ADT_A01"
      w OutputMessage.OutputToString()
    ; Access fields and segments in the HL7 message     
    set SendingFacility = OutputMessage.GetValueAt("MSH:4")
    set sendingApp = OutputMessage.GetValueAt("MSH:3")
    set ReceivingApplication = OutputMessage.GetValueAt("MSH:5", "|") 
    set PatientLastName = OutputMessage.GetValueAt("PID:5.1")  
    set PatientFirstName = OutputMessage.GetValueAt("PID:5.2") 
    set PatientMiddleName = OutputMessage.GetValueAt("PID:5.3")
    SET PatientDateofBirth = OutputMessage.GetValueAt("PID:7") 
    Set PatientAddress = OutputMessage.GetValueAt("PID:11") 
    Set PlaceofVisit = OutputMessage.GetValueAt("PV1:2") 
    set OrderType = OutputMessage.GetValueAt("ORC:5", "|")    
    set OrderingProvider = OutputMessage.GetValueAt("OBR:16", "|")
    set Results = OutputMessage.GetValueAt("OBR:2.1", "|")
    set NotesSection = OutputMessage.GetValueAt("NTE:3.1", "|")      
        
   
    write "SendingFacility: ", OutputMessage.GetSegmentAt("MSH:4"), !
    write "ReceivingApplication: ", OutputMessage.GetSegmentAt("MSH:5"), !
    Write "sendingApp: ", OutputMessage.GetValueAt("MSH:3:"), !    
    Write "PatientLastName: ", OutputMessage.GetValueAt("PID:5.1"), ! 
    Write "PatientFirstName: ", OutputMessage.GetValueAt("PID:5.2"), !    
    Write "Patient ID: ", OutputMessage.GetValueAt("PID:3:1"), !
    Write "PatientDateofBirth: ", OutputMessage.GetValueAt("PID:7"), !
    Write "PatientAddress: ", OutputMessage.GetValueAt("PID:11"), !
    Write "OrderType: ", OutputMessage.GetValueAt("ORC:5"), !
    Write "PlaceofVisit: ", OutputMessage.GetValueAt("PV1:2"), !   
    write "OrderingProvider: ", OutputMessage.GetValueAt("OBR:16"), !
    Write "Results: ", OutputMessage.GetValueAt("OBR:2.1"), !
     Write "NotesSection: ", OutputMessage.GetValueAt("NTE:3.1"), !

     /// Write the Sending Facility
     w $$$AssertEquals("LEADNORTHLLC", SendingFacility)
      // Write Patient Name
     w $$$AssertEquals("Smith", PatientLastName)
     w $$$AssertEquals("John", PatientFirstName)
     //w $$$AssertEquals("T", PatientMiddleName)
     ///Write Patient Address (Ref #49)
     /// Write Place of Visit
    
    w $$$AssertEquals("Outpatient", PlaceofVisit)
     ///set InputMessage=##class(EnsLib.HL7.Message).ImportFromFile(HL7Message,.sc) $$$ThrowOnError(sc)
}

}

