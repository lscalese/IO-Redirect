ROUTINE IORedirect [Type=INC]

#Define OldIO                   %zIORedirect("OldIO")
#Define OldMnemonic             %zIORedirect("OldMnemonic")
#Define OldState                %zIORedirect("OldState")
#Define KillOldStateData        Kill $$$OldState, $$$OldMnemonic, $$$OldIO

#Define RedirectOutputHandler   %zIORedirect("OutputHandler")
#Define RedirectInputHandler    %zIORedirect("InputHandler")

#Define RedirectGbl             %zIORedirect("OutputGlobalName")
#Define RedirectGblName         $Get($$$RedirectGbl, $Name(^||IORedirect))

#Define RedirectStream          %zIORedirect("OutStream")
#Define RedirectInputStream     %zIORedirect("InputStream")

#Define ClearConfig             Kill %zIORedirect

#Define InputHandlerUTimeout    ($CLASSMETHOD($$$RedirectInputHandler,"%GetParameter","USETIMETOUT")=1)

#Define CallReadChar(%timeout)          $SELECT($$$InputHandlerUTimeout:$CLASSMETHOD($$$RedirectInputHandler,"InChar", %timeout),1:$CLASSMETHOD($$$RedirectInputHandler,"InChar"))
#Define CallReadString(%size,%timeout)  $SELECT($$$InputHandlerUTimeout:$CLASSMETHOD($$$RedirectInputHandler,"InString",%size,%timeout),1:$CLASSMETHOD($$$RedirectInputHandler,"InString",%size))
