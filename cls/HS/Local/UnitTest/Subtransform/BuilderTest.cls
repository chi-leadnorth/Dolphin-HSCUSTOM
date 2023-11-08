Class HS.Local.UnitTest.Subtransform.BuilderTest Extends %RegisteredObject
{

// ClassMethod %New() As DOLPHIN.BuilderTest

ClassMethod BuilderTest()
{
    Set obj = ##class(DOLPHIN.BuilderTest).%OpenId($increment(^MyApp.MyTestClassD))
    Set obj.Name = ""
    Set obj.Value = ""
    Quit obj
}

Property Name As %String;

Property Value As %Integer;

Method WithName(name As %String) As DOLPHIN.BuilderTest
{
    Set ..Name = name
    Quit ..%This()
}

Method WithValue(value As %Integer) As DOLPHIN.BuilderTest
{
    Set ..Value = value
    Quit ..%This()
}

Method Transform() As DOLPHIN.BuilderTest
{
    Set ..Value = ..Value * 2
    Quit ..%This()
}

}

