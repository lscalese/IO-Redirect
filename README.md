## IRIS-IO-REDIRECT

This is a small library to handle IO redirect with ObjectScript.  

Features : 

* Redirect Output to stream.  
* Redirect Output to a global.
* Redirect Input from a stream.

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation 

Clone/git pull the repo into any local directory

```
$ git clone https://github.com/lscalese/IRIS-IO-Redirect
```

Open the terminal in this directory and run:

```
$ docker-compose build
```

3. Run the IRIS container with your project:

```
$ docker-compose up -d
```

## Run Unit Test

In Iris Terminal:

```
Set ^UnitTestRoot = "/irisrun/repo/test/"
Do ##class(%UnitTest.Manager).RunTest(,"/nodelete")
```

Or by zpm

```
zpm "test iris-io-redirect"
```

## Samples

### Redirect Output to Stream

```
Set line1 = "Stream First line"
Set line2 = "Stream second line"
Set line3 = 65
Set stream = ##class(%Stream.GlobalCharacter).%New()

Do ##class(IORedirect.Redirect).ToStream(stream)

Write line1
Write !,line2
Write !
Write *line3
Set stream = ##class(IORedirect.OutputStream).Get()

Do ##class(IORedirect.Redirect).RestoreIO()
Do ##class(IORedirect.Redirect).ClearConfig()

Do stream.OutputToDevice()
```

### Redirect Output to a global

```
Set sc = $$$OK
Set line1 = "Stream First line"
Set line2 = "Stream second line"
Set line3 = 65
Kill ^||IORedirect

Do ##class(IORedirect.Redirect).ToGlobal($Name(^||IORedirect))

Write line1
Write !,line2
Write !
Write *line3

Do ##class(IORedirect.Redirect).RestoreIO()
Do ##class(IORedirect.Redirect).ClearConfig()

Zwrite ^||IORedirect
Kill ^||IORedirect
```

### Redirect Input from a stream

In the following example, we redirect the IO Into a global and the input is in a stream object.  

```
Set inputStream = ##class(%Stream.GlobalCharacter).%New()
Set inputLine1 = "This is my input line 1"
Do inputStream.WriteLine(inputLine1)
Do inputStream.Rewind()

Set line1 = "This is a test with Input and Output redirect"
Set line2 = "Now, we READ something:"
Set line3 = "Read line is : "

Set stream = ##class(%Stream.GlobalCharacter).%New()
Kill ^||IORedirect

Do ##class(IORedirect.Redirect).ToGlobal($Name(^||IORedirect))
Do ##class(IORedirect.Redirect).InputStream(inputStream)
    
Write line1
Write !,line2
READ x:2
Write !,line3
Write !,x

Do ##class(IORedirect.Redirect).RestoreIO()
Do ##class(IORedirect.Redirect).ClearConfig()

Write !,"Read input value in var x is : ", !, x, !
Write !,"Output global ^||IORedirect : "
ZWrite ^||IORedirect
Kill ^||IORedirect
```

### Across multiple namespaces

IORedirect does not work if the process switch to another namespace for Reading\Writting.  
You can easily fix this problem by adding a package mapping "IORedirect" on %ALL namespace.  