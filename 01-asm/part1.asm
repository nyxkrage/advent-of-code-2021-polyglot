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

	mov rdi,rsp
	call atoi
	mov rbx,rax
	inc rdi
convert_loop:
	movzx rsi, byte [rdi]	; Get the current character
	cmp rsi,0				; Check for \0
	je fin
	call atoi
	cmp rax,rbx
	jg inc_counter
loop_cont:
	mov rbx,rax
	inc rdi
	jmp convert_loop
fin:
	mov rax,60				; system call (exit)
	xor rdi,rdi				; exit with code zero
	syscall

inc_counter:
	inc r8
	jmp loop_cont

atoi:
    mov rax, 0				; Set initial total to 
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
	ret		; Return total or error code

section	.data
path db 'input', 0  ;string to be printed