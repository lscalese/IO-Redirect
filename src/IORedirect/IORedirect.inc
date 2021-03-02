ROUTINE IORedirect [Type=INC]

 ; #Define OldStateData            %zIORedirect

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