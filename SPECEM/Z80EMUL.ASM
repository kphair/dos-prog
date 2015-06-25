
; Flag emulation (F part of AF)

; Bit   MnM     Name
;  0     C      Carry flag.
;  1     N      Add/Subtract (for internal BCD info)
;  2    P/V     Parity (or overflow for 2s complement maths)
;  3     -      Unused
;  4     H      Half-carry
;  5     -      Unused
;  6     Z      Zero flag
;  7     S      Sign flag (Bit 7 of A)

%macro 		poptonext 0
		popf
                jmp next_instruction
                %endmacro

%macro  	emul_p_c 0
		mov di,ax               ; Parity and carry
                mov al,00000100b              ;4
                lahf
                if no,xor al,al
                and di,0000001111111111b      ;03ff
                and ah,11010000b              ;0d0
                or ah,al
                xor al,al
                or ax,di
                jmp next_instruction
                %endmacro

%macro    	emul_p 0
		mov di,ax               ; Parity flag
                mov al,00000100b              ;4
                lahf
                if no,xor al,al
                and ah,11010001b              ;0d1
                and di,0000001011111111b      ;02ff
                or ah,al
                xor al,al
                or ax,di
                jmp next_instruction
                %endmacro

%macro  	emul_h_z 0
		or byte [bx],0              ; Half-carry and zero
                mov di,ax
                lahf
                and ah,11100100b              ;0c4
                and di,0000000100000000b      ;0100
                or ax,di
                jmp next_instruction
                %endmacro

%macro    	emul_h 0
		mov di,ax                       ; Half carry
                lahf
                and ah,11100100b              ;0c4
                and di,0000000100000000b      ;0100
                or ax,di
                jmp next_instruction
                %endmacro

%macro    	emul_z 0
		mov di,ax               ; Zero flag
                lahf
                and ah,01000000b              ;040
                and di,0000000100000000b      ;0100
                or ax,di
                or  ah,00010000b              ;010
                jmp next_instruction
                %endmacro

; Program Counter emulation

%macro   	ret_mac 0
		mov si,ax
                mov al,[ds:bp]
                mov ah,[ds:bp+1]
                xchg si,ax
                inc bp
                inc bp
                jmp preset_pc
                %endmacro

%macro  	call_mac 0
		inc si
		inc si
		inc si                	; Simulate PUSHing PC and jumping
                dec bp
                dec bp
                mov di,ax
                mov ax,si
                mov [ds:bp],al
                mov [ds:bp+1],ah
                mov al,[si-2]
                mov ah,[si-1]
                mov si,ax
                mov ax,di
                jmp preset_pc
                %endmacro

%macro    	jr_mac 0
		mov di,ax
                lodsb
                cbw
                add si,ax
                mov ax,di
                jmp preset_pc
                %endmacro

%macro    	jp_mac 0
		mov di,ax
                mov al,[si+1]
                mov ah,[si+2]
                mov si,ax
                mov ax,di
                jmp preset_pc
                %endmacro

%macro   	jp_skip 0
		inc si
		inc si               	; Skip jump or call
                jmp next_instruction
                %endmacro

%macro   	push_all 0
		pushf
                pusha
                push ds
                push ss
                push es
                %endmacro

%macro    	pop_all 0
		pop es
		pop ss
		pop ds
                popa
                popf
                %endmacro

matrix_emul:    pushf           ; This routine flags keys as either on or off
		cli		; Allowing multiple keypresses
		push ax
		push di
                in al,060h
		test al,128
		jnz keyrelease
                cmp al,050h
                ja no_key
                mov di,scan_conv
		xor ah,ah
		add di,ax
		add di,ax
		mov di,[cs:di]
		cmp di,-1
		jz no_key
		mov [cs:new_scan],di
		mov ax,di
		mov al,ah
		xor ah,ah
		mov di,keygrp0
		add di,ax
                mov ax,[cs:new_scan]
                cmp di,kemstat
                jz kempress
                xor al,255
		and [cs:di],al
                jmp no_key
     kempress:  or [cs:di],al
no_key:         pop di
		pop ax
		popf
		jmp far [cs:old_int9]
keyrelease:     and al,127
                cmp al,050h
                ja no_key
		mov di,scan_conv
		xor ah,ah
		add di,ax
		add di,ax
		mov di,[cs:di]
		cmp di,-1
		jz no_key
		mov [cs:new_scan],di
		mov ax,di
		mov al,ah
		xor ah,ah
		mov di,keygrp0
		add di,ax
                mov ax,[cs:new_scan]
                cmp di,kemstat
                jz kemrel
                or [cs:di],al
		jmp no_key
        kemrel: xor al,255
                and [cs:di],al
                jmp no_key

;*************> Start of emulator <*******************************************;

startprog:      mov ax,cs
                mov [code_seg],ax
                add ax,01000h
                mov [z80_seg],ax
                push es
                push bx
		mov ax,03509h
		dos_int
		mov [cs:old_int9],bx
		mov [cs:old_int9+2],es
		pop bx
		pop es
                mov ds,[cs:code_seg]
                mov dx,matrix_emul	; location of new ISR
		mov ax,02509h
		dos_int 		; Install matrix emulator on Int 09h
		mov ax,03533h
		dos_int
		mov ax,es
		or ax,bx
		jz skipmouse
		vmode 1
		mov ax,0
		mouse_int
		cmp ax,strict 0ffffh
		jnz skipmouse
		mov es,[cs:bios_seg]
		mov word [es:04ah],256
		mov word [es:084h],192
                mov byte [mousestat],255
		mov ax,7
		mov cx,0
		mov dx,4095
		mouse_int
		mov ax,8
		mov cx,0
		mov dx,1535
		mouse_int

  skipmouse:	mov es,[cs:code_seg]
		mov ax,01003h
		mov bl,0
		bios_int

		mov si,newpal
		mov bx,0
	do_pal: mov bh,[cs:si]
		inc si
		mov ax,01000h
		bios_int
		inc bl
		cmp bl,16
		jnz do_pal

                push es
                mov es,[scr_seg]
		mov di,0
		mov cx,32768
		mov ax,00700h
		rep stosw
		pop es

                mov ax,01100h
		mov bx,0100h
		mov cx,256
		mov dx,0
		mov bp,new_chars
		bios_int

		mov si,080h
		mov cl,[si]
		mov ch,0
                jcxz ega00
	getsw:	lodsb
		cmp al,'/'
		jz fndsw
		loop getsw
	fndsw:	mov dx,03c2h
		lodsb
                cmp al,'v'
		if nz,cmp al,'V'
		if nz,jmp ega00
                mov al,11100111b
                out dx,al

	ega00:	call spec_mode

