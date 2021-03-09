%macro GenFileMacro 1
   	mov dx,%1        	;Имя файла
	call GenFile
%endmacro 

%macro FileWritingMacro 2
   	mov dx,%1        	;Имя файла
	mov word[1], %2
	call FileWriting
%endmacro

%macro FileReadMacro 2
   	mov dx,%1        	;Имя файла
	mov word[1], %2
	call FileRead
%endmacro

%macro FileReadStrMacro 3
	FileReadMacro %1, rmessage
	mov byte[9], %3
	mov word[4], %2
	call FileReadStr
%endmacro

%macro FileWritingIniMacro 5
	mov dx,%1        	;Имя файла
	mov word[1], %2
	mov word[3], %3
	mov word[5], %4
	mov word[7], %5
	call FileWritingIni
%endmacro

;===[ Начало сегмента кода ]============================================
MYCODE: segment .code
org 100h	; Обязательная директива ТОЛЬКО для COM-файлов
START:	;---[ Точка старта ]---------------------------------------------------------------------
	
	GenFileMacro file_name
	FileWritingIniMacro file_name, IT1, IT2, IT3, IT4
	;FileWritingMacro file_name, message
	;FileReadMacro file_name, rmessage
	;FileReadStrMacro file_name, rsmessage, 2
	;---[ Стандартное завершение программы ]----------------------------------------
	mov AX, 4C00h
	int 21h
;===============================================================================
GenFile:
	mov ah,3Ch              	;Функция DOS 3Ch (создание файла)
  	mov cx,0                	;Нет атрибутов - обычный файл
    	int 21h                 	;Обращение к функции DOS
    	jnc NO_ERR1             	;Если нет ошибки, то продолжаем
    	call error_msg          	;Иначе вывод сообщения об ошибке
    	jmp exit1               	;Выход из программы
NO_ERR1:
    	mov [handle],ax         	;Сохранение дескриптора файла

    	mov ah,3Eh              	;Функция DOS 3Eh (закрытие файла)
    	mov bx,[handle]         	;Дескриптор
    	int 21h                 	;Обращение к функции DOS
    	jnc exit1               	;Если нет ошибки, то выход из программы
    	call error_msg          	;Вывод сообщения об ошибке
exit1:
    	mov ah,9
    	mov dx,s_pak
    	int 21h                 	;Вывод строки 'All is ok!'
	ret
;===============================================================================
FileWriting:
		mov ah,3Dh              	;Функция DOS 3Dh (открытие файла)
    	mov al,1                	;Режим открытия - только запись
    	mov cx,0                	;Нет атрибутов - обычный файл
    	int 21h                 	;Обращение к функции DOS
    	jnc NO_ERR2             	;Если нет ошибки, то продолжаем
    	call error_msg          	;Иначе вывод сообщения об ошибке
    	jmp exit2               	;Выход из программы
NO_ERR2:
    	mov [handle],ax         	;Сохранение дескриптора файла
		
		mov bx,[handle]         	;Дескриптор файла
    	mov ah,40h              	;Функция DOS 40h (запись в файл)
    	mov dx, word[1]         	;Адрес строки с данными
    	movzx cx,[size]         	;Размер данных
    	int 21h                 	;Обращение к функции DOS
    	jnc close_file1     		;Если нет ошибки, то закрыть файл
    	call error_msg          	;Вывод сообщения об ошибке

close_file1:
    	mov ah,3Eh              	;Функция DOS 3Eh (закрытие файла)
    	mov bx,[handle]         	;Дескриптор
    	int 21h                 	;Обращение к функции DOS
    	jnc exit2               	;Если нет ошибки, то выход из программы
    	call error_msg          	;Вывод сообщения об ошибке

exit2:
    	mov ah,9
    	mov dx,s_pak
    	int 21h                 	;Вывод строки 'All is ok!'
	ret

;===============================================================================
FileRead:
		mov ah,3Dh              	;Функция DOS 3Dh (открытие файла)
    	mov al,0                	;Режим открытия - только чтение
    	mov cx,0                	;Нет атрибутов - обычный файл
    	int 21h                 	;Обращение к функции DOS
    	jnc NO_ERR3             	;Если нет ошибки, то продолжаем
    	call error_msg          	;Иначе вывод сообщения об ошибке
    	jmp exit3               	;Выход из программы
