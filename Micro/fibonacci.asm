.data
MyByte dw "A"

.code
testFunction proc
	xor rbx, rbx
	lea rbx, MyByte
	testFunction endp
	mov rax, 123h
end