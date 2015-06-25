; This file contains the subroutines for emulating index register opcodes

iy_op:          inc si
                mov di,ax
                mov al,[si]
                sub ah,ah
                xchg di,ax
                add di,di
                jmp word [cs:di+iy_opcodes]

inc_iyh:        and ah,1
                inc byte [cs:reg_iyh]
                emul_p_c

dec_iyh:        or ah,2
                dec byte [cs:reg_iyh]
                emul_p_c

ld_iyh_n:       mov di,ax
                inc si
                mov al,[si]
                mov [cs:reg_iyh],al
                mov ax,di
                jmp next_instruction

inc_iyl:        and ah,1
                inc byte [cs:reg_iyl]
                emul_p_c

dec_iyl:        or ah,2
                dec byte [cs:reg_iyl]
                emul_p_c

ld_iyl_n:       mov di,ax
                inc si
                mov al,[si]
                mov [cs:reg_iyl],al
                mov ax,di
                jmp next_instruction

ld_b_iyh:       mov ch,[cs:reg_iyh]
                jmp next_instruction

ld_b_iyl:       mov ch,[cs:reg_iyl]
                jmp next_instruction

ld_c_iyh:       mov cl,[cs:reg_iyh]
                jmp next_instruction

ld_c_iyl:       mov cl,[cs:reg_iyl]
                jmp next_instruction

ld_d_iyh:       mov dh,[cs:reg_iyh]
                jmp next_instruction

ld_d_iyl:       mov dh,[cs:reg_iyl]
                jmp next_instruction

ld_e_iyh:       mov dl,[cs:reg_iyh]
                jmp next_instruction

ld_e_iyl:       mov dl,[cs:reg_iyl]
                jmp next_instruction

ld_iyh_b:       mov [cs:reg_iyh],ch
                jmp next_instruction

ld_iyh_c:       mov [cs:reg_iyh],cl
                jmp next_instruction

ld_iyh_d:       mov [cs:reg_iyh],dh
                jmp next_instruction

ld_iyh_e:       mov [cs:reg_iyh],dl
                jmp next_instruction

ld_iyh_iyh:     jmp next_instruction

ld_iyh_iyl:     xchg al,[cs:reg_iyh]
                mov [cs:reg_iyh],al
                xchg al,[cs:reg_iyh]
                jmp next_instruction

ld_iyh_a:       mov [cs:reg_iyh],al
                jmp next_instruction

ld_iyl_b:       mov [cs:reg_iyl],ch
                jmp next_instruction

ld_iyl_c:       mov [cs:reg_iyl],cl
                jmp next_instruction

ld_iyl_d:       mov [cs:reg_iyl],dh
                jmp next_instruction

ld_iyl_e:       mov [cs:reg_iyl],dl
                jmp next_instruction

ld_iyl_iyh:     xchg al,[cs:reg_iyh]
                mov [cs:reg_iyl],al
                xchg al,[cs:reg_iyh]
                jmp next_instruction

ld_iyl_iyl:     jmp next_instruction

ld_iyl_a:       mov [cs:reg_iyl],al
                jmp next_instruction

ld_a_iyh:       mov al,[cs:reg_iyh]
                jmp next_instruction

ld_a_iyl:       mov al,[cs:reg_iyl]
                jmp next_instruction

add_a_iyh:      and ah,11010101b
                add al,[cs:reg_iyh]
                emul_p

add_a_iyl:      and ah,11010101b
                add al,[cs:reg_iyl]
                emul_p

adc_a_iyh:      and ah,11010101b
                sahf
                adc al,[cs:reg_iyh]
                emul_p

adc_a_iyl:      and ah,11010101b
                sahf
                adc al,[cs:reg_iyl]
                emul_p

sub_a_iyh:      or ah,2
                sub al,[cs:reg_iyh]
                emul_p

sub_a_iyl:      or ah,2
                sub al,[cs:reg_iyl]
                emul_p

sbc_a_iyh:      or ah,2
                sahf
                sbb al,[cs:reg_iyh]
                emul_p

sbc_a_iyl:      or ah,2
                sahf
                sbb al,[cs:reg_iyl]
                emul_p

and_a_iyh:      and al,[cs:reg_iyh]
                lahf
                or ah,00010000b
                and ah,11010100b
                jmp next_instruction

and_a_iyl:      and al,[cs:reg_iyl]
                lahf
                or ah,00010000b
                and ah,11010100b
                jmp next_instruction

