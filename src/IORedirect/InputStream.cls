Include IORedirect

Class IORedirect.InputStream Extends InputHandler
{

/// Timeout parameter won't used in this subclass.
ClassMethod InChar() As %Integer
{
    Quit:'$ISOBJECT($Get($$$RedirectInputStream)) -1
    Quit $ASCII($$$RedirectInputStream.Read(1))
}

/// Timeout parameter won't used in this subclass.
ClassMethod InString(size As %Integer, timeout As %Integer) As %String
{
    Quit:'$ISOBJECT($Get($$$RedirectInputStream)) ""
    Quit:size="" $$$RedirectInputStream.ReadLine()
    Quit $$$RedirectInputStream.Read(size)
}

ClassMethod SetStream(stream As %Stream.Object = {##class(%Stream.GlobalCharacter).%New()}) As %Status
{
    Set $$$RedirectInputStream = stream
    Quit $$$OK
}

}