Install_rom:	push_all		; Copy the ROM into page 0
                mov es,[cs:z80_seg]
                mov ds,[cs:code_seg]
                mov si,specrom
                mov di,0
                mov cx,16384/2
                rep movsw
                mov word [specrom_stat],1

		mov si,intro_screen	; Copy title screen from multiface RAM
		mov di,16384
                mov cx,6912/2
		rep movsw
		pop_all

		mov byte [statbyte],6	; Check for snapshot filename
                cmp byte [080h],4
                if be,jmp no_file
		mov byte [statbyte],7
                parse_cmd 130
                openm 130,0		; open the snapshot file
                if b,jmp no_file
                loadm ax,auto_header,256
                mov ds,[cs:z80_seg]
                loadm bx,16384,49152
                closem bx
                mov ds,[cs:code_seg]	; extract Z80 registers from header
                mov si,auto_header+220
		mov ax,[si]
                mov [reg_iy],ax
		mov ax,[si+2]
                mov [reg_ix],ax
		mov ax,[si+4]
                mov [reg_de2],ax
		mov ax,[si+6]
                mov [reg_bc2],ax
		mov ax,[si+8]
                mov [reg_hl2],ax
		mov ax,[si+10]
                xchg al,ah
                mov [reg_af2],ax
		mov ax,[si+12]
                mov [reg_de],ax
		mov ax,[si+14]
                mov [reg_bc],ax
		mov ax,[si+16]
                mov [reg_hl],ax
		mov ax,[si+18]
                mov [ireg_i],ah
                mov byte [ireg_im],1
                cmp ah,03fh
                if nz,mov byte [ireg_im],2
		mov ax,[si+20]
                mov [reg_sp],ax
                mov ax,[si+22]
                cmp ax,strict 0
                if nz,mov [interrupt_speed],ax
                mov ds,[z80_seg]
                mov si,[cs:reg_sp]
                lodsw                   ;ar
                mov [cs:ireg_r],ah
		mov word [cs:ireg_iff1],0101h
                test al,4
		if z,mov word [cs:ireg_iff1],0
                lodsw
                xchg al,ah
                mov [cs:reg_af],ax
                lodsw
                mov [cs:reg_sp],si
                mov [cs:reg_pc],ax

       no_file: push cx
       		push bx
       		push dx
       		push bp
       		push si
       		push di
       		push ds
       		push es

                mov es,[cs:scr_seg]
		mov ds,[cs:code_seg]
		mov si,debug_text
                mov di,0
	 plp0:	lodsb
		cmp al,36
                jz endplp
                push si
		mov si,charset-256
		mov ah,0
		shl ax,3
		add si,ax
		lodsb
		mov [es:di],al
		mov byte [es:di+1],05h
		lodsb
		mov [es:di+80],al
		mov byte [es:di+81],07h
                lodsb
		mov [es:di+160],al
		mov byte [es:di+161],0fh
                lodsb
		mov [es:di+240],al
		mov byte [es:di+241],0fh
                lodsb
		mov [es:di+320],al
		mov byte [es:di+321],0fh
                lodsb
		mov [es:di+400],al
		mov byte [es:di+401],0fh
                lodsb
		mov [es:di+480],al
		mov byte [es:di+481],07h
                lodsb
		mov [es:di+560],al
		mov byte [es:di+561],05h
                pop si
		add di,2
		mov ax,di
		mov bl,80
		div bl
		cmp ah,0
		if z,add di,560
                jmp plp0
endplp: 	mov di,152*80+66
                mov si,logobox
                mov ah,7
                mov cl,44
        plogo0: mov ch,7
        plogo1: movsw
                dec ch
                jnz plogo1
                add di,66
                dec cl
                jnz plogo0
                mov ds,[cs:z80_seg]
                mov si,16384
                mov bx,pos_table
        pint0:  mov di,[cs:bx]
                add di,di
                mov cx,32
        pint1:  movsb
                inc di
                loop pint1
                inc bx
                inc bx
                cmp bx,pos_table+384
                jnz pint0
                mov di,1
                mov cx,02018h
        pint2:  lodsb
                sub ah,ah
		mov bx,attr_table
		add bx,ax
		mov al,[cs:bx]
                mov [es:di],al
		mov [es:di+80],al
		mov [es:di+160],al
		mov [es:di+240],al
		mov [es:di+320],al
		mov [es:di+400],al
		mov [es:di+480],al
		mov [es:di+560],al
		add di,2
		dec ch
                jnz pint2
		add di,640-64
		mov ch,32
		dec cl
                jnz pint2


      reset:	mov [cs:main_stack],sp
                mov ax,[cs:reg_af]      ; Set registers
		mov cx,[cs:reg_bc]
		mov dx,[cs:reg_de]
		mov bx,[cs:reg_hl]
		mov bp,[cs:reg_sp]
		mov si,[cs:reg_pc]
		jmp preset_pc

stop_speccy:	mov sp,[cs:main_stack]  ; Pressed 'Esc'
		mov dx,[cs:old_int9]
		mov ds,[cs:old_int9+2]
		mov ax,02509h
		dos_int 		; Restore Int 09h (IMPORTANT!)
                pop es
                pop ds
                pop di
                pop si
                pop bp
                pop dx
                pop bx
                pop cx
                vmode 3
                dosexit 0

ndoc:           nop
next_instruction:
_nop:           inc si
preset_pc:      dec word [cs:frame_count]
		jnz pi0
                dec si
		jmp _halt2
pi0:            mov di,ax
                mov al,[si]
                sub ah,ah
                xchg ax,di
                add di,di
		jmp word [cs:di+opcodes]

