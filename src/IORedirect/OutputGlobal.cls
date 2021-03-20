Include IORedirect

Class IORedirect.OutputGlobal Extends IORedirect.OutputHandler
{

ClassMethod Clear() As %Status
{
    Kill @$$$RedirectGblName
    Quit $$$OK
}

ClassMethod SetRedirectLocation(globalName As %String = {$Name(^||IORedirect)}) As %Status [ Deprecated ]
{
    Quit ..Set(globalName)
}

ClassMethod Set(globalName As %String = {$Name(^||IORedirect)}) As %Status
{
    Set $$$RedirectGbl = globalName
    Quit $$$OK
}

ClassMethod Get() As %String [ CodeMode = expression ]
{
$$$RedirectGblName
}

ClassMethod OutChar(char As %Integer)
{
    Do ..OutString($Char(char))
}

ClassMethod OutString(string As %String)
{
    Set gbl = $$$RedirectGblName
    Set:'$Data(@gbl) @gbl = 1
    Set @gbl@(@gbl) =  $Get(@gbl@(@gbl)) _ string
    Quit
}

ClassMethod OutFormFeed()
{
    Do ..OutString($Char(12))
    Quit
}

ClassMethod OutNewLine() [ CodeMode = expression ]
{
$Increment(@$$$RedirectGblName)
}

ClassMethod OutTab()
{
    Do ..OutString($Char(9))
    Quit
}

}
