bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; 1. Additions, subtractions - Unsigned representation
    a db 204
    b dw 43000
    d dq 84835800000

; our code starts here
segment code use32 class=code
    start:
        ; Problem 8 from each topic
        
        ; 1. Additions, subtractions (Unsigned representation) -> (a+b-d)+(a-b-d)
        mov al, [a] ; AL = a
        mov ah, 0 ; AX = AL = a (unsigned conversion)
        
        add ax, [b] ; AX = AX + b = a + b
        
        mov dx, 0 ; DX:AX = AX = a + b (unsigned conversion)
        
        push dx
        push ax
        pop eax ; EAX = DX:AX = a + b
        
        mov edx, 0 ; EDX:EAX = EAX = a + b (unsigned conversion)
        
        add eax, [d]
        adc edx, [d+4] ; EDX:EAX = EDX:EAX + d + CF = a + b + d [expected result: 84835843204]
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
