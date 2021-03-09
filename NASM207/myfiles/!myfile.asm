%macro First 1
	mov ah, 00h
	mov al,3
	int 10h
%endmacro

%macro Kursmacro 2
	mov ah, 02h
	mov bh, 0
	mov dh, %1
	mov dl, %2
	int 10h
%endmacro
	
%macro PoleM 6
	mov si, %3
	mov bl, %5
	shl bl, 4
	add bl, %6
	mov cx, %4
	mov dh, %1
	mov dl, %2
	call Pole
%endmacro

%macro HWM 4
	First 0
	mov dh, %1
	mov dl, %2
	mov bl, %3
	shl bl, 4
	add bl, %4
	call HW
%endmacro

%macro RamkaM 6
	Kursmacro %1,%2
	PoleM %1,%2,%3,%4, %5, %6
	Kursmacro %1,%2
	mov bl, %4
	mov si, %3
	sub si, 2
	sub bl, 2
	call Ramka
%endmacro

;===[ Начало сегмента кода ]============================================
MYCODE: segment .code
org 100h	; Обязательная директива ТОЛЬКО для COM-файлов
START:	;---[ Точка старта ]---------------------------------------------------------------------
	
		
	Kursmacro 3,7
	PoleM 3,7,12,16, 1001b, 0010b
	HWM 3,7, 1001b, 0010b
	RamkaM 3,7,6,8, 1001b, 0010b
	;---[ Стандартное завершение программы ]----------------------------------------
	mov AX, 4C00h
	int 21h

Kurs:
	mov ah, 00h
	mov al, 3
	int 10h
	mov ah, 02h
	mov bh, 0
	int 10h

Pole:	
cicle:	
	mov ah, 09h
	mov bh, 0
	mov al, 255
	int 10h
	dec si
	cmp si, 0
	jz end

	mov ah, 02h
	mov bh, 0
	inc dh
	int 10h

	jmp cicle
end:	ret

HW:	
	mov ah, 13h
	mov al, 0
	mov cx, 7
	mov bp, myup
	int 10h

	inc dh
	mov ah, 13h
	mov al, 0
	mov cx, 7
	mov bp, mystr1
	int 10h	

	inc dh
	mov ah, 13h
	mov al, 0
	mov cx, 7
	mov bp, mystr2
	int 10h

	inc dh
	mov ah, 13h
	mov al, 0
	mov cx, 7
	mov bp, mydown
	int 10h
	ret

Ramka:	

	mov ah, 0eh
	mov bh, 0
	mov al, 201
	int 10h

	mov cl, bl
midle:	mov ah, 0eh
	mov bh, 0
	mov al, 205
	int 10h	
	loop midle
	
	mov ah, 0eh
	mov bh, 0
	mov al, 187
	int 10h

ramci:	
	inc dh
	mov ah, 02h
	mov bh, 0
	mov dl, 7
	int 10h

	mov ah, 0eh
	mov bh, 0
	mov al, 186
	int 10h
	
	mov cl, bl
midle1:	mov ah, 0eh
	mov bh, 0
	mov al, 255
	int 10h	
	loop midle1
	
	mov ah, 0eh
	mov bh, 0
	mov al, 186
	int 10h
	
	dec si
	cmp si, 0
	jz endram
	jmp ramci
endram:	
	inc dh
	mov ah, 02h
	mov bh, 0
	mov dl, 7
	int 10h	

	mov ah, 0eh
	mov bh, 0
	mov al, 200
	int 10h
	
	mov cl, bl
midle2:	mov ah, 0eh
	mov bh, 0
	mov al, 205
	int 10h	
	loop midle2
	
	mov ah, 0eh
	mov bh, 0
	mov al, 188
	int 10h

	ret 
	

;===[ Начало сегмента данных ]==========================================
	align 16, db 90h
	db '=[MYDATA BEGIN]='
	myup db 201,205,205,205,205,205,187,'$'
	mystr1 db 186,'Hello',186,'$'
	mystr2 db 186,'world',186,'$'
	mydown db 200,205,205,205,205,205,188,'$'	

	align 16, db 32h
	times 16 db '='