;*************> emulation code <**********************************************;

    ld_bc_nn:   inc si
                mov cl,[si]
		inc si
                mov ch,[si]
		jmp next_instruction

    ld_cbc_a:	mov di,cx
                mov [di],al
		jmp next_instruction

    inc_bc:	inc cx
		jmp next_instruction

    inc_b:      and ah,00000001b
		inc ch
                emul_p_c

    dec_b:      or  ah,00000010b
		dec ch
                emul_p_c

    ld_b_n:	inc si
                mov ch,[si]
		jmp next_instruction

    rlca:       and ah,11000100b
		rol al,1
		adc ah,0
		jmp next_instruction

    ex_af:	xchg [cs:reg_af2],ax
		jmp next_instruction

    add_hl_bc:  and ah,11000100b      ; Keep S Z - - - P - -
		add bx,cx
		adc ah,0
		jmp next_instruction

    ld_a_cbc:	mov di,cx
                mov al,[di]
		jmp next_instruction

    dec_bc:	dec cx
		jmp next_instruction

    inc_c:	and ah,1
		inc cl
                emul_p_c

    dec_c:	or ah,2
		dec cl
                emul_p_c

    ld_c_n:	inc si
                mov cl,[si]
		jmp next_instruction

    rrca:       and ah,11000100b
		ror al,1
		adc ah,0
		jmp next_instruction

    _djnz:      inc si
                dec ch
                if e,jmp next_instruction
		mov di,ax
                lodsb
		cbw
		add si,ax
                mov ax,di
                jmp preset_pc

    ld_de_nn:	inc si
                mov dl,[si]
		inc si
                mov dh,[si]
		jmp next_instruction

    ld_cde_a:	mov di,dx
                mov [di],al
		jmp next_instruction

    inc_de:	inc dx
		jmp next_instruction

    inc_d:	and ah,1
		inc dh
                emul_p_c

    dec_d:	or ah,2
		dec dh
                emul_p_c

    ld_d_n:	inc si
                mov dh,[si]
		jmp next_instruction

    rla:	sahf
		rcl al,1
		mov di,ax
                lahf
                and ah,00000001b
                and di,1110110000000000b      ;0c400
                or ax,di
                jmp next_instruction

    jr: 	inc si
                jr_mac

    add_hl_de:  and ah,11101100b
		add bx,dx
		adc ah,0
		jmp next_instruction

    ld_a_cde:	mov di,dx
                mov al,[di]
		jmp next_instruction

    dec_de:	dec dx
		jmp next_instruction

    inc_e:	and ah,1
		inc dl
                emul_p_c

    dec_e:	or ah,2
		dec dl
                emul_p_c

    ld_e_n:	inc si
                mov dl,[si]
		jmp next_instruction

    rra:	sahf
		rcr al,1
		mov di,ax		; Carry flag
                lahf
                and ah,00000001b
                and di,1110110000000000b      ;0c400
                or ax,di
                jmp next_instruction

    jrnz:       inc si
                sahf
                if z,jmp next_instruction
                jr_mac

    ld_hl_nn:	inc si
                mov bl,[si]
		inc si
                mov bh,[si]
		jmp next_instruction

    ld_cnn_hl:	inc si
                mov di,ax
                lodsb
                mov ah,[si]
                xchg di,ax
                mov [di],bl
                mov [di+1],bh
		jmp next_instruction

    inc_hl:	inc bx
		jmp next_instruction

    inc_h:	and ah,1
		inc bh
                emul_p_c

    dec_h:	or ah,2
		dec bh
                emul_p_c

    ld_h_n:	inc si
		mov bh,byte [si]
		jmp next_instruction

    _daa:       test ah,2                       ;Test Add/subtract flag
                jz _daa2                        ; do a DAA if add
		sahf
		das
                mov di,ax
                lahf
                and di,0000001000000000b
                and ah,11111101b
                or ax,di
                jmp next_instruction
	 _daa2: sahf
		daa
                mov di,ax
                lahf
                and di,0000001000000000b
                and ah,11111101b
                or ax,di
                jmp next_instruction

    jr_z:       inc si
                sahf
                if nz,jmp next_instruction
                jr_mac

    add_hl_hl:  and ah,11101100b
		add bx,bx
		adc ah,0
		jmp next_instruction

    ld_hl_cnn:  inc si
                mov di,ax
                lodsb
                mov ah,[si]
                xchg di,ax
                mov bl,[di]
                mov bh,[di+1]
                jmp next_instruction

    dec_hl:	dec bx
		jmp next_instruction

    inc_l:      and ah,1
		inc bl
                emul_p_c

    dec_l:      or ah,2
		dec bl
                emul_p_c

    ld_l_n:     inc si
                mov bl,[si]
		jmp next_instruction

    cpl:        not al
		or ah,012h
		jmp next_instruction

    jr_nc:      inc si
                sahf
                if c,jmp next_instruction
                jr_mac

    ld_sp_nn:   inc si
                mov bp,ax
                lodsb
                mov ah,[si]
                xchg bp,ax
		jmp next_instruction

    ld_cnn_a:   inc si
                mov di,ax
                lodsb
                mov ah,[si]
                xchg di,ax
                mov [di],al
		jmp next_instruction

    inc_sp:     inc bp
		jmp next_instruction

    inc_chl:	and ah,1
                inc byte [bx]
                emul_p_c

    dec_chl:	or ah,2
                dec byte [bx]
                emul_p_c

    ld_chl_n:   inc si
		mov di,ax
                lodsb
                mov [bx],al
		mov ax,di
                jmp preset_pc

    scf:        and ah,0c4h
                inc ah
		jmp next_instruction

    jr_c:       inc si
                sahf
                if nc,jmp next_instruction
                jr_mac

    add_hl_sp:  and ah,0c4h
		add bx,bp
		adc ah,0
		jmp next_instruction

    ld_a_cnn:	inc si
                mov di,ax
                lodsb
                mov ah,[si]
                xchg di,ax
                mov al,[di]
                jmp next_instruction

    dec_sp:	dec bp
		jmp next_instruction

    inc_a:      and ah,1
		inc al
                emul_p_c

    dec_a:      or ah,2
		dec al
                emul_p_c

    ld_a_n:     inc si
                lodsb
                jmp preset_pc

    ccf:        and ah,0c5h
		xor ah,1
		jmp next_instruction

    ld_b_b:     mov ch,ch
		jmp next_instruction

    ld_b_c:	mov ch,cl
		jmp next_instruction

    ld_b_d:     mov ch,dh
		jmp next_instruction

    ld_b_e:     mov ch,dl
		jmp next_instruction

    ld_b_h:	mov ch,bh
		jmp next_instruction

    ld_b_l:     mov ch,bl
		jmp next_instruction

    ld_b_chl:   mov ch,[bx]
		jmp next_instruction

    ld_b_a:     mov ch,al
		jmp next_instruction

    ld_c_b:     mov cl,ch
		jmp next_instruction

    ld_c_c:     mov cl,cl
		jmp next_instruction

    ld_c_d:     mov cl,dh
		jmp next_instruction

    ld_c_e:     mov cl,dl
		jmp next_instruction

    ld_c_h:     mov cl,bh
		jmp next_instruction

    ld_c_l:     mov cl,bl
		jmp next_instruction

    ld_c_chl:   mov cl,[bx]
		jmp next_instruction

    ld_c_a:     mov cl,al
		jmp next_instruction

    ld_d_b:     mov dh,ch
		jmp next_instruction

    ld_d_c:     mov dh,cl
		jmp next_instruction

    ld_d_d:     mov dh,dh
		jmp next_instruction

    ld_d_e:     mov dh,dl
		jmp next_instruction

    ld_d_h:     mov dh,bh
		jmp next_instruction

    ld_d_l:     mov dh,bl
		jmp next_instruction

    ld_d_chl:   mov dh,[bx]
		jmp next_instruction

    ld_d_a:     mov dh,al
		jmp next_instruction

    ld_e_b:     mov dl,ch
		jmp next_instruction

    ld_e_c:     mov dl,cl
		jmp next_instruction

    ld_e_d:     mov dl,dh
		jmp next_instruction

    ld_e_e:     mov dl,dl
		jmp next_instruction

    ld_e_h:     mov dl,bh
		jmp next_instruction

    ld_e_l:     mov dl,bl
		jmp next_instruction

    ld_e_chl:   mov dl,[bx]
		jmp next_instruction

    ld_e_a:     mov dl,al
		jmp next_instruction

    ld_h_b:     mov bh,ch
		jmp next_instruction

    ld_h_c:     mov bh,cl
		jmp next_instruction

    ld_h_d:     mov bh,dh
		jmp next_instruction

    ld_h_e:     mov bh,dl
		jmp next_instruction

    ld_h_h:     mov bh,bh
		jmp next_instruction

    ld_h_l:     mov bh,bl
		jmp next_instruction

    ld_h_chl:   mov bh,[bx]
		jmp next_instruction

    ld_h_a:     mov bh,al
		jmp next_instruction

    ld_l_b:     mov bl,ch
		jmp next_instruction

    ld_l_c:     mov bl,cl
		jmp next_instruction

    ld_l_d:     mov bl,dh
		jmp next_instruction

    ld_l_e:     mov bl,dl
		jmp next_instruction

    ld_l_h:     mov bl,bh
		jmp next_instruction

    ld_l_l:     mov bl,bl
		jmp next_instruction

    ld_l_chl:   mov bl,[bx]
		jmp next_instruction

    ld_l_a:	mov bl,al
		jmp next_instruction

    ld_chl_b:   mov [bx],ch
		jmp next_instruction

    ld_chl_c:   mov [bx],cl
		jmp next_instruction

    ld_chl_d:   mov [bx],dh
		jmp next_instruction

    ld_chl_e:   mov [bx],dl
		jmp next_instruction

    ld_chl_h:   mov [bx],bh
		jmp next_instruction

    ld_chl_l:   mov [bx],bl
		jmp next_instruction

    _halt:	mov byte [cs:fresh],1
    _halt2:	push_all
                mov di,[cs:interrupt_speed]
                mov [cs:frame_count],di
		test byte [cs:statbyte],4	;Is scroll lock on?
		if z,jmp refresh_screen

                mov es,[cs:scr_seg]
                mov bp,sp
		mov di,0*80+72
		mov ax,[bp+8]		;PC
		call print_word
		mov di,8*80+72
		mov ax,[bp+20]		;AF
		xchg ah,al
		call print_word
		mov di,16*80+72
		mov ax,[bp+18]		;BC
		call print_word
		mov di,24*80+72
		mov ax,[bp+16]		;DE
		call print_word
		mov di,32*80+72
		mov ax,[bp+14]		 ;HL
		call print_word
		mov di,40*80+72
		mov ax,[cs:reg_af2]	;AF'
		xchg ah,al
		call print_word
		mov di,48*80+72
		mov ax,[cs:reg_bc2]	;BC'
		call print_word
		mov di,56*80+72
		mov ax,[cs:reg_de2]	;DE'
		call print_word
		mov di,64*80+72
		mov ax,[cs:reg_hl2]	;HL'
		call print_word
		mov di,72*80+72
		mov ax,[cs:reg_ix]	;IX
		call print_word
		mov di,80*80+72
		mov ax,[cs:reg_iy]	;IY
		call print_word
		mov di,88*80+72
		mov ax,[bp+10]		 ;SP
		call print_word
		mov di,96*80+72
		mov ax,[cs:ireg_i]	;IR
		xchg al,ah
		call print_word
		mov di,104*80+72
		mov al,[cs:ireg_im]
		mov ah,0
		call print_word 	;Int mode
                mov di,128*80+72
                mov ax,[cs:interrupt_speed]           ;Int speed
                call print_word


