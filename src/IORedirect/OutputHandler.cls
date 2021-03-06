/// Description
Class IORedirect.OutputHandler [ Abstract ]
{

ClassMethod OutChar(char As %Integer) [ Abstract ]
{
    $$$ThrowStatus($$$ERROR($$$NotImplemented))
}

ClassMethod OutString(string As %String) [ Abstract ]
{
    $$$ThrowStatus($$$ERROR($$$NotImplemented))
}

ClassMethod OutFormFeed() [ Abstract ]
{
    $$$ThrowStatus($$$ERROR($$$NotImplemented))
}

ClassMethod OutNewLine() [ Abstract ]
{
    $$$ThrowStatus($$$ERROR($$$NotImplemented))
}

ClassMethod OutTab() [ Abstract ]
{
    $$$ThrowStatus($$$ERROR($$$NotImplemented))
}

ClassMethod OnStopRedirect() As %Status
{
    Quit $$$OK
}

}
