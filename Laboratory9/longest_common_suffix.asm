bits 32
segment code use32 public code
global longest_common_suffix

segment data use32 class=data
    l1 dd 0 ; temporary variables for storing the length of the strings to compare
    l2 dd 0

	d times 100 db 0 ; reserve a memory space for the destination string d and initialize it
                      ; these will be the strings that will contain the longest common suffix for each of the three pairs
                     
    aux times 100 db 0 ; auxiliary string for reversing the output

; procedure for getting the length of a given string
getStringLength:
    mov esi, [esp + 4]
    mov ecx, 0
    
    ; take each byte (character) one by one until EAX is 0, count the number of characters and put them in EAX
    strLen:
        lodsb
        cmp eax, 0
        je stop
        add ecx, 1
        jmp strLen
    stop:
    
    ; will return the number of characters in the argument string
    mov eax, ecx
    ret 4

; longest common suffix procedure definition
longest_common_suffix: 
    mov edi, 0 ; initialize EDI with 0
    
    ; set the iterator registers to the length of the strings to compare minus one
    push dword [esp + 4] ; push the first string onto the stack
    call getStringLength ; procedure call
                         ; EAX = getStringLength(first_string)
    mov [l1], eax ; temporary store the returned length
    
    push dword [esp + 4*2]
    call getStringLength
    mov [l2], eax
    
    mov esi, [l1]
    mov ebx, [l2]
    
    checkCommonLetters:
            mov edx, [esp + 4]
            mov al, [edx + esi - 1]
            
            mov edx, [esp + 4*2]
            mov cl, [edx + ebx - 1]
            
            cmp al, cl
            jne nextPair
            
            mov [aux + edi], al
            inc edi
            
            dec esi
            dec ebx
            
            jmp checkCommonLetters
            
    nextPair:
    
    mov esi, 0
    mov ecx, 100
    mov eax, d
    
    reverseOutputString:
        mov bl, [aux + edi - 1]
        mov [eax + esi], bl
        
        dec edi
        inc esi
        
    loop reverseOutputString
    
    ret 4*2