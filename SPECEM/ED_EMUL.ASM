; This file contains the subroutines for emulating the ED-prefixed opcodes

ed_op:          inc si
		mov di,ax
		mov al,[si]
                sub ah,ah
		xchg di,ax
                add di,di
                jmp word [cs:di+ed_opcodes]

in_b_bc:
		test cl,1
                jz port2540
		test cl,32
                if z,mov ch,[cs:kemstat]
		mov di,ax
                or ch,ch
                lahf
                and di,0100h
                and ah,11010100b
                or ax,di
                jmp next_instruction
port2540:	mov di,cx
		mov ch,255
                test di,00100h
		if z,and ch,[cs:keygrp0]
                test di,00200h
                if z,and ch,[cs:keygrp1]
                test di,00400h
		if z,and ch,[cs:keygrp2]
                test di,00800h
		if z,and ch,[cs:keygrp3]
                test di,01000h
		if z,and ch,[cs:keygrp4]
                test di,02000h
		if z,and ch,[cs:keygrp5]
                test di,04000h
		if z,and ch,[cs:keygrp6]
                test di,08000h
		if z,and ch,[cs:keygrp7]
		mov di,ax
                or ch,ch
                lahf
                and di,0100h
                and ah,11010100b
                or ax,di
                jmp next_instruction

out_bc_b:	pushf
		test cl,1
                if nz,poptonext
                mov es,ax
                in al,97
                and al,11111100b
                test ch,010h
                if nz,or al,2
		and al,[cs:soundstat]
                out 97,al
                mov ax,es
                popf
                jmp next_instruction

sbc_hl_bc:	or ah,2
		sahf
		sbb bx,cx
                emul_p

ld_cnn_bc:	inc si
                mov di,ax
                lodsb
                mov ah,[si]
                xchg di,ax
                mov [di],cl
                mov [di+1],ch
		jmp next_instruction

neg_:		xor ah,ah
		sub ah,al
		mov al,ah
		mov ah,2
                emul_p

retn_:          mov si,ax
                mov al,[cs:ireg_iff2]
                mov [cs:ireg_iff1],al
                mov al,[ds:bp]
                mov ah,[ds:bp+1]
                xchg si,ax
                inc bp
                inc bp
		jmp preset_pc

im_0:		mov byte [cs:ireg_im],0
		jmp next_instruction

ld_i_a:         mov byte [cs:ireg_i],al
		jmp next_instruction

in_c_bc:	test cl,1
                jz port2541
		test cl,32
                if z,mov cl,[cs:kemstat]
		mov di,ax
		or cl,cl
		lahf
		and di,0100h
		and ah,0d4h
                or ax,di
                jmp next_instruction
port2541:       mov cl,255
		test ch,1
		if z,and cl,[cs:keygrp0]
		test ch,2
		if z,and cl,[cs:keygrp1]
		test ch,4
		if z,and cl,[cs:keygrp2]
		test ch,8
		if z,and cl,[cs:keygrp3]
		test ch,16
		if z,and cl,[cs:keygrp4]
		test ch,32
		if z,and cl,[cs:keygrp5]
		test ch,64
		if z,and cl,[cs:keygrp6]
		test ch,128
		if z,and cl,[cs:keygrp7]
		mov di,ax
		or cl,cl
		lahf
		and di,0100h
		and ah,0d4h
                or ax,di
                jmp next_instruction

out_bc_c:	pushf
		test cl,1
                if nz,poptonext
                mov es,ax
                in al,97
                and al,11111100b
                test cl,010h
                if nz,or al,2
		and al,[cs:soundstat]
                out 97,al
                mov ax,es
                popf
		jmp next_instruction

adc_hl_bc:      and ah,1
		sahf
		adc bx,cx
                emul_p

ld_bc_cnn:	inc si
                mov di,ax
                lodsb
                mov ah,[si]
                xchg di,ax
                mov cl,[di]
                mov ch,[di+1]
		jmp next_instruction

reti:           mov si,ax
                mov al,[ds:bp]
                mov ah,[ds:bp+1]
                xchg si,ax
                inc bp
                inc bp
		jmp preset_pc

