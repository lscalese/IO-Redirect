Include IORedirect

Class IORedirect.OutputString Extends IORedirect.OutputHandler
{

ClassMethod Clear() As %Status
{
    Quit ..Set("")
}

ClassMethod Set(string As %String = "") As %Status
{
    Set $$$RedirectString = string
    Quit $$$OK
}

ClassMethod Get() As %Stream.Object
{
    Quit $Get($$$RedirectString)
}

ClassMethod OutChar(char As %Integer)
{
    Do ..OutString($Char(char))
    Quit
}

ClassMethod OutString(string As %String)
{
    Set $$$RedirectString = $$$RedirectString _ string
    Do:$Get($$$RedirectWithEcho)=$$$YES ..Echo(string)
    Quit
}

ClassMethod OutFormFeed()
{
    Do ..OutString($Char(12))
    Quit
}

ClassMethod OutNewLine()
{
    Do ..OutString($$$NL)
    Quit
}

ClassMethod OutTab()
{
    Do ..OutString($Char(9))
    Quit
}

ClassMethod OnStopRedirect() As %Status
{
    Quit $$$OK
}

}
