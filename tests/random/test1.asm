bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, scanf, printf, fopen, fprintf, fclose ; add printf and scanf as extern functions     
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import scanf msvcrt.dll    ; tell the assembler that function scanf is found in msvcrt.dll library
import printf msvcrt.dll
import fopen msvcrt.dll
import fprintf msvcrt.dll
import fclose msvcrt.dll


; our data is declared here (the variables needed by our program)
segment data use32 class=data
    read_file_msg db "The output file name (with extension): ", 0
    
    file_name times 32 db 0 ; reserve a memory space for the file name
    format_f db "%s", 0 ; format for reading the file name

    read_int_msg db "Please enter each number below one by one, you can stop by typing '0'.", 10, 13, 0
    
    format_r db "%d", 0 ; format for reading the integers
    
    read_number_msg db "Number %d: ", 0
    
    int_list times 100 dd 0     ; space to hold the list of integers

    num dd 0                    ; the current integer read
    len dd 0                    ; the actual length of the list
    
    cnt dd 0 ; variable used for counting the number of 1's
    
    access_mode db "w", 0
    file_descriptor dd -1
    
    format_result db "%d(10) -> %X(16) has %d occurance(s) of 1's in binary", 10, 0
    
    end_read_msg db "Success! The result will be in the file: %s", 10, 13, 0

; our code starts here
segment code use32 class=code
    start:
        push dword read_file_msg
        call [printf]
        add esp, 4 * 1
        
        push dword file_name
        push dword format_f
        call [scanf]
        add esp, 4 * 2
        
        push dword read_int_msg
        call [printf]
        add esp, 4 * 1
        
        cld
        xor ebx, ebx ; count in ebx
        mov ecx, 100 ; loop 100 times
        
        readNumbers:
            push ecx
            
            push dword ebx
            push dword read_number_msg
            call [printf]
            add esp, 4 * 2
            
            push dword num
            push dword format_r
            call [scanf]
            add esp, 4 * 2
            
            mov eax, [num]
            cmp eax, 0
            je stopRead
            
            mov dword [int_list + 4*ebx], eax
            
            inc ebx
            pop ecx
        loop readNumbers
            
        stopRead:
            mov dword [len], ebx
            
        ; open the output file
        push dword access_mode
        push dword file_name
        call [fopen]
        add esp, 4 * 2
        
        ; check if the file was successfully opened / created (EAX != 0)
        cmp eax, 0
        je finishProgram
        
        mov [file_descriptor], eax ; store the file descriptor returned by fopen
        
        ; display the numbers in base 10, their conversion in base 16 and
        ; the number of 1's in each's binary representation
        mov ecx, [len]
        mov esi, int_list
        printResults:
            push ecx
            
            lodsd
            
            mov [cnt], dword 0 ; reset the counter variable
            mov ebx, eax ; copy EAX to EBX
            mov ecx, 32 ; we need to loop through EBX a number of times equal to the registry's size (dword -> size 32)
        
            numberOfOnes:
                shr ebx, 1 ; we shift EBX to the right with one position (also setting CF equal to the byte that was shifted)
                jnc notAOne ; don't count the current byte if it is not 1
                inc dword [cnt] ; increment the counter variable by 1 if CF=1
                notAOne:
            loop numberOfOnes
            
            push dword [cnt]
            push dword eax
            push dword eax
            push dword format_result
            push dword [file_descriptor]
            call [fprintf]
            add esp, 4 * 5
            
            pop ecx
        loop printResults
        
        ; call fclose() to close the file
        push dword [file_descriptor]
        call [fclose]
        add esp, 4 * 1
        
        push dword file_name
        push dword end_read_msg
        call [printf]
        add esp, 4 * 2
        
        finishProgram:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