ld_r_a: 	mov [cs:ireg_r],al
		jmp next_instruction

in_d_bc:	test cl,1
                jz port2542
		test cl,32
                if z,mov dh,[cs:kemstat]
		mov di,ax
		or dh,dh
		lahf
		and di,0100h
		and ah,0d4h
                or ax,di
                jmp next_instruction
port2542:       mov dh,255
		test ch,1
		if z,and dh,[cs:keygrp0]
		test ch,2
		if z,and dh,[cs:keygrp1]
		test ch,4
		if z,and dh,[cs:keygrp2]
		test ch,8
		if z,and dh,[cs:keygrp3]
		test ch,16
		if z,and dh,[cs:keygrp4]
		test ch,32
		if z,and dh,[cs:keygrp5]
		test ch,64
		if z,and dh,[cs:keygrp6]
		test ch,128
		if z,and dh,[cs:keygrp7]
		mov di,ax
		or dh,dh
		lahf
		and di,0100h
		and ah,0d4h
                or ax,di
                jmp next_instruction

out_bc_d:	pushf
		test cl,1
                if nz,poptonext
		mov es,ax
                in al,97
                and al,11111100b
                test dh,010h
                if nz,or al,2
		and al,[cs:soundstat]
                out 97,al
                mov ax,es
                popf
		jmp next_instruction

sbc_hl_de:	or ah,2
		sahf
		sbb bx,dx
                emul_p

ld_cnn_de:	inc si
                mov di,ax
                lodsb
                mov ah,[si]
                xchg di,ax
                mov [di],dl
                mov [di+1],dh
		jmp next_instruction

im_1:		mov byte [cs:ireg_im],1
		jmp next_instruction

ld_a_i: 	mov al,[cs:ireg_i]
		or al,al
		mov di,ax
		lahf
		and ah,0c0h
		and di,0100h
		or ax,di
		test byte [cs:ireg_iff2],1
		if ne,or ah,4
		jmp next_instruction

in_e_bc:	test cl,1
                jz port2543
		test cl,32
                if z,mov dl,[cs:kemstat]
		mov di,ax
		or dl,dl
		lahf
                and di,0100h
		and ah,0d4h
                or ax,di
                jmp next_instruction
port2543:       mov dl,255
		test ch,1
		if z,and dl,[cs:keygrp0]
		test ch,2
		if z,and dl,[cs:keygrp1]
		test ch,4
		if z,and dl,[cs:keygrp2]
		test ch,8
                if z,and dl,[cs:keygrp3]
		test ch,16
		if z,and dl,[cs:keygrp4]
		test ch,32
		if z,and dl,[cs:keygrp5]
		test ch,64
		if z,and dl,[cs:keygrp6]
		test ch,128
		if z,and dl,[cs:keygrp7]
		mov di,ax
		or dl,dl
		lahf
                and di,0100h
		and ah,0d4h
                or ax,di
                jmp next_instruction

out_bc_e:	pushf
		test cl,1
                if nz,poptonext
                mov es,ax
                in al,97
                and al,11111100b
                test dl,010h
                if nz,or al,2
		and al,[cs:soundstat]
                out 97,al
                mov ax,es
                popf
		jmp next_instruction

adc_hl_de:	and ah,1
		sahf
		adc bx,dx
                emul_p

ld_de_cnn:	inc si
                mov di,ax
                lodsb
                mov ah,[si]
                xchg di,ax
                mov dl,[di]
                mov dh,[di+1]
		jmp next_instruction

im_2:		mov byte [cs:ireg_im],2
		jmp next_instruction

ld_a_r: 	mov al,[cs:ireg_r]
		or al,al
		mov di,ax
		lahf
                and ah,11000000b
		and di,0100h
		or ax,di
		test byte [cs:ireg_iff2],1
		if ne,or ah,4
		add byte [cs:ireg_r],7
		jmp next_instruction

in_h_bc:	test cl,1
                jz port2544
		test cl,32
                if z,mov bh,[cs:kemstat]
		mov di,ax
		or bh,bh
		mov ax,di
		lahf
		and di,0100h
		and ah,0d4h
                or ax,di
                jmp next_instruction
