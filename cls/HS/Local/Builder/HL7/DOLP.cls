Class HS.Local.Builder.HL7.DOLP Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="TEAM1SANDBOXPKG.D.DOLP" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="MsgRouter" Category="" ClassName="EnsLib.HL7.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="This handles message routing logic." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Validation"></Setting>
    <Setting Target="Host" Name="BusinessRuleName">TEAM1SANDBOXPKG.D.DOLP.RoutingRule</Setting>
    <Setting Target="Host" Name="BadMessageHandler">BadMessageHandler</Setting>
  </Item>
  <Item Name="HL7FileService" Category="" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="This is a default HL7 File Service." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">MsgRouter</Setting>
    <Setting Target="Host" Name="MessageSchemaCategory">2.8</Setting>
    <Setting Target="Adapter" Name="ArchivePath">C:\DOLPHIN PROJECT\in\archive\</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\DOLPHIN PROJECT\in\</Setting>
    <Setting Target="Adapter" Name="WorkPath"></Setting>
  </Item>
  <Item Name="HL7FileOperation" Category="" ClassName="EnsLib.HL7.Operation.FileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="This is a default HL7 File Operation." LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Filename">DOLPHIN</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\DOLPHIN PROJECT\out\</Setting>
  </Item>
</Production>
}

}

