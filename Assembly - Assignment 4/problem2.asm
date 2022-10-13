.model small   ;medium/compact/large/huge


.stack 100h


.data 

    CR equ 0dh
    LF equ 0ah 
    prompt      dw  "Enter a two digit number: $"      
    message     dw  ", $";    
    nextline    db  0dh, 0ah, '$'

.code    ;optional name except for small program

    main proc
    	;initialize ds
        mov ax, @data     ;get data segment      
        mov ds, ax        ;initialize ds 
        
        mov ax, 0
        push ax
        mov ax, 1
        push ax
        call input
        mov ax, cx
        push ax  
        call newline
        
        call FIBONACCI
            
        EXIT:
        
        mov ah, 4ch     ;return to dos
        int 21h
    
    main endp 
    
    
    FIBONACCI PROC; nth fibonacci, n in stack top
        push bp 
        mov bp, sp
        
        cmp word ptr[bp + 4], 1
        jl SKIP1
        
        PRINT_CURRENT:
            mov cx, [bp + 8]
            call outputDecimal
            
            cmp word ptr[bp + 4], 1
            je SKIP
            lea dx, message
            call showPrompt
        
        SKIP:
        mov ax, [bp + 8]
        add ax, [bp + 6]
        mov bx, [bp + 6]
        push bx
        push ax
        mov ax, [bp + 4]
        sub ax, 1
        push ax
        call FIBONACCI
        
        
        SKIP1:
        pop bp
            
        RET 6
    FIBONACCI ENDP
    
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
    
    input proc ; input a positive/negative decimal
        ;input value in cx
        lea dx, prompt
        call showPrompt
        
        mov ah, 01h
        mov bl, 0
        
        int 21h
        mov cx, 0
        cmp al, '-'   ;check if negative or positive input
        jne INPUT1    
        mov bl, '-' 
        
        REPEAT:
            mov ah, 01h
            int 21h 
            INPUT1:
                cmp al, CR      ;following 6 lines for number validity
                je END_INPUT
                cmp al, 30h
                jl Ignore 
                cmp al, 39h
                jg Ignore
                push ax       ;to preserve input
                mov ax, 10d          
                mul cx
                mov cx, ax        ;cx * 10
                pop ax
                sub al, 30h       ;get number from character
                mov ah, 0
                add cx, ax        ;new cx
                
            Ignore:
        jmp REPEAT
        
        END_INPUT:
        
        cmp bl, '-' 
        jne return
        
        not cx     ; if negative convert into 2's complement
        add cx, 1
        
        
        return:
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