port2544:       mov bh,255
		test ch,1
		if z,and bh,[cs:keygrp0]
		test ch,2
                if z,and bh,[cs:keygrp1]
		test ch,4
		if z,and bh,[cs:keygrp2]
		test ch,8
		if z,and bh,[cs:keygrp3]
		test ch,16
		if z,and bh,[cs:keygrp4]
		test ch,32
		if z,and bh,[cs:keygrp5]
		test ch,64
		if z,and bh,[cs:keygrp6]
		test ch,128
		if z,and bh,[cs:keygrp7]
		mov di,ax
		or bh,bh
		mov ax,di
		lahf
		and di,0100h
		and ah,0d4h
                or ax,di
                jmp next_instruction

out_bc_h:	pushf
		test cl,1
                if nz,poptonext
                mov es,ax
                in al,97
                and al,11111100b
                test bh,010h
                if nz,or al,2
		and al,[cs:soundstat]
                out 97,al
                mov ax,es
                popf
		jmp next_instruction

sbc_hl_hl:	or ah,2
		sahf
		sbb bx,bx
                emul_p

rrd:		mov di,cx
		mov es,ax
                mov cl,[bx]
		mov ch,al
		mov ah,cl
		and ah,00fh
		and al,0f0h
		or al,ah
                shr cx,4
                mov [bx],cl
		or al,al
		lahf
		mov cx,es
		and ch,1
		and ah,0c4h
		or ah,ch
		mov cx,di
		jmp next_instruction

in_l_bc:	test cl,1
                jz port2545
		test cl,32
		if z,mov bl,[cs:kemstat]
                mov di,ax
                or bl,bl
                lahf
                and di,0100h
                and ah,0d4h
                or ax,di
                jmp next_instruction
port2545:       mov bl,255
		test ch,1
		if z,and bl,[cs:keygrp0]
		test ch,2
		if z,and bl,[cs:keygrp1]
		test ch,4
		if z,and bl,[cs:keygrp2]
		test ch,8
		if z,and bl,[cs:keygrp3]
		test ch,16
		if z,and bl,[cs:keygrp4]
		test ch,32
		if z,and bl,[cs:keygrp5]
		test ch,64
		if z,and bl,[cs:keygrp6]
		test ch,128
		if z,and bl,[cs:keygrp7]
		mov di,ax
                or bl,bl
                lahf
                and di,0100h
                and ah,0d4h
                or ax,di
                jmp next_instruction

out_bc_l:	pushf
		test cl,1
                if nz,poptonext
                mov es,ax
                in al,97
                and al,11111100b
                test bl,010h
                if nz,or al,2
		and al,[cs:soundstat]
                out 97,al
                mov ax,es
                popf
		jmp next_instruction

adc_hl_hl:	and ah,1
		sahf
		adc bx,bx
                emul_p

rld:		mov di,cx
		mov es,ax
                mov cl,[bx]
		mov ch,al
		mov ah,cl
                shl ch,4
                rol cx,4
                mov [bx],cl
                and al,0f0h
                or al,ch
                mov cx,es
		and ch,1
		or al,al
		lahf
		and ah,0c4h
		or ah,ch
		mov cx,di
		jmp next_instruction

in_f_bc:	test cl,1
                jz port2546
		test cl,32
                if z,mov ah,[cs:kemstat]
                mov di,ax
		or ah,ah
                lahf
                and di,0100h
                and ah,0d4h
                or ax,di
                jmp next_instruction
port2546:       mov ah,255
		test ch,1
		if z,and ah,[cs:keygrp0]
		test ch,2
		if z,and ah,[cs:keygrp1]
		test ch,4
		if z,and ah,[cs:keygrp2]
		test ch,8
		if z,and ah,[cs:keygrp3]
		test ch,16
		if z,and ah,[cs:keygrp4]
		test ch,32
		if z,and ah,[cs:keygrp5]
		test ch,64
		if z,and ah,[cs:keygrp6]
		test ch,128
		if z,and ah,[cs:keygrp7]
		mov di,ax
		or ah,ah
                lahf
                and di,0100h
                and ah,0d4h
                or ax,di
                jmp next_instruction

