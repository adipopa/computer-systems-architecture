; Se citește un număr N și după N numere, să se calculeze suma lor(S) și să se scrie în fișier numerele de la 0 la S în binar. S<256

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf, fopen, fprintf, fclose               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
import scanf msvcrt.dll
import fopen msvcrt.dll
import fprintf msvcrt.dll
import fclose msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    msg_r db "N = ", 0
    
    n dd 0
    format_r db "%d", 0
    
    max equ 100
    int_list times 100 dd 0
    
    current_no dd 0
    msg_r_list db "Number %d: ", 0
    
    file_name db "output.txt", 0
    access_mode db "w", 0
    file_descriptor dd -1
    
    binary_no times 9 db 0
    format_p db "%s", 10, 0

; our code starts here
segment code use32 class=code
    start:
        push msg_r
        call [printf]
        add esp, 4 * 1
        
        push dword n
        push dword format_r
        call [scanf]
        add esp, 4 * 2
        
        mov ebx, 0
        mov ecx, dword [n]
        
        readNumbers:
            push ecx
            
            push ebx
            push msg_r_list
            call [printf]
            add esp, 4 * 2
            
            push dword current_no
            push dword format_r
            call [scanf]
            add esp, 4 * 2
            
            mov eax, [current_no]
            
            mov dword [int_list + ebx * 4], eax
            
            inc ebx
            pop ecx
        loop readNumbers
        
        push dword access_mode
        push dword file_name
        call [fopen]
        add esp, 4 * 2
        
        cmp eax, 0
        je finishProgram
        
        mov [file_descriptor], eax
        
        mov ecx, ebx
        mov ebx, 0
        
        printNumbers:
            push ecx
            
            mov eax, dword [int_list + ebx * 4]
            
            mov ecx, 8
            convertToBinary:
                shr eax, 1
                jnc zeroBit
                mov byte [binary_no + ecx - 1], '1'
                jmp endIf
                zeroBit:
                mov byte [binary_no + ecx - 1], '0'
                endIf:
            loop convertToBinary
            
            push dword binary_no
            push dword format_p
            push dword [file_descriptor]
            call [fprintf]
            add esp, 4 * 3
            
            inc ebx
            pop ecx
        loop printNumbers
        
        push dword [file_descriptor]
        call [fclose]
        add esp, 4 * 1
        
        finishProgram:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
