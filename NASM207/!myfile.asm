%macro GenFileMacro 1
   	mov dx,%1        	;��� �����
	call GenFile
%endmacro 

%macro FileWritingMacro 2
   	mov dx,%1        	;��� �����
	mov word[1], %2
	call FileWriting
%endmacro

%macro FileReadMacro 2
   	mov dx,%1        	;��� �����
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
	mov dx,%1        	;��� �����
	mov word[1], %2
	mov word[3], %3
	mov word[5], %4
	mov word[7], %5
	call FileWritingIni
%endmacro

;===[ ������ �������� ���� ]============================================
MYCODE: segment .code
org 100h	; ������������ ��������� ������ ��� COM-������
START:	;---[ ����� ������ ]---------------------------------------------------------------------
	
	GenFileMacro file_name
	FileWritingIniMacro file_name, IT1, IT2, IT3, IT4
	;FileWritingMacro file_name, message
	;FileReadMacro file_name, rmessage
	;FileReadStrMacro file_name, rsmessage, 2
	;---[ ����������� ���������� ��������� ]----------------------------------------
	mov AX, 4C00h
	int 21h
;===============================================================================
GenFile:
	mov ah,3Ch              	;������� DOS 3Ch (�������� �����)
  	mov cx,0                	;��� ��������� - ������� ����
    	int 21h                 	;��������� � ������� DOS
    	jnc NO_ERR1             	;���� ��� ������, �� ����������
    	call error_msg          	;����� ����� ��������� �� ������
    	jmp exit1               	;����� �� ���������
NO_ERR1:
    	mov [handle],ax         	;���������� ����������� �����

    	mov ah,3Eh              	;������� DOS 3Eh (�������� �����)
    	mov bx,[handle]         	;����������
    	int 21h                 	;��������� � ������� DOS
    	jnc exit1               	;���� ��� ������, �� ����� �� ���������
    	call error_msg          	;����� ��������� �� ������
exit1:
    	mov ah,9
    	mov dx,s_pak
    	int 21h                 	;����� ������ 'All is ok!'
	ret
;===============================================================================
FileWriting:
		mov ah,3Dh              	;������� DOS 3Dh (�������� �����)
    	mov al,1                	;����� �������� - ������ ������
    	mov cx,0                	;��� ��������� - ������� ����
    	int 21h                 	;��������� � ������� DOS
    	jnc NO_ERR2             	;���� ��� ������, �� ����������
    	call error_msg          	;����� ����� ��������� �� ������
    	jmp exit2               	;����� �� ���������
NO_ERR2:
    	mov [handle],ax         	;���������� ����������� �����
		
		mov bx,[handle]         	;���������� �����
    	mov ah,40h              	;������� DOS 40h (������ � ����)
    	mov dx, word[1]         	;����� ������ � �������
    	movzx cx,[size]         	;������ ������
    	int 21h                 	;��������� � ������� DOS
    	jnc close_file1     		;���� ��� ������, �� ������� ����
    	call error_msg          	;����� ��������� �� ������

close_file1:
    	mov ah,3Eh              	;������� DOS 3Eh (�������� �����)
    	mov bx,[handle]         	;����������
    	int 21h                 	;��������� � ������� DOS
    	jnc exit2               	;���� ��� ������, �� ����� �� ���������
    	call error_msg          	;����� ��������� �� ������

exit2:
    	mov ah,9
    	mov dx,s_pak
    	int 21h                 	;����� ������ 'All is ok!'
	ret

;===============================================================================
FileRead:
		mov ah,3Dh              	;������� DOS 3Dh (�������� �����)
    	mov al,0                	;����� �������� - ������ ������
    	mov cx,0                	;��� ��������� - ������� ����
    	int 21h                 	;��������� � ������� DOS
    	jnc NO_ERR3             	;���� ��� ������, �� ����������
    	call error_msg          	;����� ����� ��������� �� ������
    	jmp exit3               	;����� �� ���������
NO_ERR3:
    	mov [handle],ax         	;���������� ����������� �����
 

    	mov bx,[handle]         	;���������� �����
    	mov ah,3Fh              	;������� DOS 3Fh (������ �� �����)
    	mov dx,word[1]          	;����� ������ ��� ������
    	mov cx,80               	;������������ ���-�� �������� ������
    	int 21h                 	;��������� � ������� DOS
    	jnc MYREAD2     			;���� ��� ������, �� ����������
    	call error_msg          	;����� ��������� �� ������
    	jmp close_file3          	;������� ���� � ����� �� ���������
 
