Include IORedirect

Class IORedirect.InputHandler [ Abstract ]
{

ClassMethod InChar(char As %String) As %Integer [ Abstract ]
{
    $$$ThrowStatus($$$ERROR($$$NotImplemented))
}

ClassMethod InString(size As %Integer, timeout As %Integer) As %String [ Abstract ]
{
    $$$ThrowStatus($$$ERROR($$$NotImplemented))
}

}
