Class HS.Local.UnitTest.Subtransform.OutputTestPID Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.HL7.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.HL7.MsgRouter.RoutingEngine" production="TEAM2SANDBOXPKG.EdgeGatewayProduction">
        <ruleSet name="" effectiveBegin="" effectiveEnd="">
            <rule name="Transform">
                <when condition="1">
                    <send transform="TEAM2SANDBOXPKG.DolphinPID" target="HS.Gateway.HL7.InboundProcess"></send>
                </when>
            </rule>
        </ruleSet>
        </ruleDefinition>
}

}

