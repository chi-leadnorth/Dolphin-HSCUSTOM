Class HS.Local.UnitTest.Subtransform.ORUTestMessages Extends %RegisteredObject
{

/// Resource for Sample Data: HS.Util.SampleData.HL7Scenarios
XData Scenario1
{
<message>
MSH|^~\&amp;||PHLS|||||ORU^R01|||2.5
PID||S2345|S2345^^^PHLS^MR|C9876^^^COR^XX~S45008787^^^MA^DL|Smith^John||19301019|M|||1 Memorial Drive^^Cambridge^MA^02142||||||||063070516
PV1||O|||||ISCGP001^Moore^James|||||||EO|||||HSVN00008|||||||||||||||||||||||||\ZHSDate-83\090700|\ZHSDate-83\090700
ORC||00265-001|0606:H00550R||||^^^\ZHSDate-83\0910||\ZHSDate-83\0910|||ISCGP001^Moore^James|PHLS||||||||PHLS||||||||LAB
OBR||00265-001|0606:H00550R|CBCD^CBC+ AUTOMATED DIFFERENTIAL^L|||\ZHSDate-83\1049|||||||\ZHSDate-83\0937|Blood|ISCGP001^Moore^James||||||\ZHSDate-83\1227|||F
OBX||NM|WBC^WHITE BLOOD CELL COUNT||6.24|10(9)/L|4.0-10.6||||F|||\ZHSDate-83\1049
OBX||NM|RBC^RED BLOOD CELL COUNT||4.99|10x12/L|4.5-5.9||||F|||\ZHSDate-83\1049
OBX||NM|HGB^HEMOGLOBIN||13.6|g/dL|12.0-16.0||||F|||\ZHSDate-83\1049
OBX||NM|HCT^HEMATOCRIT||41.6|Percent|36.0-46.0||||F|||\ZHSDate-83\1049
OBX||NM|MCV^MEAN CELL VOLUME||83.4|fL|80-100||||F|||\ZHSDate-83\1049
OBX||NM|MCH^MEAN CELL HEMOGLOBIN||27.3|pg|26-34||||F|||\ZHSDate-83\1049
OBX||NM|MCHC^MEAN CELL HEMOGLOBIN CONC||32.7|g/dL|31-37||||F|||\ZHSDate-83\1049
OBX||NM|RDW^RED CELL DISTRIB WIDTH||14.1|Percent|11.5-14.5||||F|||\ZHSDate-83\1049
OBX||NM|PLT^PLATELET COUNT - AUTOMATED||237|10(9)L|140-440||||F|||\ZHSDate-83\1049
OBX||NM|MPV^MEAN PLATELET VOLUME||10.1|UMx1000|8-11||||F|||\ZHSDate-83\1049
OBX||NM|NE^# NEUTROPHILS||3.02|#|1.8-8.5||||F|||\ZHSDate-83\1049
OBX||NM|LY^# LYMPHS||2.51|#|0.8-3.5||||F|||\ZHSDate-83\1049
OBX||NM|MO^# MONOS||0.69|#|0.2-0.9||||F|||\ZHSDate-83\1049
OBX||NM|EO^# EOSINOPHILS||0.01|#|0.0-0.6||||F|||\ZHSDate-83\1049
OBX||NM|BA^# BASOPHILS||0.01|#|0.0-0.2||||F|||\ZHSDate-83\1049
OBX||NM|PERCENTNE^Percent  NEUTROPHILS||48.3|Percent|40-80||||F|||\ZHSDate-83\1049
OBX||NM|PERCENTLY^Percent  LYMPHS||40.2|Percent|15-45||||F|||\ZHSDate-83\1049
OBX||ST|PLEST^PLATELET COUNT ESTIMATE||NORMAL||||||F|||\ZHSDate-83\1049
OBX||ST|SPR^PERFORM SLIDE REVIEW?||YES||||||F|||\ZHSDate-83\1049
OBX||ST|NM^MORPHOLOGY NORMAL||NON SPECIFIC CHANGES||||||F|||\ZHSDate-83\1049
OBX||NM|SEG^SEGMENTED NEUTROPHILS||54|Percent|50-75||||F|||\ZHSDate-83\1049
OBX||NM|LYMPHS^LYMPHOCYTES||31|Percent|20-44||||F|||\ZHSDate-83\1049
OBX||NM|MONO^MONOCYTES||13|Percent|2-9||||F|||\ZHSDate-83\1049
OBX||NM|ATYP^ATYPICAL LYMPHOCYTES||12|Percent|||||F|||\ZHSDate-83\1049	

MSH|^~\&amp;||PHLS|||||ORU^R01|||2.5
PID|||LAB572046^^^PHLS^MR||Smith^John||19301019|M|||1 Memorial Drive^^Cambridge^MA^02142||||||||063070516
PV1||O|||||ISCGP001^Moore^James|||||||EO|||||HSVN00008|||||||||||||||||||||||||\ZHSDate-83\090700|\ZHSDate-83\090700
ORC||00002-001|0606:C00928S||||^^^\ZHSDate-83\0910||\ZHSDate-83\0912|||ISCGP001^Moore^James|PHLS||||||||PHLS||||||||LAB
OBR||00002-001|0606:C00928S|RGL^Random GLucose^L|||\ZHSDate-83\1214|||||||\ZHSDate-83\0937||ISCGP001^Moore^James||||||\ZHSDate-83\1227|||F
OBX||NM|GLU^GLUCOSE||12.3|mmol/l|70-99||||F|||\ZHSDate-83\1214

MSH|^~\&amp;||HC6|||||MDM^T02|||2.5
EVN|T02|\ZHSDate-80\090700
PID|||LD572046^^^HC6^MR||Smith^John||19301019|M|||1 Memorial Drive^^Cambridge^MA^02142||||||||063070516
PV1||O|||||ISCGP001^Moore^James|||||||EO|||||HSVN00002|||||||||||||||||||||||||\ZHSDate-80\090700|\ZHSDate-80\090700
TXA||Progress note||\ZHSDate-80\0907|HB01^Winterbottom^Henry||||ISCGP001^Moore^James|||19815951^TRANS
OBX||FT|RTF^TRANS||Patient seems vague complaining of dizziness and fatigue need to check blood sugar and Haemoglobin.||||||R


MSH|^~\&amp;||HC6|||||ADT^A08|||2.5
EVN|A08|\ZHSDate-71\094500
PID|||LD572046^^^HC6^MR||Smith^John||19301019|M|||1 Memorial Drive^^Cambridge^MA^02142||||||||063070516
PV1||O|||||ISCGP001^Moore^James|||||||EO|||||HSVN00006|||||||||||||||||||||||||\ZHSDate-71\094500|\ZHSDate-71\094500
AL1||Food|Choc^Chocolate|Sev^Severe - Danger of Choking|Sneeze|\ZHSDate-2557\
DG1|||T2D^ Type 2 diabetes mellitus|Type 2 diabetes mellitus|\ZHSDate-71\0945|T2D||||||||||ISCGP001^Moore^James
DG1|||DA^Dementia in Alzheimer's disease|Dementia in Alzheimer's disease|\ZHSDate-71\0945|DA||||||||||ISCGP001^Moore^James

MSH|^~\&amp;||CGH|||||ORU^R01|||2.5
PID|||LN572046^^^CGH^MR||Smith^John||19301019|M|||1 Memorial Drive^^Cambridge^MA^02142||||||||063070516
PV1||I|||||BJ0099^Farrell^Sam^^^^^^PHLS|||||||EO|||||HSVN00007|||||||||||||||||||||||||\ZHSDate-64\094500|\ZHSDate-62\150000
ORC||HOS9001|HOS9001||||^^^\ZHSDate-64\1800||\ZHSDate-64\1800|||BJ0099^Farrell^Sam^^^^^^PHLS|CGH||||||||CGH||||||||LAB
OBR||HOS9001|HOS9001|CBCD^CBC+ AUTOMATED DIFFERENTIAL^L|||\ZHSDate-64\1900||||||||Blood|BJ0099^Farrell^Sam^^^^^^PHLS||||||\ZHSDate-64\2000|||F
OBX||NM|WBC^WHITE BLOOD CELL COUNT||6.1|10(9)/L|4.0-10.6||||F|||\ZHSDate-64\1900
OBX||NM|RBC^RED BLOOD CELL COUNT||4.99|10x12/L|4.5-5.9||||F|||\ZHSDate-64\1900
OBX||NM|HGB^HEMOGLOBIN||13.6|g/dL|12.0-16.0||||F|||\ZHSDate-64\1900
OBX||NM|HCT^HEMATOCRIT||41.6|Percent|36.0-46.0||||F|||\ZHSDate-64\1900
OBX||NM|MCV^MEAN CELL VOLUME||83.4|fL|80-100||||F|||\ZHSDate-64\1900
OBX||NM|MCH^MEAN CELL HEMOGLOBIN||27.3|pg|26-34||||F|||\ZHSDate-64\1900
OBX||NM|MCHC^MEAN CELL HEMOGLOBIN CONC||32.7|g/dL|31-37||||F|||\ZHSDate-64\1900
OBX||NM|RDW^RED CELL DISTRIB WIDTH||14.1|Percent|11.5-14.5||||F|||\ZHSDate-64\1900
OBX||NM|PLT^PLATELET COUNT - AUTOMATED||237|10(9)L|140-440||||F|||\ZHSDate-64\1900
OBX||NM|MPV^MEAN PLATELET VOLUME||9.0|UMx1000|8-11||||F|||\ZHSDate-64\1900
OBX||NM|NE^# NEUTROPHILS||3.02|#|1.8-8.5||||F|||\ZHSDate-64\1900
OBX||NM|LY^# LYMPHS||2.51|#|0.8-3.5||||F|||\ZHSDate-64\1900
OBX||NM|MO^# MONOS||0.69|#|0.2-0.9||||F|||\ZHSDate-64\1900
OBX||NM|EO^# EOSINOPHILS||0.01|#|0.0-0.6||||F|||\ZHSDate-64\1900
OBX||NM|BA^# BASOPHILS||0.01|#|0.0-0.2||||F|||\ZHSDate-64\1900
OBX||NM|PERCENTNE^Percent  NEUTROPHILS||48.3|Percent|40-80||||F|||\ZHSDate-64\1900
OBX||NM|PERCENTLY^Percent  LYMPHS||40.2|Percent|15-45||||F|||\ZHSDate-64\1900
OBX||ST|PLEST^PLATELET COUNT ESTIMATE||NORMAL||||||F|||\ZHSDate-64\1900
OBX||ST|SPR^PERFORM SLIDE REVIEW?||YES||||||F|||\ZHSDate-64\1900
OBX||ST|NM^MORPHOLOGY NORMAL||NON SPECIFIC CHANGES||||||F|||\ZHSDate-64\1900
OBX||NM|SEG^SEGMENTED NEUTROPHILS||54|Percent|50-75||||F|||\ZHSDate-64\1900
OBX||NM|LYMPHS^LYMPHOCYTES||31|Percent|20-44||||F|||\ZHSDate-64\1900
OBX||NM|MONO^MONOCYTES||13|Percent|2-9||||F|||\ZHSDate-64\1900
OBX||NM|ATYP^ATYPICAL LYMPHOCYTES||10|Percent|||||F|||\ZHSDate-64\1900
OBX||NM|PERCENTNE^Percent  NEUTROPHILS||48.3|Percent|40-80||||F|||\ZHSDate-64\1900
OBX||NM|PERCENTLY^Percent  LYMPHS||40.2|Percent|15-45||||F|||\ZHSDate-64\1900

MSH|^~\&amp;||CGH|||||ORU^R01|||2.5
PID|||LN572046^^^CGH^MR||Smith^John||19301019|M|||1 Memorial Drive^^Cambridge^MA^02142||||||||063070516
PV1||I|||||BJ0099^Farrell^Sam^^^^^^PHLS|||||||EO|||||HSVN00007|||||||||||||||||||||||||\ZHSDate-64\094500|\ZHSDate-62\150000
ORC||HOS9001|HOS9001||||^^^\ZHSDate-64\1800||\ZHSDate-64\1800|||BJ0099^Farrell^Sam^^^^^^PHLS|CGH||||||||CGH||||||||LAB
OBR||HOS9001|HOS9001|RGL^Random GLucose^L|||\ZHSDate-64\1900|||||||||BJ0099^Farrell^Sam^^^^^^PHLS||||||\ZHSDate-64\2000|||F



MSH|^~\&amp;||CGH|||||OMP^O09|||2.5
PID|||LN572046^^^CGH^MR||Smith^John||19301019|M|||1 Memorial Drive^^Cambridge^MA^02142||||||||063070516
PV1||I|||||BJ0099^Farrell^Sam^^^^^^PHLS|||||||EO|||||HSVN00007|||||||||||||||||||||||||\ZHSDate-64\094500|\ZHSDate-62\150000
ORC||HOS100319001|HOS100319001||||^^^\ZHSDate-64\1212||\ZHSDate-64\1212|||BJ0099^Farrell^Sam^^^^^^PHLS|CGH||||||||CGH||||||||LAB
TQ1|||||||\ZHSDate-64\1212||PRN
RXO|Panadeine Forte Tablets^Panadeine Forte Tablets|100|||||Oral^Oral

MSH|^~\&amp;||CGH|||||MDM^T02|||2.5
EVN|T02|\ZHSDate-64\094500
PID|||LN572046^^^CGH^MR||Smith^John||19301019|M|||1 Memorial Drive^^Cambridge^MA^02142||||||||063070516
PV1||I|||||BJ0099^Farrell^Sam^^^^^^PHLS|||||||EO|||||HSVN00007|||||||||||||||||||||||||\ZHSDate-64\094500|\ZHSDate-62\150000
TXA||Progress note||\ZHSDate-64\1300|BJ0099^Farrell^Sam^^^^^^PHLS||||BJ0099^Farrell^Sam^^^^^^PHLS|||19815953^TRANS
OBX||FT|RTF^TRANS||Admitted with unstable sugar levels. For review/observation for next few days.||||||R



MSH|^~\&amp;||CGH|||||ORU^R01|||2.5
PID|||LN572046^^^CGH^MR||Smith^John||19301019|M|||1 Memorial Drive^^Cambridge^MA^02142||||||||063070516
PV1||I|||||BJ0099^Farrell^Sam^^^^^^PHLS|||||||EO|||||HSVN00007|||||||||||||||||||||||||\ZHSDate-64\094500|\ZHSDate-62\150000
ORC||HOS9002|HOS9002||||^^^\ZHSDate-63\1800||\ZHSDate-63\1800|||BJ0099^Farrell^Sam^^^^^^PHLS|CGH||||||||CGH||||||||LAB
OBR||HOS9002|HOS9002|CBCD^CBC+ AUTOMATED DIFFERENTIAL^L|||\ZHSDate-63\1900||||||||Blood|BJ0099^Farrell^Sam^^^^^^PHLS||||||\ZHSDate-63\2000|||F
OBX||NM|WBC^WHITE BLOOD CELL COUNT||5.1|10(9)/L|4.0-10.6||||F|||\ZHSDate-63\1900
OBX||NM|RBC^RED BLOOD CELL COUNT||3.99|10x12/L|4.5-5.9||||F|||\ZHSDate-63\1900
OBX||NM|HGB^HEMOGLOBIN||13.7|g/dL|12.0-16.0||||F|||\ZHSDate-63\1900
OBX||NM|HCT^HEMATOCRIT||41.5|Percent|36.0-46.0||||F|||\ZHSDate-63\1900
OBX||NM|MCV^MEAN CELL VOLUME||84|fL|80-100||||F|||\ZHSDate-63\1900
OBX||NM|MCH^MEAN CELL HEMOGLOBIN||28.3|pg|26-34||||F|||\ZHSDate-63\1900
OBX||NM|MCHC^MEAN CELL HEMOGLOBIN CONC||32.7|g/dL|31-37||||F|||\ZHSDate-63\1900
OBX||NM|RDW^RED CELL DISTRIB WIDTH||14|Percent|11.5-14.5||||F|||\ZHSDate-63\1900
OBX||NM|PLT^PLATELET COUNT - AUTOMATED||288|10(9)L|140-440||||F|||\ZHSDate-63\1900
OBX||NM|MPV^MEAN PLATELET VOLUME||9.2|UMx1000|8-11||||F|||\ZHSDate-63\1900
OBX||NM|NE^# NEUTROPHILS||3|#|1.8-8.5||||F|||\ZHSDate-63\1900
OBX||NM|LY^# LYMPHS||2|#|0.8-3.5||||F|||\ZHSDate-63\1900
OBX||NM|MO^# MONOS||0.7|#|0.2-0.9||||F|||\ZHSDate-63\1900
OBX||NM|EO^# EOSINOPHILS||0.01|#|0.0-0.6||||F|||\ZHSDate-63\1900
OBX||NM|BA^# BASOPHILS||0.01|#|0.0-0.2||||F|||\ZHSDate-63\1900
OBX||NM|PERCENTNE^Percent  NEUTROPHILS||49.3|Percent|40-80||||F|||\ZHSDate-63\1900
OBX||NM|PERCENTLY^Percent  LYMPHS||47|Percent|15-45||||F|||\ZHSDate-63\1900
OBX||ST|PLEST^PLATELET COUNT ESTIMATE||NORMAL||||||F|||\ZHSDate-63\1900
OBX||ST|SPR^PERFORM SLIDE REVIEW?||YES||||||F|||\ZHSDate-63\1900
OBX||ST|NM^MORPHOLOGY NORMAL||NON SPECIFIC CHANGES||||||F|||\ZHSDate-63\1900
OBX||NM|SEG^SEGMENTED NEUTROPHILS||54|Percent|50-75||||F|||\ZHSDate-63\1900
OBX||NM|LYMPHS^LYMPHOCYTES||41|Percent|20-44||||F|||\ZHSDate-63\1900
OBX||NM|MONO^MONOCYTES||13|Percent|2-9||||F|||\ZHSDate-63\1900
OBX||NM|ATYP^ATYPICAL LYMPHOCYTES||5|Percent|||||F|||\ZHSDate-63\1900
OBX||NM|PERCENTNE^Percent  NEUTROPHILS||58.3|Percent|40-80||||F|||\ZHSDate-63\1900
OBX||NM|PERCENTLY^Percent  LYMPHS||30.2|Percent|15-45||||F|||\ZHSDate-63\1900


</message>
}

XData Scenario2
{
<message>

MSH|^~\&amp;||EMERGENCY|||||ORU^R01|||2.5
PID|||Ab443^^^EMERGENCY^MR||Simpson^Harold||19220203|M|||14 Tangier Lane^^Eton^Berks^SL4 6BB||||||||456112222
PV1||E|||||PP22^Pelle^Pettersson|||||||EO|||||HSVN00004|||||||||||||||||||||||||\ZHSDate-108\100000|\ZHSDate-108\120000
ORC||E265-001|E06:H00550R||||^^^\ZHSDate-108\1101||\ZHSDate-108\1101|||PP22^Pelle^Pettersson|Radiologyy||||||||Radiologyy||||||||RAD
OBR||E265-001|E06:H00550R|HCT^Head CT^L|||\ZHSDate-108\1101|||||||||PP22^Pelle^Pettersson||||||\ZHSDate-108\1200|||F
OBX||TX|HCT_1^||-----------RADIOLOGY REPORT------------||||||F|||\ZHSDate-108\1101
OBX||TX|HCT_2||Major cerebral hemorrahge in the capsula interna, a cerebri media( right side)||||||F|||\ZHSDate-108\1101


MSH|^~\&amp;||EMERGENCY|||||ORM^O01|||2.5
PID|||Ab443^^^EMERGENCY^MR||Simpson^Harold||19220203|M|||14 Tangier Lane^^Eton^Berks^SL4 6BB||||||||456112222
PV1||I|||||OO11^Scott^Peter|||||||EO|||||HSVN00003|||||||||||||||||||||||||\ZHSDate-108\130000|\ZHSDate-101\140500
ORC||P12|P12||||^^^\ZHSDate-108\1300||\ZHSDate-108\1300|||OO11^Scott^Peter|EMERGENCY||||||||EMERGENCY||||||||OTH
OBR||P12|P12|AWC^Vitals|||\ZHSDate-108\1300|||||||\ZHSDate-108\1300||OO11^Scott^Peter||||||\ZHSDate-108\1300|||F

MSH|^~\&amp;||EMERGENCY|||||ORU^R01|||2.5
PID|||Ab443^^^EMERGENCY^MR||Simpson^Harold||19220203|M|||14 Tangier Lane^^Eton^Berks^SL4 6BB||||||||456112222
PV1||I|||||OO11^Scott^Peter|||||||EO|||||HSVN00003|||||||||||||||||||||||||\ZHSDate-108\130000|\ZHSDate-101\140500
ORC||LB123G|LB123G||||^^^\ZHSDate-108\1300||\ZHSDate-108\1300|||OO11^Scott^Peter|EMERGENCY||||||||EMERGENCY||||||||LAB
OBR||LB123G|LB123G|CBCD^CBC+ AUTOMATED DIFFERENTIAL^L|||\ZHSDate-108\1300|||||||\ZHSDate-108\1330|Blood|OO11^Scott^Peter||||||\ZHSDate-108\1620|||F
OBX||NM|WBC^WHITE BLOOD CELL COUNT||6.24|10(9)/L|4.0-10.6||||F|||\ZHSDate-108\1330
OBX||NM|RBC^RED BLOOD CELL COUNT||4.99|10x12/L|4.5-5.9||||F|||\ZHSDate-108\1330
OBX||NM|HGB^HEMOGLOBIN||13.6|g/dL|12.0-16.0||||F|||\ZHSDate-108\1330
OBX||NM|HCT^HEMATOCRIT||41.6|Percent|36.0-46.0||||F|||\ZHSDate-108\1330
OBX||NM|MCV^MEAN CELL VOLUME||83.4|fL|80-100||||F|||\ZHSDate-108\1330
OBX||NM|MCH^MEAN CELL HEMOGLOBIN||27.3|pg|26-34||||F|||\ZHSDate-108\1330
OBX||NM|MCHC^MEAN CELL HEMOGLOBIN CONC||32.7|g/dL|31-37||||F|||\ZHSDate-108\1330
OBX||NM|RDW^RED CELL DISTRIB WIDTH||14.1|Percent|11.5-14.5||||F|||\ZHSDate-108\1330
OBX||NM|PLT^PLATELET COUNT - AUTOMATED||237|10(9)L|140-440||||F|||\ZHSDate-108\1330
OBX||NM|MPV^MEAN PLATELET VOLUME||10.1|UMx1000|8-11||||F|||\ZHSDate-108\1330
OBX||NM|NE^# NEUTROPHILS||3.02|#|1.8-8.5||||F|||\ZHSDate-108\1330
OBX||NM|LY^# LYMPHS||2.51|#|0.8-3.5||||F|||\ZHSDate-108\1330
OBX||NM|MO^# MONOS||0.69|#|0.2-0.9||||F|||\ZHSDate-108\1330
OBX||NM|EO^# EOSINOPHILS||0.01|#|0.0-0.6||||F|||\ZHSDate-108\1330
OBX||NM|BA^# BASOPHILS||0.01|#|0.0-0.2||||F|||\ZHSDate-108\1330
OBX||NM|PERCENTNE^Percent  NEUTROPHILS||48.3|Percent|40-80||||F|||\ZHSDate-108\1330
OBX||NM|PERCENTLY^Percent  LYMPHS||40.2|Percent|15-45||||F|||\ZHSDate-108\1330
OBX||ST|PLEST^PLATELET COUNT ESTIMATE||NORMAL||||||F|||\ZHSDate-108\1330
OBX||ST|SPR^PERFORM SLIDE REVIEW?||YES||||||F|||\ZHSDate-108\1330
OBX||ST|NM^MORPHOLOGY NORMAL||NON SPECIFIC CHANGES||||||F|||\ZHSDate-108\1330
OBX||NM|SEG^SEGMENTED NEUTROPHILS||54|Percent|50-75||||F|||\ZHSDate-108\1330
OBX||NM|LYMPHS^LYMPHOCYTES||31|Percent|20-44||||F|||\ZHSDate-108\1330
OBX||NM|MONO^MONOCYTES||13|Percent|2-9||||F|||\ZHSDate-108\1330
OBX||NM|ATYP^ATYPICAL LYMPHOCYTES||2|Percent|||||F|||\ZHSDate-108\1330

MSH|^~\&amp;||EMERGENCY|||||ORU^R01|||2.5
PID|||Ab443^^^EMERGENCY^MR||Simpson^Harold||19220203|M|||14 Tangier Lane^^Eton^Berks^SL4 6BB||||||||456112222
PV1||I|||||OO11^Scott^Peter|||||||EO|||||HSVN00003|||||||||||||||||||||||||\ZHSDate-108\130000|\ZHSDate-101\140500
ORC||LB123G|LB123G||||^^^\ZHSDate-108\1200||\ZHSDate-108\1200|||OO11^Scott^Peter|EMERGENCY||||||||EMERGENCY||||||||LAB
OBR||LB123G|LB123G|COAG^Coag^L|||\ZHSDate-108\1300|||||||\ZHSDate-108\1330|Blood|OO11^Scott^Peter||||||\ZHSDate-108\1620|||F
OBX||NM|APTT^APTT||25|Secs|24-38||||F|||\ZHSDate-108\1300



MSH|^~\&amp;||EMERGENCY|||||ORU^R01|||2.5
PID|||Ab443^^^EMERGENCY^MR||Simpson^Harold||19220203|M|||14 Tangier Lane^^Eton^Berks^SL4 6BB||||||||456112222
PV1||I|||||OO11^Scott^Peter|||||||EO|||||HSVN00003|||||||||||||||||||||||||\ZHSDate-108\130000|\ZHSDate-101\140500
ORC||LB123G|LB123G||||^^^\ZHSDate-103\1300||\ZHSDate-103\1300|||OO11^Scott^Peter|EMERGENCY||||||||EMERGENCY||||||||LAB
OBR||LB123G|LB123G|CBCD^CBC+ AUTOMATED DIFFERENTIAL^L|||\ZHSDate-108\1300|||||||\ZHSDate-103\1030|Blood|OO11^Scott^Peter||||||\ZHSDate-108\1620|||F
OBX||NM|WBC^WHITE BLOOD CELL COUNT||6.24|10(9)/L|4.0-10.6||||F|||\ZHSDate-103\1030
OBX||NM|RBC^RED BLOOD CELL COUNT||4.99|10x12/L|4.5-5.9||||F|||\ZHSDate-103\1030
OBX||NM|HGB^HEMOGLOBIN||13.6|g/dL|12.0-16.0||||F|||\ZHSDate-103\1030
OBX||NM|HCT^HEMATOCRIT||41.6|Percent|36.0-46.0||||F|||\ZHSDate-103\1030
OBX||NM|MCV^MEAN CELL VOLUME||83.4|fL|80-100||||F|||\ZHSDate-103\1030
OBX||NM|MCH^MEAN CELL HEMOGLOBIN||27.5|pg|26-34||||F|||\ZHSDate-103\1030
OBX||NM|MCHC^MEAN CELL HEMOGLOBIN CONC||32.7|g/dL|31-37||||F|||\ZHSDate-103\1030
OBX||NM|RDW^RED CELL DISTRIB WIDTH||14.1|Percent|11.5-14.5||||F|||\ZHSDate-103\1030
OBX||NM|PLT^PLATELET COUNT - AUTOMATED||237|10(9)L|140-440||||F|||\ZHSDate-103\1030
OBX||NM|MPV^MEAN PLATELET VOLUME||10.1|UMx1000|8-11||||F|||\ZHSDate-103\1030
OBX||NM|NE^# NEUTROPHILS||3.02|#|1.8-8.5||||F|||\ZHSDate-103\1030
OBX||NM|LY^# LYMPHS||2.8|#|0.8-3.5||||F|||\ZHSDate-103\1030
OBX||NM|MO^# MONOS||0.69|#|0.2-0.9||||F|||\ZHSDate-103\1030
OBX||NM|EO^# EOSINOPHILS||0.01|#|0.0-0.6||||F|||\ZHSDate-103\1030
OBX||NM|BA^# BASOPHILS||0.01|#|0.0-0.2||||F|||\ZHSDate-103\1030
OBX||NM|PERCENTNE^Percent  NEUTROPHILS||48.3|Percent|40-80||||F|||\ZHSDate-103\1030
OBX||NM|PERCENTLY^Percent  LYMPHS||40.2|Percent|15-45||||F|||\ZHSDate-103\1030
OBX||ST|PLEST^PLATELET COUNT ESTIMATE||NORMAL||||||F|||\ZHSDate-103\1030
OBX||ST|SPR^PERFORM SLIDE REVIEW?||YES||||||F|||\ZHSDate-103\1030
OBX||ST|NM^MORPHOLOGY NORMAL||NON SPECIFIC CHANGES||||||F|||\ZHSDate-103\1030
OBX||NM|SEG^SEGMENTED NEUTROPHILS||58|Percent|50-75||||F|||\ZHSDate-103\1030
OBX||NM|LYMPHS^LYMPHOCYTES||31|Percent|20-44||||F|||\ZHSDate-103\1030
OBX||NM|MONO^MONOCYTES||7|Percent|2-9||||F|||\ZHSDate-103\1030
OBX||NM|ATYP^ATYPICAL LYMPHOCYTES||2|Percent|||||F|||\ZHSDate-103\1030

MSH|^~\&amp;||EMERGENCY|||||ORU^R01|||2.5
PID|||Ab443^^^EMERGENCY^MR||Simpson^Harold||19220203|M|||14 Tangier Lane^^Eton^Berks^SL4 6BB||||||||456112222
PV1||I|||||OO11^Scott^Peter|||||||EO|||||HSVN00003|||||||||||||||||||||||||\ZHSDate-108\130000|\ZHSDate-101\140500
ORC||LB123G|LB123G||||^^^\ZHSDate-102\1300||\ZHSDate-102\1300|||OO11^Scott^Peter|EMERGENCY||||||||EMERGENCY||||||||LAB
OBR||LB123G|LB123G|CBCD^CBC+ AUTOMATED DIFFERENTIAL^L|||\ZHSDate-108\1300|||||||\ZHSDate-102\1030|Blood|OO11^Scott^Peter||||||\ZHSDate-108\1620|||F
OBX||NM|WBC^WHITE BLOOD CELL COUNT||6.24|10(9)/L|4.0-10.6||||F|||\ZHSDate-102\1030
OBX||NM|RBC^RED BLOOD CELL COUNT||4.99|10x12/L|4.5-5.9||||F|||\ZHSDate-102\1030
OBX||NM|HGB^HEMOGLOBIN||13.6|g/dL|12.0-16.0||||F|||\ZHSDate-102\1030
OBX||NM|HCT^HEMATOCRIT||44.6|Percent|36.0-46.0||||F|||\ZHSDate-102\1030
OBX||NM|MCV^MEAN CELL VOLUME||83.4|fL|80-100||||F|||\ZHSDate-102\1030
OBX||NM|MCH^MEAN CELL HEMOGLOBIN||27.3|pg|26-34||||F|||\ZHSDate-102\1030
OBX||NM|MCHC^MEAN CELL HEMOGLOBIN CONC||32.7|g/dL|31-37||||F|||\ZHSDate-102\1030
OBX||NM|RDW^RED CELL DISTRIB WIDTH||14.1|Percent|11.5-14.5||||F|||\ZHSDate-102\1030
OBX||NM|PLT^PLATELET COUNT - AUTOMATED||237|10(9)L|140-440||||F|||\ZHSDate-102\1030
OBX||NM|MPV^MEAN PLATELET VOLUME||9.1|UMx1000|8-11||||F|||\ZHSDate-102\1030
OBX||NM|NE^# NEUTROPHILS||3.02|#|1.8-8.5||||F|||\ZHSDate-102\1030
OBX||NM|LY^# LYMPHS||2.51|#|0.8-3.5||||F|||\ZHSDate-102\1030
OBX||NM|MO^# MONOS||0.7|#|0.2-0.9||||F|||\ZHSDate-102\1030
OBX||NM|EO^# EOSINOPHILS||0.01|#|0.0-0.6||||F|||\ZHSDate-102\1030
OBX||NM|BA^# BASOPHILS||0.01|#|0.0-0.2||||F|||\ZHSDate-102\1030
OBX||NM|PERCENTNE^Percent  NEUTROPHILS||48.3|Percent|40-80||||F|||\ZHSDate-102\1030
OBX||NM|PERCENTLY^Percent  LYMPHS||40.2|Percent|15-45||||F|||\ZHSDate-102\1030
OBX||ST|PLEST^PLATELET COUNT ESTIMATE||NORMAL||||||F|||\ZHSDate-102\1030
OBX||ST|SPR^PERFORM SLIDE REVIEW?||YES||||||F|||\ZHSDate-102\1030
OBX||ST|NM^MORPHOLOGY NORMAL||NON SPECIFIC CHANGES||||||F|||\ZHSDate-102\1030
OBX||NM|SEG^SEGMENTED NEUTROPHILS||54|Percent|50-75||||F|||\ZHSDate-102\1030
OBX||NM|LYMPHS^LYMPHOCYTES||31|Percent|20-44||||F|||\ZHSDate-102\1030
OBX||NM|MONO^MONOCYTES||10|Percent|2-9||||F|||\ZHSDate-102\1030
OBX||NM|ATYP^ATYPICAL LYMPHOCYTES||7|Percent|||||F|||\ZHSDate-102\1030
</message>
}

XData Scenario3
{
<message>
MSH|^~\&amp;||EMERGENCY|||||ADT^A08|||2.5
EVN|A08|\ZHSDate-454\101000
PID|||S2345^^^EMERGENCY^MR||Johnson^Eric^Middle||19521001|M|||15 Trocadero^^Edinburgh^Lothian^EH2||||||||888123456
PV1||O|||||OO87^Farthing^Christine|||||||EO|||||HSVN00005|||||||||||||||||||||||||\ZHSDate-454\101000|\ZHSDate-454\101000
AL1||PC|PC^Penicillin|||

MSH|^~\&amp;||CGH|||||ORU^R01|||2.5
PID|||K4567^^^CGH^MR||Johnson^Eric||19521001|M|||15 Trocadero^^Edinburgh^Lothian^EH2||||||||888123456
PV1||E|||||OS12^Smith^Otto|||||||EO|||||HSVN00012|||||||||||||||||||||||||\ZHSDate-85\110000|\ZHSDate-85\110000
ORC||LB34567|LB34567||||^^^\ZHSDate-85\1200||\ZHSDate-85\1200|||OS12^Smith^Otto|CGH||||||||CGH||||||||LAB
OBR||LB3467|LB3467|CBCD^CBC+ AUTOMATED DIFFERENTIAL^L|||\ZHSDate-85\1200|||||||\ZHSDate-85\1245|Blood|OS12^Smith^Otto||||||\ZHSDate-332\1235|||F
OBX||NM|WBC^WHITE BLOOD CELL COUNT||6.24|10(9)/L|4.0-10.6||||F|||\ZHSDate-85\1200
OBX||NM|RBC^RED BLOOD CELL COUNT||4.99|10x12/L|4.5-5.9||||F|||\ZHSDate-85\1200
OBX||NM|HGB^HEMOGLOBIN||13.6|g/dL|12.0-16.0||||F|||\ZHSDate-85\1200
OBX||NM|HCT^HEMATOCRIT||41.6|Percent|36.0-46.0||||F|||\ZHSDate-85\1200
OBX||NM|MCV^MEAN CELL VOLUME||83.4|fL|80-100||||F|||\ZHSDate-85\1200
OBX||NM|MCH^MEAN CELL HEMOGLOBIN||27.3|pg|26-34||||F|||\ZHSDate-85\1200
OBX||NM|MCHC^MEAN CELL HEMOGLOBIN CONC||32.7|g/dL|31-37||||F|||\ZHSDate-85\1200
OBX||NM|RDW^RED CELL DISTRIB WIDTH||14.1|Percent|11.5-14.5||||F|||\ZHSDate-85\1200
OBX||NM|PLT^PLATELET COUNT - AUTOMATED||237|10(9)L|140-440||||F|||\ZHSDate-85\1200
OBX||NM|MPV^MEAN PLATELET VOLUME||10.1|UMx1000|8-11||||F|||\ZHSDate-85\1200
OBX||NM|NE^# NEUTROPHILS||3.02|#|1.8-8.5||||F|||\ZHSDate-85\1200
OBX||NM|LY^# LYMPHS||2.51|#|0.8-3.5||||F|||\ZHSDate-85\1200
OBX||NM|MO^# MONOS||0.69|#|0.2-0.9||||F|||\ZHSDate-85\1200
OBX||NM|EO^# EOSINOPHILS||0.01|#|0.0-0.6||||F|||\ZHSDate-85\1200
OBX||NM|BA^# BASOPHILS||0.01|#|0.0-0.2||||F|||\ZHSDate-85\1200
OBX||NM|PERCENTNE^Percent  NEUTROPHILS||48.3|Percent|40-80||||F|||\ZHSDate-85\1200
OBX||NM|PERCENTLY^Percent  LYMPHS||40.2|Percent|15-45||||F|||\ZHSDate-85\1200
OBX||ST|PLEST^PLATELET COUNT ESTIMATE||NORMAL||||||F|||\ZHSDate-85\1200
OBX||ST|SPR^PERFORM SLIDE REVIEW?||YES||||||F|||\ZHSDate-85\1200
OBX||ST|NM^MORPHOLOGY NORMAL||NON SPECIFIC CHANGES||||||F|||\ZHSDate-85\1200
OBX||NM|SEG^SEGMENTED NEUTROPHILS||54|Percent|50-75||||F|||\ZHSDate-85\1200
OBX||NM|LYMPHS^LYMPHOCYTES||31|Percent|20-44||||F|||\ZHSDate-85\1200
OBX||NM|MONO^MONOCYTES||13|Percent|2-9||||F|||\ZHSDate-85\1200
OBX||NM|ATYP^ATYPICAL LYMPHOCYTES||2|Percent|||||F|||\ZHSDate-85\1200
OBX||NM|PERCENTNE^Percent  NEUTROPHILS||48.3|Percent|40-80||||F|||\ZHSDate-85\1200
OBX||NM|PERCENTLY^Percent  LYMPHS||40.2|Percent|15-45||||F|||\ZHSDate-85\1200
</message>
}

}

