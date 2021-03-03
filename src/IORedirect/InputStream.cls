Include IORedirect

Class IORedirect.InputStream Extends InputHandler
{

ClassMethod InChar(char As %String) As %Integer
{
    Quit:'$ISOBJECT($Get($$$RedirectInputStream)) -1
    Quit $ASCII($$$RedirectInputStream.Read(1))
}

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
