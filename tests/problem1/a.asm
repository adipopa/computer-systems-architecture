bits 32

global start

extern exit, printf
import exit msvcrt.dll
import printf msvcrt.dll

extern compute_byte_ranks

segment data use32 class=data
    sir dd 1234A678h, 12345678h, 01AC3B47Dh, 0DCFE9876h
    len equ ($ - sir) / 4 ; len of string sir in doublewords
    
    rsir times len dd 0 ; the result string
    
    sum dd 0
    
    p_format db "%d", 0
    p_sum_format db " - the sum of these bytes: %d", 0
    
segment code use32 class=code
    start:
        xor eax, eax
        
        push dword len
        push dword rsir
        push dword sir
        call compute_byte_ranks
        
        mov dword [sum], eax

        mov esi, rsir
        mov ecx, len
        
        jecxz end_program

        print_ranks:
            push ecx

            lodsd
            
            push eax
            push dword p_format
            call [printf]
            add esp, 4*2
            
            pop ecx
        loop print_ranks
        
        push dword [sum]
        push dword p_sum_format
        call [printf]
        add esp, 4*2
        
        end_program:
    
        push dword 0
        call [exit]