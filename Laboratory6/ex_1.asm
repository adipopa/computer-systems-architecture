bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s db 'a', 'b', 'c', 'd', 'e' ; source string
    len_s equ $-s ; length of source string
    d times len_s db 0 ; destination string

; our code starts here
segment code use32 class=code
    start:
        ; initialisation
        
        mov ecx, len_s
        mov esi, s ; offset of source string
        mov edi, d ; offset of destination string
        cld ; clear DF (DF = 0)
        
        jecxz end_prog ; jump if ECX = 0
        
        read_byte:
            ; lodsb ; AL = a and ESI = ESI + 1
            ; stosb ; mov [d], AL and EDI = EDI + 1
            movsb
        loop read_byte
            
        end_prog:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