refresh_screen: cmp byte [cs:fresh],1			;Is it forced by halt?
		if z,jmp forced_refresh
		test byte [cs:statbyte],1		;Is num lock on?
		if z,jmp no_refresh
forced_refresh: mov byte [cs:fresh],0
                mov es,[cs:scr_seg]
		dec byte [cs:flash_count]
                jnz l0
                mov byte [cs:flash_count],16
                xor byte [cs:flash_ff],1

        l0:     mov si,16384
                mov bx,pos_table

	l1:	mov di,[cs:bx]
		add di,di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		movsb
		inc di
		inc bx
		inc bx
		cmp bx,pos_table+384
		jnz l1

                cmp byte [cs:flash_count],1
		jz att0
		test byte [cs:statbyte],2
		jz no_refresh

        att0:   mov di,1
		mov cx,02018h
        att1:   lodsb
		mov ah,0
		mov bx,attr_table
		add bx,ax
		add bh,[cs:flash_ff]
		mov al,[cs:bx]

                mov [es:di],al
		mov [es:di+80],al
		mov [es:di+160],al
		mov [es:di+240],al
		mov [es:di+320],al
		mov [es:di+400],al
		mov [es:di+480],al
		mov [es:di+560],al
		add di,2
		dec ch
		jnz att1
		add di,640-64
		mov ch,32
		dec cl
		jnz att1

