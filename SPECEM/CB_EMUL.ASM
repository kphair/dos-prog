; This file contains the subroutines for emulating the CB-prefixed opcodes

cb_op:          inc si
		mov di,ax
		mov al,[si]
		sub ah,ah
	        xchg di,ax
                add di,di
		sahf
                jmp word [cs:di+cb_opcodes]

rlc_b:		rol ch,1
		lahf
		or ch,ch
                emul_h

rlc_c:          rol cl,1
		lahf
		or cl,cl
                emul_h

rlc_d:          rol dh,1
		lahf
		or dh,dh
                emul_h

rlc_e:          rol dl,1
		lahf
		or dl,dl
                emul_h

rlc_h:          rol bh,1
		lahf
		or bh,bh
                emul_h

rlc_l:          rol bl,1
		lahf
		or bl,bl
                emul_h

rlc_chl:        rol byte [bx],1
		lahf
                emul_h_z

rlc_a:          rol al,1
		lahf
		or al,al
                emul_h

rrc_b:		ror ch,1
		lahf
		or ch,ch
                emul_h

rrc_c:          ror cl,1
		lahf
		or cl,cl
                emul_h

rrc_d:          ror dh,1
		lahf
		or dh,dh
                emul_h

rrc_e:          ror dl,1
		lahf
		or dl,dl
                emul_h

rrc_h:          ror bh,1
		lahf
		or bh,bh
                emul_h

rrc_l:          ror bl,1
		lahf
		or bl,bl
                emul_h

rrc_chl:        ror byte [bx],1
		lahf
                emul_h_z

rrc_a:          ror al,1
		lahf
		or al,al
                emul_h

rl_b:           rcl ch,1
		lahf
		or ch,ch
                emul_h

rl_c:           rcl cl,1
		lahf
		or cl,cl
                emul_h

rl_d:           rcl dh,1
		lahf
		or dh,dh
                emul_h

rl_e:		rcl dl,1
		lahf
		or dl,dl
                emul_h

rl_h:           rcl bh,1
		lahf
		or bh,bh
                emul_h

rl_l:           rcl bl,1
		lahf
		or bl,bl
                emul_h

rl_chl:         rcl byte [bx],1
		lahf
                emul_h_z

rl_a:           rcl al,1
		lahf
		or al,al
                emul_h

rr_b:           rcr ch,1
		lahf
		or ch,ch
                emul_h

rr_c:           rcr cl,1
		lahf
		or cl,cl
                emul_h

rr_d:           rcr dh,1
		lahf
		or dh,dh
                emul_h

rr_e:           rcr dl,1
		lahf
		or dl,dl
                emul_h

rr_h:           rcr bh,1
		lahf
		or bh,bh
                emul_h

rr_l:           rcr bl,1
		lahf
		or bl,bl
                emul_h

rr_chl:         rcr byte [bx],1
		lahf
                emul_h_z

rr_a:           rcr al,1
		lahf
		or al,al
                emul_h

sla_b:          shl ch,1
		lahf
		or ch,ch
                emul_h

sla_c:          shl cl,1
		lahf
		or cl,cl
                emul_h

sla_d:          shl dh,1
		lahf
		or dh,dh
                emul_h

sla_e:          shl dl,1
		lahf
		or dl,dl
                emul_h

sla_h:          shl bh,1
		lahf
		or bh,bh
                emul_h

sla_l:          shl bl,1
		lahf
		or bl,bl
                emul_h

sla_chl:        shl byte [bx],1
		lahf
                emul_h_z

sla_a:          shl al,1
		lahf
		or al,al
                emul_h

sra_b:          sar ch,1
		lahf
		or ch,ch
                emul_h

sra_c:          sar cl,1
		lahf
		or cl,cl
                emul_h

sra_d:          sar dh,1
		lahf
		or dh,dh
                emul_h

sra_e:          sar dl,1
		lahf
		or dl,dl
                emul_h

sra_h:          sar bh,1
		lahf
		or bh,bh
                emul_h

sra_l:          sar bl,1
		lahf
		or bl,bl
                emul_h

sra_chl:        sar byte [bx],1
		lahf
                emul_h_z

sra_a:          sar al,1
		lahf
		or al,al
                emul_h

