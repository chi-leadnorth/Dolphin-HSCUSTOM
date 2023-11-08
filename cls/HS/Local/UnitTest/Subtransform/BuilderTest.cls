<<<<<<< HEAD
Class HS.Local.UnitTest.Subtransform.BuilderTest Extends %RegisteredObject
=======
Class HS.Local.Unit.DOLPHIN.UnitTestClasses.BuilderTest Extends %RegisteredObject
>>>>>>> 7c97b8415f5531b2180e3ea138a1b16f3fb26899
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

