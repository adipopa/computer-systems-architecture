bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; 1. Simple exercises
    a1 dw 256
    b1 dw 1
    
    ; 2/3. Additions, subtractions
    a2 db 124
    b2 db 4
    c2 db 2
    d2 db 12
    
    a3 dw 540
    b3 dw 324
    c3 dw 432
    d3 dw 276
    
    ; 4/5. Multiplications, divisions
    a4 db 3
    b4 db 4
    c4 db 2
    d4 dw 264
    
    a5 db 7
    b5 db 17
    d5 db 5
    
; our code starts here
segment code use32 class=code
    start:
        ; Problem 23 from each topic
        
        ; 1. Simple exercises:
        xor eax, eax ; EAX = 0
        
        mov ax, [a1] ; AX = a
        mul word [b1] ; result in BX:AX = 256 * 1
        
        ; 2. Additions, subtractions (a, b, c, d - byte):
        xor eax, eax ; EAX = 0
        xor ebx, ebx ; EBX = 0
        
        mov al, [a2] ; AL = a
        sub al, [c2] ; AL = AL - c = a - c
        
        mov bl, [b2] ; BL = b
        add bl, [b2] ; BL = BL + b = b + b
        add bl, [d2] ; BL = BL + d = b + b + d
        
        add al, bl ; result: AL = (a - c) + (b + b + d)
        
        ; 3. Additions, subtractions (a, b, c, d - word):
        xor eax, eax ; EAX = 0
        xor ebx, ebx ; EBX = 0
        
        mov ax, [a3] ; AX = a
        add ax, [b3] ; AX = AX + b = a + b
        add ax, [c3] ; AX = AX + c = a + b +c
        
        mov bx, [d3] ; BX = d
        add bx, [d3] ; BX = BX + d = d + d
        
        sub ax, bx ; result: AX = (a+b+c)-(d+d)
        
        ; 4. Multiplications, divisions (a, b, c - byte, d - word)
        xor eax, eax ; EAX = 0
        xor ebx, ebx ; EBX = 0
        
        mov al, [a4] ; AL = a
        add al, [b4] ; AL = AL + b = a + b
        mov cl, 3 ; CL = 3
        mul byte cl ; AX = AL * CL = (a + b) * 3
        mov bx, ax ; BX = AX = (a + b) * 3
        
        mov al, [c4] ; AL = c
        mov cl, 2 ; CL = 2
        mul byte cl ; AX = AL * CL = c * 2
        
        sub bx, ax ; BX = BX - AX = (a + b) * 3 - c * 2
        add bx, [d4] ; result: BX = BX - d = [(a + b) * 3 - c * 2] + d
        
        ; 5. Multiplications, divisions (a, b, c, d - byte, e, f, g, h - word)
        xor eax, eax ; EAX = 0
        xor ebx, ebx ; EBX = 0
        
        mov al, [a5] ; AL = a
        add al, [b5] ; AL = AL + b = a + b
        mov cl, 2 ; CL = 2
        mul byte cl ; AX = AL * CL = (a + b) * 2
        
        mov bl, [a5] ; BL = a
        add bl, [d5] ; BL = BL + d = a + d
        
        div byte bl ; result: AL = AX / BL = [(a + b) * 2] / (a + d)
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