sll_b:          shl ch,1
		lahf
                or ch,1
                emul_h

sll_c:          shl cl,1
                lahf
                or cl,1
                emul_h

sll_d:          shl dh,1
		lahf
                or dh,1
                emul_h

sll_e:          shl dl,1
		lahf
                or dl,1
                emul_h

sll_h:          shl bh,1
		lahf
                or bh,1
                emul_h

sll_l:          shl bl,1
		lahf
                or bl,1
                emul_h

sll_chl:        shl byte [bx],1
                lahf
                or byte [bx],1
                emul_h_z

sll_a:          shl al,1
		lahf
		or al,1
                emul_h

srl_b:          shr ch,1
		lahf
		or ch,ch
                emul_h

srl_c:          shr cl,1
		lahf
		or cl,cl
                emul_h

srl_d:          shr dh,1
		lahf
		or dh,dh
                emul_h

srl_e:          shr dl,1
		lahf
		or dl,dl
                emul_h

srl_h:          shr bh,1
		lahf
		or bh,bh
                emul_h

srl_l:          shr bl,1
		lahf
		or bl,bl
                emul_h

srl_chl:        shr byte [bx],1
		lahf
                emul_h_z

srl_a:          shr al,1
		lahf
		or al,al
                emul_h

bit_0_b:        test ch,1
                emul_z
bit_0_c:	test cl,1
                emul_z
bit_0_d:	test dh,1
                emul_z
bit_0_e:	test dl,1
                emul_z
bit_0_h:	test bh,1
                emul_z
bit_0_l:	test bl,1
                emul_z
bit_0_chl:      test byte [bx],1
                emul_z
bit_0_a:	test al,1
                emul_z

bit_1_b:        test ch,2
                emul_z
bit_1_c:	test cl,2
                emul_z
bit_1_d:	test dh,2
                emul_z
bit_1_e:	test dl,2
                emul_z
bit_1_h:	test bh,2
                emul_z
bit_1_l:	test bl,2
                emul_z
bit_1_chl:	test byte [bx],2
                emul_z
bit_1_a:	test al,2
                emul_z

bit_2_b:        test ch,4
                emul_z
bit_2_c:	test cl,4
                emul_z
bit_2_d:	test dh,4
                emul_z
bit_2_e:	test dl,4
                emul_z
bit_2_h:	test bh,4
                emul_z
bit_2_l:	test bl,4
                emul_z
bit_2_chl:	test byte [bx],4
                emul_z
bit_2_a:	test al,4
                emul_z

bit_3_b:        test ch,8
                emul_z
bit_3_c:	test cl,8
                emul_z
bit_3_d:	test dh,8
                emul_z
bit_3_e:	test dl,8
                emul_z
bit_3_h:	test bh,8
                emul_z
bit_3_l:	test bl,8
                emul_z
bit_3_chl:	test byte [bx],8
                emul_z
bit_3_a:	test al,8
                emul_z

bit_4_b:        test ch,16
                emul_z
bit_4_c:        test cl,16
                emul_z
bit_4_d:        test dh,16
                emul_z
bit_4_e:        test dl,16
                emul_z
bit_4_h:        test bh,16
                emul_z
bit_4_l:        test bl,16
                emul_z
bit_4_chl:      test byte [bx],16
                emul_z
bit_4_a:        test al,16
                emul_z

bit_5_b:        test ch,32
                emul_z
bit_5_c:        test cl,32
                emul_z
bit_5_d:        test dh,32
                emul_z
bit_5_e:        test dl,32
                emul_z
bit_5_h:        test bh,32
                emul_z
bit_5_l:        test bl,32
                emul_z
bit_5_chl:      test byte [bx],32
                emul_z
bit_5_a:        test al,32
                emul_z

bit_6_b:        test ch,64
                emul_z
bit_6_c:        test cl,64
                emul_z
bit_6_d:        test dh,64
                emul_z
bit_6_e:        test dl,64
                emul_z
bit_6_h:        test bh,64
                emul_z
bit_6_l:        test bl,64
                emul_z
bit_6_chl:      test byte [bx],64
                emul_z
bit_6_a:        test al,64
                emul_z

