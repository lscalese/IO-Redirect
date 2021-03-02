/// Description
Class PackageName.ClassName Extends %UnitTest.TestCase
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

    Set stream = ##class(IORedirect.OutputStream).Get()
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

    Set stream = ##class(%Stream.GlobalCharacter).%New()
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

}
