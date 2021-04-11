/// 
Class IORedirect.OutputNull Extends IORedirect.OutputHandler
{
ClassMethod OutChar(char As %Integer)
{
    Quit
}

ClassMethod OutString(string As %String)
{
    Quit
}

ClassMethod OutFormFeed()
{
    Quit
}

ClassMethod OutNewLine()
{
    Quit
}
ClassMethod OutTab()
{
    Quit
}

}