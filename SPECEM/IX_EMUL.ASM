; This file contains the subroutines for emulating index register opcodes

ix_op:          inc si
                mov di,ax
                mov al,[si]
                sub ah,ah
                xchg di,ax
                add di,di
                jmp word [cs:di+ix_opcodes]

inc_ixh:        and ah,1
                inc byte [cs:reg_ixh]
                emul_p_c

dec_ixh:        or ah,2
                dec byte [cs:reg_ixh]
                emul_p_c

ld_ixh_n:       mov di,ax
                inc si
                mov al,[si]
                mov [cs:reg_ixh],al
                mov ax,di
                jmp next_instruction

inc_ixl:        and ah,1
                inc byte [cs:reg_ixl]
                emul_p_c

dec_ixl:        or ah,2
                dec byte [cs:reg_ixl]
                emul_p_c

ld_ixl_n:       mov di,ax
                inc si
                mov al,[si]
                mov [cs:reg_ixl],al
                mov ax,di
                jmp next_instruction

ld_b_ixh:       mov ch,[cs:reg_ixh]
                jmp next_instruction

ld_b_ixl:       mov ch,[cs:reg_ixl]
                jmp next_instruction

ld_c_ixh:       mov cl,[cs:reg_ixh]
                jmp next_instruction

ld_c_ixl:       mov cl,[cs:reg_ixl]
                jmp next_instruction

ld_d_ixh:       mov dh,[cs:reg_ixh]
                jmp next_instruction

ld_d_ixl:       mov dh,[cs:reg_ixl]
                jmp next_instruction

ld_e_ixh:       mov dl,[cs:reg_ixh]
                jmp next_instruction

ld_e_ixl:       mov dl,[cs:reg_ixl]
                jmp next_instruction

ld_ixh_b:       mov [cs:reg_ixh],ch
                jmp next_instruction

ld_ixh_c:       mov [cs:reg_ixh],cl
                jmp next_instruction

ld_ixh_d:       mov [cs:reg_ixh],dh
                jmp next_instruction

ld_ixh_e:       mov [cs:reg_ixh],dl
                jmp next_instruction

ld_ixh_ixh:     jmp next_instruction

ld_ixh_ixl:     xchg al,[cs:reg_ixh]
                mov [cs:reg_ixh],al
                xchg al,[cs:reg_ixh]
                jmp next_instruction

ld_ixh_a:       mov [cs:reg_ixh],al
                jmp next_instruction

ld_ixl_b:       mov [cs:reg_ixl],ch
                jmp next_instruction

ld_ixl_c:       mov [cs:reg_ixl],cl
                jmp next_instruction

ld_ixl_d:       mov [cs:reg_ixl],dh
                jmp next_instruction

ld_ixl_e:       mov [cs:reg_ixl],dl
                jmp next_instruction

ld_ixl_ixh:     xchg al,[cs:reg_ixh]
                mov [cs:reg_ixl],al
                xchg al,[cs:reg_ixh]
                jmp next_instruction

ld_ixl_ixl:     jmp next_instruction

ld_ixl_a:       mov [cs:reg_ixl],al
                jmp next_instruction

ld_a_ixh:       mov al,[cs:reg_ixh]
                jmp next_instruction

ld_a_ixl:       mov al,[cs:reg_ixl]
                jmp next_instruction

add_a_ixh:      and ah,11010101b
                add al,[cs:reg_ixh]
                emul_p

add_a_ixl:      and ah,11010101b
                add al,[cs:reg_ixl]
                emul_p

adc_a_ixh:      and ah,11010101b
                sahf
                adc al,[cs:reg_ixh]
                emul_p

adc_a_ixl:      and ah,11010101b
                sahf
                adc al,[cs:reg_ixl]
                emul_p

sub_a_ixh:      or ah,2
                sub al,[cs:reg_ixh]
                emul_p

sub_a_ixl:      or ah,2
                sub al,[cs:reg_ixl]
                emul_p

sbc_a_ixh:      or ah,2
                sahf
                sbb al,[cs:reg_ixh]
                emul_p

sbc_a_ixl:      or ah,2
                sahf
                sbb al,[cs:reg_ixl]
                emul_p

and_a_ixh:      and al,[cs:reg_ixh]
                lahf
                or ah,00010000b
                and ah,11010100b
                jmp next_instruction

and_a_ixl:      and al,[cs:reg_ixl]
                lahf
                or ah,00010000b
                and ah,11010100b
                jmp next_instruction

