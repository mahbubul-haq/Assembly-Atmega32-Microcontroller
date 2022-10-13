.model small


.stack 100h


.data 

    cr equ 0dh
    lf equ 0ah
    message dw "Please enter a number between 0 and 9: $"
    message1 dw "The value of Z is: $"
    message01 dw "After performing (Z = X - 2Y) -> $"
    message02 dw "After performing (Z = 25 - (X + Y)) -> $" 
    message03 dw "After performing (Z = 2X - 3Y) -> $"
    message04 dw "After performing (Z = Y - X + 1) -> $"
    
    x   dw  ?
    y   dw  ?
    z   dw  ?


.code

    main proc
    	;initialize ds
        mov ax, @data     ;get data segment      
        mov ds, ax        ;initialize ds      
        
        call inputXY
        call operation1
        call operation2
        call operation3
        call operation4
              
            
       
        mov ah, 4ch     ;return to dos
        int 21h
    
    main endp
    
    operation4 proc
        mov ax, y        
        mov z, ax        ;z = y
        mov ax, x
        sub z, ax        ;z =  y - x
        add z, 1         ;z = y - x + 1
        add z, 30h
        
        call newline     ;following 4 lines to show appropriate message
        mov ah, 09h
        lea dx, message04
        int 21h
        call showMsg1
        
        mov ah, 02h       ;show z
        mov dx, z
        int 21h
        
        
        ret
    operation4 endp
    
    operation3 proc
        mov ax, x
        mov z, ax
        mov ax, y
        sub z, ax   ;x - y
        mov ax, x
        add z, ax   ;2x - y
        mov ax, y   ;
        add ax, ax
        sub z, ax   ;2x - 3y 
        add z, 30h
        
        call newline       ;show appropriate message
        mov ah, 09h
        lea dx, message03
        int 21h
        call showMsg1
        
        mov ah, 02h       ;show z
        mov dx, z 
        int 21h
        
        
        ret
    operation3 endp
    
    operation2 proc
        mov z, 25d     ;z=25
        mov ax, x
        sub z, ax      ;z = 25 - x
        mov ax, y
        sub z, ax      ;z = 25 - x - y
        add z, 30h
        
        call newline                ;show message
        mov ah, 09h
        lea dx, message02
        int 21h
        call showMsg1
        
        mov ah, 02h,                ;sshow z
        mov dx, z
        int 21h
        
        
        ret
    operation2 endp
    
    operation1 proc
        
        mov ax, x
        mov z, ax           ;z = x
        mov ax, y
        sub z, ax           ;z = x - y
        mov ax, y
        sub z, ax           ;z = x - 2y
        add z, 30h
                   
        call newline        ;show message
        mov ah, 09h
        lea dx, message01
        int 21h 
        call showMsg1
        
        
        mov ah, 02h         ;show z
        mov dx, z
        int 21h 
        
        
        ret
    operation1 endp
    
    inputXY proc
        
        call showPrompt     ;show prompt message
        
        mov ah, 01h         ;input
        int 21h
        mov ah, 0           ;high bits zero
        mov x, ax           
        sub x, 30h          ;convert x into integer
        
        call newline
        call showPrompt     ;newline and prompt
                            
                           
        mov ah, 01h         ;similar as x input
        int 21h
        mov ah, 0
        mov y, ax
        sub y, 30h
        
        
        ret
    inputXY endp
    
    showMsg1 proc
        mov ah, 09h
        lea dx, message1
        int 21h
        
        ret
    showMsg1 endp
    
    
    showPrompt proc
        lea dx, message
        mov ah, 09h
        int 21h 
        
        ret
    showPrompt endp
    
    
    newline proc
        mov ah, 02h
        mov dl, cr   ;cr carriage retrun
        int 21h
        
        mov ah, 02h
        mov dl, lf   ;lf line feed
        int 21h
        
        ret 
        
    newline endp 
    
    
    end main
        
