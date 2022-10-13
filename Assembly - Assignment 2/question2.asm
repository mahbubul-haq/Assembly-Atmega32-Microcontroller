.model small


.stack 100h


.data 

    CR equ 0dh
    LF equ 0ah       
    message     dw  "Invalid password$"
    message1    dw  "Valid password$"
    hasLowerCase    db  ?
    hasUpperCase    db  ?
    hasNumeric      db  ?


.code

    main proc
    	;initialize ds
        mov ax, @data     ;get data segment      
        mov ds, ax        ;initialize ds    
        
        mov ah, 01h
        mov hasLowerCase, 0
        mov hasUpperCase, 0
        mov hasNumeric, 0
        
        Input:
            int 21h
            
            cmp al, 21h
            jl Output 
            cmp al, 7eh
            jg Output
            cmp al, 30h
            jl NonNumeric
            Numeric:
                cmp al, 39h
                jg NonNumeric
                mov hasNumeric, 1
                jmp Input
                
            NonNumeric:
            cmp al, 41h
            jl NonUpper
            Upper:
                cmp al, 5ah
                jg NonUpper
                mov hasUpperCase, 1
                jmp Input
            NonUpper:
            cmp al, 61h
            jl NonLower
            Lower:
                cmp al, 7ah
                jg NonLower
                mov hasLowerCase, 1
                jmp Input
            NonLower:
                jmp Input
                
        Output: 
            cmp hasLowerCase, 1
            jnz Invalid
            cmp hasUpperCase, 1
            jnz Invalid
            cmp hasNumeric, 1
            jnz Invalid 
            
            call newline
            
            mov ah, 09h
            lea dx, message1
            int 21h
            jmp EXIT
        
        
        
        Invalid:  
            call newline
            call showPrompt
            call newline
                    
            
        EXIT:
        mov ah, 4ch     ;return to dos
        int 21h
    
    main endp
    
    
    showPrompt proc      ;print a prompt message
        lea dx, message
        mov ah, 09h
        int 21h 
        
        ret
    showPrompt endp
    
    
    newline proc     ;print a newline
        mov ah, 02h
        mov dl, CR   ;cr carriage retrun
        int 21h
        
        mov ah, 02h
        mov dl, LF   ;lf line feed
        int 21h
        
        ret 
        
    newline endp
    
    
    
    end main