no_refresh:     mov ax,0100h
		keyboard_int
		if z,jmp nokinbuff
                mov ax,0
		keyboard_int
		cmp ax,01a5bh
		jnz nois0
		sub word [cs:interrupt_speed],10
		jmp no_refresh
        nois0:  cmp ax,01b5dh
		jnz nois1
		add word [cs:interrupt_speed],10
		jmp no_refresh
        nois1:  cmp ax,01a1bh
		jnz nois2
		sub word [cs:interrupt_speed],100
		jmp no_refresh
        nois2:  cmp ax,01b1dh
		jnz nois3
		add word [cs:interrupt_speed],100
                jmp no_refresh
        nois3:  mov es,[cs:scr_seg]
                cmp ax,03b00h           ;F1 Redraw
		jnz nof1
		xor byte [cs:statbyte],1
		mov di,113*80+69
                mov al,2
		test byte [cs:statbyte],1
		if nz,mov al,12
		mov [es:di],al
		mov [es:di+2],al
		mov [es:di+80],al
		mov [es:di+82],al
		mov [es:di+160],al
		mov [es:di+162],al
		mov [es:di+240],al
		mov [es:di+242],al
		mov [es:di+320],al
		mov [es:di+322],al
		jmp no_refresh

	 nof1:	cmp ax,03c00h		;F2 Attributes
		jnz nof2
		xor byte [cs:statbyte],2
		mov di,113*80+75
                mov al,2
		test byte [cs:statbyte],2
		if nz,mov al,12
		mov [es:di],al
		mov [es:di+2],al
		mov [es:di+80],al
		mov [es:di+82],al
		mov [es:di+160],al
		mov [es:di+162],al
		mov [es:di+240],al
		mov [es:di+242],al
		mov [es:di+320],al
                mov [es:di+322],al
                jmp no_refresh

         nof2:  cmp ax,03d00h           ;F3 Registers
		jnz nof3
		xor byte [cs:statbyte],4
		mov di,121*80+69
                mov al,2
		test byte [cs:statbyte],4
		if nz,mov al,12
		mov [es:di],al
		mov [es:di+2],al
		mov [es:di+80],al
		mov [es:di+82],al
		mov [es:di+160],al
		mov [es:di+162],al
		mov [es:di+240],al
		mov [es:di+242],al
		mov [es:di+320],al
                mov [es:di+322],al
                jmp no_refresh

         nof3:  cmp ax,03e00h           ;F4 Sound
		jnz nof4
		xor byte [cs:soundstat],2
		mov di,121*80+75
                mov al,2
		test byte [cs:soundstat],2
		if nz,mov al,12
		mov [es:di],al
		mov [es:di+2],al
		mov [es:di+80],al
		mov [es:di+82],al
		mov [es:di+160],al
		mov [es:di+162],al
		mov [es:di+240],al
		mov [es:di+242],al
		mov [es:di+320],al
                mov [es:di+322],al
                jmp no_refresh

	 nof4:	cmp ax,04400h
                jnz .l0
                pop_all
                jmp multiface_in
         .l0:   jmp no_refresh
nokinbuff:	pop_all
		cmp byte [cs:kemstat],030h
                if z,jmp stop_speccy
		pushf
		cmp byte [cs:ireg_iff1],0
                if z,poptonext
                ;cmp byte [cs:ireg_im],0
                ;if z,poptonext
                cmp bp,23298
		ja imode1
		cmp bp,0
		jz imode1
		popf
		jmp next_instruction

      imode1:	cmp byte [cs:ireg_im],2
                jz imode2
		inc si
                xchg ax,si
                dec bp
                dec bp
                mov [ds:bp],al
                mov [ds:bp+1],ah
		mov al,[cs:ireg_iff1]
		mov [cs:ireg_iff2],al
		mov byte [cs:ireg_iff1],0
                mov ax,si
                mov si,038h
		popf
		jmp preset_pc

      imode2:	inc si
                xchg ax,si
                dec bp
                dec bp
                mov [ds:bp],al
                mov [ds:bp+1],ah
		mov al,[cs:ireg_iff1]
		mov [cs:ireg_iff2],al
                mov byte [cs:ireg_iff1],0
                mov ax,si
                mov di,[cs:ireg_im]
                or di,255
                mov si,ax
                mov al,[di]
                mov ah,[di+1]
                xchg ax,si
		popf
                jmp preset_pc


    ld_chl_a:   mov [bx],al
		jmp next_instruction

    ld_a_b:     mov al,ch
		jmp next_instruction

    ld_a_c:     mov al,cl
		jmp next_instruction

    ld_a_d:     mov al,dh
		jmp next_instruction

    ld_a_e:     mov al,dl
		jmp next_instruction

    ld_a_h:     mov al,bh
		jmp next_instruction

    ld_a_l:     mov al,bl
		jmp next_instruction

    ld_a_chl:   mov al,[bx]
		jmp next_instruction

    ld_a_a:     mov al,al
		jmp next_instruction

    add_a_b:    and ah,0d5h
		add al,ch
                emul_p

    add_a_c:    and ah,0d5h
		add al,cl
                emul_p

    add_a_d:    and ah,0d5h
		add al,dh
                emul_p

    add_a_e:    and ah,0d5h
		add al,dl
                emul_p

    add_a_h:    and ah,0d5h
		add al,bh
                emul_p

    add_a_l:    and ah,0d5h
		add al,bl
                emul_p

    add_a_chl:  and ah,0d5h
                add al,[bx]
                emul_p

    add_a_a:    and ah,0d5h
		add al,al
                emul_p

    adc_a_b:    and ah,0d5h
		sahf
		adc al,ch
                emul_p

    adc_a_c:    and ah,0d5h
		sahf
		adc al,cl
                emul_p

    adc_a_d:    and ah,0d5h
		sahf
		adc al,dh
                emul_p

    adc_a_e:    and ah,0d5h
		sahf
		adc al,dl
                emul_p

    adc_a_h:    and ah,0d5h
		sahf
		adc al,bh
                emul_p

    adc_a_l:    and ah,0d5h
		sahf
		adc al,bl
                emul_p

    adc_a_chl:  and ah,0d5h
		sahf
                adc al,[bx]
                emul_p

    adc_a_a:    and ah,0d5h
		sahf
		adc al,al
                emul_p

    sub_a_b:    or ah,2
		sub al,ch
                emul_p

    sub_a_c:    or ah,2
		sub al,cl
                emul_p

    sub_a_d:    or ah,2
		sub al,dh
                emul_p

    sub_a_e:    or ah,2
		sub al,dl
                emul_p

    sub_a_h:    or ah,2
		sub al,bh
                emul_p

    sub_a_l:    or ah,2
		sub al,bl
                emul_p

    sub_a_chl:  or ah,2
                sub al,[bx]
                emul_p

    sub_a_a:    or ah,2
		sub al,al
                emul_p

    sbc_a_b:    or ah,2
		sahf
		sbb al,ch
                emul_p

    sbc_a_c:    or ah,2
		sahf
		sbb al,cl
                emul_p

    sbc_a_d:	or ah,2
		sahf
		sbb al,dh
                emul_p

    sbc_a_e:    or ah,2
		sahf
		sbb al,dl
                emul_p

    sbc_a_h:    or ah,2
		sahf
		sbb al,bh
                emul_p

    sbc_a_l:    or ah,2
		sahf
		sbb al,bl
                emul_p

    sbc_a_chl:  or ah,2
		sahf
                sbb al,[bx]
                emul_p

    sbc_a_a:    or ah,2
		sahf
		sbb al,al
                emul_p

    and_a_b:    and al,ch
		lahf
		or ah,010h
		and ah,0d4h
		jmp next_instruction

    and_a_c:    and al,cl
		lahf
		or ah,010h
		and ah,0d4h
		jmp next_instruction

    and_a_d:    and al,dh
		lahf
		or ah,010h
		and ah,0d4h
		jmp next_instruction

    and_a_e:    and al,dl
		lahf
		or ah,010h
		and ah,0d4h
		jmp next_instruction

    and_a_h:    and al,bh
		lahf
		or ah,010h
		and ah,0d4h
		jmp next_instruction

    and_a_l:    and al,bl
		lahf
		or ah,010h
		and ah,0d4h
		jmp next_instruction

    and_a_chl:  and al,[bx]
		lahf
		or ah,010h
		and ah,0d4h
		jmp next_instruction

    and_a_a:    and al,al
		lahf
		or ah,010h
		and ah,0d4h
		jmp next_instruction

    xor_a_b:    xor al,ch
		lahf
		and ah,0c4h
		jmp next_instruction

    xor_a_c:    xor al,cl
		lahf
		and ah,0c4h
		jmp next_instruction

    xor_a_d:    xor al,dh
		lahf
		and ah,0c4h
		jmp next_instruction

    xor_a_e:    xor al,dl
		lahf
		and ah,0c4h
		jmp next_instruction

    xor_a_h:    xor al,bh
		lahf
		and ah,0c4h
		jmp next_instruction

    xor_a_l:    xor al,bl
		lahf
		and ah,0c4h
		jmp next_instruction

    xor_a_chl:  xor al,[bx]
		lahf
		and ah,0c4h
		jmp next_instruction

    xor_a_a:    xor al,al
		lahf
		and ah,0c4h
		jmp next_instruction

    or_a_b:     or al,ch
		lahf
		and ah,0c4h
		jmp next_instruction

    or_a_c:     or al,cl
		lahf
		and ah,0c4h
		jmp next_instruction

    or_a_d:     or al,dh
		lahf
		and ah,0c4h
		jmp next_instruction

    or_a_e:     or al,dl
		lahf
		and ah,0c4h
		jmp next_instruction

    or_a_h:     or al,bh
		lahf
		and ah,0c4h
		jmp next_instruction

    or_a_l:     or al,bl
		lahf
		and ah,0c4h
		jmp next_instruction

    or_a_chl:   or al,[bx]
		lahf
		and ah,0c4h
		jmp next_instruction

    or_a_a:     or al,al
		lahf
		and ah,0c4h
		jmp next_instruction

    cp_a_b:     or ah,2
		cmp al,ch
                emul_p

    cp_a_c:     or ah,2
		cmp al,cl
                emul_p

    cp_a_d:     or ah,2
		cmp al,dh
                emul_p

    cp_a_e:     or ah,2
		cmp al,dl
                emul_p

    cp_a_h:     or ah,2
		cmp al,bh
                emul_p

    cp_a_l:     or ah,2
		cmp al,bl
                emul_p

    cp_a_chl:   or ah,2
                cmp al,[bx]
                emul_p

    cp_a_a:     or ah,2
		cmp al,al
                emul_p

    ret_nz:     sahf
                if nz,ret_mac
		jmp next_instruction

    pop_bc:     mov cl,[ds:bp]
                mov ch,[ds:bp+1]
                inc bp
                inc bp
		jmp next_instruction

    jp_nz:      sahf
		if nz,jp_mac
		jp_skip

    jp_:        jp_mac

    call_nz:    sahf
		if nz,call_mac
		jp_skip

    push_bc:    dec bp
    		dec bp
                mov [ds:bp],cl
                mov [ds:bp+1],ch
		jmp next_instruction

    add_a_n:    and ah,0d5h
		inc si
		add al,byte [si]
                emul_p

    rst_0:      inc si
                push_all
                mov si,specrom
                mov di,0
                mov ds,[cs:code_seg]
                mov es,[z80_seg]
                mov cx,8192
                cmp word [specrom_stat],1
                if z,rep movsw
                pop_all
                push_all
		cmp byte [si],'f'
		if z,jmp file_search
		cmp byte [si],'s'
		if z,jmp file_save
		cmp byte [si],'c'
		if z,jmp file_create
		cmp byte [si],'l'
		if z,jmp file_load
                cmp byte [si],'i'
                if z,jmp intell_s
                pop_all
                xchg si,ax
                mov [ds:bp],al
                mov [ds:bp+1],ah
                mov ax,si
		mov si,0
		jmp preset_pc