bit_7_b:        test ch,128
                emul_z
bit_7_c:        test cl,128
                emul_z
bit_7_d:        test dh,128
                emul_z
bit_7_e:        test dl,128
                emul_z
bit_7_h:        test bh,128
                emul_z
bit_7_l:        test bl,128
                emul_z
bit_7_chl:      test byte [bx],128
                emul_z
bit_7_a:        test al,128
                emul_z

res_0_b:        and ch,0feh
		jmp next_instruction
res_0_c:	and cl,0feh
		jmp next_instruction
res_0_d:	and dh,0feh
		jmp next_instruction
res_0_e:	and dl,0feh
		jmp next_instruction
res_0_h:	and bh,0feh
		jmp next_instruction
res_0_l:	and bl,0feh
		jmp next_instruction
res_0_chl:      and byte [bx],0feh
		jmp next_instruction
res_0_a:	and al,0feh
		jmp next_instruction

res_1_b:        and ch,0fdh
		jmp next_instruction
res_1_c:	and cl,0fdh
		jmp next_instruction
res_1_d:	and dh,0fdh
		jmp next_instruction
res_1_e:	and dl,0fdh
		jmp next_instruction
res_1_h:	and bh,0fdh
		jmp next_instruction
res_1_l:	and bl,0fdh
		jmp next_instruction
res_1_chl:      and byte [bx],0fdh
		jmp next_instruction
res_1_a:	and al,0fdh
		jmp next_instruction

res_2_b:        and ch,0fbh
		jmp next_instruction
res_2_c:	and cl,0fbh
		jmp next_instruction
res_2_d:	and dh,0fbh
		jmp next_instruction
res_2_e:	and dl,0fbh
		jmp next_instruction
res_2_h:	and bh,0fbh
		jmp next_instruction
res_2_l:	and bl,0fbh
		jmp next_instruction
res_2_chl:      and byte [bx],0fbh
		jmp next_instruction
res_2_a:	and al,0fbh
		jmp next_instruction

res_3_b:        and ch,0f7h
		jmp next_instruction
res_3_c:	and cl,0f7h
		jmp next_instruction
res_3_d:	and dh,0f7h
		jmp next_instruction
res_3_e:	and dl,0f7h
		jmp next_instruction
res_3_h:	and bh,0f7h
		jmp next_instruction
res_3_l:	and bl,0f7h
		jmp next_instruction
res_3_chl:      and byte [bx],0f7h
		jmp next_instruction
res_3_a:	and al,0f7h
		jmp next_instruction

res_4_b:        and ch,0efh
		jmp next_instruction
res_4_c:	and cl,0efh
		jmp next_instruction
res_4_d:	and dh,0efh
		jmp next_instruction
res_4_e:	and dl,0efh
		jmp next_instruction
res_4_h:	and bh,0efh
		jmp next_instruction
res_4_l:	and bl,0efh
		jmp next_instruction
res_4_chl:      and byte [bx],0efh
		jmp next_instruction
res_4_a:	and al,0efh
		jmp next_instruction

res_5_b:        and ch,0dfh
		jmp next_instruction
res_5_c:	and cl,0dfh
		jmp next_instruction
res_5_d:	and dh,0dfh
		jmp next_instruction
res_5_e:	and dl,0dfh
		jmp next_instruction
res_5_h:	and bh,0dfh
		jmp next_instruction
res_5_l:	and bl,0dfh
		jmp next_instruction
res_5_chl:      and byte [bx],0dfh
		jmp next_instruction
res_5_a:	and al,0dfh
		jmp next_instruction

res_6_b:        and ch,0bfh
		jmp next_instruction
res_6_c:	and cl,0bfh
		jmp next_instruction
res_6_d:	and dh,0bfh
		jmp next_instruction
res_6_e:	and dl,0bfh
		jmp next_instruction
res_6_h:	and bh,0bfh
		jmp next_instruction
res_6_l:	and bl,0bfh
		jmp next_instruction
res_6_chl:      and byte [bx],0bfh
		jmp next_instruction
res_6_a:	and al,0bfh
		jmp next_instruction

res_7_b:        and ch,07fh
		jmp next_instruction
res_7_c:	and cl,07fh
		jmp next_instruction
