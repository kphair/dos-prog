;                       Interrupt aliases
;			~~~~~~~~~~~~~~~~~
%define		disk_int        int 013h
%define		dos_int         int 021h
%define		tsr_int         int 027h
%define		mouse_int       int 033h
%define		bios_int        int 010h
%define		keyboard_int    int 016h

;****************************> Macro definitions <****************************;

%macro		if 2+
		j%-1 %%skip
		%2
%%skip:	
		%endmacro


;Allocate an ASCIIZ (null terminated) type string
%macro		asciiz 1        ; Store null terminated string
                db %1,0
                %endmacro

;Print dollar ($) terminated string at cursor position
%macro		printm 1        ;Prints a '$' terminated message from
                mov dx,%1       ;                        DS:parameter
                mov ah,9
                dos_int
                %endmacro

;Open file and get handle
%macro		openm 2         ;Openm name,access
                mov dx,%1       ;Pointer to ASCIIZ filename
                mov al,%2       ;Access 0-READ,1-WRITE,2-BOTH
                mov ah,03dh
                dos_int         ;Returns AX=File handle, or
                %endmacro             ;AL=Error number and Carry flag set if error
 
;Load from file handle into memory
%macro		loadm 3         ;Loadm handle,location,length
                mov bx,%1       ;File handle
                mov dx,%2       ;Load destination (DS implied)
                mov cx,%3       ;Bytes to load
                mov ah,03fh
                dos_int         ;Returns AX=Bytes loaded, or error as above
                %endmacro
 
;Move file pointer
%macro		move_fpointer 4 ;move_fpointer handle,method,msw,lsw
                mov bx,%1       ;File handle
                mov dx,%4       ;LSW of DWORD address
                mov cx,%3       ;MSW of DWORD address
                mov ax,04200h+%2 ;Function + Method-  0:Bytes from file start
                dos_int         ;                    1:Bytes from current pos
                %endmacro             ;                    2:Bytes from file end

;Create file and get handle
%macro		createm 1       ;Createm name
                mov dx,%1       ;Pointer to null terminated filename
                mov cx,0
                mov ah,03ch
                dos_int         ;Returns AX=File handle, or error as usual
                %endmacro
 
;Save from memory into file handle
%macro		savem 3         ;Savem handle,location,length
                mov bx,%1       ;File handle
                mov dx,%2       ;Source to save from
                mov cx,%3       ;Number of bytes to save
                mov ah,040h
                dos_int
                %endmacro
 
;Close file handle
%macro		closem 1        ;Closem handle
                mov bx,%1       ;File handle
                mov ah,03eh
                dos_int
                %endmacro
 
;Set video mode
%macro		vmode 1         ;Vmode videomode
                mov ax,%1       ;Video mode (if bit 7=1, No screen mem clear)
                bios_int
                %endmacro
 
;Plot point using BIOS routine
%macro		biosplot 3      ;BIOSPLOT x,y,colour
                mov al,%3       ;Colour
                mov cx,%1       ;Xpos
                mov dx,%2       ;Ypos
                mov ah,0ch
                bios_int
                %endmacro

;Get point value using BIOS routine
%macro		biospoint 2     ;BIOSPOINT x,y
                mov cx,%1       ;Xpos
                mov dx,%2       ;Ypos
                mov ah,0dh
                bios_int
                %endmacro       ;Returns AL=colour of pixel
 
;Get key from buffer
%macro		getchm 0        ;Getchm
                sub ax,ax       ;Wait for keypress
                keyboard_int
                %endmacro       ;Returns AX=Code of key pressed

;Check keyboard buffer
%macro		scankbd 0       ;Scankbd
                mov ax,0100h    ;IF NZ, key waiting - use getchm to retrieve
                keyboard_int
                %endmacro             ;Returns AX=Scancode waiting in buffer
 
;Read scancode from AT keyboard port
%macro		getscanm 0      ;Getscanm
                in al,060h      ;Reads keyboard directly on AT or above
                %endmacro             ;Returns AL=Current make/break code
 
