; 13. Three strings of characters are given. Show the longest common suffix for each of the three pairs of two strings that can be formed

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, scanf, printf ; add printf as extern function     
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import scanf msvcrt.dll    ; tell the assembler that function scanf is found in msvcrt.dll library
import printf msvcrt.dll    ; tell the assembler that function printf is found in msvcrt.dll library

extern longest_common_suffix

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s1 times 100 db 0 ; reserve a memory space for the initial string s1
    s2 times 100 db 0 ; same for s2
    s3 times 100 db 0 ; same for s3
    
    message1 db "Please enter the first string s1: ", 0 ; ask the user to input the first string
    message2 db "Please enter the second string s2: ", 0 ; same for second string
    message3 db "Please enter the third string s3: ", 0 ; same for third string
    
    input_format db "%s", 0 ; specify that we're expecting a string to be read
    
    format_string db `The longest common suffix of strings s%d and s%d: %s\n`, 0 ; %d and %s will be replaced with a number and a string respectivly

; our code starts here
segment code use32 class=code
    start:
        ; will call printf(message1) => will print "Please enter the first string s1: "
        ; place parameters on stack
        push dword message1 ; on the stack is placed the address of the string, not its value
        call [printf] ; call function printf for printing
        add esp, 4 * 1 ; free parameters on the stack; 4 = size of dword; 1 = number of parameters
        
        ; will scanf(input_format, s1) => will read a string in variable s1
        ; place parameters on stack from right to left
        push dword s1 ; address of s1, not the value
        push dword input_format
        call [scanf] ; call function scanf for reading
        add esp, 4 * 2 ; free parameters on the stack; 4 = size of dword; 2 = number of parameters
        
        ; will to the same for the second number => will print "Please enter the second string s2: "
        push dword message2
        call [printf]
        add esp, 4 * 1
        
        ; will scanf(input_format, s2) => will read a string in variable s2
        push dword s2
        push dword input_format
        call [scanf]
        add esp, 4 * 2
        
        ; will to the same for the second number => will print "Please enter the third string s3: "
        push dword message3
        call [printf]
        add esp, 4 * 1
        
        ; will scanf(input_format, s3) => will read a string in variable s3
        push dword s3
        push dword input_format
        call [scanf]
        add esp, 4 * 2
    
    
        ; first step: compute the longest common suffix of the first and second string
        
        ; push parameters s2 and s1 onto the stack from right to left
        push dword s2
        push dword s1
        call longest_common_suffix ; procedure call
                                   ; EAX = longest_common_suffix(s1, s2)

        ; display the result
        push dword eax
        push dword 2
        push dword 1
        push format_string
        call [printf]
        add esp, 4*4
        
        
        ; second step: compute the longest common suffix of the first and third string
        
        ; push parameters s3 and s1 onto the stack from right to left
        push dword s3
        push dword s1
        call longest_common_suffix ; procedure call
                                   ; EAX = longest_common_suffix(s1, s3)

        ; display the result
        push dword eax
        push dword 3
        push dword 1
        push format_string
        call [printf]
        add esp, 4*4
        
        
        ; third and final step: compute the longest common suffix of the second and third string
        
        ; push parameters s3 and s2 onto the stack from right to left
        push dword s3
        push dword s2
        call longest_common_suffix ; procedure call
                                   ; EAX = longest_common_suffix(s2, s3)

        ; display the result
        push dword eax
        push dword 3
        push dword 2
        push format_string
        call [printf]
        add esp, 4*4
        
        finishProgram: ; end of the program
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
