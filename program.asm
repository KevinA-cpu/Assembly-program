.model small  ;setup program
.stack 10000
.data   ;messages and variables
	msg db 13,10,'Hello user, wishing you a wonderful day! $'
        msg1 db 13,10,'Nhap vao chuoi toi da 80 ky tu:  $'
        msg2 db 13,10,'Nhap vao chu so dau tien cua so thu nhat:  $'
        msg3 db 13,10,'Nhap vao chu so thu hai cua so thu nhat:  $'
        msg4 db 13,10,'Nhap vao chu so dau tien cua so thu hai:  $'
        msg5 db 13,10,'Nhap vao chu so thu hai cua so thu hai:  $'
	msg6 db 13,10,'Tong:  $'
	msg7 db 13,10,'Hieu:  $'
	msg8 db 13,10,'Nhan:  $'
	msg9 db 13,10,'Chia:  $'
	msg10 db 13,10,'du: $'
	goodmorning db 13,10,'Good morning user! $'
	goodafternoon db 13,10,'Good afternoon user! $'
	goodevening db 13,10,'Good evening user! $'
	digit11 db 0
	digit12 db 0
	digit21 db 0
	digit22 db 0
	num1 db 0
	num2 db 0
	temp db 0
	carry db 0
	first db 0
	second db 0
	third db 0
	fourth db 0
	q db ?
	r db ?

	ans db 0
	s db 100 dup('$')
	count db 0
.code
org 100h

start:
        ;move data into ax
        mov ax, @DATA
        mov ds, ax
	; get shift status
        mov ah, 02h
        int 16h
	; check capslock
        cmp al, 01000000b
        je Equal
	; capslock is off or both capslock and numlock is on
	; capslock is off or both capslock and numlock is on
        jmp Both

; capslock key is on
Equal:
     ; tell user to enter string
     mov ah, 9h
     lea dx, msg1
     int 21h
     ;user entering string
     mov si, offset s
     l1:
     mov ah,1
     int 21h
     ;stop the program if user enter more than 80 chars
     cmp count, 80
     je programend
     ;stop the program is user press enter key
     cmp al, 0dh
     je programend
     ; check the character if it is lower or not
     cmp al, 'A'
     jb checklower
     cmp al, 'Z'
     ja checklower
     mov [si],al
     inc si
     inc count
     jmp l1
     ; check the character if it is lower, if yes then uppercase the character
     checklower:
	cmp al, ' '
	je addspace
	cmp al, 'a'
    	jb l1
    	cmp al, 'z'
    	ja l1
    	sub al, 32
	mov [si],al
     	inc si
     	inc count
	jmp l1
     ; add white space into the string
     addspace:
	mov word ptr [si], ' '
     	inc si
     	inc count
	jmp l1
     ; end the program
     programend:
	mov dx, offset s
	mov ah, 9
	int 21h
	mov ax, 4c00h
	int 21h

; check the numlock key
Both:
     cmp al, 00100000b
     je Equal2
     ; numlock is off or both capslock and numlock is on
     ; numlock is off or both capslock and numlock is on
     jmp Both2

; numlock key is on
Equal2:
     ; nhap vao chu so dau tien cua so thu nhat
     mov ah, 9h
     lea dx, msg2
     int 21h
     
     ; nhap 1 ki tu vao ban phim
     mov ah, 1h
     int 21h

     ; kiem tra so co nam trong khoang tu 1 - 9
     cmp al, '0'
     jb Equal2
     cmp al, '9'
     ja Equal2

     sub al, 30h
     mov digit11, al

     ; nhap vao chu so dau tien cua so thu hai
     mov ah, 9h
     lea dx, msg3
     int 21h

     ; nhap 1 ki tu vao ban phim
     mov ah, 1h
     int 21h

     ; kiem tra so co nam trong khoang tu 1 - 9
     cmp al, '0'
     jb Equal2
     cmp al, '9'
     ja Equal2

     sub al, 30h
     mov digit12, al

     ; ket hop thanh so co hai chu so cua so thu nhat
     mov al, digit11
     mov bl, 10
     mul bl

     mov num1, al
     mov al, digit12
     add num1, al


     ; nhap vao chu so dau tien cua so thu hai
     mov ah, 9h
     lea dx, msg4
     int 21h
     
     ; nhap 1 ki tu vao ban phim
     mov ah, 1h
     int 21h

     ; kiem tra so co nam trong khoang tu 1 - 9
     cmp al, '0'
     jb Equal2
     cmp al, '9'
     ja Equal2

     sub al, 30h
     mov digit21, al

     ; nhap vao chu so dau tien cua so thu hai
     mov ah, 9h
     lea dx, msg5
     int 21h

     ; nhap 1 ki tu vao ban phim
     mov ah, 1h
     int 21h

     ; kiem tra so co nam trong khoang tu 1 - 9
     cmp al, '0'
     jb Equal2
     cmp al, '9'
     ja Equal2

     sub al, 30h
     mov digit22, al

     ; ket hop thanh so co hai chu so cua so thu hai
     mov al, digit21
     mov bl, 10
     mul bl

     mov num2, al
     mov al, digit22
     add num2, al

     ; tinh tong
     mov bl, num1
     add bl, num2
	
     call change
     mov dx, offset msg6
     call result

     ; tinh hieu
     mov bl, num1
     cmp bl, num2
     jl less
     sub bl, num2
     call change
     mov dx, offset msg7
     call result
     jmp nextEquation