MYREAD2:
    	mov bx,word[1]
    	add bx,ax               	;� AX ���������� ����������� ������
    	mov byte[bx],'$'        	;���������� ������� '$'

    	mov ah,9
    	mov dx,word[1]
    	int 21h                 	;����� ����������� �����
    	mov dx,endline
    	int 21h                 	;����� �������� �� ����� ������
 
close_file3:
    	mov ah,3Eh              	;������� DOS 3Eh (�������� �����)
    	mov bx,[handle]         	;����������
    	int 21h                 	;��������� � ������� DOS
    	jnc exit3               	;���� ��� ������, �� ����� �� ���������
    	call error_msg          	;����� ��������� �� ������ 
		ret

exit3:
    	mov ah,9                	;����� ������ 'All is ok!'
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
		mov ah,3Dh              	;������� DOS 3Dh (�������� �����)
    	mov al,1                	;����� �������� - ������ ������
    	mov cx,0                	;��� ��������� - ������� ����
    	int 21h                 	;��������� � ������� DOS
    	jnc NO_ERR					;���� ��� ������, �� ����������
    	call error_msg          	;����� ����� ��������� �� ������
    	jmp exit					;����� �� ���������
NO_ERR:
    	mov [handle],ax         	;���������� ����������� �����
		
		mov bx,[handle]         	;���������� �����
    	mov ah,40h              	;������� DOS 40h (������ � ����)
    	mov dx, word[1]         	;����� ������ � �������
    	movzx cx,[size1]         	;������ ������
    	int 21h                 	;��������� � ������� DOS

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


		mov bx,[handle]         	;���������� �����
    	mov ah,40h              	;������� DOS 40h (������ � ����)
    	mov dx, registr				;����� ������ � �������
    	movzx cx,[size2]         	;������ ������
    	int 21h                 	;��������� � ������� DOS
    	jnc ITM2     				;���� ��� ������, �� ������� ����
    	call error_msg          	;����� ��������� �� ������


ITM2:	
		mov bx,[handle]         	;���������� �����
    	mov ah,40h              	;������� DOS 40h (������ � ����)
    	mov dx, word[3]         	;����� ������ � �������
    	movzx cx,[size3]         	;������ ������
    	int 21h                 	;��������� � ������� DOS

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

		mov bx,[handle]         	;���������� �����
    	mov ah,40h              	;������� DOS 40h (������ � ����)
    	mov dx, registr				;����� ������ � �������
    	movzx cx,[size2]         	;������ ������
    	int 21h                 	;��������� � ������� DOS
    	jnc ITM3     				;���� ��� ������, �� ������� ����
    	call error_msg          	;����� ��������� �� ������

ITM3:	
		mov bx,[handle]         	;���������� �����
    	mov ah,40h              	;������� DOS 40h (������ � ����)
    	mov dx, word[5]         	;����� ������ � �������
    	movzx cx,[size3]         	;������ ������
    	int 21h                 	;��������� � ������� DOS

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


		mov bx,[handle]         	;���������� �����
    	mov ah,40h              	;������� DOS 40h (������ � ����)
    	mov dx, registr				 ;����� ������ � �������
    	movzx cx,[size2]         	;������ ������
    	int 21h                 	;��������� � ������� DOS
    	jnc ITM4     				;���� ��� ������, �� ������� ����
    	call error_msg          	;����� ��������� �� ������

ITM4:	
		mov bx,[handle]         	;���������� �����
    	mov ah,40h              	;������� DOS 40h (������ � ����)
    	mov dx, word[7]         	;����� ������ � �������
    	movzx cx,[size3]         	;������ ������
    	int 21h                 	;��������� � ������� DOS

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


		mov bx,[handle]         	;���������� �����
    	mov ah,40h              	;������� DOS 40h (������ � ����)
    	mov dx, registr				;����� ������ � �������
    	movzx cx,[size2]         	;������ ������
    	int 21h                 	;��������� � ������� DOS
    	jnc close_file     			;���� ��� ������, �� ������� ����
    	call error_msg          	;����� ��������� �� ������

close_file:
    	mov ah,3Eh              	;������� DOS 3Eh (�������� �����)
    	mov bx,[handle]         	;����������
    	int 21h                 	;��������� � ������� DOS
    	jnc exit               	;���� ��� ������, �� ����� �� ���������
    	call error_msg          	;����� ��������� �� ������

exit:
    	mov ah,9
    	mov dx,s_pak
    	int 21h                 	;����� ������ 'All is ok!'
	ret

;===============================================================================
error_msg:
    	mov ah,9
    	mov dx,s_error
    	int 21h                 	;����� ��������� �� ������
    	ret
;===============================================================================



;===[ ������ �������� ������ ]==========================================
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