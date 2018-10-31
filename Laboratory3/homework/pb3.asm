bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; 3. Multiplications, divisions - Unsigned representation and signed representation
    a dw 2750
    b dw 3500
    c db 124
    d db 61
    e dd 400716
    x dq 1974500

; our code starts here
segment code use32 class=code
    start:
        ; Problem 8 from each topic
        
        ; 3. Multiplications, divisions - Unsigned representation and signed representation -> 1/a+200*b-c/(d+1)+x/a-e
        mov dx, 0
        mov ax, 1 ; DX:AX = 1
        idiv word [a] ; AX = DX:AX / a = 1 / a
        
        cwd ; DX:AX = AX = 1 / a (signed conversion)
        
        mov cx, ax
        mov bx, dx ; BX:CX = DX:AX = 1 / a
        
        mov ax, 200
        imul word [b] ; DX:AX = AX * b = 200 * b
        
        add cx, ax
        adc bx, dx ; BX:CX = BX:CX + DX:AX + CF = 1 / a + 200 * b
        
        mov al, [c] ; AL = c
        cbw ; AX = AL = c (signed conversion)
        
        mov dl, [d] ; DL = d
        add dl, 1 ; DL = DL + 1 = d + 1
        
        idiv dl ; AL = AX / DL = c / (d + 1)
        
        cbw ; AX = AL = c / (d + 1)
        cwd ; DX:AX = AX = c / (d + 1)
        
        sub cx, ax
        sbb bx, dx ; BX:CX = BX:CX - DX:AX = 1 / a + 200 * b - c / (d + 1)
        
        push bx
        push cx
        
        mov ax, [a] ; AX = a
        
        cwde ; EAX = AX = a
        
        mov ebx, eax ; EBX =  EAX = a
        
        mov eax, [x]
        mov edx, [x+4] ; EDX:EAX = x
        
        idiv dword ebx ; EAX = EDX:EAX / EBX = x / a
        
        pop edx ; EDX = BX:CX = 1 / a + 200 * b - c / (d + 1)
        
        add edx, eax ; EDX = EDX - EAX = 1 / a + 200 * b - c / (d + 1) + x / a
        
        sub edx, [e] ; EDX = EDX - e = 1 / a + 200 * b - c / (d + 1) + x / a - e [expected result: 300000]
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
