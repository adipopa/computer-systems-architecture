bits 32
segment code use32 public code
global compute_byte_ranks

segment data use32 class=data
    bytes_of_max_val times 100 db 0
    res_s dd 0
    len_s dd 0
    c_dword dd 0
    max_byte db 0
    c_sum dd 0
    c_byte db 0

compute_byte_ranks:
    mov esi, [esp + 4]
    
    mov eax, [esp + 4*2]
    mov [res_s], eax
    
    mov eax, [esp + 4*3]
    mov [len_s], eax
    
    mov edi, bytes_of_max_val
    mov ecx, [len_s]

    jecxz end_proc
    
    iter_dwords:
        push ecx

        lodsd
        mov dword [c_dword], eax
        
        mov [max_byte], byte 0
        mov ecx, 4

        iter_bytes:
            mov al, [c_dword + ecx - 1]
            
            cmp al, [max_byte]
            jb end_if
            mov [max_byte], al
            end_if:
        loop iter_bytes
        
        mov al, [max_byte]
        stosb
        
        cbw
        cwde
        add [c_sum], eax
        
        pop ecx
    loop iter_dwords
    
    mov esi, bytes_of_max_val
    mov edi, [res_s]
    mov ecx, [len_s]

    build_ranks:
        push ecx
        
        lodsb
        mov [c_byte], al
        
        push esi
        
        mov ebx, 1
        mov esi, bytes_of_max_val
        mov ecx, [len_s]

        inner_loop:
            lodsb
            cmp al, [c_byte]
            jbe end_if2
            inc ebx
            end_if2:
        loop inner_loop
        
        mov eax, ebx
        stosd
        
        pop esi

        pop ecx
    loop build_ranks
    
    mov eax, [c_sum]
    
    end_proc:
    
    ret 4 * 3