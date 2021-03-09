%macro Inczmacro 1
	mov si, %1
	mov byte[ds:si],0
%endmacro

%macro IncLenght 1
	mov bl, byte[%1]
	inc bx
	mov byte[%1], bl
%endmacro

%macro lenghtmacro 1
	mov si, %1
	mov dl, byte[si]
%endmacro

%macro Incstrmacro 1
	mov bl, byte[%1]
	inc bx
	mov byte[%1+bx], dh
	mov byte[%1], bl
%endmacro

%macro Fillstrmacro 1
	mov cl, byte[%1]
zap%1:	mov bx, cx
	mov byte[%1+bx], dh
	loop zap%1
%endmacro

%macro Incstrbeginmacro 1
		mov cl, byte[%1]
begin%1:	mov bx, cx
		mov dl, byte[%1+bx]
		inc bx
		mov byte[%1+bx], dl
		loop begin%1
		mov byte[%1+1], dh 
		IncLenght %1
%endmacro

%macro Incstrrandmacro 2
	mov cl, byte[%1]
	mov ax, %2
	dec ax
	sub cl, al
rand%1:	mov bx, cx
	add bx, ax
	mov dl, byte[%1+bx]
	inc bx
	mov byte[%1+bx], dl
	loop rand%1
	mov bx, ax
	inc bx
	mov byte[%1+bx], dh 
	IncLenght si
%endmacro
	
%macro SearchSymBeginmacro 1
	mov bx, 1
	mov al, byte[%1]
nextsearch%1:
	cmp byte[%1+bx],dh
	jz endsearch%1
	inc bx
	cmp al, bl
	js nopesearch%1
	jmp nextsearch%1
endsearch%1:
nopesearch%1:
%endmacro

%macro SearchSymEndmacro 1
	mov cl, byte[%1]
Nsearch%1:
	mov bx,cx
	cmp byte[%1+bx],dh
	jz Esearch%1
	loop Nsearch%1
Esearch%1:
%endmacro

%macro SearchSymImacro 2
	mov ax, %2
	mov bx, 0
next%1:	inc bx
	cmp byte[%1+bx],dh
	jz prefind%1
	cmp byte[%1],bl
	jz find%1
	jmp next%1
prefind%1:
	dec ax
	cmp ax, 0
	jz find%1
	jmp next%1
find%1:	
%endmacro

%macro SearchSymCountmacro 1
	mov ax, 0
	mov cl, byte[%1]
Nend%1:	mov bx,cx
	cmp byte[%1+bx],dh
	jz FFind%1
endfind%1:	
	loop Nend%1
	jmp endmacro%1
FFind%1:	
	inc ax
	jmp endfind%1
endmacro%1:
%endmacro

;===[ Начало сегмента кода ]============================================
MYCODE: segment .code
org 100h	; Обязательная директива ТОЛЬКО для COM-файлов
START:	;---[ Точка старта ]---------------------------------------------------------------------
	
	Inczmacro 00h
	Inczmacro 20h
	Inczmacro 40h
	mov dh,'U'
	Incstrmacro 00h

	lenghtmacro 00h
	
	mov dh, '6'
	Fillstrmacro 00h
	mov dh, 'A'
	Incstrbeginmacro 00h
	
	mov dh, 'g'
	Incstrrandmacro 00h,1

	mov dh, 'A'
	call Incstrbegin
	
	mov dh, '6'
	SearchSymBeginmacro 00h

	mov dh, 'A'
	SearchSymEndmacro 00h

	SearchSymImacro 00h,2

	mov dh, '6'
	SearchSymCountmacro 00h

	;---[ Стандартное завершение программы ]----------------------------------------
	mov AX, 4C00h
	int 21h

Incz:	mov al, 0
	mov byte[si], ah
	ret

lenght:	mov dl, byte[si]
	ret

Incstrend:	
	mov bl, byte[si]
	inc bx
	mov byte[si+bx], dh
	mov byte[si], bl
	ret

Fillstr:
	mov cl, byte[si]
zap:	mov bx, cx
	mov byte[si+bx], dh
	loop zap
	ret
	
Incstrbegin:
	mov cl, byte[si]
begin:	mov bx, cx
	mov dl, byte[si+bx]
	inc bx
	mov byte[si+bx], dl
	loop begin
	mov byte[si+1], dh 
	IncLenght si
	ret

Incstrrand:
	mov cl, byte[si]
	dec ax
	sub cl, al
rand:	mov bx, cx
	add bx, ax
	mov dl, byte[si+bx]
	inc bx
	mov byte[si+bx], dl
	loop rand
	mov bx, ax
	inc bx
	mov byte[si+bx], dh 
	IncLenght si
	ret	

SearchSymBegin:
	mov bx, 1
	mov al, byte[si]
nextsearch:
	cmp byte[si+bx],dh
	jz endsearch
	inc bx
	cmp al, bl
	js nopesearch
	jmp nextsearch
endsearch:
nopesearch:
	ret

SearchSymEnd:
	mov cl, byte[si]
Nsearch:mov bx,cx
	cmp byte[si+bx],dh
	jz Esearch
	loop Nsearch
Esearch:
	ret
	
SearchSymI:
	mov bx, 0
next:	inc bx
	cmp byte[si+bx],dh
	jz prefind
	cmp byte[si],bl
	jz find
	jmp next
prefind:
	dec ax
	cmp ax, 0
	jz find
	jmp next
find:	ret

SearchSymCount:
	mov ax, 0
	mov cl, byte[si]
Nend:	mov bx,cx
	cmp byte[si+bx],dh
	jz FFind
endfind:	
	loop Nend
	ret
FFind:	
	inc ax
	jmp endfind

;===[ Начало сегмента данных ]==========================================


