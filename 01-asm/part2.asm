section	.text
   global _start     ; must be declared for linker (ld)

_start:						; tells linker entry point
	mov	rax,2				; system call (open)
	mov	rdi,path			; filepath
	xor	rsi,rsi				; file access mode (RO)
	syscall

	push rax				; push fd to stack
	sub rsp,9749			; reserve space for "part1.input"

	xor rax,rax				; system call (read)
	mov rdi,[rsp+9749]		; move the file descriptor
	mov rsi,rsp				; address of buffer
	mov rdx,9749			; size of buffer
	syscall

	;; The difference between the sum of A and B is just the difference between the numbers they dont have in common
	;; So every iteration we can just compare the current line with the line 3 above it

	mov rdi,rsp ; use rdi for the pointer to the input string
	call atoi ; convert first line to a number
	mov r8,rax ; move it to the r8 register
	inc rdi ; increment our pointer past the \n
	call atoi ; repeat but with r9
	mov r9,rax
	inc rdi
	call atoi ; repeat with rbx
	inc rdi
	mov rbx,rax
convert_loop:
	movzx rsi, byte [rdi]	; Get the current character
	cmp rsi,0				; Check for \0
	je fin ; exit the program
	call atoi ; convert the next line, which would be the last line of the next sequence
	cmp rax,r8 ; compare the last line of the next sequence with the first of the previous
	jg inc_counter ; increment the counter
loop_cont:
	mov r8,r9 ; move the lines up so we can run the same loop
	mov r9,rbx
	mov rbx,rax
	inc rdi
	jmp convert_loop ; rerun the loop

inc_counter:
	inc r12
	jmp loop_cont

fin:
	mov rax,60				; system call (exit)
	xor rdi,rdi				; exit with code zero
	syscall

atoi:
	mov rax, 0				; Set initial total to 0
convert:
	movzx rsi, byte [rdi]	; Get the current character
	cmp rsi,10				; Check for \n
	je done
	
	cmp rsi, 48				; Anything less than 0 is invalid
	jl error

	cmp rsi, 57				; Anything greater than 9 is invalid
	jg error

	sub rsi, 48				; Convert from ASCII to decimal 
	imul rax, 10			; Multiply total by 10
	add rax, rsi			; Add current digit to total

	inc rdi					; Get the address of the next character
	jmp convert
error:
	mov rax, -1				; Return -1 on error
done:
	ret                     ; Return total or error code

section	.data
path db 'input', 0  ;path of the input file