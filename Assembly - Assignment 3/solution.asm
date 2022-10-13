.model small


.stack 100h


.data 

    CR equ 0dh
    LF equ 0ah       
    message     dw  "Enter a number: $";
    message1    dw  "Enter '+' / '-' / '/' / '*'. 'q' to quit: $"
    wrongOP     dw  "Wrong operator$"
    equal       dw  " = $"    
    nextline    db  0dh, 0ah, '$'
    temp        dw  10d
    number1     dw  ?
    number2     dw  ?
    answer      dw  ? 
    sign1       dw  ?
    sign2       dw  ?
    sign        dw  ?
    operator    dw  ?


.code

    main proc
    	;initialize ds
        mov ax, @data     ;get data segment      
        mov ds, ax        ;initialize ds 
        
        
        call input              ;input first num and save sign
        mov number1, cx
        mov sign1, '+'
        cmp dx, 1   ;dx contains 1 for negative
        jne skip1
        mov sign1, '-'
        skip1:
            
           
        call newline
        
        mov ah, 09h
        lea dx, message1
        int 21h
        
        mov ah, 01h
        int 21h  ;input operator 
        push ax
        call newline   
        
        pop ax
        
        cmp al, '+'        
        jne notPlus     
        ;operator = '+'
        
        call input           
        mov number2, cx       ;input number2 and save sign
        
        mov sign2, '+'
        cmp dx, 1
        jne skip2
        mov sign2, '-'
        skip2:
           
        mov bx, number1          ;operation
        add bx, cx
        mov answer, bx   
        
        
        
        mov operator, '+'
        jmp EXIT
        
        notPlus:
            cmp al, '-'
            jne notMinus              ;for minus sign
            call input
            mov number2, cx 
            
             mov sign2, '+'           ;save sign
            cmp dx, 1
            jne skip3
            mov sign2, '-'
            skip3:
            
            
            mov bx, number1          ;operation
            sub bx, cx
            mov answer, bx
            mov operator, '-'
            jmp EXIT
            
        notMinus: 
            cmp al, '*'
            jne notMultiply 
            call input             ;for * sign
            mov number2, cx 
            
            mov sign2, '+'          ;save sign
            cmp dx, 1
            jne skip4
            mov sign2, '-'
            skip4:
            
            
            mov ax, number1         ;operation
            imul cx
            mov answer, ax
            mov operator, '*'
            jmp EXIT
            
            
        notMultiply:
            cmp al, '/'
            jne notDivision 
            call input              ;for / sign
            mov number2, cx
            
            mov sign2, '+'          ;save sign
            cmp dx, 1
            jne skip5
            mov sign2, '-'
            skip5:  
            
            mov ax, number1              ;operation
            mov dx, 0
            
            cmp sign1, '-'              ;higher bits 0 or 1
            jne skip11
            mov ax, number1
            cwd
            skip11:
            
            mov cx, number2
            idiv cx
            mov answer, ax
            
            
             
            mov operator, '/'
            jmp EXIT
        notDivision:
            cmp al, 'q'
            jne  notQuit
            jmp endProgram        ;q for quit
            
        notQuit:
            call newline        ;not quit error operator
        
            mov ah, 09h
            lea dx, wrongOP
            int 21h
            jmp endProgram
            
        EXIT:
            call finalOutput
        
        endProgram:
        
        mov ah, 4ch     ;return to dos
        int 21h
    
    main endp
    
    
    finalOutput proc            ;formatted output
       
        call newline
        
        call showLeftBracket
        
        mov bx, sign1
        mov sign, bx          ;before output call set sign
        
        mov cx, number1
        call outputDecimal 
        call showRightBracket
        
        call showLeftBracket
        mov dx, operator
        mov ah, 02h
        int 21h
        call showRightBracket  
        
        call showLeftBracket
        
        mov bx, sign2
        mov sign, bx    
        
        mov cx, number2
         
        call outputDecimal
        call showRightBracket
        
        lea dx, equal
        mov ah, 09h
        int 21h
        
        call showLeftBracket 
        mov sign, '+'            ;set sign for answer
        cmp answer, 0
        jge skip10
        mov sign, '-'
        
        skip10:
        mov cx, answer
        call outputDecimal
        call showRightBracket
        call newline
        
        ret
    finalOutput endp
    
    showLeftBracket proc
        mov ah, 02h
        mov dl, '['
        int 21h
        
        ret
    showLeftBracket endp 
    
    showRightBracket proc
        mov ah, 02h
        mov dl, ']'
        int 21h
        
        ret
    showRightBracket endp
    
    outputDecimal proc ;the number should be in cx
        ;the value of cx is preserved after output
        
        push cx
        
        cmp sign, '-'
        jne nonNegative  
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
             div temp
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
    
    input proc      ;input the number in cx
         
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
        mov dx, 0
        
        cmp bl, '-' 
        jne return
        
        not cx     ; if negative convert into 2's complement
        add cx, 1
        mov dx, 1
        
        
        return:
        ret
    input endp
    
    showPrompt proc      ;print a prompt message
        lea dx, message
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
