; 26. A string of doublewords is given. Compute the string formed by the high bytes of the low words from the elements of the doubleword string and these bytes should be multiple of 10.

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s dd 12345678h, 1A2B3C4Dh, 9E98DC76h ; the initial string s
    l equ ($-s) / 4 ; the length of the string (in doublewords)
	ten db 10 ; variabile used for testing divisibility by 10
    d times l db 0 ; reserve a memory space of l for the destination string d and initialize it

; our code starts here
segment code use32 class=code
    start:
        mov esi, s ; in esi we will store the FAR address of the string 's'
        cld ; parse the string from left to right (DF = 0)
        mov ecx, l ; we will parse the elements of the string in the loop with l iterations
        mov edi, d ; in edi we will store the FAR address of the string 'd'
        
        jecxz finishProgram ; end the program if ECX is zero (s is an empty string)
        
        multiplesOfTen:
            lodsd ; in eax we will have the current doubleword from the string
            
            shr eax, 8 ; we are interested in the high byte (most significant) of the low word (least significant) of the current doubleword (AH)
            mov ah, 0 ; so we shift eax 8 positions to the right so the high byte will now be in AL
            
            push ax ; push the value of AL to the stack before we make the division
            
            div byte[ten] ; check whether AL is divisible by 10
            cmp ah, 0 ; if the remainder is 0, resume the loop 'multiplesOfTen' else add the current byte to the destination string 'd'
            
            jnz nonDivisible
            
            pop ax ; pop the value from the stack back to AL
            stosb ; store the value of the byte AL in EDI
            
            nonDivisible:
            
        loop multiplesOfTen ; if there are more elements (ecx>0) resume the loop.
        
        finishProgram: ; the end of the program
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
