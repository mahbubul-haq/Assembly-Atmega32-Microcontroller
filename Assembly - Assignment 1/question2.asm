.model small


.stack 100h


.data 

    cr equ 0dh
    lf equ 0ah
    message dw "Please enter an uppercase letter: $"
    message1 dw "Previous letter in lowercase: $"
    message2 dw "One's complement of the letter is: $"


.code

    main proc
    	;initialize ds
        mov ax, @data     ;get data segment      
        mov ds, ax        ;initialize ds
        
        ;following three lines to show prompt message
        lea dx, message     ;load effective address into dx
        mov ah, 09h         ;09h - function to print string
        int 21h             ;input - output
                
        ;input the letter
        mov ah, 01h     ; 01h -fuction for character input
        int 21h 
        mov cl, al
        
        add al, 20h   ;converting to lowercase
        sub al, 1     ;previous letter
        
        mov bl, al   
        
        call newline    ;go to the next line
        
        ;printing the second message
        mov ah, 09h
        lea dx, message1
        int 21h
        
        
        ;print the character
        mov ah, 02h     ;02h - fuction for printing a character 
        mov dl, bl
        int 21h
        
        
        ;===============second operation ===============  
        call newline
        ;printing message2
        mov ah, 09h
        lea dx, message2
        int 21h         
        
        not cl          ;provides the one's complement
        
        mov ah, 02h         ;print the character
        mov dl, cl
        int 21h
        
        
        
        
       
        mov ah, 4ch     ;return to dos
        int 21h
    
    main endp
    
    
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
        