xor_a_ixh:      xor al,[cs:reg_ixh]
                lahf
                and ah,11000100b
                jmp next_instruction

xor_a_ixl:      xor al,[cs:reg_ixl]
                lahf
                and ah,11000100b
                jmp next_instruction

or_a_ixh:       or al,[cs:reg_ixh]
                lahf
                and ah,11000100b
                jmp next_instruction

or_a_ixl:       or al,[cs:reg_ixl]
                lahf
                and ah,11000100b
                jmp next_instruction

cp_a_ixh:       or ah,2
                cmp al,[cs:reg_ixh]
                emul_p

cp_a_ixl:       or ah,2
                cmp al,[cs:reg_ixl]
                emul_p

ex_de_ix:       xchg [cs:reg_ix],dx
                jmp next_instruction

add_ix_bc:      add [cs:reg_ix],cx
                mov di,ax                ; Emulates carry and half-carry
                lahf
                and ah,00010001b
                and di,1110010000000000b
                or ax,di
                jmp next_instruction

add_ix_de:      add [cs:reg_ix],dx
                mov di,ax                ; Emulates carry and half-carry
                lahf
                and ah,00010001b
                and di,1110010000000000b
                or ax,di
                jmp next_instruction

ld_ix_nn:       inc si
                mov di,ax
                lodsb
                mov ah,[si]
                xchg di,ax
                mov [cs:reg_ix],di
                jmp next_instruction

ld_cnn_ix:      inc si
                mov es,ax
                lodsb
                mov ah,[si]
                mov di,ax
                mov ax,[cs:reg_ix]
                mov [di],al
                mov [di+1],ah
                mov ax,es
                jmp next_instruction

inc_ix:         inc word [cs:reg_ix]
                jmp next_instruction

add_ix_ix:      mov di,[cs:reg_ix]
                add [cs:reg_ix],di
                mov di,ax                ; Emulates carry and half-carry
                lahf
                and ah,00010001b
                and di,1110010000000000b
                or ax,di
                jmp next_instruction

ld_ix_cnn:      inc si
                mov es,ax
                lodsb
                mov ah,[si]
                mov di,ax
                mov al,[di]
                mov ah,[di+1]
                mov [cs:reg_ix],ax
                mov ax,es
                jmp next_instruction

dec_ix:         dec word [cs:reg_ix]
                jmp next_instruction

