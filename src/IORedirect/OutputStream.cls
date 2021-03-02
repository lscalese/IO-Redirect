Include IORedirect

Class IORedirect.OutputStream Extends IORedirect.OutputHandler
{

ClassMethod Clear() As %Status
{
    Set stream = $$$RedirectStream
    Do:$Isobject(stream) stream.Clear()
    Quit $$$OK
}

/// Description
ClassMethod SetStream(stream As %Stream.Object = {##class(%Stream.GlobalCharacter).%New()}) As %Status
{
    Set $$$RedirectStream = stream
    Quit $$$OK
}

ClassMethod Get() As %Stream.Object
{
    Quit:$ISOBJECT($Get($$$RedirectStream)) $$$RedirectStream
    Do ..SetStream()
    Quit $$$RedirectStream
}

ClassMethod OutChar(char As %Integer)
{
    Do ..OutString($Char(char))
    Quit
}

ClassMethod OutString(string As %String)
{
    Do ..Get().Write(string)
    Quit
}

ClassMethod OutFormFeed()
{
    Do ..OutString($Char(12))
    Quit
}

ClassMethod OutNewLine()
{
    Do ..OutString(..Get().LineTerminator)
    Quit
}

ClassMethod OutTab()
{
    Do ..OutString($Char(9))
    Quit
}

}
