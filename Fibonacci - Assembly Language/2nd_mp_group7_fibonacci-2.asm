
; COPYRIGHT RESERVED FOR :
; Mohamed Ganana
; AbdelRahman Khater
; AbdelRahman Shibl
; Mohamed Fayed
; Mahmoud Youssef
                                                           
org 100h   ; Starting address

.data      ; Our data

    Input_Msg db 'Please enter the number of elements in the sequence:  $'
    Error_Msg db 'Please enter suitable number in the range of [1 - 25]:$'
.code  ; our code starts from here...
 mov ax,03               ;open console
 int 10h                 ;execute
jmp main  ; go to main code

;-------------------------------------------------

proc Print_Fibonacci     ; print the fibonacci series
    pop bp     ; save return address
    mov ah,02  ; preparing for displaying
    print_digit:     ; this loop for printing each digit
    pop dx     ; pop the digits in sequence
    add dx,30h ; convert to ASCII
    int 21h    ; execute
    dec si     ; si the number of digits got from get_digits
    cmp si,00  ; compare if si = '0'
    jnz print_digit  ; jump to labol label
    push bp    ; put the return address into stack
    ret

;***********************************************     

proc Obtain_Digits  ; we can calculate the number of digits 
    
    pop bp  ; save return address
    pop di  ; pop from stack
    pop bx  ; pop from stack
    pop ax  ; pop from stack
    push ax ; push into stack
    push bx ; push into stack
    push di ; push into stack
    mov si,0; si = '0'
    compare:
    mov dx,00 ; always make sure that the remiander = '0'
    mov bx,10 ; bx = '10'
    div bx    ; we will divide our number by 10 to get last digit one by one
    push dx   ; push into stack
    inc si    ; incremet si to get the number of digits
    cmp ax,00 ; compare if ax = '0'
    jnz compare ; if false jump compare
    push bp     ; put the return address into stack
    ret

;-------------------------------------------------

proc Gene_Fibonacci ; Generate Fibonacci Series 
    
     ; This is a New Way to generate the fibonacci... 
    
    ;                            n
	;	|F(n+1) F(n)  |    |1  1|
	;	|     	      |  = |    |
	;	|F(n)   F(n-1)|    |1  0|
                  
    ;                    n
	;	|bx cx|    |1 1|
	;	|     |	 = |   |		
	;	|si di|    |1 0|

    ; the following lines for generating the fibonacci 

    pop bp   ; save return address 
    pop di
    pop si
    pop cx
    pop bx 
    mov ax,bx
    mov dx,1
    mul dx 
    push ax 
    mov ax,cx
    mov dx,1
    mul dx 
    pop dx
    add ax,dx
    push ax
    mov ax,bx
    mov dx,1
    mul dx
    push ax
    mov ax,cx
    mov dx,0
    mul dx 
    pop dx
    add ax,dx
    push ax
    mov ax,si
    mov dx,1
    mul dx
    push ax
    mov ax,di
    mov dx,1
    mul dx 
    pop dx
    add ax,dx
    push ax 
    mov ax,si
    mov dx,1
    mul dx
    push ax
    mov ax,di
    mov dx,0
    mul dx 
    pop dx
    add ax,dx
    push ax
    push bp     ; put the return address into stack
    ret
;-------------------------------------------------

proc Input_Display   ; this function displays the input message
    pop bp        ; save the return address
        mov dx,offset input_msg ; to show the message in our data 'String'
        mov ah,09h   ;Preparing for displaying
        int 21h    ; Execute 
    push bp   ;put the return address into stack
    ret 

;-------------------------------------------------
 
proc New_Line ; function process a new line
    pop bp    ; save return address
        mov ah,02h   ; preparing for displaying just a 'char'
        mov dl,0Dh   ; DL == 'Enter' \ begin of the line
        int 21h      ; Execute 
        mov dl,0Ah   ; moves down new line
        int 21h      ; Execute
    push bp          ; put the return address into stack
    ret

;-------------------------------------------------
 