;Exit with errorlevel
%macro		dosexit 1       ;Exitm errorlevel
                mov al,%1       ;Errorlevel to return
                mov ah,04ch
                dos_int
                %endmacro

%macro		clrscr 0         
                mov ax,0f00h
                bios_int
                sub ah,ah
                bios_int
                %endmacro

%macro		clrtxtscr 1      
                push es
                push di
                push ax
                push cx
                mov es,%1
                sub di,di
                mov ax,0
                mov cx,32768
                rep stosb
                gotoxy 0,0
                pop cx
                pop ax
                pop di
                pop es
                %endmacro

;Loop for the specified number of video frames
%macro		pause 1         ;Pause <number of video frames>
                push ax
                push dx
                push cx
                mov cx,%1       ;Number of frames to wait for
                mov dx,03dah
%%p1:           in al,dx
                test al,8
                jz %%p1
%%p2:           in al,dx
                test al,1
                jne %%p2
                loop %%p1
                pop cx
                pop dx
                pop ax
                %endmacro
 
;Wait for beginning of retrace, does not waste time waiting for it to return
;to the top of the screen.
%macro		wait_retrace 0	;Retrace
                push dx
                push ax     	;Simply wait for retrace to start
                mov dx,03dah
%%r1:           in al,dx
                test al,8
                jz %%r1
                pop ax
                pop dx
                %endmacro

;Find first file match
%macro		findfirst 3     ;Findfirst filespecseg,filespecofs,attribute
                mov ax,%1       ;Segment pointer of null terminated filespec
                mov ds,ax
                mov dx,%2       ;Offset of filespec
                mov cx,%3       ;Attribute mask
                mov ax,04e00h
                dos_int
                %endmacro

;Find next file match
%macro		findnext 0      ;CF=0 if found next match CF=1 otherwise
                mov ax,04f00h
                dos_int
                %endmacro
 
;Change current directory
%macro		setdir 2        ;Setdir nameseg,nameofs
                mov ax,%1       ;Segment pointer to ASCIIZ directory name
                mov ds,ax
                mov dx,%2       ;Offset to ASCIIZ directory name
                mov ax,03b00h
                dos_int
                %endmacro

;Make new directory
%macro		makedir 2       ;Makedir nameseg,nameofs
                mov ax,%1
                mov ds,ax
                mov dx,%2       ;ASCIIZ
                mov ax,03900h
                dos_int
                %endmacro

;Delete directory
%macro		removedir 2     ;Removedir nameseg,nameofs
                mov ax,%1
                mov ds,ax
                mov dx,%2       ;ASCIIZ
                mov ax,03a00h
                dos_int
                %endmacro

;Get current directory
%macro		getdir 2        ;Getdir drive,nameseg,nameofs
                mov dl,%1
                mov ax,%2
                mov ds,ax
                mov ax,04700h
                mov si,%3
                dos_int
                %endmacro

;Get current logged drive
%macro		getdrive 0      ;Getdrive
                mov ah,019h
                dos_int         ;Returns current logged drive number into AL
                %endmacro

;Execute specified program
%macro		exec 1          ;Exec <location of ASCIIZ filename to execute>
                mov ah,04bh
                mov dx,%1
                dos_int
                %endmacro

;Load disk sector into memory location
%macro		load@ 5         ;Load@ drive,head,track,sector,destination
                mov ax,0201h
                mov dl,%1       ;Drive number
                mov dh,%2       ;Head
                mov ch,%3       ;Track
                mov cl,%4       ;Sector
                mov bx,%5       ;Destination (ES implied)
                disk_int        ;Read sector
		%endmacro

;Save disk sector from memory location
%macro		save@ 5         ;Save@ drive,head,track,sector,(ES:)source
		mov ax,0301h
                mov dl,%1       ;Drive number
                and dl,127      ;Ensure it's floppy disk for safety's sake!
                mov dh,%2       ;Head
                mov ch,%3       ;Track
                mov cl,%4       ;Sector
                mov bx,%5       ;Source (ES implied)
                disk_int        ;Write sector
		%endmacro
 