NO_ERR3:
    	mov [handle],ax         	;Сохранение дескриптора файла
 

    	mov bx,[handle]         	;Дескриптор файла
    	mov ah,3Fh              	;Функция DOS 3Fh (чтение из файла)
    	mov dx,word[1]          	;Адрес буфера для данных
    	mov cx,80               	;Максимальное кол-во читаемых байтов
    	int 21h                 	;Обращение к функции DOS
    	jnc MYREAD2     			;Если нет ошибки, то продолжаем
    	call error_msg          	;Вывод сообщения об ошибке
    	jmp close_file3          	;Закрыть файл и выйти из программы
 
MYREAD2:
    	mov bx,word[1]
    	add bx,ax               	;В AX количество прочитанных байтов
    	mov byte[bx],'$'        	;Добавление символа '$'

    	mov ah,9
    	mov dx,word[1]
    	int 21h                 	;Вывод содержимого файла
    	mov dx,endline
    	int 21h                 	;Вывод перехода на новую строку
 
close_file3:
    	mov ah,3Eh              	;Функция DOS 3Eh (закрытие файла)
    	mov bx,[handle]         	;Дескриптор
    	int 21h                 	;Обращение к функции DOS
    	jnc exit3               	;Если нет ошибки, то выход из программы
    	call error_msg          	;Вывод сообщения об ошибке 
		ret

exit3:
    	mov ah,9                	;Вывод строки 'All is ok!'
    	mov dx,s_pak
    	int 21h
		ret
;===============================================================================
FileReadStr:
		mov bx,0
		mov al,1
		mov dx,0
		mov si, word[4]
cicle:		
			mov cx, 2
			cmp al, byte[9]
			jz yes
			cmp byte[rmessage+bx],10
			jz smen
			inc bx
			loop cicle
smen:
			inc al
			inc bx
			loop cicle

yes:		cmp dx,0
			jnz flag
			mov dx,bx
			dec dx
			mov bx,0
flag:
			inc bx
			cmp byte[rmessage+bx],10
			jz end
			add bx,dx
			mov ah,byte[rmessage+bx]
			sub bx,dx
			mov byte[si+bx],ah
			loop cicle
end:		
			add bx,dx
			mov ah,byte[rmessage+bx]
			sub bx,dx
			mov byte[si+bx],ah
			add bx,dx
			mov ah,byte[rmessage+bx]
			sub bx,dx
			mov byte[si+bx],ah
			ret

;===============================================================================
FileWritingIni:
		mov ah,3Dh              	;Функция DOS 3Dh (открытие файла)
    	mov al,1                	;Режим открытия - только запись
    	mov cx,0                	;Нет атрибутов - обычный файл
    	int 21h                 	;Обращение к функции DOS
    	jnc NO_ERR					;Если нет ошибки, то продолжаем
    	call error_msg          	;Иначе вывод сообщения об ошибке
    	jmp exit					;Выход из программы
NO_ERR:
    	mov [handle],ax         	;Сохранение дескриптора файла
		
		mov bx,[handle]         	;Дескриптор файла
    	mov ah,40h              	;Функция DOS 40h (запись в файл)
    	mov dx, word[1]         	;Адрес строки с данными
    	movzx cx,[size1]         	;Размер данных
    	int 21h                 	;Обращение к функции DOS

		mov bx, ax
		and ax,	0F000h
		shr ax, 4
		add ah, 30h
		mov byte[registr],ah
		mov ax,bx
		and ax,	0F00h
		add ah, 30h
		mov byte[registr+1],ah
		mov ax, bx
		and ax,	0F0h
		shr ax, 4
		add al, 30h
		mov byte[registr+2],al
		mov ax,bx
		and ax,	0Fh
		add al, 30h
		mov byte[registr+3],al


		mov bx,[handle]         	;Дескриптор файла
    	mov ah,40h              	;Функция DOS 40h (запись в файл)
    	mov dx, registr				;Адрес строки с данными
    	movzx cx,[size2]         	;Размер данных
    	int 21h                 	;Обращение к функции DOS
    	jnc ITM2     				;Если нет ошибки, то закрыть файл
    	call error_msg          	;Вывод сообщения об ошибке


