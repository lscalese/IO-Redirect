Include IORedirect

Class IORedirect.InputString Extends InputHandler
{

/// Timeout parameter won't used in this subclass.
ClassMethod InChar() As %Integer
{
    Set char = $ASCII($Extract(..Get()))
    Do ..Set($Extract(..Get(), 2, *))
    Quit char
}

/// Timeout parameter won't used in this subclass.
ClassMethod InString(size As %Integer) As %String
{
    If size '= "" {
        Set buffer = $Extract(..Get(), 1, size)
        Do ..Set($Extract(..Get(), size+1, *))
        Quit buffer
    }

    Set buffer = $Piece(..Get(), $$$NL, 1)
    Do ..Set($Piece(..Get(), $$$NL, 2, *))
    Quit buffer
}

ClassMethod Get() As %String [ CodeMode = expression ]
{
$Get($$$RedirectInputString)
}

ClassMethod Set(string As %String = "") As %Status
{
    Set $$$RedirectInputString = string
    Quit $$$OK
}

}
