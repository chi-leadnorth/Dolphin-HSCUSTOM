Class HS.Local.Unit.DOLPHIN.UnitTestAPI.OwnPaceLearning Extends %RegisteredObject
{

ClassMethod OperatorsExpressions()
{
        // Operators and Expressions
    // Assignment 
       set value = 0
       set value = " a + b"

       SET pies = "apple,banana,cherry"
       WRITE "Before: ",pies,!

 // set the 3rd comma-delimited piece of pies to coconut
       SET $Piece(pies,",",3) = "coconut"
       WRITE "After: ",pies
}

}