intell_s:       cmp dx,17
                if z,cmp al,0
                if z,jmp file_create
                jmp file_save

file_search:	mov si,[cs:reg_ix]
		sub si,17
		cmp byte [si],4
		jb f_search0
		pop_all
		or ah,1
		jmp next_instruction

f_search0:	mov ds,[cs:code_seg]
		mov es,[z80_seg]
		mov di,last_file
		mov si,[reg_ix]
		sub si,16
                mov cx,10
fs_tran:	mov al,[es:si]
		cmp al,48
		if b,mov al,95
		cmp al,58
		if z,mov al,95
		cmp al,59
                if z,mov al,95
		cmp al,60
                if z,mov al,95
		cmp al,61
                if z,mov al,95
		cmp al,62
                if z,mov al,95
		cmp al,63
                if z,mov al,95
		cmp al,64
		if z,mov al,95
		cmp al,91
                if z,mov al,95
		cmp al,92
                if z,mov al,95
		cmp al,93
                if z,mov al,95
		cmp al,94
                if z,mov al,95
		cmp al,122
		if a,mov al,95
		mov byte [di],al
		inc si
		inc di
		cmp di,last_file+8
		if z,inc di
		loop fs_tran
		mov si,[reg_ix]
		cmp byte [es:si-17],0
		if z,mov byte [di],'b'
		cmp byte [es:si-17],1
		if z,mov byte [di],'n'
		cmp byte [es:si-17],2
		if z,mov byte [di],'r'
		cmp byte [es:si-17],3
		if z,mov byte [di],'c'
		openm last_file,0
		jc fs_notfound
		mov ds,[cs:z80_seg]
		loadm ax,si,17
		closem bx
		pop_all
		or ah,1
		jmp next_instruction
fs_notfound:	pop_all
		mov si,1362
		mov si,2054
		jmp preset_pc

file_create:	mov si,[cs:reg_ix]
		cmp byte [si],4
		jb f_create0
		pop_all
		or ah,1
		jmp next_instruction

f_create0:	mov ds,[cs:code_seg]
                mov es,[z80_seg]
		mov di,last_file
                mov si,[reg_ix]
		mov cx,10
		inc si

