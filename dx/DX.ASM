; DX.ASM, a program to take an AKA from the command line, try to match it to
; a list of AKAs in a text file and change to a directory specified on the
; line of the matched AKA
;
; Written in about 80 minutes using QEdit and A86
; Author: Kevin J Phair
; Date:   13 Aug, 1993
;
; Written for compiling with the A86 assembler.
;
; //=======================================================================\\
;||             Program starts here                                         ||
; \\=======================================================================//

jmp startprog

search_len      dw 0
last_param      dw 0
dx_info:        db '.AKA',0
name_buffer:    db 256 dup 0
;-----------------------------------------------------------------------------
;               Bad DOS version
;-----------------------------------------------------------------------------
dosver_err_msg: db 13,10
                db 'Sorry, this program needs at least version 3.10 of MS-DOS.',13,10
                db 36
dosver_err:     printm dosver_err_msg
                int 020

;-----------------------------------------------------------------------------
;               Help text
;-----------------------------------------------------------------------------
help_msg:       db 13,10
                db 'Directory X, v1.10 (C) 1993, Kevin J Phair. This is a FREEWARE utility.',13,10
                db 'Uses file with the same name as the program, but with extension .AKA, to match',13,10
                db 'AKAs with directories. The file is a <50k text file with the AKA and matching',13,10
                db 'directory on each line. The AKA and directory are separated by spaces. E.g.',13,10,13,10

                db 'WORK c:\progs\asm',13,10
                db 'PROJECT c:\progs\c\main\payroll',13,10
                db 'etc.',13,10,13,10,

                db 'No distinction is made between upper and lower case.',13,10,13,10,36
help_me:        printm help_msg
                dosexit 1

;-----------------------------------------------------------------------------
;               No AKA list
;-----------------------------------------------------------------------------
no_list_msg:    db 13,10
                db 'No AKA list found. Please make sure that there is an AKA list in the same',13,10
                db 'directory as the program.',13,10
                db 36
no_listfile:    printm no_list_msg
                dosexit 2

;-----------------------------------------------------------------------------
;               Bad directory
;-----------------------------------------------------------------------------
no_dir_msg:     db 13,10
                db 'The DIRECTORY specified by the AKA does not exist or is inaccessible.',13,10
                db 36
no_dir:         printm no_dir_msg
                dosexit 3

;-----------------------------------------------------------------------------
;               Bad drive
;-----------------------------------------------------------------------------
no_drive_msg:   db 13,10
                db 'The DRIVE specified by the AKA does not exist or is inaccessible.',13,10
                db 36
no_drive:       printm no_drive_msg
                dosexit 5

;-----------------------------------------------------------------------------
;               Bad AKA
;-----------------------------------------------------------------------------
no_match_msg:   db 13,10
                db 'AKA specified is not in list!',13,10
                db 36
no_match:       printm no_match_msg
                dosexit 255

;#############################################################################
;               Main code block
;#############################################################################
startprog:      mov ax,03000
                int 021h
                cmp al,3
                if c jmp dosver_err
                if z cmp ah,10
                if c jmp dosver_err
                cmp b[128],0
                if z jmp help_me
                mov ax,cs
                sub ax,[02c]
                mov cx,ax
                add cx,cx
                add cx,cx
                add cx,cx
                add cx,cx
                mov es,[02c]
                mov di,0
                mov al,0
        s0:     repnz scasb
                scasb
                jnz s0
                inc di
                inc di

                mov si,di
                mov di,name_buffer
                push es
                pop ds
                push cs
                pop es
        t0:     lodsb
                stosb
                cmp al,0
                jnz t0

                push cs
                pop ds

        s2:     dec di
                cmp b[di],'.'
                jnz s2

                mov si,dx_info
                movsw
                movsw
                movsb

                openm name_buffer,read
                if b jmp no_listfile
                loadm ax,list_buffer+2,51200
                closem bx
                mov si,list_buffer
                mov di,si
                mov cx,51200
        cconv0: lodsb
                cmp al,'A'
                jb no_case_change
                cmp al,'Z'
                ja no_case_change
                add al,32
no_case_change: stosb
                loop cconv0

                mov si,130
                mov di,si
                mov cx,126
        cconv2: lodsb
                cmp al,'A'
                jb no_case_change2
                cmp al,'Z'
                ja no_case_change2
                add al,32
no_case_change2:
                stosb
                loop cconv2

                parse_cmd 130
                mov last_param,si
                sub si,131
                mov search_len,si

                mov di,list_buffer
                mov al,10
search_list:    mov cx,list_buffer+51200
                sub cx,di
                repnz scasb
                cmp b[di],';'
                jz search_list
                mov si,130
                mov cx,search_len
                repz cmpsb
                jnz not_really
                cmp es:b[di],32
                jbe found_assign
not_really:     cmp es:b[di],0
                if z jmp no_match
                cmp di,list_buffer+51200
                if a jmp no_match
                jmp search_list

found_assign:   mov si,di
get_drive:      lodsb
                cmp al,32
                jbe get_drive
                cmp b[si],':'
                if nz jmp no_drive
                sub al,'a'
                setdrive al
                getdrive
                cmp al,dl
                if nz jmp no_drive
                lodsb
                mov di,si
get_aka_end:    inc di
                mov al,[di]
                cmp al,32
                ja get_aka_end
                cmp b[di-1],'\'
                if z dec di
                mov b[di],0
                setdir ds,si
                if c jmp no_dir
                mov si,last_param

        l0:     lodsb
                cmp al,32
                jz l0
        l1:     dec si
                push si
                parse_cmd si
                pop si
                setdir ds,si
                dosexit 0

list_buffer:    db 13,10
                db 51200 dup 0
