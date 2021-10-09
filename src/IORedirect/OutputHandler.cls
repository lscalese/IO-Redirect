Include IORedirect

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

/// Description
ClassMethod Echo(out As %String) As %Status
{
    Set currentIO = $IO
    Set currentMnemo = ##class(%Library.Device).GetMnemonicRoutine()
    Set currentRedirect = ##class(%Library.Device).ReDirectIO()

    If $Get($$$OldMnemonic) '= "" {
        Use $$$OldIO::("^"_$$$OldMnemonic)
    } Else {
        Use $$$OldIO
    }

    Do:##class(%Library.Device).ReDirectIO()'=$$$OldState ##class(%Library.Device).ReDirectIO($$$OldState)

    Write out

    If currentIO '= "" {
        Use currentIO::("^"_currentMnemo)
    } Else {
        Use currentIO
    }

    Do:##class(%Library.Device).ReDirectIO()'=currentRedirect ##class(%Library.Device).ReDirectIO(currentRedirect)
    
    Return $$$OK
}

}