res_7_d:	and dh,07fh
		jmp next_instruction
res_7_e:	and dl,07fh
		jmp next_instruction
res_7_h:	and bh,07fh
		jmp next_instruction
res_7_l:	and bl,07fh
		jmp next_instruction
res_7_chl:      and byte [bx],07fh
		jmp next_instruction
res_7_a:	and al,07fh
		jmp next_instruction

set_0_b:        or ch,1
		jmp next_instruction
set_0_c:	or cl,1
		jmp next_instruction
set_0_d:	or dh,1
		jmp next_instruction
set_0_e:	or dl,1
		jmp next_instruction
set_0_h:	or bh,1
		jmp next_instruction
set_0_l:	or bl,1
		jmp next_instruction
set_0_chl:      or byte [bx],1
		jmp next_instruction
set_0_a:	or al,1
		jmp next_instruction

set_1_b:        or ch,2
		jmp next_instruction
set_1_c:	or cl,2
		jmp next_instruction
set_1_d:	or dh,2
		jmp next_instruction
set_1_e:	or dl,2
		jmp next_instruction
set_1_h:	or bh,2
		jmp next_instruction
set_1_l:	or bl,2
		jmp next_instruction
set_1_chl:      or byte [bx],2
		jmp next_instruction
set_1_a:	or al,2
		jmp next_instruction

set_2_b:        or ch,4
		jmp next_instruction
set_2_c:	or cl,4
		jmp next_instruction
set_2_d:	or dh,4
		jmp next_instruction
set_2_e:	or dl,4
		jmp next_instruction
set_2_h:	or bh,4
		jmp next_instruction
set_2_l:	or bl,4
		jmp next_instruction
set_2_chl:      or byte [bx],4
		jmp next_instruction
set_2_a:	or al,4
		jmp next_instruction

set_3_b:        or ch,8
		jmp next_instruction
set_3_c:	or cl,8
		jmp next_instruction
set_3_d:	or dh,8
		jmp next_instruction
set_3_e:	or dl,8
		jmp next_instruction
set_3_h:	or bh,8
		jmp next_instruction
set_3_l:	or bl,8
		jmp next_instruction
set_3_chl:      or byte [bx],8
		jmp next_instruction
set_3_a:	or al,8
		jmp next_instruction

set_4_b:        or ch,16
		jmp next_instruction
set_4_c:        or cl,16
		jmp next_instruction
set_4_d:        or dh,16
		jmp next_instruction
set_4_e:        or dl,16
		jmp next_instruction
set_4_h:        or bh,16
		jmp next_instruction
set_4_l:        or bl,16
		jmp next_instruction
set_4_chl:      or byte [bx],16
		jmp next_instruction
set_4_a:        or al,16
		jmp next_instruction

set_5_b:        or ch,32
		jmp next_instruction
set_5_c:        or cl,32
		jmp next_instruction
set_5_d:        or dh,32
		jmp next_instruction
set_5_e:        or dl,32
		jmp next_instruction
set_5_h:        or bh,32
		jmp next_instruction
set_5_l:        or bl,32
		jmp next_instruction
set_5_chl:      or byte [bx],32
		jmp next_instruction
set_5_a:        or al,32
		jmp next_instruction

set_6_b:        or ch,64
		jmp next_instruction
set_6_c:        or cl,64
		jmp next_instruction
set_6_d:        or dh,64
		jmp next_instruction
set_6_e:        or dl,64
		jmp next_instruction
set_6_h:        or bh,64
		jmp next_instruction
set_6_l:        or bl,64
		jmp next_instruction
set_6_chl:      or byte [bx],64
		jmp next_instruction
set_6_a:        or al,64
		jmp next_instruction

set_7_b:        or ch,128
		jmp next_instruction
set_7_c:        or cl,128
		jmp next_instruction
set_7_d:        or dh,128
		jmp next_instruction
set_7_e:        or dl,128
		jmp next_instruction
set_7_h:        or bh,128
		jmp next_instruction
set_7_l:        or bl,128
		jmp next_instruction
set_7_chl:      or byte [bx],128
		jmp next_instruction
set_7_a:        or al,128
                jmp next_instruction