proc Error_Display ; Displays The Error Msg
    pop bp  ; Save the return address
        mov dx ,offset error_msg  ; to show the message in our data 'string'
        mov ah,09h                ; preparing for displaying
        int 21h                   ; Execute  
    push bp                       ; put the return address into stack
    ret

;-------------------------------------------------

proc input     ; this function takes an input number 
    pop bp     ; save return address
        mov ah,01h   ; Preparing to take a KeyPress
        int 21h      ; Execute
        mov dl,al    ; DL = AL
        cmp dl,0Dh   ; Comparing if the input == 'Enter'
        jz Enter     ; if True Jump to Enter Label
        cmp dl,30h   ; Compare input and '0'
        jb error     ; if input less than '0' , if True go Error
        cmp dl,39h   ; Compare input and '9'
        ja error     ; if input greater than '9' , if True go Error
        mov dh,00h   ; DH = 0
        sub dx,30h   ; DL = DL - 30h (Convert the input from ASCII to Integer)
        push dx      ; Put the dx into stack
    Enter:  ; Enter Label
    push bp ; put the return address into stack
    ret

;------------------------------------------------- 

proc comma    ; this function displays comma
    pop bp    ; save return address
    
    mov ah,2  ; preparing for printing
    mov dl,44 ; comma in ASCII 
    int 21h   ; execute
    push bp   ; put the return address into stack
    
    ret


;-------------------------------------------------

main:
    call Input_Display ; Printing the input message
    again:
    call input      ; taking the input number
    cmp  dl ,0Dh    ; Comparing the first Digit of our input nubmer with 'Enter'
    jz error        ; if True go to Error Label
    cmp dl, 00h        ;if user enters zero
    jz endfib          ; if user enters zero close program
    call input      ; taking the Second digit of our input number
    cmp dl,0Dh      ; Comparing the Second Digit of our input nubmer with 'Enter'
    
    jz Fibo_One_Digit  ; if True Generate A Fibonacci Series of a one digit number
    
    pop bx          ; first digit
    pop ax          ; second digit
    mov dx,10       ; mov dx = 10
    mul dx          ; second digit * 10
    add ax,bx       ; generate 2 digits (second*10+first)
     
     
    cmp ax,19h      ; compare ax with 9
    ja error        ; if higher than digit 9 in ASCII go error
    cmp ax,00h      ; compare ax with 0
    jb error        ; if lower than 0 in ASCII go error
    push ax         ; push into stack                              
        
    
Fibo_One_Digit:
    pop cx ; put the number from stack to CX 
    push cx  ; save the number into stack
    cmp cx,00h  ; Compare the CX with '0'
    jz error ; if True Print Nothing 	    
    
    pop cx
    call New_line
    push 0
    push 0
    mov dl,48
    int 21h
    cmp cx, 1h
    jz finish 
    call comma
    mov dl,49
    int 21h
    dec cx
    cmp cx,2    ; Compare CX with '2'
    jb finish   ; if Result Below 2 go to Ghost Label
    sub cx,1    ; CX = CX - 1 
    push cx     ; Put the CX into stack 
    
    push 1      ; push 1 into stack
    push 1      ; push 1 into stack
    push 1      ; push 1 into stack
    push 0      ; push 0 into stack
    
    
fibo:  
    call comma     ; generating ','
    call Gene_Fibonacci   ; Generating the Fibonacci Series
    call Obtain_Digits ; Generating the Digits of Fibonacci Output
    call Print_Fibonacci      ; Print the Fibonacci Series     
    
    ; the following lines for Inc cx as we can loop in fibonacci
    
    pop di          
    pop bx
    pop ax
    pop si
    pop cx
    dec cx
    push cx
    push si 
    push ax
    push bx
    push di
    cmp cx,00
    jnz fibo 
    call New_line
         
finish:
    call New_Line 
    jmp main 

error:

    call New_Line ; New Line
    call Error_Display  ; Shows an Error Message
    jmp again      ; Go to the main code
endfib:
ret