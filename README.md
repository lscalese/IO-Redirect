## IO-REDIRECT

This is a small library to handle IO redirect in ObjectScript.  

Features : 

* Redirect Output to stream.  
* Redirect Output to a global.
* Redirect Input from a stream.

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation 

Clone/git pull the repo into any local directory

```
$ git clone https://github.com/lscalese/IO-Redirect
```

Open the terminal in this directory and run:

```
$ docker-compose build
```

3. Run the IRIS container with your project:

```
$ docker-compose up -d
```

### By ZPM

```
zpm "install io-redirect"
```

## Run Unit Test

In Iris Terminal:

```
Set ^UnitTestRoot = "/irisrun/repo/test/"
Do ##class(%UnitTest.Manager).RunTest(,"/nodelete")
```

Or by zpm

```
zpm "test io-redirect"
```

## How It Works

It works in 3 steps : 

* Enable the IO Redirect.
* Call your code wich need Read\Write redirect.
* Disable IO Redirect and restore previous IO State.

Redirect is controlled by `IORedirect.Redirect` class and need IO handlers classname as parameters.  

```
Do ##class(IORedirect.Redirect).RedirectIO(<OutputHandler>,<InputHandler>)
```

`InputHandler` parameter is not mandatory.  

Current available handlers are :

| Handlers | Type | Description | Setup |
| -------- | ---- | ----------- | ----- |
| `IORedirect.OutputStream` | Output | Redirect Output to a stream | Set output stream with `Do ##class(IORedirect.OutputStream).SetStream(stream)` |
| `IORedirect.OutputGlobal` | Output | Redirect Output to a global | Set output global name with : <code>Do ##class(IORedirect.OutputGlobal).SetRedirectLocation($Name(^&#124;&#124;IORedirect))</code> |
| `IORedirect.InputStream` | Input | Read Input from a stream | Set input stream with `Do ##class(IORedirect.InputStream).SetStream(inputStream)` |
  
&nbsp;  
To disable IO Redirect simply call : 

```
Do ##class(IORedirect.Redirect).RestoreIO()
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

Do ##class(IORedirect.Redirect).RestoreIO()
Do ##class(IORedirect.Redirect).ClearConfig()

Do stream.OutputToDevice()
```

`Do ##class(IORedirect.Redirect).ToStream(stream)` is equivalent to :

```
Do ##class(IORedirect.Redirect).RedirectIO("IORedirect.OutputStream")
Do ##class(IORedirect.OutputStream).SetStream(stream)
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

`Do ##class(IORedirect.Redirect).ToGlobal($Name(^||IORedirect))` is equivalent to :  

```
Do ##class(IORedirect.Redirect).RedirectIO("IORedirect.OutputGlobal")
Do ##class(IORedirect.OutputGlobal).SetRedirectLocation($Name(^||IORedirect))
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
  
## Source

This development is inspired by [this community post](https://community.intersystems.com/post/rest-and-io-redirection).  

## Troubleshoot

### Across multiple namespaces

IORedirect does not work if the process switch to another namespace for Reading\Writting.  
You can easily fix this problem by adding a package mapping "IORedirect" on %ALL namespace.  


### \<PROTECT\>

Noticed by [Timothy Leavitt](https://community.intersystems.com/user/timothy-leavitt)·  

>One important note on I/O redirection, from the documentation:  
>When a process performs I/O redirection, this redirection is performed using the user’s login $ROLES value, not the current $ROLES value.
>In other words, if the I/O redirection is happening in a CSP application or privileged routine application context, in which matching or application roles are added that grant permissions on resources protecting assets the I/O functions need, you might get an unexpected <PROTECT> error, with roles seeming to disappear in wstr()/etc.
