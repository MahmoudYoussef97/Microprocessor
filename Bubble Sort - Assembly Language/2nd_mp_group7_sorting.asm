.model tiny
.data 
str db 'Please enter the number of elements in the array to be sorted or press 0 to terminate:$'
str1 db 'Please enter suitable number in the range of [1 - 25]:$'
str2 db 'Enter a for ascending order or d for descending order:$'
str3 db  'Please enter elements of the array to be sorted:$'
str4 db 'Enter a for ascending order or d for descending order:$'
str5 db 'The sorted array is:$' 
f db ?
n dw ? 
nums dw 25 dup(0)  

;------------------------------------------------------------------
.code
mov ax, 03   ;open console
int 10h        ;execute
jmp main    

;------------------------------------------------------------------

msg_start proc ;displaying starting message
mov ah, 09
mov dx, offset str
int 21h        ;execute
ret   
 
;------------------------------------------------------------------

sort_msg proc  ;displaying message to user to display below elements of array
mov ah, 09
mov dx, offset str5
int 21h
ret
;------------------------------------------------------------------

detect_msg proc ;displaying message to user to choose ascending or descending order
mov ah, 09
mov dx, offset str4
int 21h         ;execute
ret  
;------------------------------------------------------------------

flag proc
mov ah, 01
int 21h
mov f, al
ret  
;------------------------------------------------------------------

input_n proc   ;take n 
mov bx, 0
mov ah, 01     ;read char
int 21h        ;execute
cmp al, '0'    ;if less 0
jl error       ;go to error
je finish      ;if equal 0 go ot terminate
cmp al, '9'    ;if larger 9
jg error       ;go to error
mov bl, al     
sub bl, 30h    ;convet to integer
int 21h        ;execute
cmp al, 013     ;if equal enter
je start       ;go to start
cmp al, '0'    ;if less 0
jl error       ;go to error
cmp al, '9'    ;if larger 0
jg error       ;go to error
mov cl, al
sub cl,30h     ;convert to integer 
mov ax,bx      ;first * 10 + second 
mov dl, 10
mul dl                             
add cx, ax
mov bx, cx
start:         
mov n, bx 
cmp bx, 25     ;ckeck if num > 25
jg error
ret
;------------------------------------------------------------------
 
new_line proc  ;dispaly new line
mov ah, 02
mov dl, 013
int 21h        ;execute
mov dl, 010
int 21h        ;execute
ret 
;------------------------------------------------------------------

msg_second proc   ;display message to make user entering inputs
mov ah, 09
mov dx, offset str3
int 21h
ret 
;------------------------------------------------------------------

input_num proc    ;to take number of elements
pop bp
push di
mov nums[si], 0 ;clear arr
label1:
mov cx, 0
mov ah, 01     ;read char
int 21h        ;excute
cmp al, 013     ;if equal enter
je sure        ;go to sure
mov cl, al
sub cl, 30h
mov ax, nums[si] ;num * 10 + digit 
mov dx, 0
mov di, 10
mul di           
add ax, cx
mov nums[si], ax 
mov ax, nums[si]
jmp label1
sure:
pop di
push bp
ret   
;------------------------------------------------------------------

comma_dis proc   ;dispaly comma
mov ah, 02
mov dl, 044
int 21h
ret  
;------------------------------------------------------------------

error_msg proc      ;dispalay error message
mov dx, offset str1
mov ah, 09
int 21h
ret   
;------------------------------------------------------------------

bubble_sort proc    ;bubble sort algorithm
mov dx, -2
mov ax, n
mov bx,2
mul bl
mov bx,ax
sub bx, 4
label2:
add dx, 2
cmp dx, bx
jg label7
mov di, 0
label3:
mov si, di
add si, 2            
mov ax, nums[di]
cmp f, 'd'           ;to check ascending or descending
je choose           
cmp ax, nums[si]     ;if ascending order
ja do
jmp again
choose:              ;if descending order
cmp ax, nums[si]
jb do
again:
cmp bx,di            ;to know if nested loop is finished or not
je label2            ;go to main loop
add di, 2
jmp label3           ;continue in nested loop
label7:
ret        

;------------------------------------------------------------------

output_nums proc    ;to display elements of array
pop bp              ;ex num = 54321
push 10             ;5
mov ax, nums[di]    ;4
label4:             ;3
mov dx, 0           ;2
mov bx, 10          ;1
div bx              ;10 that is at bottom of stack
push dx             
cmp ax, 0
jne label4
mov ah, 02
label5:
pop dx
cmp dl, 10         ;to know num is finsihed or no
je fin
add dl, 30h
int 21h
jmp label5
fin:
push bp
ret  

;------------------------------------------------------------------

main:
call msg_start    ;to display message to user to enter number of elements
direct:
mov ax, 0
mov bx, 0
mov dx, 0
mov cx, 0
call input_n      ;to take input n from user
call new_line 
push si
push di
mov si, 0 
mov di, 0
call msg_second   ;displaying message to user to enter elements
call new_line     ;dispaly new line
label:
call input_num    ;to take element of array
inc di
add si, 2
cmp di, n
call new_line     ;display new line
jne label 
call detect_msg   ;to know ascending or descending
call flag         ;to take char a or d
call new_line     ;dispalying newline       
call bubble_sort  ;execute algorithm bubble sort
mov di, 0 
mov si, 0 
call sort_msg     ;to diplay elements below
call new_line     ;display first element of array
call output_nums
add di, 2
add si, 1
cmp si, n
je direct
label6:
call comma_dis    ;display comma
call output_nums  ;display other elements
inc si
add di, 2
cmp si, n
jne label6 
call new_line     ;display new line
jmp main
do:               ;to swap between to numbers
mov cx, nums[si]
mov nums[si] , ax
mov nums[di] , cx
jmp again
error: 
call new_line     ;display new line
call error_msg    ;display error msg
jmp direct 
finish:
end