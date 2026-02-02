{ Game   : Wuthering Waves  
  Version: 
  Date   : 2025-03-28
  Author : A d m i n i s t r a t o r
}
define(Camera_address,$process+4380FD0)
define(Camera_bytes,F2 41 0F 10 45 00)
[ENABLE]
assert(Camera_address,Camera_bytes)
alloc(newmem,$1000,Camera_address)
label(code)
label(return)
label(YawRadian PitchRadian DeltaX DeltaZ DeltaY)
$process+4467953: //; all xyz (camera & player & etc )
db 90 90 90 90 90 90 90 90
newmem:
push rcx
mov rcx,0x57
call GetAsyncKeyState
test eax,eax
pop rcx
jz @f

   //; Yaw
   fldpi
   fdiv dword ptr [fPI]
   fmul dword ptr [r13+10]
   fstp dword ptr [YawRadian]

   //; Pitch
   fldpi
   fdiv dword ptr [fPI]
   fmul dword ptr [r13+C]
   fstp dword ptr [PitchRadian]

   //; X (COS)
   fld dword ptr [YawRadian]
   fcos
   fmul dword ptr [BySpeed]
   fstp dword ptr [DeltaX]

   //; Z (SIN)
   fld dword ptr [YawRadian]
   fsin
   fmul dword ptr [BySpeed]
   fstp dword ptr [DeltaZ]

   //; Y (SIN)
   fld dword ptr [PitchRadian]
   fsin
   fmul dword ptr [BySpeed]
   fstp dword ptr [DeltaY]

   //; VecX
   fld dword ptr [r13]
   fadd dword ptr [DeltaX]
   fstp dword ptr [r13]

   //; VecZ
   fld dword ptr [r13+4]
   fadd dword ptr [DeltaZ]
   fstp dword ptr [r13+4]

   //; VecY
   fld dword ptr [r13+8]
   fadd dword ptr [DeltaY]
   fstp dword ptr [r13+8]

code:
  //movsd xmm0,[r13+00]
  pop rbx
  jmp return

YawRadian:
dq 00

PitchRadian:
dq 00

DeltaX:
dq 00
DeltaZ:
dq 00
DeltaY:
dq 00

fPI:
dd (float)180
BySpeed:
dd (float)10
Camera_address:
  jmp newmem
  nop
return:
[DISABLE]
$process+4467953: //; all shared
db 44 0F 11 9B F0 01 00 00
Camera_address:
  db Camera_bytes
unregistersymbol(Camera_address fCamera YawRadian PitchRadian DeltaX DeltaZ DeltaY SpeedUP)
dealloc(newmem)
