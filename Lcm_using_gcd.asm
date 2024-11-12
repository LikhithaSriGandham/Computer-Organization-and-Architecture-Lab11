.model small
.stack 100h
.data
num1 db  2         ; First number (single byte)
num2 db 4          ; Second number (single byte)
gcd_res db 0       ; To store GCD result (single byte)
lcm_res dw 0       ; To store LCM result (two bytes for larger result)
msg_gcd db 'GCD: $'
msg_lcm db 'LCM: $'

.code
main:
mov ax, @data
mov ds, ax         ; Initialize data segment

; Display message for GCD
mov ah, 09h        ; DOS function to display string
lea dx, msg_gcd
int 21h

; Load num1 and num2 into AL and BL for GCD calculation
mov al, num1
mov bl, num2
call gcd           ; Calculate GCD of num1 and num2
mov gcd_res, al    ; Store GCD in gcd_res

; Display GCD result
mov al, gcd_res
call display_result

; Calculate LCM using (num1 * num2) / GCD
mov al, num1       ; Load num1 into AL
mov ah, 0          ; Clear AH for 16-bit multiplication
mov dl, num2       ; Load num2 into DL
mul dl             ; AX = num1 * num2 (result in AX)

; Divide AX by the GCD (stored in gcd_res)
mov cl, gcd_res    ; Load GCD into CL
div cl             ; AX = (num1 * num2) / GCD

; Store the result in lcm_res
mov lcm_res, ax

; Display message for LCM
mov ah, 09h        ; DOS function to display string
lea dx, msg_lcm
int 21h

; Display LCM result
mov ax, lcm_res
call display_result

; End the program
mov ah, 4Ch
int 21h

; Function to calculate GCD using the Euclidean algorithm
gcd proc
cmp bl, 0
je end_gcd         ; If BL = 0, GCD is in AL

gcd_loop:
mov ah, 0
div bl             ; Divide AL by BL, remainder in AH
mov al, bl         ; Move BL to AL (new A)
mov bl, ah         ; Move remainder to BL (new B)
cmp bl, 0
jne gcd_loop       ; Repeat until remainder (B) = 0

end_gcd:
ret                ; Final GCD is in AL
gcd endp

; Function to display a number in AX as decimal
display_result proc
mov bx, 10         ; Divisor for decimal conversion
xor cx, cx         ; Clear CX to use as counter for digits

convert_loop:
xor dx, dx         ; Clear DX for division
div bx             ; Divide AX by 10, remainder in DX (last digit)
push dx            ; Push remainder onto stack
inc cx             ; Increment digit counter
cmp ax, 0          ; Check if quotient is 0
jne convert_loop   ; If not, continue dividing

print_digits:
pop dx             ; Pop digit from stack
add dl, '0'        ; Convert to ASCII
mov ah, 02h        ; DOS function to display character
int 21h            ; Display digit
loop print_digits  ; Repeat for all digits

ret
display_result endp

end main