less:
	mov bl, num2
	sub bl, num1
	call change
	mov dx, offset msg7
	call result

nextEquation:
	;tinh tich
	call multi

	;tinh thuong
    	mov cl, num2
    	cmp cl, num1
    	jg greatdivide
    	mov ah, 0
    	mov al, num1
    	div cl

	mov q, al
    	mov r, ah
    	mov bl, q
    
 	call change
   	mov dx, offset msg9
    	call result
    	mov bl, r
    	call change
    	mov dx, offset msg10
   	call result
	jmp programend2
     	greatdivide:
       	  mov cl, num1
       	  mov ah, 0
      	  mov al, num2
       	  div cl

          mov q, al
       	  mov r, ah
       	  mov bl, q
 
       	  call change
       	  mov dx, offset msg9
       	  call result
       	  mov bl, r
       	  call change
       	  mov dx, offset msg10
       	  call result
	programend2:	
	  mov ax, 4c00h
   	  int 21h 
     	
     multi proc
        mov al, digit22
        mul digit12
        mov ah, 00h
        aam

        add third, ah
        add fourth, al

        mov al, digit22
        mul digit11
        mov ah, 00h
        aam

        add second, ah
        add third, al

        mov al, digit21
        mul digit12
        mov ah, 00h
        aam

        add second, ah
        add third, al

	mov al, digit21
	mul digit11
	mov ah, 00h
	aam
	
	add first, ah
	add second, al
     
        mov dl, 010
        mov ah, 02h
        int 21h
        mov dx, offset msg8
        mov ah, 9h
        int 21h

        mov al, third
        mov ah, 00h
        aam
	
	add second, ah
	mov third, al
	
	mov al, second
	mov ah, 00h
	aam 

        mov second, al
	add first, ah
     
        mov dl, first
        add dl, 30h
        mov ah, 02h
        int 21h

        mov dl, second
        add dl, 30h
        mov ah, 02h
        int 21h
    
        mov dl, third
        add dl, 30h
        mov ah, 02h
        int 21h

        mov dl, fourth
        add dl, 30h
        mov ah, 02h
        int 21h
	ret
       multi endp

     change proc
	mov ah, 0
	mov al, bl
	
	mov bl, 10
	div bl

	mov bl, al
	mov bh, ah

	add bh, 30h
	mov ans, bh

	mov ah, 0
	mov al, bl
	mov bl, 10
	div bl

	mov bl, al
	mov bh, ah

	add bh, 30h
	add bl, 30h

	ret
      change endp

     result proc
	mov ah, 9h
	int 21h

	mov dl, bl
	mov ah, 02h
	int 21h

	mov dl, bh
	mov ah, 02h
	int 21h

	mov dl, ans
	mov ah, 02h
	int 21h
	ret
       result endp

; check if both numlock and capslock is on
Both2:
     cmp al, 01100000b
     je Equal3
     ; numlock and capslock is off

     mov ah, 2ch     ; To get system time [HH in ch, MM in cl, SS in dh]
     int 21h         ; DOS interrupt to get time
     mov al, ch

     cmp al, 24
     jl morning
     mov ah, 9h
     lea dx, goodmorning
     int 21h
     jmp Both3
     ; numlock and capslock is off
     jmp Both3
morning:
	cmp al, 12
	jg afternoon
	; hien thong bao chao buoi sang
	mov ah, 9h
     	lea dx, goodmorning
     	int 21h
	jmp Both3

afternoon:
	cmp al, 18
	jg evening
	; hien thong bao chao buoi chieu
	mov ah, 9h
     	lea dx, goodafternoon
     	int 21h
	jmp Both3
	
evening:
	; hien thong bao chao buoi toi
	mov ah, 9h
     	lea dx, goodevening
     	int 21h
	jmp Both3
	
	
	
; both buttons are on, display machine time
Equal3:
      mov dl, 0Dh     ; To print 0D [\r]
      mov ah, 02h
      int 21h

      mov dl, 0Ah     ; To print 0A [\n]
      mov ah, 02h
      int 21h

      mov ah, 2ch     ; To get system time [HH in ch, MM in cl, SS in dh]
      int 21h         ; DOS interrupt to get time

      mov al, ch
      call disp

      mov dl, ':'     ; copy : to dl to print
      mov ah, 02h     ; copy 02 to ah
      int 21h

      mov al, cl
      call disp

      mov dl, ':'     ; To print : as above
      mov ah, 02h     
      int 21h         

      mov al, dh      ; seconds in dh as SS
      call disp       ; call disp procedure to display seconds

      mov dl, 0Dh     ; To print 0D [0D stands for \r]
      mov ah, 02h
      int 21h

      mov dl, 0Ah     ; To print 0A [0A stands for \n]
      mov ah, 02h
      int 21h

      mov ax, 4c00h
      int 21h   

      disp proc       ; Beginning of disp procedure
        aam           ; ASCII adjust after multiplication [ax register]
        mov bx, ax    ; loading adjusted value to bx
        add bx, 3030h ; Add 3030 to properly print the data

        mov dl, bh    ; To print first digit of data
        mov ah, 02h
        int 21h

        mov dl, bl    ; To print second digit of data
        mov ah, 02h
        int 21h

        ret           ; return from the procedure
        disp endp     ; end display procedure

; end program
Both3:
    mov ax, 4c00h
    int 21h   

end start