sbc_hl_sp:	or ah,2
		sahf
		sbb bx,bp
                emul_p

ld_cnn_sp:	inc si
                mov di,ax
                lodsb
                mov ah,[si]
                xchg di,ax
                xchg bp,ax
                mov [di],al
                mov [di+1],ah
                xchg bp,ax
		jmp next_instruction

in_a_bc:	test cl,1
		if z,jmp port2547
		cmp byte [cs:mousestat],0
		jz nomouse7
		cmp cx,64479
		jz mousex7
		cmp cx,65503
		jz mousey7
		cmp cx,64223
		jz mouseb7
nomouse7:	test cl,32
                if z,mov al,[cs:kemstat]
		mov di,ax
                or al,al
                lahf
		and di,0100h
		and ah,11010100b
                or ax,di
                jmp next_instruction
mousex7:	push ax
		push bx
		push cx
		push dx
		mov ax,3
		mouse_int
		mov di,cx
		pop dx
		pop cx
		pop bx
		pop ax
		sub al,al
		shr di,4
		and di,000ffh
		or ax,di
		mov di,ax
                or al,al
                lahf
		and di,0100h
		and ah,11010100b
                or ax,di
                jmp next_instruction
mousey7:	push ax
		push bx
		push cx
		push dx
		mov ax,3
		mouse_int
		mov di,dx
		pop dx
		pop cx
		pop bx
		pop ax
		shr di,3
		and di,000ffh
		mov al,191
		sub ax,di
		mov di,ax
                or al,al
                lahf
		and di,0100h
		and ah,11010100b
                or ax,di
                jmp next_instruction
mouseb7:	push ax
		push bx
		push cx
		push dx
		mov ax,3
		mouse_int
		mov di,bx
		pop dx
		pop cx
		pop bx
		pop ax
		mov al,255
		and di,3
		xor ax,di
		mov di,ax
                or al,al
                lahf
		and di,0100h
		and ah,11010100b
                or ax,di
                jmp next_instruction
port2547:	mov al,255
		test ch,1
		if z,and al,[cs:keygrp0]
		test ch,2
		if z,and al,[cs:keygrp1]
		test ch,4
		if z,and al,[cs:keygrp2]
		test ch,8
		if z,and al,[cs:keygrp3]
		test ch,16
		if z,and al,[cs:keygrp4]
		test ch,32
		if z,and al,[cs:keygrp5]
		test ch,64
		if z,and al,[cs:keygrp6]
		test ch,128
		if z,and al,[cs:keygrp7]
		mov di,ax
                or al,al
                lahf
		and di,0100h
		and ah,11010100b
                or ax,di
                jmp next_instruction

out_bc_a:	pushf
		test cl,1
                if nz,poptonext
                mov es,ax
                mov ah,al
                in al,97
                and al,11111100b
                test ah,010h
                if nz,or al,2
		and al,[cs:soundstat]
                out 97,al
                mov ax,es
		popf
		jmp next_instruction

adc_hl_sp:	and ah,1
		sahf
		adc bx,bp
                emul_p

ld_sp_cnn:	inc si
                mov di,ax
                lodsb
                mov ah,[si]
                xchg di,ax
                mov bp,ax
                mov al,[di]
                mov ah,[di+1]
                xchg bp,ax
		jmp next_instruction

ldi:		mov es,ax
		mov di,dx
                mov al,[bx]
                mov [di],al
		inc dx
		inc bx
		dec cx
		mov ax,es
		and ah,0c1h
		jcxz ldi2
		or ah,4
	  ldi2: jmp next_instruction

cpi:		mov di,ax
                cmp al,[bx]
		lahf
		inc bx
		dec cx
		and di,0100h
		and ah,0d0h
		or ah,2
		or ax,di
		jcxz cpi2
		or ah,4
	  cpi2: jmp next_instruction

ini:		mov [bx],al
		inc bx
		sahf
		dec ch
		lahf
		jmp next_instruction