;Get drive information
%macro		getinfo@ 1      ;Getinfo@ drive number
		mov ah,036h
                mov dl,%1       ;Standard drive number
                dos_int
		%endmacro
 
;Get interrupt vector into memory location
%macro		get_vec 2       ;Get_vec interrupt_vector,dest
                push ax
                push bx
                pusha
                mov ax,03500h+%1 ;Int vector
		dos_int
                mov word [%2],bx    ;Store offset,segment into dest
		mov word [%2+2],es
                pop bx
                pop ax
		pop es
		%endmacro
	 
;Set interrupt vector
%macro		set_vec 3       ;Set_vec interrupt,segment,offset
                push ds
                push ax
                push dx
                mov ax,%2       ;segment
                mov ds,ax
                mov dx,%3       ;offset
                mov ah,02500h+%1 ;Int vector
		dos_int
                pop dx
                pop ax
                pop ds
		%endmacro

;Select EGA/VGA bitplane
%macro		bitplane 1      ;Bitplane plane
		push dx
		push ax
		mov dx,03c4h
		mov ah,%1
		mov al,2
		out dx,ax
		pop ax
		pop dx
		%endmacro

;Set EGA/VGA bit panning register
%macro		pixel_offset 1  ;Pixel_offse 24-bit offset
                push ax
                push dx         ;       Byte 0: Low byte of byte offset
                mov dx,03d4h    ;       Byte 1: High byte of byte offset
                mov al,0ch      ;       Byte 2: Horizontal pixel shift
                mov ah,byte [%1+1]
		out dx,ax
                inc al
                mov ah,byte [%1]
		out dx,ax
		mov dl,0dah
		in al,dx
                mov dl,0c0h
                mov al,033h
		out dx,al
		mov al,byte [%1+2]
		out dx,al
                pop dx
                pop ax
                %endmacro

%macro		iffd 4
		cmp %1,%2
		if z %3,%4
		%endmacro

%macro		iffs 2+
                cmp %1,%2
                jnz %%skip
                %3
%%skip:
                %endmacro

%macro		movif 4
                cmp %1,%2
                if z %3,%4
                %endmacro

%macro		dmov 4
		mov %1,%2
		mov %3,%4
		%endmacro

%macro		movl 4
		mov %1,%3
		mov %2,%4
		%endmacro

;Parse string to CR or Space and null terminate it
%macro		parse_cmd 1     ;Parse_cmd stringloc
                mov si,%1
                mov cx,126
%%l1: 		lodsb
                cmp al,32
                jz %%e1
                cmp al,13
                jz %%e1
                loop %%l1
%%e1:         	mov byte [si-1],0
		%endmacro

%macro		_bit 2          ;Bit bitpos,variable
                test %2,1 bit %1
                %endmacro

%macro		_res 2          ;Res bitpos,variable
                and (-1 xor bit %1),%2
		%endmacro

%macro		_set 2          ;Set bitpos,variable
		or %2,1 bit %1
                %endmacro

%macro		gotoxy 2        ;Gotoxy x,y
                mov ah,02
                mov bh,0
                mov dl,%1
                mov dh,%2
                bios_int
                %endmacro

%macro		cmpd 2          ;Cmpd dword1,dword2
                push ax
                mov ax,[%1]
                cmp ax,[%2]
                if z compound ##'mov ax,[%1+2]',##'cmp ax,[%2+2]'
                pop ax
                %endmacro

%macro		border 1
                mov bl,%1
                mov ah,0bh
                mov bh,0
                bios_int
                %endmacro

%macro		qborder 3
                push dx
                push ax
                mov dx,03c8h
                mov al,0
                out dx,al
                inc dl
                mov al,%1
                out dx,al
                mov al,%2
                out dx,al
                mov al,%3
                out dx,al
                pop ax
                pop dx
                %endmacro