inc_cix:        mov di,ax
                inc si
                mov al,byte [si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                and ah,1
                inc byte [di]
                emul_p_c

dec_cix:        mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                or ah,2
                dec byte [di]
                emul_p_c

ld_cix_n:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                inc si
                mov es,ax
                lodsb
                mov [di],al
                mov ax,es
                jmp preset_pc

add_ix_sp:      add [cs:reg_ix],bp
                mov di,ax                ; Emulates carry and half-carry
                lahf
                and ah,00010001b
                and di,1110010000000000b
                or ax,di
                jmp next_instruction

ld_b_cix:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                mov ch,[di]
                jmp next_instruction

ld_c_cix:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                mov cl,[di]
                jmp next_instruction

ld_d_cix:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                mov dh,[di]
                jmp next_instruction

ld_e_cix:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                mov dl,[di]
                jmp next_instruction

ld_h_cix:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                mov bh,[di]
                jmp next_instruction

ld_l_cix:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                mov bl,[di]
                jmp next_instruction

ld_cix_b:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                mov [di],ch
                jmp next_instruction

ld_cix_c:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                mov [di],cl
                jmp next_instruction

ld_cix_d:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                mov [di],dh
                jmp next_instruction

ld_cix_e:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                mov [di],dl
                jmp next_instruction

ld_cix_h:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                mov [di],bh
                jmp next_instruction

ld_cix_l:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                mov [di],bl
                jmp next_instruction

ld_cix_a:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                mov [di],al
                jmp next_instruction

ld_a_cix:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                mov al,[di]
                jmp next_instruction

add_a_cix:      xor ah,ah
                mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                add al,[di]
                emul_p

adc_a_cix:      and ah,1
                mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                sahf
                adc al,[di]
                emul_p

sub_a_cix:      or ah,2
                mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                sub al,[di]
                emul_p

sbc_a_cix:      or ah,2
                mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                sahf
                sbb al,[di]
                emul_p

and_a_cix:      mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                and al,[di]
                lahf
                or  ah,00010000b
                and ah,11010100b
                jmp next_instruction

xor_a_cix:      mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                xor al,[di]
                lahf
                and ah,11000100b
                jmp next_instruction

or_a_cix:       mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                or  al,[di]
                lahf
                and ah,11000100b
                jmp next_instruction

cp_a_cix:       or ah,2
                mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                cmp al,[di]
                emul_p

pop_ix:         mov es,ax
                mov al,[ds:bp]
                mov ah,[ds:bp+1]
                mov [cs:reg_ix],ax
                mov ax,es
                inc bp
                inc bp
                jmp next_instruction

ex_csp_ix:      mov es,ax
                mov al,[ds:bp]
                mov ah,[ds:bp+1]
                xchg [cs:reg_ix],ax
                mov [ds:bp],al
                mov [ds:bp+1],ah
                mov ax,es
                jmp next_instruction

push_ix:        mov es,ax
                mov ax,[cs:reg_ix]
                dec bp
                dec bp
                mov [ds:bp],al
                mov [ds:bp+1],ah
                mov ax,es
                jmp next_instruction

jp_ix:          mov si,[cs:reg_ix]
                jmp preset_pc

ld_sp_ix:       mov bp,[cs:reg_ix]
                jmp next_instruction


cbix:           mov di,ax
                inc si
                mov al,[si]
                cbw
                add ax,[cs:reg_ix]
                xchg ax,di
                mov es,di
                inc si
                mov di,ax
                mov al,[si]
                xor ah,ah
                xchg di,ax
                add di,di
                sahf
                jmp word [cs:di+cbix_ops]

cbix_done:      lahf
                or byte [di],0
                emul_h

ixndoc:         jmp ndoc

rlc_cix:        mov di,es
                rol byte [di],1
                jmp cbix_done

rrc_cix:        mov di,es
                ror byte [di],1
                jmp cbix_done

rl_cix:         mov di,es
                rcl byte [di],1
                jmp cbix_done

rr_cix:         mov di,es
                rcr byte [di],1
                jmp cbix_done

sla_cix:        mov di,es
                shl byte [di],1
                jmp cbix_done

sra_cix:        mov di,es
                sar byte [di],1
                jmp cbix_done

sll_cix:        mov di,es
                shl byte [di],1
                or byte [di],1
                jmp cbix_done

srl_cix:        mov di,es
                shr byte [di],1
                jmp cbix_done

bit_0_cix:      mov di,es
                test byte [di],1
                emul_z

bit_1_cix:      mov di,es
                test byte [di],2
                emul_z

bit_2_cix:      mov di,es
                test byte [di],4
                emul_z

bit_3_cix:      mov di,es
                test byte [di],8
                emul_z

bit_4_cix:      mov di,es
                test byte [di],16
                emul_z

bit_5_cix:      mov di,es
                test byte [di],32
                emul_z

bit_6_cix:      mov di,es
                test byte [di],64
                emul_z

bit_7_cix:      mov di,es
                test byte [di],128
                emul_z

res_0_cix:      mov di,es
                and byte [di],0feh
                jmp next_instruction

res_1_cix:      mov di,es
                and byte [di],0fdh
                jmp next_instruction

res_2_cix:      mov di,es
                and byte [di],0fbh
                jmp next_instruction

res_3_cix:      mov di,es
                and byte [di],0f7h
                jmp next_instruction

res_4_cix:      mov di,es
                and byte [di],0efh
                jmp next_instruction

res_5_cix:      mov di,es
                and byte [di],0dfh
                jmp next_instruction

res_6_cix:      mov di,es
                and byte [di],0bfh
                jmp next_instruction

res_7_cix:      mov di,es
                and byte [di],07fh
                jmp next_instruction

set_0_cix:      mov di,es
                or byte [di],1
                jmp next_instruction

set_1_cix:      mov di,es
                or byte [di],2
                jmp next_instruction

set_2_cix:      mov di,es
                or byte [di],4
                jmp next_instruction

set_3_cix:      mov di,es
                or byte [di],8
                jmp next_instruction

set_4_cix:      mov di,es
                or byte [di],16
                jmp next_instruction

set_5_cix:      mov di,es
                or byte [di],32
                jmp next_instruction

set_6_cix:      mov di,es
                or byte [di],64
                jmp next_instruction

set_7_cix:      mov di,es
                or byte [di],128
                jmp next_instruction

