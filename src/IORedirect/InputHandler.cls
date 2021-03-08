Include IORedirect

Class IORedirect.InputHandler [ Abstract ]
{

Parameter USETIMEOUT = 0;

ClassMethod InChar() As %Integer [ Abstract ]
{
    $$$ThrowStatus($$$ERROR($$$NotImplemented))
}

ClassMethod InString(size As %Integer) As %String [ Abstract ]
{
    $$$ThrowStatus($$$ERROR($$$NotImplemented))
}

}
