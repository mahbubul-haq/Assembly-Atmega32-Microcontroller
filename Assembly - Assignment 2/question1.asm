.model small


.stack 100h


.data 

    CR equ 0dh
    LF equ 0ah       
    message     dw  "Enter three 1 digit numbers: $"
    message1    dw  "All the numbers are equal$" 
    temp        db  ?


.code

    main proc
    	;initialize ds
        mov ax, @data     ;get data segment      
        mov ds, ax        ;initialize ds 
        
        call input
         
        mov ah, 02h ;for output
        
        cmp bl, cl
        jge BLGreaterEqualCL 
        
        CLGreaterBL:
            cmp bl, dl
            jge showBL
            BLSmallest:
                cmp dl, cl
                jz showBL
                cmp dl, cl
                jl showDL
                showCL:
                    mov dl, cl
                    int 21h
                    jmp EXIT
                
                showDL:
                    int 21h 
                    jmp EXIT       
            
            showBL:
                mov dl, bl
                int 21h
                jmp EXIT
        
        
        BLGreaterEqualCL: 
            cmp bl, cl
            jz  BLEqualCL
            BLGreaterCL:
                mov temp, bl
                mov bl, cl
                mov cl, temp
                jmp CLGreaterBL
            
            BLEqualCL:
                cmp cl, dl
                jz allEqual
                cmp cl, dl
                jl showBL
                jmp showDL
                
                
                allEqual:
                    mov ah, 09h
                    lea dx, message1
                    int 21h
                    jmp EXIT
                
            
                
        
        
        
        EXIT:    
       
        mov ah, 4ch     ;return to dos
        int 21h
    
    main endp
    
    input proc
        
        call showPrompt     ;show prompt message
        
        mov ah, 01h   ;input a character
        int 21h
        mov bl, al             ;first digit
        
        int 21h
        mov cl, al               ;second digit
        
        int 21h
        mov dl, al               ;third digit
        
        
        ret
    input endp
    
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
