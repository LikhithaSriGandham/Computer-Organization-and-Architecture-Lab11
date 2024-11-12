.MODEL SMALL
.STACK 100H
.DATA
msg db 'Enter a single-digit number (0-9): $'    ; Prompt message for input
result_msg db 0Dh, 0Ah, 'Factorial: $'           ; Message to display the result
result db '00000$', 0Dh, 0Ah                     ; Space to store factorial result as a string
num db ?                                         ; Variable to store the input number
fact dw 1                                        ; Variable to store the factorial result

.CODE
main:
; Initialize data segment
mov ax, @data
mov ds, ax

; Display prompt message
mov ah, 09h
lea dx, msg
int 21h

; Take single-digit input from user
mov ah, 01h
int 21h
sub al, '0'                ; Convert ASCII to integer
mov num, al                ; Store user input in 'num'

; Initialize factorial calculation
mov al, num
mov ah, 0                  ; Clear AH to extend AL to AX
mov cx, ax                 ; Move AX to CX (counter)
mov ax, 1                  ; Initialize AX to 1 (factorial result)

factorial_loop:
cmp cx, 1                  ; Compare CX to 1
je end_factorial_loop      ; If CX is 1, end the loop
mul cx                     ; Multiply AX by CX
loop factorial_loop        ; Decrement CX and repeat the loop

end_factorial_loop:
; Store the factorial result in 'fact'
mov fact, ax

display_factorial:
; Display result message
mov ah, 09h
lea dx, result_msg
int 21h

; Convert the factorial result to ASCII
mov ax, fact
mov cx, 10                 ; Prepare divisor (10) for unpacking digits
lea di, result + 4         ; Start storing result from the end

convert_to_ascii:
xor dx, dx                 ; Clear DX for division
div cx                     ; AX = AX / 10, DX = remainder (last digit)
add dl, '0'                ; Convert remainder to ASCII
mov [di], dl               ; Store ASCII character in result
dec di                     ; Move to the next character position
cmp ax, 0                  ; Check if quotient is zero
jne convert_to_ascii       ; Repeat if there are more digits

; Display the factorial result
lea dx, result
mov ah, 09h
int 21h

; End the program
mov ah, 4Ch
int 21h

end main


