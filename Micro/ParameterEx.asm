.code
Parameter proc
	mov eax, ecx
	cmp edx, eax
	jg ReturnSmaller
	mov eax, edx

ReturnSmaller:
	cmp r8d, eax
	jg ReturnSmallest
	mov eax, r8d

ReturnSmallest:
	ret
Parameter endp
end