Procedure.s EncodeString(Input.s)
  Encoded.s = Space(1024)
  Base64Encoder(@Input, StringByteLength(Input), @Encoded, 1024)
  ProcedureReturn Encoded
EndProcedure 


Procedure.s DecodeString(Input.s)
  Decoded.s = Space(1024)
  Base64Decoder(@Input, StringByteLength(Input), @Decoded, 1024)
  ProcedureReturn Decoded
EndProcedure

Address$ = EncodeString("bitcoin address"); enter your bitcoin address here

If CreateFile(0, "based.txt")
  WriteString(0, Address$)
EndIf

Debug Address$ 
Debug DecodeString(Address$)
; IDE Options = PureBasic 5.50 (Windows - x86)
; CursorPosition = 15
; Folding = -
; EnableXP