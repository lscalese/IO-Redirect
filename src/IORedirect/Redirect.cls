Include IORedirect

Class IORedirect.Redirect
{

Parameter OUTPUTSTREAM = "IORedirect.OutputStream";

Parameter OUTPUTGLOBAL = "IORedirect.OutputGlobal";

Parameter OUTPUTSTRING = "IORedirect.OutputString";

Parameter OUTPUTNULL;

Parameter INPUTSTREAM = "IORedirect.InputStream";

Parameter INPUTSTRING = "IORedirect.InputString";

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

    Set $$$RedirectWithEcho = $$$NO

    Do:$Get($$$RedirectOutputHandler)'="" $CLASSMETHOD($$$RedirectOutputHandler, "OnStopRedirect")
    
    Do ..SetInputHandler(""), ..SetOuputHandler("")
    
    Quit $$$OK
}

/// Return the output value depending the last used output hander:
/// OutputGlobal : String with the global name.
/// OutputString : String with the output value.
/// OutputStream : Stream with the output value.
ClassMethod Get() As %String
{
    Quit:$Get($$$LastOutputHandler)="" ""
    Quit $CLASSMETHOD($$$LastOutputHandler, "Get")
}

/// Enable Output Redirection to a Stream object.
ClassMethod ToStream(stream As %Stream.Object = {##class(%Stream.GlobalCharacter).%New()}, echo As %Boolean = {$$$NO}) As %Status
{
    Set $$$RedirectWithEcho = echo
    $$$QuitOnError(..RedirectIO(..#OUTPUTSTREAM))
    $$$QuitOnError($CLASSMETHOD(..#OUTPUTSTREAM, "Set", stream))
    Quit $$$OK
}

/// Enable output redirect to a string.
ClassMethod ToString(echo As %Boolean = {$$$NO}) As %Status
{
    Set $$$RedirectWithEcho = echo
    $$$QuitOnError(..RedirectIO(..#OUTPUTSTRING))
    $$$QuitOnError($CLASSMETHOD(..#OUTPUTSTRING, "Set", ""))
    Quit $$$OK
}

/// Enable output redirect to a file.
ClassMethod ToFileCharacter(fileName As %String, echo As %Boolean = {$$$NO})
{
    Set $$$RedirectWithEcho = echo
    Set exists = ##class(%File).Exists(fileName)
    #dim fcs As %Stream.FileCharacter = ##class(%Stream.FileCharacter).%New()
    Set dir = ##class(%File).GetDirectory(fileName)
    Do:'##class(%File).DirectoryExists(dir) ##class(%File).CreateDirectoryChain(dir)
    Do fcs.LinkToFile(fileName)
    Do:exists fcs.MoveToEnd()
    $$$QuitOnError(..RedirectIO(..#OUTPUTSTREAM))

    Quit $CLASSMETHOD(..#OUTPUTSTREAM, "SetStream", fcs)
}

/// Enable Output redirection to a global.
ClassMethod ToGlobal(global As %String = {$Name(^||IORedirect)}, echo As %Boolean = {$$$NO}) As %Status
{
    Set $$$RedirectWithEcho = echo
    $$$QuitOnError(..RedirectIO(..#OUTPUTGLOBAL))
    $$$QuitOnError($CLASSMETHOD(..#OUTPUTGLOBAL, "Set", global))
    Quit $$$OK
}

ClassMethod ToNull() As %Status
{
    Quit ..RedirectIO(..#OUTPUTNULL)
}

/// Enable Read from a stream.
ClassMethod InputStream(stream As %Stream.Object = {##class(%Stream.GlobalCharacter).%New()}) As %Status
{
    Do ..SetInputHandler(..#INPUTSTREAM), $CLASSMETHOD(..#INPUTSTREAM, "Set", stream)
    Quit $$$OK
}

ClassMethod InputFile(fileName As %String) As %Status
{
    If '##class(%File).Exists(fileName) {
        Quit $$$ERROR(5001, "File not found "_fileName)
    }
    #dim fcs As %Stream.FileCharacter = ##class(%Stream.FileCharacter).%New()
    Do fcs.LinkToFile(fileName)
    Do ..SetInputHandler(..#INPUTSTREAM), $CLASSMETHOD(..#INPUTSTREAM, "Set", fcs)
    Quit $$$OK
}

/// Enable Read from a string.
ClassMethod InputString(inputString As %String = "") As %Status
{
    Do ..SetInputHandler(..#INPUTSTRING), $CLASSMETHOD(..#INPUTSTRING, "Set", inputString)
    Quit $$$OK
}

ClassMethod SetOuputHandler(OutputHandler As %String) As %Status
{
    Set:OutputHandler'="" $$$LastOutputHandler = OutputHandler
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
rchr(c)      Quit:$Get($$$RedirectInputHandler)=""  Quit $$$CallReadChar($Get(c))
rstr(sz,to)  Quit:$Get($$$RedirectInputHandler)=""  Quit $$$CallReadString($g(sz),$g(to))
wchr(s)      Do:$Get($$$RedirectOutputHandler)'="" $CLASSMETHOD($$$RedirectOutputHandler,"OutChar",s)  Quit
wstr(s)      Do:$Get($$$RedirectOutputHandler)'="" $CLASSMETHOD($$$RedirectOutputHandler,"OutString",s)  Quit
wff()        Do:$Get($$$RedirectOutputHandler)'="" $CLASSMETHOD($$$RedirectOutputHandler,"OutFormFeed")  Quit
wnl()        Do:$Get($$$RedirectOutputHandler)'="" $CLASSMETHOD($$$RedirectOutputHandler,"OutNewLine")  Quit
wtab(s)      Do:$Get($$$RedirectOutputHandler)'="" $CLASSMETHOD($$$RedirectOutputHandler,"OutTab")  Quit
}

}