fc_tran:	mov al,[es:si]
		cmp al,48
		if b,mov al,95
		cmp al,58
		if z,mov al,95
		cmp al,59
                if z,mov al,95
		cmp al,60
                if z,mov al,95
		cmp al,61
                if z,mov al,95
		cmp al,62
                if z,mov al,95
		cmp al,63
                if z,mov al,95
		cmp al,64
		if z,mov al,95
		cmp al,91
                if z,mov al,95
		cmp al,92
                if z,mov al,95
		cmp al,93
                if z,mov al,95
		cmp al,94
                if z,mov al,95
		cmp al,122
		if a,mov al,95
		mov byte [di],al
		inc si
		inc di
		cmp di,last_file+8
		if z,inc di
		loop fc_tran
		mov si,[reg_ix]
		cmp byte [es:si],0
		if z,mov byte [di],'b'
		cmp byte [es:si],1
		if z,mov byte [di],'n'
		cmp byte [es:si],2
		if z,mov byte [di],'r'
		cmp byte [es:si],3
		if z,mov byte [di],'c'

		mov di,header
		mov si,[reg_ix]
		mov cx,17
xfer_header:	mov al,[es:si]
		mov [di],al
		inc di
		inc si
		loop xfer_header
		pop_all
		or ah,1
		jmp next_instruction
fc_notfound:	pop_all
		mov si,1362
		mov si,2054
                jmp preset_pc

file_save:	mov ds,[cs:code_seg]
		createm last_file
		savem ax,header,17
		mov ds,[z80_seg]
		savem bx,[cs:reg_ix],[cs:header+11]
		closem bx
		pop_all
		jmp next_instruction

file_load:	mov ds,[cs:code_seg]
		mov si,dx
		openm last_file,0
		jc fl_notfound
		mov bx,ax
		mov ax,04200h
		mov cx,0
                mov dx,17
		dos_int
                mov ds,[z80_seg]
		loadm bx,[cs:reg_ix],si
		closem bx
		pop_all
		jmp next_instruction
fl_notfound:	pop_all
		mov si,1362
		mov si,2054
		jmp preset_pc

    ret_z:      sahf
		if z,ret_mac
		jmp next_instruction

    _ret:       ret_mac

    jp_z:       sahf
		if z,jp_mac
		jp_skip

    call_z:     sahf
		if z,call_mac
		jp_skip

    _call:	call_mac

    adc_a_n:    and ah,0d5h
		inc si
		sahf
		adc al,[si]
                emul_p

    rst_8:      inc si
                dec bp
                dec bp
                xchg si,ax
                mov [ds:bp],al
                mov [ds:bp+1],ah
                mov ax,si
		mov si,8
		jmp preset_pc

    ret_nc:	sahf
		if nc,ret_mac
		jmp next_instruction

    pop_de:     mov dl,[ds:bp]
                mov dh,[ds:bp+1]
                inc bp
                inc bp
		jmp next_instruction

    jp_nc:      sahf
		if nc,jp_mac
		jp_skip

    out_n_a:    pushf
                inc si
                test byte [si],1
                if z,poptonext
                mov di,ax
		mov ah,al
                in al,97
                and al,11111100b
		test di,010h
                if nz,or al,2
		and al,[cs:soundstat]
                out 97,al
                mov ax,di
                popf
                jmp next_instruction

    call_nc:    sahf
		if nc,call_mac
		jp_skip

    push_de:    dec bp
    		dec bp
                mov [ds:bp],dl
                mov [ds:bp+1],dh
		jmp next_instruction

    sub_a_n:    or ah,2
		inc si
                sub al,[si]
                emul_p

    rst_16:     inc si
                dec bp
                dec bp
                xchg si,ax
                mov [ds:bp],al
                mov [ds:bp+1],ah
                mov ax,si
		mov si,16
		jmp preset_pc

    ret_c:	sahf
		if c,ret_mac
		jmp next_instruction

    exx:	xchg word [cs:reg_bc2],cx
		xchg word [cs:reg_de2],dx
		xchg word [cs:reg_hl2],bx
		jmp next_instruction

    jp_c:       sahf
		if c,jp_mac
		jp_skip

    in_a_n:     inc si
                mov di,ax
                pushf
                test byte [si],1
                jz port254
                cmp byte [si],255
                jz frame_test
		cmp byte [si],159
                jnz .l0
                call page_mfrom
                poptonext
        .l0:    test byte [si],32
                if nz,poptonext
                mov al,[cs:kemstat]
		cmp word [cs:specrom_stat],1
		if nz,call page_specrom
                popf
                jmp next_instruction
    frame_test: popf
                jmp _halt
    port254:    test di,1
                mov al,255
		if z,and al,[cs:keygrp0]
		test di,2
		if z,and al,[cs:keygrp1]
		test di,4
		if z,and al,[cs:keygrp2]
		test di,8
		if z,and al,[cs:keygrp3]
		test di,16
		if z,and al,[cs:keygrp4]
		test di,32
		if z,and al,[cs:keygrp5]
		test di,64
		if z,and al,[cs:keygrp6]
		test di,128
		if z,and al,[cs:keygrp7]
                popf
		jmp next_instruction

    call_c:     sahf
		if c,call_mac
		jp_skip

    sbc_a_n:    or ah,2
		inc si
		sahf
		sbb al,[si]
                emul_p

    rst_24:     inc si
                dec bp
                dec bp
                xchg si,ax
                mov [ds:bp],al
                mov [ds:bp+1],ah
                mov ax,si
                mov si,24
		jmp preset_pc

    ret_po:     sahf
		if po,ret_mac
		jmp next_instruction

    pop_hl:     mov bl,[ds:bp]
                mov bh,[ds:bp+1]
                inc bp
                inc bp
		jmp next_instruction

    jp_po:      sahf
		if po,jp_mac
		jp_skip

    ex_csp_hl:  xchg [ds:bp],bl
                xchg [ds:bp+1],bh
		jmp next_instruction

    call_po:    sahf
		if po,call_mac
		jp_skip

    push_hl:    dec bp
    		dec bp
                mov [ds:bp],bl
                mov [ds:bp+1],bh
		jmp next_instruction

    and_a_n:	inc si
                and al,[si]
		lahf
		or ah,010h
		and ah,0d4h
		jmp next_instruction

    rst_32:     inc si
                dec bp
                dec bp
                xchg si,ax
                mov [ds:bp],al
                mov [ds:bp+1],ah
                mov ax,si
                mov si,32
		jmp preset_pc

    ret_pe:	sahf
		if pe,ret_mac
		jmp next_instruction

    jp_hl:      mov si,bx
		jmp preset_pc

    jp_pe:      sahf
		if pe,jp_mac
		jp_skip

    ex_de_hl:   xchg bx,dx
		jmp next_instruction

    call_pe:    sahf
		if pe,call_mac
		jp_skip

    xor_a_n:    inc si
		xor al,[si]
		lahf
		and ah,0c4h
		jmp next_instruction

    rst_40:	inc si
                dec bp
                dec bp
                xchg si,ax
                mov [ds:bp],al
                mov [ds:bp+1],ah
                mov ax,si
                mov si,40
		jmp preset_pc


    ret_p:      sahf
		if ns,ret_mac
		jmp next_instruction

    pop_af:     mov ah,[ds:bp]
                mov al,[ds:bp+1]
                inc bp
                inc bp
		jmp next_instruction

    jp_p:       sahf
		if ns,jp_mac
		jp_skip

    _di:	mov word [cs:ireg_iff1],0
		jmp next_instruction

    call_p:     sahf
		if ns,call_mac
		jp_skip

    push_af:    dec bp
    		dec bp
                mov [ds:bp],ah
                mov [ds:bp+1],al
		jmp next_instruction

    or_n:	inc si
		or al,[si]
		lahf
		and ah,0c4h
		jmp next_instruction

    rst_48:	inc si
                dec bp
                dec bp
                xchg si,ax
                mov [ds:bp],al
                mov [ds:bp+1],ah
                mov ax,si
                mov si,48
		jmp preset_pc

    ret_m:      sahf
		if s,ret_mac
		jmp next_instruction

    ld_sp_hl:   mov bp,bx
		jmp next_instruction

    jp_m:       sahf
		if s,jp_mac
		jp_skip

    ei: 	mov word [cs:ireg_iff1],0101h
                pushf
                inc word [cs:frame_count]
                popf
                jmp next_instruction

    call_m:	sahf
		if s,call_mac
		jp_skip

    cp_a_n:     or ah,2
		inc si
		cmp al,[si]
                emul_p

    rst_56:     inc si
                dec bp
                dec bp
                xchg si,ax
                mov [ds:bp],al
                mov [ds:bp+1],ah
                mov ax,si
                mov si,56
		jmp preset_pc