xor_a_iyh:      xor al,[cs:reg_iyh]
                lahf
                and ah,11000100b
                jmp next_instruction

xor_a_iyl:      xor al,[cs:reg_iyl]
                lahf
                and ah,11000100b
                jmp next_instruction

or_a_iyh:       or al,[cs:reg_iyh]
                lahf
                and ah,11000100b
                jmp next_instruction

or_a_iyl:       or al,[cs:reg_iyl]
                lahf
                and ah,11000100b
                jmp next_instruction

cp_a_iyh:       or ah,2
                cmp al,[cs:reg_iyh]
                emul_p

cp_a_iyl:       or ah,2
                cmp al,[cs:reg_iyl]
                emul_p

ex_de_iy:       xchg [cs:reg_iy],dx
                jmp next_instruction

add_iy_bc:      add [cs:reg_iy],cx
                mov di,ax                ; Emulates carry and half-carry
                lahf
                and ah,00010001b
                and di,1110010000000000b
                or ax,di
                jmp next_instruction

add_iy_de:      add [cs:reg_iy],dx
                mov di,ax                ; Emulates carry and half-carry
                lahf
                and ah,00010001b
                and di,1110010000000000b
                or ax,di
                jmp next_instruction

ld_iy_nn:       inc si
                mov di,ax
                lodsb
                mov ah,[si]
                xchg di,ax
                mov [cs:reg_iy],di
                jmp next_instruction

ld_cnn_iy:      inc si
                mov es,ax
                lodsb
                mov ah,[si]
                mov di,ax
                mov ax,[cs:reg_iy]
                mov [di],al
                mov [di+1],ah
                mov ax,es
                jmp next_instruction

inc_iy:         inc word [cs:reg_iy]
                jmp next_instruction

add_iy_iy:      mov di,[cs:reg_iy]
                add [cs:reg_iy],di
                mov di,ax                ; Emulates carry and half-carry
                lahf
                and ah,00010001b
                and di,1110010000000000b
                or ax,di
                jmp next_instruction

ld_iy_cnn:      inc si
                mov es,ax
                lodsb
                mov ah,[si]
                mov di,ax
                mov al,[di]
                mov ah,[di+1]
                mov [cs:reg_iy],ax
                mov ax,es
                jmp next_instruction

dec_iy:         dec word [cs:reg_iy]
                jmp next_instruction

inc_ciy:        mov di,ax
                inc si
                mov al,byte [si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                and ah,1
                inc byte [di]
                emul_p_c

dec_ciy:        mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                or ah,2
                dec byte [di]
                emul_p_c

ld_ciy_n:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                inc si
                mov es,ax
                lodsb
                mov [di],al
                mov ax,es
                jmp preset_pc

add_iy_sp:      add [cs:reg_iy],bp
                mov di,ax                ; Emulates carry and half-carry
                lahf
                and ah,00010001b
                and di,1110010000000000b
                or ax,di
                jmp next_instruction

ld_b_ciy:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                mov ch,[di]
                jmp next_instruction

ld_c_ciy:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                mov cl,[di]
                jmp next_instruction

ld_d_ciy:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                mov dh,[di]
                jmp next_instruction

ld_e_ciy:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                mov dl,[di]
                jmp next_instruction

ld_h_ciy:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                mov bh,[di]
                jmp next_instruction

ld_l_ciy:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                mov bl,[di]
                jmp next_instruction

ld_ciy_b:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                mov [di],ch
                jmp next_instruction

ld_ciy_c:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                mov [di],cl
                jmp next_instruction

ld_ciy_d:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                mov [di],dh
                jmp next_instruction

ld_ciy_e:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                mov [di],dl
                jmp next_instruction

ld_ciy_h:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                mov [di],bh
                jmp next_instruction

ld_ciy_l:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                mov [di],bl
                jmp next_instruction

ld_ciy_a:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                mov [di],al
                jmp next_instruction

ld_a_ciy:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                mov al,[di]
                jmp next_instruction

add_a_ciy:      xor ah,ah
                mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                add al,[di]
                emul_p

adc_a_ciy:      and ah,1
                mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                sahf
                adc al,[di]
                emul_p

sub_a_ciy:      or ah,2
                mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                sub al,[di]
                emul_p

sbc_a_ciy:      or ah,2
                mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                sahf
                sbb al,[di]
                emul_p

and_a_ciy:      mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                and al,[di]
                lahf
                or  ah,00010000b
                and ah,11010100b
                jmp next_instruction

xor_a_ciy:      mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                xor al,[di]
                lahf
                and ah,11000100b
                jmp next_instruction

or_a_ciy:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                or  al,[di]
                lahf
                and ah,11000100b
                jmp next_instruction

cp_a_ciy:       or ah,2
                mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                cmp al,[di]
                emul_p

pop_iy:         mov es,ax
                mov al,[ds:bp]
                mov ah,[ds:bp+1]
                mov [cs:reg_iy],ax
                mov ax,es
                inc bp
                inc bp
                jmp next_instruction

ex_csp_iy:      mov es,ax
                mov al,[ds:bp]
                mov ah,[ds:bp+1]
                xchg [cs:reg_iy],ax
                mov [ds:bp],al
                mov [ds:bp+1],ah
                mov ax,es
                jmp next_instruction

push_iy:        mov es,ax
                mov ax,[cs:reg_iy]
                dec bp
                dec bp
                mov [ds:bp],al
                mov [ds:bp+1],ah
                mov ax,es
                jmp next_instruction

jp_iy:          mov si,[cs:reg_iy]
                jmp preset_pc

ld_sp_iy:       mov bp,[cs:reg_iy]
                jmp next_instruction


cbiy:           mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_iy]
                xchg ax,di
                mov es,di
                inc si
                mov di,ax
                mov al,[si]
                xor ah,ah
                xchg di,ax
                add di,di
                sahf
                jmp word [cs:di+cbiy_ops]

