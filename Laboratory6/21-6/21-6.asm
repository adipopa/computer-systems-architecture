; 21. Being given a string of words, obtain the string (of bytes) of the digits in base 10 of each word from this string.

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    sir dw 12345, 20778, 4596  ; the initial string sir
    l equ ($-sir) / 2 ; the length of the string (in words)
	ten dw 10 ; variabile used for getting the right most digit of a number
    dest times l db 0 ; reserve a memory space of l for the destination string dest and initialize it

; our code starts here
segment code use32 class=code
    start:
        mov esi, sir ; in esi we will store the FAR address of the string 's'
        cld ; parse the string from left to right (DF = 0)
        mov ecx, l ; we will parse the elements of the string in the loop with l iterations
        mov edi, dest ; in edi we will store the FAR address of the string 'd'
        
        jecxz finishProgram ; end the program if ECX is zero (s is an empty string)
        
        digitsInBase10:
            lodsw ; in AX we will have the current word from the string
            
            extractDigit:
                mov dx, 0 ; clear the DX registry -> DX:AX = AX
                
                div word[ten] ; in DX we will have the right most digit of DX:AX and in AX the initial number without the right most digit
                
                mov bx, ax ; BX = AX so we can compare it below
                
                mov ax, dx ; AX = DX so that AL (the low byte from AX) can be stored in the destination string
                stosb ; store the value of the byte AL in EDI
                
                cmp bx, 0 ; check whether the current number is 0 
                jne extractDigit ; if not, continue extracting the next digit (we haven't found all the digits)
            
        loop digitsInBase10 ; if there are more elements (ecx>0) resume the loop.
        
        finishProgram: ; the end of the program
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
