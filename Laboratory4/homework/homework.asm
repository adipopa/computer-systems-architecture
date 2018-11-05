;26. Given 2 doublewords R and T. Compute the doubleword Q as follows:
; the bits 0-6 of Q are the same as the bits 10-16 of T
; the bits 7-24 of Q are the same as the bits 7-24 of (R XOR T).
; the bits 25-31 of Q are the same as the bits 5-11 of R.

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; define R, T and Q as doublewords
    R dd 00010011011100100100011001111010b
    T dd 10100011100010010110101110001010b
    Q dd 0

; our code starts here
segment code use32 class=code
    start:
    
        mov ebx, 0 ; we compute the result in EBX
        
        mov eax, [T] ; EAX = T
        and eax, 00000000000000011111110000000000b ; we isolate bits 10-16 of T
        mov cl, 10
        ror eax, cl ; we rotate 10 positions to the right (10-16 -> 0-6)
        or ebx, eax ; we put the bits into the result
        
        mov eax, [R] ; EAX = R
        xor eax, [T]; EAX = R xor T
        and eax, 00000001111111111111111110000000b ; we isolate bits 7-24 of (R xor T)
        or ebx, eax ; we put the bits into the result
        
        mov eax, [R] ; EAX = R
        and eax, 00000000000000000000111111100000b ; we isolate bits 5-11 of R
        mov cl, 20
        rol eax, cl ; we rotate 20 positions to the left (5-11 -> 25-31)
        or ebx, eax ; we put the bits into the result
        
        mov [Q], ebx ; Q = EBX, expected result: 01100110111110110010110111011010(b) or 66FB2DDA(h)
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