outi:		test cl,1
                jnz no_outi
		mov es,ax
                mov al,[bx]
                mov ah,al
                in al,97
                and al,11111100b
                test ah,010h
                if nz,or al,2
		and al,[cs:soundstat]
                out 97,al
                mov ax,es
  no_outi:	inc bx
		or  ah,00000010b
                dec ch
                emul_p_c

ldd:		mov es,ax
		mov di,dx
                mov al,[bx]
                mov [di],al
		dec dx
		dec bx
		dec cx
		mov ax,es
		and ah,0c1h
		jcxz ldd2
		or ah,4
	  ldd2: jmp next_instruction

cpd:		mov di,ax
                cmp al,[bx]
		lahf
		dec bx
		dec cx
		and di,0100h
		and ah,0d0h
		or ah,2
		or ax,di
		jcxz cpd2
		or ah,4
	  cpd2: jmp next_instruction

ind:		mov es,dx
		mov di,ax
		mov dl,cl
		xor dh,dh
                mov byte [bx],al
		mov ax,di
		dec bx
		sahf
		dec ch
		lahf
		mov dx,es
		jmp next_instruction

outd:		test cl,1
                jnz no_outd
		mov es,ax
                mov al,[bx]
                mov ah,al
                in al,97
                and al,11111100b
                test ah,010h
                if nz,or al,2
                and al,[cs:soundstat]
                out 97,al
                mov ax,es
     no_outd:	dec bx
		or  ah,00000010b
                dec ch
		emul_p_c

ldir:		mov es,ax
		mov di,dx
	 ldir2: mov al,[bx]
                mov [di],al
		inc di
		inc bx
		loop ldir2
		mov dx,di
		mov ax,es
		and ah,0c1h
		jmp next_instruction

cpir:		mov di,ax
	 cpir0: cmp al,[bx]
		lahf
		inc bx
		dec cx
		jcxz cpir2
		sahf
		jne cpir0
	 cpir2: and di,0100h
		and ah,0d0h
		or ah,2
		or ax,di
		jcxz cpir3
		or ah,4
	 cpir3: jmp next_instruction

inir:		mov es,dx
		mov di,ax
		mov dl,cl
		xor dh,dh
         inir2: mov [bx],al
		inc bx
		dec ch
		jne inir2
		mov ax,di
		mov dx,es
		or ah,042h
		jmp next_instruction

otir:		mov di,ax
	 otir2: test cl,1
		jnz otir3
                mov al,[bx]
                mov ah,al
                in al,97
                and al,11111100b
                test ah,010h
                if nz,or al,2
		and al,[cs:soundstat]
                out 97,al
	 otir3: inc bx
		dec ch
		jne otir2
		mov ax,di
		or ah,042h
		jmp next_instruction

lddr:		mov es,ax
		mov di,dx
	 lddr2: mov al,[bx]
                mov [di],al
		dec di
		dec bx
		loop lddr2
		mov dx,di
		mov ax,es
		and ah,0c1h
		jmp next_instruction

cpdr:		mov di,ax
	 cpdr0: cmp al,[bx]
		lahf
		dec bx
		dec cx
		jcxz cpdr2
		sahf
		jne cpdr0
	 cpdr2: and di,0100h
		and ah,0d0h
		or ah,2
		or ax,di
		jcxz cpdr3
		or ah,4
	 cpdr3: jmp next_instruction

indr:		mov es,dx
		mov di,ax
		mov dl,cl
		xor dh,dh
         indr2: mov [bx],al
		dec bx
		dec ch
		jne indr2
		mov ax,di
		mov dx,es
		or ah,042h
		jmp next_instruction

otdr:		mov di,ax
	 otdr2: test cl,1
		jnz otdr3
                mov al,[bx]
                mov ah,al
                in al,97
                and al,11111100b
                test ah,010h
                if nz,or al,2
		and al,[cs:soundstat]
                out 97,al
	 otdr3: dec bx
		dec ch
		jne otdr2
		mov ax,di
		or ah,042h
		jmp next_instruction

