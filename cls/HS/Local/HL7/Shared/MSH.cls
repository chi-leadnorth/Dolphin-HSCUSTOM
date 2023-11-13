Class HS.Local.HL7.Shared.MSH Extends Ens.DataTransformDTL [ DependsOn = EnsLib.HL7.Segment ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Segment' targetClass='EnsLib.HL7.Segment' sourceDocType='2.5.1:MSH' targetDocType='2.5.1:MSH' create='copy' language='objectscript' >
<assign value='aux("AACode")' property='target.{4}' action='set' />
<assign value='$P(aux("MessageType"),"^",1)' property='target.{9.1}' action='set' />
<assign value='$P(aux("MessageType"),"^",2)' property='target.{9.2}' action='set' />
<assign value='"2.5.1"' property='target.{12}' action='set' />
<if condition='..Length(source.{7.1}) &lt; 8' >
<true>
<assign value='$ZDATE($H,8)_$TR($ZTIME($H,1),":")' property='target.{7.1}' action='set' />
</true>
<false>
<if condition='..Length(source.{7.1}) &lt; 14' >
<true>
<assign value='$E(source.{7.1},1,8)_$TR($ZTIME($H,1),":")' property='target.{7.1}' action='set' />
</true>
</if>
</false>
</if>
<assign value='target.{2}' property='aux("EVNDate")' action='set' />
<assign value='target.{7.1}' property='aux("MSHDate")' action='set' />
</transform>
}

}