ITM2:	
		mov bx,[handle]         	;Дескриптор файла
    	mov ah,40h              	;Функция DOS 40h (запись в файл)
    	mov dx, word[3]         	;Адрес строки с данными
    	movzx cx,[size3]         	;Размер данных
    	int 21h                 	;Обращение к функции DOS

		mov dx, bx
		and bx,	0F000h
		shr bx, 4
		add bh, 30h
		mov byte[registr],bh
		mov bx,dx
		and bx,	0F00h
		shr bx, 8
		add bl, 30h
		mov byte[registr+1],bl
		mov bx, dx
		and bx,	0F0h
		shr bx, 4
		add bl, 30h
		mov byte[registr+2],bl
		mov bx,dx
		and bx,	0Fh
		add bl, 30h
		mov byte[registr+3],bl

		mov bx,[handle]         	;Дескриптор файла
    	mov ah,40h              	;Функция DOS 40h (запись в файл)
    	mov dx, registr				;Адрес строки с данными
    	movzx cx,[size2]         	;Размер данных
    	int 21h                 	;Обращение к функции DOS
    	jnc ITM3     				;Если нет ошибки, то закрыть файл
    	call error_msg          	;Вывод сообщения об ошибке

ITM3:	
		mov bx,[handle]         	;Дескриптор файла
    	mov ah,40h              	;Функция DOS 40h (запись в файл)
    	mov dx, word[5]         	;Адрес строки с данными
    	movzx cx,[size3]         	;Размер данных
    	int 21h                 	;Обращение к функции DOS

		mov bx, cx
		and cx,	0F000h
		shr cx, 4
		add ch, 30h
		mov byte[registr],ch
		mov cx,bx
		and cx,	0F00h
		add ch, 30h
		mov byte[registr+1],ch
		mov cx, bx
		and cx,	0F0h
		shr cx, 4
		add cl, 30h
		mov byte[registr+2],cl
		mov cx,bx
		and cx,	0Fh
		add cl, 30h
		mov byte[registr+3],cl


		mov bx,[handle]         	;Дескриптор файла
    	mov ah,40h              	;Функция DOS 40h (запись в файл)
    	mov dx, registr				 ;Адрес строки с данными
    	movzx cx,[size2]         	;Размер данных
    	int 21h                 	;Обращение к функции DOS
    	jnc ITM4     				;Если нет ошибки, то закрыть файл
    	call error_msg          	;Вывод сообщения об ошибке

ITM4:	
		mov bx,[handle]         	;Дескриптор файла
    	mov ah,40h              	;Функция DOS 40h (запись в файл)
    	mov dx, word[7]         	;Адрес строки с данными
    	movzx cx,[size3]         	;Размер данных
    	int 21h                 	;Обращение к функции DOS

		mov bx, dx
		and dx,	0F000h
		shr dx, 4
		add dh, 30h
		mov byte[registr],dh
		mov dx,bx
		and dx,	0F00h
		add dh, 30h
		mov byte[registr+1],dh
		mov dx, bx
		and dx,	0F0h
		shr dx, 4
		add dl, 30h
		mov byte[registr+2],dl
		mov dx,bx
		and dx,	0Fh
		add dl, 30h
		mov byte[registr+3],dl


		mov bx,[handle]         	;Дескриптор файла
    	mov ah,40h              	;Функция DOS 40h (запись в файл)
    	mov dx, registr				;Адрес строки с данными
    	movzx cx,[size2]         	;Размер данных
    	int 21h                 	;Обращение к функции DOS
    	jnc close_file     			;Если нет ошибки, то закрыть файл
    	call error_msg          	;Вывод сообщения об ошибке

close_file:
    	mov ah,3Eh              	;Функция DOS 3Eh (закрытие файла)
    	mov bx,[handle]         	;Дескриптор
    	int 21h                 	;Обращение к функции DOS
    	jnc exit               	;Если нет ошибки, то выход из программы
    	call error_msg          	;Вывод сообщения об ошибке

exit:
    	mov ah,9
    	mov dx,s_pak
    	int 21h                 	;Вывод строки 'All is ok!'
	ret

;===============================================================================
error_msg:
    	mov ah,9
    	mov dx,s_error
    	int 21h                 	;Вывод сообщения об ошибке
    	ret
;===============================================================================



;===[ Начало сегмента данных ]==========================================
align 16, db 90h
db '=[MYDATA BEGIN]='
rsmessage	db 1
align 16, db 90h
rmessage	db 1
align 16, db 90h
message		db 'Hello',10,'world',33,0
align 16, db 90h
file_name	db '5555.ini',0
align 16, db 90h
s_pak     	db 'All is ok!',10,'$'
align 16, db 90h
s_error   	db 'Error!',13,10,'$'
align 16, db 90h
handle    	dw 1 
align 16, db 90h
size      	db 12
align 16, db 90h
endline   	db 13,10,'$'
size1 db 15
size2 db 4
size3 db 4
IT1 db '[REGISTERS]',10,'AX='
IT2 db 13,'BX='
IT3 db 13,'CX='
IT4 db 13,'DX='
registr db 1