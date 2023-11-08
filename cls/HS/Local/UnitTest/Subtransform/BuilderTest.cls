Class HS.Local.UnitTest.Subtransform.BuilderTest Extends %RegisteredObject
{

// ClassMethod %New() As HS.Local.UnitTest.Subtransform.BuilderTest

ClassMethod BuilderTest()
{
    Set obj = ##class(HS.Local.UnitTest.Subtransform.BuilderTest).%OpenId($increment(^MyApp.MyTestClassD))
    Set obj.Name = ""
    Set obj.Value = ""
    Quit obj
}

Property Name As %String;

Property Value As %Integer;

Method WithName(name As %String) As HS.Local.UnitTest.Subtransform.BuilderTest
{
    Set ..Name = name
    Quit ..%This()
}

Method WithValue(value As %Integer) As HS.Local.UnitTest.Subtransform.BuilderTest
{
    Set ..Value = value
    Quit ..%This()
}

Method Transform() As HS.Local.UnitTest.Subtransform.BuilderTest
{
    Set ..Value = ..Value * 2
    Quit ..%This()
}

}

