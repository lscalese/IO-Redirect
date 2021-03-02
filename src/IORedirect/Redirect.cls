Include IORedirect

Class IORedirect.Redirect
{

Parameter OUTPUTSTREAM = "IORedirect.OutputStream";

Parameter OUTPUTGLOBAL = "IORedirect.OutputGlobal";

Parameter INPUTSTREAM = "IORedirect.InputStream";

/// Class this method to Enable the redirect<br/>
/// OutputHandler must be a subclass name of IORedirect.OutputHandler<br/>
/// If you want to handle Input, you can fill InputHandler with a subclass name of IORedirect.InputHandler<br/>
ClassMethod RedirectIO(OutputHandler As %String, InputHandler As %String = "") As %Status
{
    Set $$$OldIO = $IO
    Set $$$OldMnemonic = ##class(%Library.Device).GetMnemonicRoutine()
    Set $$$OldState = ##class(%Library.Device).ReDirectIO()

    Do ..SetInputHandler(InputHandler), ..SetOuputHandler(OutputHandler)

    Use $IO::("^"_$ZNAME)

    Do ##class(%Library.Device).ReDirectIO(1)

    Quit $$$OK
}

/// Stop the redirect and restore original IO Setting.<br/>
ClassMethod RestoreIO() As %Status
{
    Quit:'$Data($$$OldState) $$$OK
    
    If $Get($$$OldMnemonic) '= "" {
        Use $$$OldIO::("^"_$$$OldMnemonic)
    } Else {
        Use $$$OldIO
    }

    Do ##class(%Library.Device).ReDirectIO($$$OldState)
    $$$KillOldStateData

    Do ..SetInputHandler(""), ..SetOuputHandler("")
    
    Quit $$$OK
}

/// Enable Output Redirection to a Stream object.
ClassMethod ToStream(stream As %Stream.Object = {##class(%Stream.GlobalCharacter).%New()}) As %Status
{
    $$$QuitOnError(..RedirectIO(..#OUTPUTSTREAM))
    $$$QuitOnError($CLASSMETHOD(..#OUTPUTSTREAM, "SetStream", stream))
    Quit $$$OK
}

/// Enable Output redirection to a global.
ClassMethod ToGlobal(global As %String = {$Name(^||IORedirect)}) As %Status
{
    $$$QuitOnError(..RedirectIO(..#OUTPUTGLOBAL))
    $$$QuitOnError($CLASSMETHOD(..#OUTPUTGLOBAL, "SetRedirectLocation", global))
    Quit $$$OK
}

ClassMethod InputStream(stream As %Stream.Object = {##class(%Stream.GlobalCharacter).%New()}) As %Status
{
    Do ..SetInputHandler(..#INPUTSTREAM), $CLASSMETHOD(..#INPUTSTREAM, "SetStream", stream)
    Quit $$$OK
}

ClassMethod SetOuputHandler(OutputHandler As %String) As %Status
{
    Set $$$RedirectOutputHandler = OutputHandler
    Quit $$$OK
}

ClassMethod GetOuputHandler() As %String [ CodeMode = expression ]
{
$$$RedirectOutputHandler
}

ClassMethod SetInputHandler(OutputHandler As %String) As %Status
{
    Set $$$RedirectInputHandler = OutputHandler
    Quit $$$OK
}

ClassMethod GetInputHandler() As %String [ CodeMode = expression ]
{
$$$RedirectInputHandler
}

ClassMethod ClearConfig() As %Status
{
    $$$ClearConfig
    Quit $$$OK
}

ClassMethod labels() [ ProcedureBlock = 0 ]
{
    Quit
rchr(c)      Quit:$Get($$$RedirectInputHandler)=""  Quit $CLASSMETHOD($$$RedirectInputHandler,"InChar", c)
rstr(sz,to)  Quit:$Get($$$RedirectInputHandler)=""  Quit $CLASSMETHOD($$$RedirectInputHandler,"InString", $g(sz), $g(to))
wchr(s)      Do $CLASSMETHOD($$$RedirectOutputHandler,"OutChar",s)  Quit
wstr(s)      Do $CLASSMETHOD($$$RedirectOutputHandler,"OutString",s)  Quit
wff()        Do $CLASSMETHOD($$$RedirectOutputHandler,"OutFormFeed")  Quit
wnl()        Do $CLASSMETHOD($$$RedirectOutputHandler,"OutNewLine")  Quit
wtab(s)      Do $CLASSMETHOD($$$RedirectOutputHandler,"OutTab")  Quit
}

}
