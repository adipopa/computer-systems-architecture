; 18. Read a decimal number and a hexadecimal number from the keyboard. Display the number of 1's of the sum of the two numbers in decimal format. Example:
; a = 32 = 0010 0000b
; b = 1Ah = 0001 1010b
; 32 + 1Ah = 0011 1010b
; The value printed on the screen will be 4

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf ; add printf and scanf as extern functions     
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll    ; tell the assembler that function printf is found in msvcrt.dll library
import scanf msvcrt.dll     ; similar for scanf

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dd 0 ; in this variable we'll store the first number read from the keyboard
    b dd 0 ; same for the second number
    
    message1 db "Please insert number a: ", 0 ; ask the user to input the number a
    message2 db "Please insert number b: ", 0 ; same for number b
    
    format1 db "%d", 0 ; specify that a is a decimal number (base 10)
    format2 db "%x", 0 ; and b is a hexadecimal number (base 16)
    
    cnt dd 0 ; variable used for counting the number of 1's
    
    resultFormat db "The number of 1's in the binary representation of the sum of a and b: %d", 0 ; %d will be replaced with a number

; our code starts here
segment code use32 class=code
    start:
        ; will call printf(message1) => will print "a="
        ; place parameters on stack
        push dword message1 ; on the stack is placed the address of the string, not its value
        call [printf] ; call function printf for printing
        add esp, 4 * 1 ; free parameters on the stack; 4 = size of dword; 1 = number of parameters
        
        ; will scanf(format1, a) => will read a number in variable a
        ; place parameters on stack from right to left
        push dword a ; address of a, not the value
        push dword format1
        call [scanf] ; call function scanf for reading
        add esp, 4 * 2 ; free parameters on the stack; 4 = size of dword; 2 = number of parameters
        
        ; will to the same for the second number => will print "b="
        push dword message2
        call [printf]
        add esp, 4 * 1
        
        ; will scanf(format2, b) => will read a number in variable b
        push dword b
        push dword format2
        call [scanf]
        add esp, 4 * 2
        
        mov ebx, [a] ; moving the value of a to EBX
        add ebx, [b] ; we've got EBX = EBX + b = a + b
        
        mov ecx, 32 ; we need to loop through EBX a number of times equal to the registry's size (dword -> size 32)
        
        numberOfOnes:
            shr ebx, 1 ; we shift EBX to the right with one position (also setting CF equal to the byte that was shifted)
            
            jnc notAOne ; don't count the current byte if it is not 1
            
            add [cnt], dword 1 ; add 1 to the counter variable if CF=1
            
            notAOne:
            
        loop numberOfOnes
        
        ; will call printf(resultFormat, [cnt]) => will print: „The number of 1's of the sum of a and b: [cnt]”
        ; place parameters on the stack from right to left
        push dword [cnt]
        push dword resultFormat ; ! on the stack is placed the address of the string, not its value
        call [printf] ; call function printf for printing
        add esp, 4 * 2 ; free parameters on the stack; 4 = size of dword; 2 = number of parameters
    
        ; ex: if a = 247, b = D5C -> expected result: 7 (1110 0101 0011b)
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
