bits 32

; informing the assembler that we want to make the _countLetters function available for other modules
global _countLetters

; the linker may use the public data segment for external data
segment data public data use32

; the code written in assembly language resides in a public segment, that may be shared with external code
segment code public code use32

; int countLetters(char[])
; stdcall convention
_countLetters:
    ; creating a stack frame for the called program
    push ebp
    mov ebp, esp

    ; retreive the function's arguments from the stack
    ; [ebp+4] contains the return value
    ; [ebp] contains the ebp value for the caller
    mov esi, [ebp + 8] ; ESI <- the FAR address of the sentence given as parameter
    mov ecx, 0 ; ECX will count the number of characters in ESI

    ; take each byte (character) one by one until EAX is 0, count the number of characters and put them in ECX
    count:
        mov al, [esi + ecx] ; in AL we'll store a character from ESI
        cmp al, 0x00 ; check whether we've reached the end (the character is null)
        je stop ; then stop
        inc ecx ; else increment ECX
        jmp count ; recall the bit of code
    stop:

    ; restore the stack frame
    mov esp, ebp
    pop ebp

    ; will return the number of characters of the word given as argument
    mov eax, ecx

    ret
    ; stdcall convention - it is the responsibility of the caller program to free the parameters of the function from the stack
