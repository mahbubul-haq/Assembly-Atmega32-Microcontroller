.model small   ;medium/compact/large/huge


.stack 100h


.data 

    CR equ 0dh
    LF equ 0ah       
    message1        dw  "Enter matrix 1:$"
    message2        dw  "Enter matrix 2:$"
    message3        dw  "Resultant matrix:$"      
    nextline        db  0dh, 0ah, '$'
    
    array1          db 4 dup(0)
    array2          db 4 dup(0)
    result          db 4 dup(0)
    

.code    ;optional name except for small program

    main proc
    	;initialize ds
        mov ax, @data     ;get data segment      
        mov ds, ax        ;initialize ds 
        
        ;===================array1 input=============
        lea dx, message1
        call showPrompt
        call newline
        mov bx, 0
        mov cx, 2
        
        input_array1: 
        
            push cx
            push bx
            mov cx, 2 
            mov si, 0
            
            rows: 
                mov ah, 01h   
                int 21h  
                sub al, 30h
                mov array1[bx][si], al
                add si, 1
                loop rows
                
            call newline
            pop bx
            pop cx
            add bx, 2
            loop input_array1
            
        ;============array2 input================
        call newline
        lea dx, message2
        call showPrompt
        call newline
        
        mov bx, 0
        mov cx, 2
        mov ah, 01h   
        
        input_array2: 
        
            push cx 
            push bx
            mov cx, 2 
            mov si, 0
            
            rows2:
                mov ah, 01h
                int 21h 
                sub al, 30h
                mov array2[bx][si], al
                add si, 1
                loop rows2
            call newline    
            
            pop bx
            pop cx
            add bx, 2
            loop input_array2 
            
            
        ;========calculate and show result====================
        call addMatrices  
        
        lea dx, message3
        call showPrompt
        call newline
        
        xor bx, bx
        mov cx, 2
        
        output_rows:
            xor si, si
            push cx
            push bx
            mov cx, 2
            output_columns:
                
                push cx
                
                mov ch, 0
                mov cl, result[bx][si] 
                push bx
                call outputDecimal
                pop bx
                
                mov ah, 02h
                mov dx, ' '
                int 21h
                
                pop cx
                add si, 1
                loop output_columns
            call newline
            pop bx
            pop cx
            add bx, 2
            loop output_rows
            
        EXIT:
        
        mov ah, 4ch     ;return to dos
        int 21h
    
    main endp
    
    addMatrices proc 
        mov bx, 0
        mov cx, 2
        
        loop1:
            push cx
            mov cx, 2
            xor si, si
            loop2:
                mov al, array1[bx][si]
                add al, array2[bx][si]
                mov result[bx][si], al
                 
                add si, 1
                loop loop2
            pop cx
            add bx, 2
            loop loop1
  
        
        ret
    addMatrices endp
    
    outputDecimal proc ;the number should be in cx
        ;the value of cx is preserved after output
        
        push cx
        
        cmp cx, 0
        jge nonNegative  
        not cx   ;if negative make 2's complement and print '-'
        add cx, 1
        mov ah,02h
        mov dl, '-'
        int 21h
        
        nonNegative:
        
        mov bx, 0
        
        while:
             mov ax, cx   ; division part 
             
             mov dx, 0
             
             push bx
             mov bx, 10d
             div bx
             pop bx
             
             
             add dx, 30h  ;remainder
             push dx   ;save in stack to print them in right order
             add bx, 1
             mov cx, ax   ;quotient in cx
             
             cmp cx, 0      ;if quotient 0 endProcess
             je endProcess
             jmp while
             
        
        endProcess: 
            mov cx, bx
            jcxz finishOutput 
            mov ah, 02h
            output:        ;now print in proper order
                pop dx
                int 21h
                loop output
                
                
        finishOutput: 
        
        pop cx     ;regain the value of cx
        
        ret
    outputDecimal endp
    
    input proc
        
        ret
    input endp
    
    showPrompt proc      ;print a prompt message given in dx
        mov ah, 09h
        int 21h 
        
        ret
    showPrompt endp
    
    
    newline proc     ;print a newline
        lea dx, nextline
        mov ah, 09h
        int 21h
        
        ret 
        
    newline endp
    
    
    
    end main
