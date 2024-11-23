.code
Gcd proc
	mov eax, ecx
	mov ecx, edx
	cmp ecx, 0
	je Greater

	mov r8d, edx
	xor edx, edx
	div ecx
	mov eax, r8d

	jmp Gcd


Greater:
	ret

Gcd endp
end



; Comment Line
; eax -- > a
; ecx -- > b
; r8x -- > t
; t = b -- > mov r8x, edx
; b = a % b -- > xor edx, edx
; a = t -- > mov rax, r8x