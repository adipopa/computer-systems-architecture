bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
                          
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    sir dd 1234A678h, 345678C8h, 4B5C1234h
    len equ ($-sir) / 4
    result_s times len dw 0
    no_of_bytes dd 0
    p_format db "%d"

; our code starts here
segment code use32 class=code
    start:
        xor eax, eax
        
        mov esi, sir
        mov edi, result_s
        mov ecx, len
        
        jecxz finish_alg
        
        parse_string:
            push ecx
            
            lodsd
            
            mov ebx, eax
            
            shr eax, 8
            shr ebx, 16
            
            mov ah, bh
            
            stosw
            
            pop ecx
        loop parse_string
        
        mov esi, result_s
        mov ecx, len
        
        count_bytes:
            push ecx
            
            lodsw
            
            mov ecx, 16
            inner_loop:
                shr eax, 1
                jnc not_a_one
                inc dword [no_of_bytes]
                not_a_one:
            loop inner_loop

            pop ecx
        loop count_bytes
        
        push dword [no_of_bytes]
        push dword p_format
        call [printf]
        add esp, 4*2
        
        finish_alg:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
