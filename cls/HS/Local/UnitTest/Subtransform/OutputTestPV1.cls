<<<<<<< HEAD
Class HS.Local.UnitTest.Subtransform.OutputTestPV1 Extends Ens.Rule.Definition
=======
Class HS.Local.Unit.DOLPHIN.UnitTestClasses.OutputTestPV1 Extends Ens.Rule.Definition
>>>>>>> 7c97b8415f5531b2180e3ea138a1b16f3fb26899
{

Parameter RuleAssistClass = "EnsLib.HL7.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.HL7.MsgRouter.RoutingEngine" production="TEAM2SANDBOXPKG.EdgeGatewayProduction">
        <ruleSet name="" effectiveBegin="" effectiveEnd="">
            <rule name="Transform">
                <when condition="1">
                    <send transform="TEAM2SANDBOXPKG.DolphinPV1" target="HS.Gateway.HL7.InboundProcess"></send>
                </when>
            </rule>
        </ruleSet>
        </ruleDefinition>
}

}

