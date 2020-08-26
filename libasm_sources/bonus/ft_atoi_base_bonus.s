section	.text
	global	ft_atoi_base

;int	ft_atoi_base(const char *str,const char *base)
;rax	ft_atoi_base(rdi, rsi)

ft_atoi_base:
		;PUSH	rbx						;save sign
		;PUSH	r12						;save base length)
	XOR		rax, rax			;initialize rax(i.e. the return value) at 0
	XOR		rbx, rbx			;initialize rbx(i.e. the sign) at 0
	XOR		r12, r12			;initialize r12(i.e. the base length) at 0
	JMP		base_check_loop

base_check_increment:
			inc		r12				; base_length++

base_check_loop:
	CMP		BYTE [rsi + r12], 0	;check if rsi[r12] == '\0'
	JZ		base_check_end		;if equal, jump to base_check_end layer
	MOV		r8, r12				;r8 receives the value of r12 (j = i)

base_check_dup_inc:
	INC		r8					;j++

base_check_dup_loop:
	CMP	BYTE [rsi + r8], 0		; !base[j]
			jz		base_check_correct
			mov		r9b, [rsi + r8]
			cmp		BYTE [rsi + r12], r9b	; base[base_length] == base[j]
			je		set_rax
			jmp		base_check_dup_inc
base_check_correct:
			cmp		BYTE [rsi + r12], 32	; base[base_length] == ' '
			je		set_rax
			cmp		BYTE [rsi + r12], 43	; base[base_length] == '+'
			je		set_rax
			cmp		BYTE [rsi + r12], 45	; base[base_length] == '-'
			je		set_rax
			cmp		BYTE [rsi + r12], 9		; base[base_length] == '\t'
			je		set_rax
			cmp		BYTE [rsi + r12], 10	; base[base_length] == '\n'
			je		set_rax
			cmp		BYTE [rsi + r12], 13	; base[base_length] == '\r'
			je		set_rax
			cmp		BYTE [rsi + r12], 11	; base[base_length] == '\v'
			je		set_rax
			cmp		BYTE [rsi + r12], 12	; base[base_length] == '\f'
			je		set_rax
			jmp		base_check_increment
base_check_end:
			cmp		r12, 1					; base_length <= 1
			jle		set_rax
			xor		r8, r8					; i = 0
			jmp		skip_whitespaces
skip_whitespaces_inc:
			inc		r8						; i++
skip_whitespaces:
			cmp		BYTE [rdi + r8], 32		; str[i] == ' '
			je		skip_whitespaces_inc
			cmp		BYTE [rdi + r8], 9		; str[i] == '\t'
			je		skip_whitespaces_inc
			cmp		BYTE [rdi + r8], 10		; str[i] == '\n'
			je		skip_whitespaces_inc
			cmp		BYTE [rdi + r8], 13		; str[i] == '\r'
			je		skip_whitespaces_inc
			cmp		BYTE [rdi + r8], 11		; str[i] == '\v'
			je		skip_whitespaces_inc
			cmp		BYTE [rdi + r8], 12		; str[i] == '\f'
			je		skip_whitespaces_inc
			jmp		check_sign
is_negative:
			xor		bl, 0x00000001
is_positive:
			inc		r8
check_sign:
			cmp		BYTE [rdi + r8], 45		; str[i] == '-'
			je		is_negative
			cmp		BYTE [rdi + r8], 43		; str[i] == '+'
			je		is_positive
			jmp		atoi_loop
atoi_increment:
			inc		r8						; i++
atoi_loop:
			cmp		BYTE [rdi + r8], 0		; str[i] == 0
			je		set_rax
			xor		r9, r9					; j = 0
			jmp		atoi_idx
atoi_idx_inc:
			inc		r9						; j++
atoi_idx:
			mov		r10b, BYTE [rsi + r9]
			cmp		r10b, 0					; base[j] == 0
			je		set_rax
			cmp		BYTE [rdi + r8], r10b	; base[j] == str[i]
			jne		atoi_idx_inc
add_to_total:
			mul		r12						; total *= base_length
			add		rax, r9					; total += k
			jmp		atoi_increment
set_rax:
			mov		rax, rax				; ret = total
			cmp		rbx, 0					; sign is negative
			jz		return
			neg		rax						; ret = -ret
return:
			pop		r12						; restore r12
			pop		rbx						; restore rbx
			ret