print_word:	push ax
		push bx
		push ds
		mov ds,[cs:code_seg]
		mov bx,ax
		mov ah,0
		mov al,bh
		push ax
		push bx
		mov bl,ah
		mov ah,al
		and al,15
		shr ah,4
		cmp ah,9
		if a,add ah,7
		cmp al,9
		if a,add al,7
		push ax
		mov al,ah
		sub ah,ah
                shl ax,3
		mov si,specrom+15616+128
		add si,ax
		lodsb
		mov [es:di],al
		lodsb
		mov [es:di+80],al
                lodsb
		mov [es:di+160],al
                lodsb
		mov [es:di+240],al
                lodsb
		mov [es:di+320],al
                lodsb
		mov [es:di+400],al
                lodsb
		mov [es:di+480],al
                lodsb
		mov [es:di+560],al
		pop ax
		sub ah,ah
		shl ax,3
		mov si,specrom+15616+128
		add si,ax
		lodsb
		mov [es:di+2],al
		lodsb
		mov [es:di+82],al
		lodsb
		mov [es:di+162],al
                lodsb
		mov [es:di+242],al
                lodsb
		mov [es:di+322],al
                lodsb
		mov [es:di+402],al
                lodsb
		mov [es:di+482],al
                lodsb
		mov [es:di+562],al
		pop bx
		pop ax

		mov ah,0
		mov al,bl
		push ax
		push bx
		mov bl,ah
		mov ah,al
		and al,15
		shr ah,4
		cmp ah,9
		if a,add ah,7
		cmp al,9
		if a,add al,7
		push ax
		mov al,ah
		sub ah,ah
		shl ax,3
		mov si,specrom+15616+128
		add si,ax
		lodsb
		mov [es:di+4],al
		lodsb
		mov [es:di+84],al
                lodsb
		mov [es:di+164],al
                lodsb
		mov [es:di+244],al
		lodsb
		mov [es:di+324],al
                lodsb
		mov [es:di+404],al
                lodsb
		mov [es:di+484],al
                lodsb
		mov [es:di+564],al
		pop ax
		sub ah,ah
		shl ax,3
		mov si,specrom+15616+128
		add si,ax
		lodsb
		mov [es:di+6],al
		lodsb
		mov [es:di+86],al
		lodsb
		mov [es:di+166],al
                lodsb
		mov [es:di+246],al
                lodsb
		mov [es:di+326],al
                lodsb
		mov [es:di+406],al
                lodsb
		mov [es:di+486],al
                lodsb
		mov [es:di+566],al
                pop bx
                pop ax

		pop ds
		pop bx
		pop ax
                ret

; trigger the NMI and page the Multiface in
multiface_in:	pushf
		cmp bp,23298
                if b,poptonext
                cmp word [cs:specrom_stat],0
                if z,poptonext
                xchg al,[cs:ireg_iff1]
                mov [cs:ireg_iff2],al
		xor al,al
                xchg al,[cs:ireg_iff1]
                call page_mfrom
		inc si
                dec bp
                dec bp
                xchg si,ax
                mov [ds:bp],al
                mov [ds:bp+1],ah
                mov ax,si
                mov si,066h
		popf
		jmp preset_pc

; Page the 16K Spectrum back in
page_specrom:	pushf
		push es
		push ds
		push si
		push di
		push cx
                cmp word [cs:specrom_stat],1
                jz psr0
                mov es,[cs:code_seg]	; preserve multiface 8K RAM page
                mov ds,[cs:z80_seg]
		mov si,8192
		mov di,mf_ram
		mov cx,8192/2
                rep movsw
                mov es,[cs:z80_seg]
                mov ds,[cs:code_seg]
		mov si,specrom
                mov di,0
                mov cx,16384/2
                rep movsw
                mov word [specrom_stat],1
	 psr0:	pop cx
	 	pop di
	 	pop si
	 	pop ds
	 	pop es
		popf
                ret

; Page the Multiface 1 8K ROM and 8K RAM in 
page_mfrom:	pushf
		push es
		push ds
		push si
		push di
		push cx
		cmp word [cs:specrom_stat],0
		jz pmf0
                mov es,[cs:z80_seg]
		mov ds,[cs:code_seg]
		mov si,mf_rom
		mov di,0
		mov cx,16384/2
		rep movsw
		mov word [specrom_stat],0
    pmf0:	pop cx
    		pop di
    		pop si
    		pop ds
    		pop es
		popf
		ret


text_mode:	push_all
		vmode 3
		pop_all
		ret

spec_mode:      wait_retrace
                cli
                mov dx,03c4h
                mov ax,00b01h
                out dx,ax

                mov dx,03c0h            ;Compensate for 9-8 pel change
                mov al,033h
                out dx,al
                mov al,0
                out dx,al

                mov dx,03d4h
                mov ax,08009h
                out dx,ax
                mov al,00011h
                out dx,ax
                mov ax,03200h
                out dx,ax

                mov dx,03c2h
                mov al,0e3h
                out dx,al

		ret
