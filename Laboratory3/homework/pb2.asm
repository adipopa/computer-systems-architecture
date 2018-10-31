bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; 2. Additions, subtractions - Signed representation
    a db 57
    b dw -24114
    c dd 13524228
    d dq 374500000000

; our code starts here
segment code use32 class=code
    start:
        ; Problem 8 from each topic
        
        ; 2. Additions, subtractions (Signed representation) -> (b+c+d)-(a+a)
        mov ax, [b] ; AX = b
        
        cwde ; EAX = AX = b (signed conversion)
        
        add eax, [c] ; EAX = EAX + c + CF = b + c
        
        cdq ; EDX:EAX = EAX = b + c (signed conversion)
        
        add eax, [d]
        adc edx, [d+4] ; EDX:EAX = EDX:EAX + d + CF = b + c + d

        mov ecx, eax
        mov ebx, edx ; EBX:ECX = EDX:EAX = b + c + d
        
        mov al, [a] ; AL = a
        
        add al, [a] ; AL = a + a
        
        cbw ; AX = AL = a + a (signed conversion)
        cwde ; EAX = AX = a + a  (signed conversion)
        cdq ; EDX:EAX = EAX = a + a (signed conversion)
        
        sub ecx, eax
        sbb ebx, edx ; EBX:ECX = EBX:ECX - EDX:EAX = (b + c + d) - (a + a) [expected result: 374513500000]
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