cbiy_done:      lahf
                or byte [di],0
                emul_h

iyndoc:         jmp ndoc

rlc_ciy:        mov di,es
                rol byte [di],1
                jmp cbiy_done

rrc_ciy:        mov di,es
                ror byte [di],1
                jmp cbiy_done

rl_ciy:         mov di,es
                rcl byte [di],1
                jmp cbiy_done

rr_ciy:         mov di,es
                rcr byte [di],1
                jmp cbiy_done

sla_ciy:        mov di,es
                shl byte [di],1
                jmp cbiy_done

sra_ciy:        mov di,es
                sar byte [di],1
                jmp cbiy_done

sll_ciy:        mov di,es
                shl byte [di],1
                or byte [di],1
                jmp cbiy_done

srl_ciy:        mov di,es
                shr byte [di],1
                jmp cbiy_done

bit_0_ciy:      mov di,es
                test byte [di],1
                emul_z

bit_1_ciy:      mov di,es
                test byte [di],2
                emul_z

bit_2_ciy:      mov di,es
                test byte [di],4
                emul_z

bit_3_ciy:      mov di,es
                test byte [di],8
                emul_z

bit_4_ciy:      mov di,es
                test byte [di],16
                emul_z

bit_5_ciy:      mov di,es
                test byte [di],32
                emul_z

bit_6_ciy:      mov di,es
                test byte [di],64
                emul_z

bit_7_ciy:      mov di,es
                test byte [di],128
                emul_z

res_0_ciy:      mov di,es
                and byte [di],0feh
                jmp next_instruction

res_1_ciy:      mov di,es
                and byte [di],0fdh
                jmp next_instruction

res_2_ciy:      mov di,es
                and byte [di],0fbh
                jmp next_instruction

res_3_ciy:      mov di,es
                and byte [di],0f7h
                jmp next_instruction

res_4_ciy:      mov di,es
                and byte [di],0efh
                jmp next_instruction

res_5_ciy:      mov di,es
                and byte [di],0dfh
                jmp next_instruction

res_6_ciy:      mov di,es
                and byte [di],0bfh
                jmp next_instruction

res_7_ciy:      mov di,es
                and byte [di],07fh
                jmp next_instruction

set_0_ciy:      mov di,es
                or byte [di],1
                jmp next_instruction

set_1_ciy:      mov di,es
                or byte [di],2
                jmp next_instruction

set_2_ciy:      mov di,es
                or byte [di],4
                jmp next_instruction

set_3_ciy:      mov di,es
                or byte [di],8
                jmp next_instruction

set_4_ciy:      mov di,es
                or byte [di],16
                jmp next_instruction

set_5_ciy:      mov di,es
                or byte [di],32
                jmp next_instruction

set_6_ciy:      mov di,es
                or byte [di],64
                jmp next_instruction

set_7_ciy:      mov di,es
                or byte [di],128
                jmp next_instruction

