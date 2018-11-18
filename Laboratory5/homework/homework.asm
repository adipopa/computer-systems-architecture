; 8. A character string S is given. Obtain the string D that contains all capital letters of the string S. 

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s db 'a', 'A', 'b', 'B', '2', '%', 'x', 'M' ; declare the initial string s
	l equ $-s ; l keeps the length of the initial string s
	d times l db 0 ; reserve a memory space of l for the destination string d and initialize it

; our code starts here
segment code use32 class=code
    start:
        mov ecx, l ; we put the length in ECX for iterating through the loop for l times
        mov esi, 0 ; initialize ESI with 0
        mov edi, 0 ; initialize EDI with 0
        
        jecxz finishProgram ; end the program if ECX is zero (s is an empty string)
        
        keepCapitalLetters:
            mov al, [s + esi] ; move a letter from the string s to AL
            
            mov bl, 'A' ; move the character 'A' to BL
            cmp al, bl ; compare AL with BL (current letter of s with character 'A')
            jb skipCurrent ; skip the current character if AL < BL (a < 'A')
            
            mov bl, 'Z' ; move the character 'Z' to BL
            cmp al, bl ; compare AL with BL (current letter of s with character 'Z')
            ja skipCurrent ; skip the current character if AL > BL (a > 'Z')
            
            mov [d + edi], al ; if the character is a capital letter add it to the destination string d
            inc edi ; increment EDI
            
            skipCurrent:
            inc esi ; increment ESI
            
        loop keepCapitalLetters ; start the main loop
        
        finishProgram: ; the end of the program
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
