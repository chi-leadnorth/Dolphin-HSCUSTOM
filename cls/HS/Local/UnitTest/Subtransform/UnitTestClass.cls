Class HS.Local.UnitTest.Subtransform.UnitTestClass Extends %UnitTest.TestCase
{

/// Creating the first method to test
Method TestORUTransformations()
{

    //create a transformation class instance
    set Transformation = ##class(HS.LeadNorthTransforms.R01).%New()
   // sample HL7 Input message
   set InputMessage = ##class(EnsLib.HL7.Message).%New()
 set HL7MessageParser = ##class(EnsLib.HL7.Message).%New()
   
  
   // Define a Sample of HL7 Message
    #; set HL7Message = "MSH|^~\&|HIS|LAB|LIS|LAB|201206130711||ORM^O01|0001|P|2.3"
    #; set HL7Message = "PID|1|12345|12345|DOE^JOHN||19670101|M"
    #; set HL7Message = "PV1|1|I|2000^2012^01||||004777^LEVINE^ADAM^A|||SUR||||ADM|A0|0000000030|"
    #; set HL7Message = "ORC|NW|00001|0000000001||CM||||20120613073000"
    #; set HL7Message = "OBR|1|00001|0000000001|ALT|001|^^^20120613073000|20120613073000"
    #; set HL7Message = "OBX|1|NM|ALT|001|100|U/L|0.9-1.9|H|||F"
       

      set HL7Message= 
      "MSH|^~\&amp;|Test|HC6|||||ORU^R01|||2.5\n"_
      "PID|||MR1000^^^HC6^MR||Clark^Dan||19301019|M|||1 Memorial Drive^^Cambridge^MA^02142||||||||063070516\n"_
      "PV1||O|||||ISCGP001^Moore^James|||||||EO|||||HSVN00002_200810130907|||||||||||||||||||||||||20081013090700|20081013090700\n"_
      "ORC||MRA23|A11162||||1^^^200810131253||200810131253|||JW22^Walker^James|PHLS||||||||||||||||RAD\n"_
      "OBR||||L SP ROU^L SPINE ROUTINE MIN 4VWS|||200810131245|||||||||||||||200810131245|||F\n"_
      "OBX||TX|||some text that goes with the image result.|||N|||N||||DEMO||COM"   

    //set hl7 message as a test of the input message
     //do InputMessage.ImportFromString(HL7Message)
     //set InputMessage=##class(EnsLib.HL7.Message).ImportFromString(HL7Message,.sc) $$$ThrowOnError(sc)
     set InputMessage=##class(EnsLib.HL7.Message).ImportFromFile(HL7Message,.sc) $$$ThrowOnError(sc)
    #;  Set segments = $LISTFROMSTRING(HL7Message, $CHAR(13,10))
    #;  For i = 1:1:$LISTLENGTH(HL7Message)
    #; {
    #;   Set segment = $LISTGET(HL7Message, i)
    #;   Set segmentType = $PIECE(HL7Message, "|", 1)  // Get the segment type

    #;   // Use ASSERT to find specific elements in each segment
    #;   If segmentType = "MSH" {
    #;     // Parse MSH segment fields
    #;     Set sendingApp = $PIECE(HL7Message, "|", 3)
    #;     Set receivingApp = $PIECE(HL7Message, "|", 5)
    #;     // ... add more fields as needed

    #;     // Assert specific elements
    #;     //Write "Sending App: "_sendingApp,!
    #;      w $$$AssertEquals("LEADNORTHLLC", SendingFacility)
    #;     Write "Receiving App: "_receivingApp,!
    #;   }
    #;   ElseIf segmentType = "PID" {
    #;     // Parse PID segment fields
    #;     Set patientID = $PIECE(HL7Message, "|", 4)
    #;     // ... add more fields as needed

    #;     // Assert specific elements
    #;     Write "Patient ID: "_patientID,!
    #;   }
    #;   ElseIf segmentType = "EVN" {
    #;     // Parse EVN segment fields
    #;     Set eventType = $PIECE(HL7Message, "|", 2)
    #;     // ... add more fields as needed

    #;     // Assert specific elements
    #;     Write "Event Type: "_eventType,!
    #;   }

     //set segments = HL7Message.strip().split()
     
    //Transformation Happens
    set status = Transformation.Transform(InputMessage,.OutputMessage)
    //set ^ZOutputMessage= OutputMessage.OutputToString()
    #; //Assertion: Verifications
    set SendingFacility = OutputMessage.GetValueAt("MSH:4")
    set ReceivingFacility = OutputMessage.GetValueAt("MSH:5")    
    set FamilyName=OutputMessage.GetValueAt("PID:5.1")
    //set DateTimeOfBirth=OutputMessage.GetValueAt("PID:7")
    //set AccountNumber =OutputMessage.GetValueAt("PID:18")
    //set VisitNumber=OutputMessage.GetValueAt("PV1:19")
     
    w $$$AssertEquals("LEADNORTHLLC", SendingFacility)
    w $$$AssertEquals("CERNER", ReceivingFacility)
    w $$$AssertEquals("364546", ID)
    #; w $$$AssertEquals("Clark", FirstName)
    //do $$$AssertEquals(19850316, DateTimeOfBirth)
    //do $$$AssertEquals("369666810440", VisitNumber)
   // do $$$AssertEquals("369666810440", AccountNumber)
   // w $$$assertHL7message.segment("PID")[5] == ("amanda^openda^", PatientName)
    //w $$$AssertEquals("ORU", Field1)
    //write msg.GetValueAt("PID:DateTimeOfBirth.timeofanevent")
    //do $$$AssertEquals("amanda", Field1)
    //w GetValueAt("MSH:4")
}

}

