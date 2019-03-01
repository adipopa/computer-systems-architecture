bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf, fopen, fread, fclose               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
import scanf msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    msg_r db "File name: ", 0
    
    file_name times 100 db 0
    format_r db "%s", 0
    
    access_mode db "r", 0
    file_descriptor dd -1
    
    text times 100 db 0
    len dd 0
    
    current_char dd 0
    is_last_word dd 0
    
    format_p db "%c", 0
    
    format_newline db 10, 0

; our code starts here
segment code use32 class=code
    start:
        push dword msg_r
        call [printf]
        add esp, 4 * 1
        
        push dword file_name
        push dword format_r
        call [scanf]
        add esp, 4 * 2
        
        push dword access_mode
        push dword file_name
        call [fopen]
        add esp, 4 * 2
        
        cmp eax, 0
        je stopProgram
        
        mov [file_descriptor], eax
        
        push dword [file_descriptor]
        push dword 100
        push dword 1
        push dword text
        call [fread]
        add esp, 4 * 4
        
        mov dword [len], eax
        
        push dword [file_descriptor]
        call [fclose]
        add esp, 4 * 1
        
        xor ebx, ebx
        mov ecx, [len]
        iterateText:
            push ecx
            
            mov bl, [text + ecx - 1]
            mov [current_char], ebx
            
            cmp [current_char], dword ' '
            jne notTrue1
            mov [is_last_word], dword 0
            notTrue1:
            
            cmp [is_last_word], dword 1
            jne skipChar
            
            push dword [current_char]
            push dword format_p
            call [printf]
            add esp, 4 * 2
            
            skipChar:
            
            cmp [current_char], dword '.'
            jne notTrue2
            mov [is_last_word], dword 1
            
            push dword format_newline
            call [printf]
            add esp, 4 * 1
            
            notTrue2:
            
            pop ecx
        loop iterateText
            
        push dword format_newline
        call [printf]
        add esp, 4 * 1
        
        stopProgram:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
