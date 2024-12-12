.model small
.stack 100h

.data
    word db 'EMIRHAN', 0       ; Tahmin edilecek kelime
    guessed db '_______$', 0   ; Tahmin edilen harfler (null-terminated string)
    errors db 0                ; Yanl�� tahmin say�s�
    msg1 db 'Kelime Tahmin Oyununa Hos Geldiniz!', 13, 10, '$'
    msg2 db 'Kelimeyi tahmin etmeye calisin.', 13, 10, '$'
    msg3 db 'Gecersiz harf, tekrar deneyin.', 13, 10, '$'
    msg4 db 'Dogru harfi buldunuz!', 13, 10, '$'
    msg5 db 'Kelimeyi dogru bildiniz! Tebrikler!', 13, 10, '$'
    msg6 db 'Kaybettiniz! Kelime: ', 0
    newLine db 13, 10, '$'

    game_started db 0        ; Oyun ba�lad���n� kontrol eden bayrak

.code
main:
    ; Veri segmentini ba�lat
    mov ax, @data
    mov ds, ax

    ; E�er oyun ba�lamad�ysa, "Ho� Geldiniz" mesaj�n� yazd�r
    cmp byte ptr [game_started], 1
    je game_loop            ; E�er oyun ba�lad�ysa direk oyun d�ng�s�ne ge�
    mov ah, 09h
    lea dx, msg1
    int 21h
    lea dx, msg2
    int 21h
    call print_guessed  ; Ba�lang��ta guessed string'ini yazd�r
    mov byte ptr [game_started], 1   ; Oyun ba�lad���n� i�aretle

game_loop:
    ; Kullan�c�dan bir harf iste
    mov ah, 01h         ; Dosya okuma i�in fonksiyon
    int 21h
    mov bl, al          ; Kullan�c�n�n girdi�i harf

    ; Harf kontrol�: Do�ru tahmin
    call check_guess

    ; E�er kelime tamamland�ysa, oyun bitti
    call check_win
    jnz game_loop

    ; Yanl�� tahmin say�s� 6'ya ula��rsa kaybetti
    call check_loss
    jnz game_loop

    ; Oyun bitti
    mov ah, 4Ch
    int 21h

check_guess proc
    ; Kullan�c�dan al�nan harfi kelimede ara
    lea si, word
    lea di, guessed
    mov cx, 7            ; Kelimenin uzunlu�u
    mov dx, 0            ; Do�ru harf bulundu mu kontrol etmek i�in

search_loop:
    ; Her harfi kontrol et
    mov al, [si]         ; Kelimenin bir harfini al
    cmp al, bl           ; Kullan�c�n�n tahmin etti�i harf ile kar��la�t�r
    je correct_guess     ; E�er e�le�irse do�ru tahmin

next_char:
    inc si
    inc di
    loop search_loop
    ; Yanl�� harf oldu�unda hata say�s�n� artt�r
    inc byte ptr [errors]
    lea dx, msg3
    mov ah, 09h
    int 21h
    ret

correct_guess:
    ; Do�ru harf bulunduysa guessed string'ini g�ncelle
    lea si, word
    lea di, guessed
    mov cx, 7            ; Kelimenin uzunlu�u

update_guess:
    mov al, [si]         ; Kelimenin bir harfini al
    cmp al, bl           ; Harf do�ru mu?
    jne no_update
    mov [di], al         ; guessed string'ine harfi yerle�tir

no_update:
    inc si
    inc di
    loop update_guess

    ; Do�ru harf bulundu�unda mesaj yazd�r
    lea dx, msg4
    mov ah, 09h
    int 21h
    call print_guessed  ; guessed dizisini yazd�rarak do�ru tahmin edilen harfi g�ster

    ret
check_guess endp

print_guessed proc
    ; guessed string'ini ekrana yazd�r
    mov ah, 09h
    lea dx, guessed         ; guessed null-terminated string
    int 21h
    mov ah, 09h
    lea dx, newLine         ; Yeni sat�r ekle
    int 21h
    ret
print_guessed endp

check_win proc
    ; Kelimenin tamamland���n� kontrol et
    lea si, guessed
    mov cx, 7
check_win_loop:
    mov al, [si]
    cmp al, '_'
    je not_done
    inc si
    loop check_win_loop
    ; E�er t�m harfler do�ruysa
    lea dx, msg5
    mov ah, 09h
    int 21h
    mov al, 1   ; Oyun bitti
    ret
not_done:
    xor al, al  ; Oyun devam ediyor
    ret
check_win endp

check_loss proc
    ; Hata say�s�n� kontrol et
    mov al, [errors]
    cmp al, 6
    je lost_game
    ret

lost_game:
    ; Oyun kaybedildi
    lea dx, msg6
    mov ah, 09h
    int 21h
    lea dx, word
    mov ah, 09h
    int 21h
    mov al, 1   ; Oyun bitti
    ret
check_loss endp

end main
