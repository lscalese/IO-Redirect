/// Description
Class UnitTest.IORedirect.Redirect Extends %UnitTest.TestCase
{

Method TestToStream() As %Status
{
    Set sc = $$$OK
    Set line1 = "Stream First line"
    Set line2 = "Stream second line"
    Set line3 = 65
    Set stream = ##class(%Stream.GlobalCharacter).%New()
    Do ##class(IORedirect.Redirect).ToStream(stream)
    
    Try {
        Write line1
        Write !,line2
        Write !
        Write *line3

    } Catch (ex) {
        Set sc = ex.AsStatus()
    }
    
    Do ##class(IORedirect.Redirect).RestoreIO()

    Do $$$AssertStatusOK(sc, "Redirect to stream")

    If $$$ISERR(sc) {
        Do ##class(IORedirect.Redirect).ClearConfig()
        Quit sc
    }

    Set stream = ##class(IORedirect.Redirect).Get()
    Do ##class(IORedirect.Redirect).ClearConfig()
    Do stream.Rewind()
    
    Do $$$LogMessage("Check stream result line 1")
    Do $$$AssertEquals(stream.ReadLine(), line1)

    Do $$$LogMessage("Check stream result line 2")
    Do $$$AssertEquals(stream.ReadLine(), line2)

    Do $$$LogMessage("Check stream result char")
    Do $$$AssertEquals(stream.ReadLine(), $Char(line3))

    Quit sc
}

Method TestToString() As %Status
{
    Set sc = $$$OK
    Set line1 = "String First line"
    Set line2 = "String second line"
    Set line3 = 65
    
    Do ##class(IORedirect.Redirect).ToString()
    
    Try {
        Write line1
        Write !,line2
        Write !
        Write *line3

    } Catch (ex) {
        Set sc = ex.AsStatus()
    }
    
    Do ##class(IORedirect.Redirect).RestoreIO()

    Do $$$AssertStatusOK(sc, "Redirect to string")

    If $$$ISERR(sc) {
        Do ##class(IORedirect.Redirect).ClearConfig()
        Quit sc
    }

    Set outputString = ##class(IORedirect.Redirect).Get()
    Do ##class(IORedirect.Redirect).ClearConfig()
    
    Do $$$LogMessage("Check string result line 1")
    Do $$$AssertEquals($Piece(outputString, $$$NL, 1), line1)

    Do $$$LogMessage("Check string result line 2")
    Do $$$AssertEquals($Piece(outputString, $$$NL, 2), line2)

    Do $$$LogMessage("Check string result char")
    Do $$$AssertEquals($ASCII($Piece(outputString, $$$NL, 3)), line3)

    Quit sc
}

Method TestToFileCharacter() As %Status
{
    Set sc = $$$OK
    Set line1 = "Stream First line"
    Set line2 = "Stream second line"
    Set line3 = 65
    
    Set fileName = $zu(12,"temp") _ "fcs.txt"
    Do:##class(%File).Exists(fileName) ##class(%File).Delete(fileName)

    Do ##class(IORedirect.Redirect).ToFileCharacter(fileName)
    Try {
        Write line1
        Write !,line2
        Write !
        Write *line3

    } Catch (ex) {
        Set sc = ex.AsStatus()
    }
    
    Do ##class(IORedirect.Redirect).RestoreIO()

    Do $$$AssertStatusOK(sc, "Redirect to stream")

    If $$$ISERR(sc) {
        Do ##class(IORedirect.Redirect).ClearConfig()
        Quit sc
    }

    Do $$$LogMessage("File Exists ?")
    Do $$$AssertEquals(##class(%File).Exists(fileName), 1)

    Set stream = ##class(%Stream.FileCharacter).%New()
    Do stream.LinkToFile(fileName)
    
    Do ##class(IORedirect.Redirect).ClearConfig()
    Do stream.Rewind()
    
    Do $$$LogMessage("Check stream result line 1")
    Do $$$AssertEquals(stream.ReadLine(), line1)

    Do $$$LogMessage("Check stream result line 2")
    Do $$$AssertEquals(stream.ReadLine(), line2)

    Do $$$LogMessage("Check stream result char")
    Do $$$AssertEquals(stream.ReadLine(), $Char(line3))

    Quit sc
}

Method TestToGlobal() As %Status
{
    Set sc = $$$OK
    Set line1 = "Stream First line"
    Set line2 = "Stream second line"
    Set line3 = 65
    
    Kill ^||IORedirect
    Do ##class(IORedirect.Redirect).ToGlobal($Name(^||IORedirect))

    Try {
        Write line1
        Write !,line2
        Write !
        Write *line3

    } Catch (ex) {
        Set sc = ex.AsStatus()
    }

    Do ##class(IORedirect.Redirect).RestoreIO()
    Do ##class(IORedirect.Redirect).ClearConfig()

    Do $$$AssertStatusOK(sc, "Redirect to stream")

    Quit:$$$ISERR(sc) sc
    
    Do $$$LogMessage("Check ^||IORedirect(1) result line 1")
    Do $$$AssertEquals($Get(^||IORedirect(1)), line1)

    Do $$$LogMessage("Check ^||IORedirect(2) result line 2")
    Do $$$AssertEquals($Get(^||IORedirect(2)), line2)

    Do $$$LogMessage("Check ^||IORedirect(3) result char")
    Do $$$AssertEquals($Get(^||IORedirect(3)), $Char(line3))

    Kill ^||IORedirect

    Quit sc
}

Method TestIORedirect() As %Status
{
    Set sc = $$$OK
    Set inputStream = ##class(%Stream.GlobalCharacter).%New()
    
    Set inputLine1 = "This is my input line 1"
    Do inputStream.WriteLine(inputLine1)
    Do inputStream.Rewind()

    Set line1 = "This is a test with Input and Output redirect"
    Set line2 = "Now, we READ something:"
    Set line3 = "Read line is : "
    Set line4 = inputLine1

    Kill ^||IORedirect
    
    Do ##class(IORedirect.Redirect).ToGlobal($Name(^||IORedirect))
    Do ##class(IORedirect.Redirect).InputStream(inputStream)
    
    Try {
        Write line1
        Write !,line2
        READ x:2
        Write !,line3
        Write !,x

    } Catch (ex) {
        Set sc = ex.AsStatus()
    }

    Do ##class(IORedirect.Redirect).RestoreIO()
    Do ##class(IORedirect.Redirect).ClearConfig()

    Do $$$AssertStatusOK(sc, "Redirect to stream")

    Quit:$$$ISERR(sc) sc
    
    Do $$$LogMessage("Check ^||IORedirect(1) result line 1")
    Do $$$AssertEquals($Get(^||IORedirect(1)), line1)

    Do $$$LogMessage("Check ^||IORedirect(2) result line 2")
    Do $$$AssertEquals($Get(^||IORedirect(2)), line2)

    Do $$$LogMessage("Check ^||IORedirect(3) result line 3")
    Do $$$AssertEquals($Get(^||IORedirect(3)), line3)

    Do $$$LogMessage("Check ^||IORedirect(4) result line 4")
    Do $$$AssertEquals($Get(^||IORedirect(4)), line4)

    Do $$$LogMessage("Check Input value")
    Do $$$AssertEquals($Get(x), inputLine1)

    Kill ^||IORedirect

    Quit sc
}

Method TestInputString() As %Status
{
    Set sc = $$$OK
    
    Set inputString = "This is my input line 1" _ $$$NL _ $Char(65)

    Set line1 = "This is a test with Input and Output redirect"
    Set line2 = "Now, we READ something:"
    Set line3 = "Read line is : "
    Set line4 = $Piece(inputString, $$$NL, 1)

    Kill ^||IORedirect
    
    Do ##class(IORedirect.Redirect).ToGlobal($Name(^||IORedirect))
    Do ##class(IORedirect.Redirect).InputString(inputString)
    
    Try {
        Write line1
        Write !,line2
        READ x:2
        Write !,line3
        Write !,x
        Read *char:2

    } Catch (ex) {
        Set sc = ex.AsStatus()
    }

    Do ##class(IORedirect.Redirect).RestoreIO()
    Do ##class(IORedirect.Redirect).ClearConfig()

    Do $$$AssertStatusOK(sc, "Redirect to stream")

    Quit:$$$ISERR(sc) sc
    
    Do $$$LogMessage("Check ^||IORedirect(1) result line 1")
    Do $$$AssertEquals($Get(^||IORedirect(1)), line1)

    Do $$$LogMessage("Check ^||IORedirect(2) result line 2")
    Do $$$AssertEquals($Get(^||IORedirect(2)), line2)

    Do $$$LogMessage("Check ^||IORedirect(3) result line 3")
    Do $$$AssertEquals($Get(^||IORedirect(3)), line3)

    Do $$$LogMessage("Check ^||IORedirect(4) result line 4")
    Do $$$AssertEquals($Get(^||IORedirect(4)), line4)

    Do $$$LogMessage("Check Input value")
    Do $$$AssertEquals($Get(x), line4)

    Do $$$LogMessage("Check Input char")
    Do $$$AssertEquals($Get(char), 65)

    Kill ^||IORedirect

    Quit sc
}

}
