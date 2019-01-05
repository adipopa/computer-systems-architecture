; 18. A text file is given. The text contains letters, spaces and points. Read the content of the file, determine the number of words and display the result on the screen. (A word is a sequence of characters separated by space or point)

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fread, fclose, printf ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll 
import fread msvcrt.dll 
import fclose msvcrt.dll 
import printf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    file_name db "input.txt", 0 ; filename to be read
    access_mode db "r", 0 ; file access mode:
                          ; r - opens a file for reading. The file must exist. 
    file_descriptor dd -1 ; variable to hold the file descriptor
    len equ 100 ; maximum number of characters to read
    text times len db 0 ; string to hold the text which is read from file
    
    words_count dd 0 ; the number of characters in the file
    
    resultFormat db "The number of words in the input.txt file: %d", 0 ; %d will be replaced with a number

; our code starts here
segment code use32 class=code
    start:
        ; call fopen() to create the file
        ; fopen() will return a file descriptor in the EAX or 0 in case of error
        ; eax = fopen(file_name, access_mode)
        push dword access_mode     
        push dword file_name
        call [fopen]
        add esp, 4*2 ; clean-up the stack

        mov [file_descriptor], eax ; store the file descriptor returned by fopen

        ; check if fopen() has successfully created the file (EAX != 0)
        cmp eax, 0
        je finishProgram

        ; read the text from file using fread()
        ; after the fread() call, EAX will contain the number of chars we've read 
        ; eax = fread(text, 1, len, file_descriptor)
        push dword [file_descriptor]
        push dword len
        push dword 1
        push dword text        
        call [fread]
        add esp, 4*4
        
        mov esi, 0 ; initialize ESI (our iterator) with 0
        mov ebx, 0 ; make sure EBX is empty
        mov ecx, 0 ; ECX will act as a counter for the number of characters before a space / period
        sub eax, 1 ; we're going to check every character until length of text - 1
        
        foundWord:
            ; check if there were any letters before the current character
            cmp ecx, 0
            je nextCharacter ; if not, continue with the next character
            
            add [words_count], dword 1 ; else increase the words count by one
            mov ecx, 0 ; and reset the character counter
        
        nextCharacter:
            mov bl, [text + esi] ; move a character from the string text to BL
            
            inc esi ; increment ESI
            
            ; if the current character is a space, we're going to check if we found a word
            cmp bl, byte ' '
            je foundWord
            
            ; the same if the current character is a period
            cmp bl, byte '.'
            je foundWord
            
            add ecx, 1 ; else add 1 to the character counter
            
            cmp esi, eax ; if ESI is smaller than EAX then we take the next character and repeat the process
            jb nextCharacter
           
        ; one check remaining: if the content of input.txt ends with a word, count it
        cmp ecx, 0
        je notAWord
        
        add [words_count], dword 1
        
        notAWord:
        
        ; will call printf(resultFormat, [words_count]) => will print: „The number of words in the input.txt file: [words_count]”
        ; place parameters on the stack from right to left
        push dword [words_count]
        push dword resultFormat ; ! on the stack is placed the address of the string, not its value
        call [printf] ; call function printf for printing
        add esp, 4 * 2 ; free parameters on the stack; 4 = size of dword; 2 = number of parameters

        ; call fclose() to close the file
        ; fclose(file_descriptor)
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
        
        finishProgram: ; end of the program
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program