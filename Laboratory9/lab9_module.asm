; 13. Three strings of characters are given. Show the longest common suffix for each of the three pairs of two strings that can be formed

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf ; add printf as extern function     
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll    ; tell the assembler that function printf is found in msvcrt.dll library

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s1 db 'd', 'e', 'f', 'g', 'h', 'x', 'y', 'z' ; declare the initial string s1
	l1 equ $-s1 ; l1 keeps the length of the initial string s1
    
    s2 db 'a', 'b', 'c', 'y', 'z' ; same for s2
    l2 equ $-s2 ; same for l2
    
    s3 db 'a', 'd', 'h', 'x', 'y', 'z' ; same for s3
    l3 equ $-s3 ; same for l3
    
	d times 100 db 0 ; reserve a memory space for the destination string d and initialize it
                      ; these will be the strings that will contain the longest common suffix for each of the three pairs
                     
    aux times 100 db 0 ; auxiliary string for reversing the output
    
    format_string db `The longest common suffix of strings s%d and s%d: %s\n`, 0 ; %d and %s will be replaced with a number and a string respectivly

; procedure definition
longest_common_suffix: 
    mov edi, 0 ; initialize EDI with 0
    
    checkCommonLetters:
            mov edx, [esp + 4]
            mov al, [edx + esi]
            
            mov edx, [esp + 4*2]
            mov cl, [edx + ebx]
            
            cmp al, cl
            jne nextPair
            
            mov [aux + edi], al
            inc edi
            
            dec esi
            dec ebx
            
            jmp checkCommonLetters
            
    nextPair:
    
    mov esi, 0
    mov ecx, 100
    
    reverseOutputString:
        mov bl, [aux + edi - 1]
        mov [d + esi], bl
        
        dec edi
        inc esi
        
    loop reverseOutputString
    
    ret

; our code starts here
segment code use32 class=code
    start:
        ; first step: compute the longest common suffix of the first and second string
    
        ; set the iterator registers to the length of the strings to compare minus one
        mov esi, l1 - 1
        mov ebx, l2 - 1
        
        ; push parameters s2 and s1 onto the stack from right to left
        push dword s2
        push dword s1
        call longest_common_suffix ; procedure call
        add esp, 4*2

        ; display the result
        push dword d
        push dword 2
        push dword 1
        push format_string
        call [printf]
        add esp, 4*4
        
        
        ; second step: compute the longest common suffix of the first and third string
    
        ; set the iterator registers to the length of the strings to compare minus one
        mov esi, l1 - 1
        mov ebx, l3 - 1
        
        ; push parameters s3 and s1 onto the stack from right to left
        push dword s3
        push dword s1
        call longest_common_suffix ; procedure call
        add esp, 4*2

        ; display the result
        push dword d
        push dword 3
        push dword 1
        push format_string
        call [printf]
        add esp, 4*4
        
        
        ; third and final step: compute the longest common suffix of the second and third string
    
        ; set the iterator registers to the length of the strings to compare minus one
        mov esi, l2 - 1
        mov ebx, l3 - 1
        
        ; push parameters s3 and s2 onto the stack from right to left
        push dword s3
        push dword s2
        call longest_common_suffix ; procedure call
        add esp, 4*2

        ; display the result
        push dword d
        push dword 3
        push dword 2
        push format_string
        call [printf]
        add esp, 4*4
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
