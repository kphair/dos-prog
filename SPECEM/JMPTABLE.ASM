; This file contains the jump tables for each category of opcodes

jmp startprog

; Ensure jump tables are aligned on even byte boundaries
align 2

;**********> Jump tables for Z80 instructions <*******************************;
opcodes:
dw _nop,     ld_bc_nn, ld_cbc_a, inc_bc,   inc_b,   dec_b,   ld_b_n,    rlca
dw ex_af,    add_hl_bc,ld_a_cbc, dec_bc,   inc_c,   dec_c,   ld_c_n,    rrca
dw _djnz,    ld_de_nn, ld_cde_a, inc_de,   inc_d,   dec_d,   ld_d_n,    rla
dw jr,       add_hl_de,ld_a_cde, dec_de,   inc_e,   dec_e,   ld_e_n,    rra
dw jrnz,     ld_hl_nn, ld_cnn_hl,inc_hl,   inc_h,   dec_h,   ld_h_n,    _daa
dw jr_z,     add_hl_hl,ld_hl_cnn,dec_hl,   inc_l,   dec_l,   ld_l_n,    cpl
dw jr_nc,    ld_sp_nn, ld_cnn_a, inc_sp,   inc_chl, dec_chl, ld_chl_n,  scf
dw jr_c,     add_hl_sp,ld_a_cnn, dec_sp,   inc_a,   dec_a,   ld_a_n,    ccf
dw ld_b_b,   ld_b_c,   ld_b_d,   ld_b_e,   ld_b_h,  ld_b_l,  ld_b_chl,  ld_b_a
dw ld_c_b,   ld_c_c,   ld_c_d,   ld_c_e,   ld_c_h,  ld_c_l,  ld_c_chl,  ld_c_a
dw ld_d_b,   ld_d_c,   ld_d_d,   ld_d_e,   ld_d_h,  ld_d_l,  ld_d_chl,  ld_d_a
dw ld_e_b,   ld_e_c,   ld_e_d,   ld_e_e,   ld_e_h,  ld_e_l,  ld_e_chl,  ld_e_a
dw ld_h_b,   ld_h_c,   ld_h_d,   ld_h_e,   ld_h_h,  ld_h_l,  ld_h_chl,  ld_h_a
dw ld_l_b,   ld_l_c,   ld_l_d,   ld_l_e,   ld_l_h,  ld_l_l,  ld_l_chl,  ld_l_a
dw ld_chl_b, ld_chl_c, ld_chl_d, ld_chl_e, ld_chl_h,ld_chl_l,_halt,     ld_chl_a
dw ld_a_b,   ld_a_c,   ld_a_d,   ld_a_e,   ld_a_h,  ld_a_l,  ld_a_chl,  ld_a_a
dw add_a_b,  add_a_c,  add_a_d,  add_a_e,  add_a_h, add_a_l, add_a_chl, add_a_a
dw adc_a_b,  adc_a_c,  adc_a_d,  adc_a_e,  adc_a_h, adc_a_l, adc_a_chl, adc_a_a
dw sub_a_b,  sub_a_c,  sub_a_d,  sub_a_e,  sub_a_h, sub_a_l, sub_a_chl, sub_a_a
dw sbc_a_b,  sbc_a_c,  sbc_a_d,  sbc_a_e,  sbc_a_h, sbc_a_l, sbc_a_chl, sbc_a_a
dw and_a_b,  and_a_c,  and_a_d,  and_a_e,  and_a_h, and_a_l, and_a_chl, and_a_a
dw xor_a_b,  xor_a_c,  xor_a_d,  xor_a_e,  xor_a_h, xor_a_l, xor_a_chl, xor_a_a
dw or_a_b,   or_a_c,   or_a_d,   or_a_e,   or_a_h,  or_a_l,  or_a_chl,  or_a_a
dw cp_a_b,   cp_a_c,   cp_a_d,   cp_a_e,   cp_a_h,  cp_a_l,  cp_a_chl,  cp_a_a
dw ret_nz,   pop_bc,   jp_nz,    jp_,      call_nz, push_bc, add_a_n,   rst_0
dw ret_z,    _ret,     jp_z,     cb_op,    call_z,  _call,   adc_a_n,   rst_8
dw ret_nc,   pop_de,   jp_nc,    out_n_a,  call_nc, push_de, sub_a_n,   rst_16
dw ret_c,    exx,      jp_c,     in_a_n,   call_c,  ix_op,   sbc_a_n,   rst_24
dw ret_po,   pop_hl,   jp_po,    ex_csp_hl,call_po, push_hl, and_a_n,   rst_32
dw ret_pe,   jp_hl,    jp_pe,    ex_de_hl, call_pe, ed_op,   xor_a_n,   rst_40
dw ret_p,    pop_af,   jp_p,     _di,      call_p,  push_af, or_n,      rst_48
dw ret_m,    ld_sp_hl, jp_m,     ei,       call_m,  iy_op,   cp_a_n,    rst_56

cb_opcodes:
dw   rlc_b,   rlc_c,   rlc_d,   rlc_e,   rlc_h,   rlc_l,   rlc_chl,   rlc_a
dw   rrc_b,   rrc_c,   rrc_d,   rrc_e,   rrc_h,   rrc_l,   rrc_chl,   rrc_a
dw    rl_b,    rl_c,    rl_d,    rl_e,    rl_h,    rl_l,    rl_chl,    rl_a
dw    rr_b,    rr_c,    rr_d,    rr_e,    rr_h,    rr_l,    rr_chl,    rr_a
dw   sla_b,   sla_c,   sla_d,   sla_e,   sla_h,   sla_l,   sla_chl,   sla_a
dw   sra_b,   sra_c,   sra_d,   sra_e,   sra_h,   sra_l,   sra_chl,   sra_a
dw   sll_b,   sll_c,   sll_d,   sll_e,   sll_h,   sll_l,   sll_chl,   sll_a
dw   srl_b,   srl_c,   srl_d,   srl_e,   srl_h,   srl_l,   srl_chl,   srl_a
dw bit_0_b, bit_0_c, bit_0_d, bit_0_e, bit_0_h, bit_0_l, bit_0_chl, bit_0_a
dw bit_1_b, bit_1_c, bit_1_d, bit_1_e, bit_1_h, bit_1_l, bit_1_chl, bit_1_a
dw bit_2_b, bit_2_c, bit_2_d, bit_2_e, bit_2_h, bit_2_l, bit_2_chl, bit_2_a
dw bit_3_b, bit_3_c, bit_3_d, bit_3_e, bit_3_h, bit_3_l, bit_3_chl, bit_3_a
dw bit_4_b, bit_4_c, bit_4_d, bit_4_e, bit_4_h, bit_4_l, bit_4_chl, bit_4_a
dw bit_5_b, bit_5_c, bit_5_d, bit_5_e, bit_5_h, bit_5_l, bit_5_chl, bit_5_a
dw bit_6_b, bit_6_c, bit_6_d, bit_6_e, bit_6_h, bit_6_l, bit_6_chl, bit_6_a
dw bit_7_b, bit_7_c, bit_7_d, bit_7_e, bit_7_h, bit_7_l, bit_7_chl, bit_7_a
dw res_0_b, res_0_c, res_0_d, res_0_e, res_0_h, res_0_l, res_0_chl, res_0_a
dw res_1_b, res_1_c, res_1_d, res_1_e, res_1_h, res_1_l, res_1_chl, res_1_a
dw res_2_b, res_2_c, res_2_d, res_2_e, res_2_h, res_2_l, res_2_chl, res_2_a
dw res_3_b, res_3_c, res_3_d, res_3_e, res_3_h, res_3_l, res_3_chl, res_3_a
dw res_4_b, res_4_c, res_4_d, res_4_e, res_4_h, res_4_l, res_4_chl, res_4_a
dw res_5_b, res_5_c, res_5_d, res_5_e, res_5_h, res_5_l, res_5_chl, res_5_a
dw res_6_b, res_6_c, res_6_d, res_6_e, res_6_h, res_6_l, res_6_chl, res_6_a
dw res_7_b, res_7_c, res_7_d, res_7_e, res_7_h, res_7_l, res_7_chl, res_7_a
dw set_0_b, set_0_c, set_0_d, set_0_e, set_0_h, set_0_l, set_0_chl, set_0_a
dw set_1_b, set_1_c, set_1_d, set_1_e, set_1_h, set_1_l, set_1_chl, set_1_a
dw set_2_b, set_2_c, set_2_d, set_2_e, set_2_h, set_2_l, set_2_chl, set_2_a
dw set_3_b, set_3_c, set_3_d, set_3_e, set_3_h, set_3_l, set_3_chl, set_3_a
dw set_4_b, set_4_c, set_4_d, set_4_e, set_4_h, set_4_l, set_4_chl, set_4_a
dw set_5_b, set_5_c, set_5_d, set_5_e, set_5_h, set_5_l, set_5_chl, set_5_a
dw set_6_b, set_6_c, set_6_d, set_6_e, set_6_h, set_6_l, set_6_chl, set_6_a
dw set_7_b, set_7_c, set_7_d, set_7_e, set_7_h, set_7_l, set_7_chl, set_7_a

ix_opcodes:
dw ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,       ndoc
dw ndoc,     add_ix_bc,ndoc,     ndoc,     ndoc,     ndoc,     ndoc,       ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,       ndoc
dw ndoc,     add_ix_de,ndoc,     ndoc,     ndoc,     ndoc,     ndoc,       ndoc
dw ndoc,     ld_ix_nn, ld_cnn_ix,inc_ix,   inc_ixh,  dec_ixh,  ld_ixh_n,   ndoc
dw ndoc,     add_ix_ix,ld_ix_cnn,dec_ix,   inc_ixl,  dec_ixl,  ld_ixl_n,   ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     inc_cix,  dec_cix,  ld_cix_n,   ndoc
dw ndoc,     add_ix_sp,ndoc,     ndoc,     ndoc,     ndoc,     ndoc,       ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     ld_b_ixh, ld_b_ixl, ld_b_cix,   ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     ld_c_ixh, ld_c_ixl, ld_c_cix,   ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     ld_d_ixh, ld_d_ixl, ld_d_cix,   ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     ld_e_ixh, ld_e_ixl, ld_e_cix,   ndoc
dw ld_ixh_b, ld_ixh_c, ld_ixh_d, ld_ixh_e,ld_ixh_ixh,ld_ixh_ixl,ld_h_cix,   ld_ixh_a
dw ld_ixl_b, ld_ixl_c, ld_ixl_d, ld_ixl_e,ld_ixl_ixh,ld_ixl_ixl,ld_l_cix,   ld_ixl_a
dw ld_cix_b, ld_cix_c, ld_cix_d, ld_cix_e,ld_cix_h,  ld_cix_l,  ndoc,       ld_cix_a
dw ndoc,     ndoc,     ndoc,     ndoc,     ld_a_ixh, ld_a_ixl, ld_a_cix,   ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     add_a_ixh,add_a_ixl,add_a_cix,  ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     adc_a_ixh,adc_a_ixl,adc_a_cix,  ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     sub_a_ixh,sub_a_ixl,sub_a_cix,  ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     sbc_a_ixh,sbc_a_ixl,sbc_a_cix,  ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     and_a_ixh,and_a_ixl,and_a_cix,  ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     xor_a_ixh,xor_a_ixl,xor_a_cix,  ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     or_a_ixh, or_a_ixl, or_a_cix,   ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     cp_a_ixh, cp_a_ixl, cp_a_cix,   ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,       ndoc
dw ndoc,     ndoc,     ndoc,     cbix,     ndoc,     ndoc,     ndoc,       ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,       ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,       ndoc
dw ndoc,     pop_ix,   ndoc,     ex_csp_ix,ndoc,     push_ix,  ndoc,       ndoc
dw ndoc,     jp_ix,    ndoc,     ex_de_ix, ndoc,     ndoc,     ndoc,       ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,       ndoc
dw ndoc,     ld_sp_ix, ndoc,     ndoc,     ndoc,     ndoc,     ndoc,       ndoc

cbix_ops:
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  rlc_cix,    ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  rrc_cix,    ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  rl_cix,     ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  rr_cix,     ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  sla_cix,    ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  sra_cix,    ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  sll_cix,    ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  srl_cix,    ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  bit_0_cix,  ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  bit_1_cix,  ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  bit_2_cix,  ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  bit_3_cix,  ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  bit_4_cix,  ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  bit_5_cix,  ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  bit_6_cix,  ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  bit_7_cix,  ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  res_0_cix,  ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  res_1_cix,  ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  res_2_cix,  ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  res_3_cix,  ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  res_4_cix,  ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  res_5_cix,  ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  res_6_cix,  ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  res_7_cix,  ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  set_0_cix,  ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  set_1_cix,  ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  set_2_cix,  ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  set_3_cix,  ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  set_4_cix,  ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  set_5_cix,  ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  set_6_cix,  ixndoc
dw ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  ixndoc,  set_7_cix,  ixndoc

iy_opcodes:
dw ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,       ndoc
dw ndoc,     add_iy_bc,ndoc,     ndoc,     ndoc,     ndoc,     ndoc,       ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,       ndoc
dw ndoc,     add_iy_de,ndoc,     ndoc,     ndoc,     ndoc,     ndoc,       ndoc
dw ndoc,     ld_iy_nn, ld_cnn_iy,inc_iy,   inc_iyh,  dec_iyh,  ld_iyh_n,   ndoc
dw ndoc,     add_iy_iy,ld_iy_cnn,dec_iy,   inc_iyl,  dec_iyl,  ld_iyl_n,   ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     inc_ciy,  dec_ciy,  ld_ciy_n,   ndoc
dw ndoc,     add_iy_sp,ndoc,     ndoc,     ndoc,     ndoc,     ndoc,       ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     ld_b_iyh, ld_b_iyl, ld_b_ciy,   ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     ld_c_iyh, ld_c_iyl, ld_c_ciy,   ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     ld_d_iyh, ld_d_iyl, ld_d_ciy,   ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     ld_e_iyh, ld_e_iyl, ld_e_ciy,   ndoc
dw ld_iyh_b, ld_iyh_c, ld_iyh_d, ld_iyh_e,ld_iyh_iyh,ld_iyh_iyl,ld_h_ciy,   ld_iyh_a
dw ld_iyl_b, ld_iyl_c, ld_iyl_d, ld_iyl_e,ld_iyl_iyh,ld_iyl_iyl,ld_l_ciy,   ld_iyl_a
dw ld_ciy_b, ld_ciy_c, ld_ciy_d, ld_ciy_e,ld_ciy_h,  ld_ciy_l,  ndoc,       ld_ciy_a
dw ndoc,     ndoc,     ndoc,     ndoc,     ld_a_iyh, ld_a_iyl, ld_a_ciy,   ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     add_a_iyh,add_a_iyl,add_a_ciy,  ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     adc_a_iyh,adc_a_iyl,adc_a_ciy,  ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     sub_a_iyh,sub_a_iyl,sub_a_ciy,  ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     sbc_a_iyh,sbc_a_iyl,sbc_a_ciy,  ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     and_a_iyh,and_a_iyl,and_a_ciy,  ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     xor_a_iyh,xor_a_iyl,xor_a_ciy,  ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     or_a_iyh, or_a_iyl, or_a_ciy,   ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     cp_a_iyh, cp_a_iyl, cp_a_ciy,   ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,       ndoc
dw ndoc,     ndoc,     ndoc,     cbiy,     ndoc,     ndoc,     ndoc,       ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,       ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,       ndoc
dw ndoc,     pop_iy,   ndoc,     ex_csp_iy,ndoc,     push_iy,  ndoc,       ndoc
dw ndoc,     jp_iy,    ndoc,     ex_de_iy, ndoc,     ndoc,     ndoc,       ndoc
dw ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,     ndoc,       ndoc
dw ndoc,     ld_sp_iy, ndoc,     ndoc,     ndoc,     ndoc,     ndoc,       ndoc

cbiy_ops:
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  rlc_ciy,    iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  rrc_ciy,    iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  rl_ciy,     iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  rr_ciy,     iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  sla_ciy,    iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  sra_ciy,    iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  sll_ciy,    iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  srl_ciy,    iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  bit_0_ciy,  iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  bit_1_ciy,  iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  bit_2_ciy,  iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  bit_3_ciy,  iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  bit_4_ciy,  iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  bit_5_ciy,  iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  bit_6_ciy,  iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  bit_7_ciy,  iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  res_0_ciy,  iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  res_1_ciy,  iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  res_2_ciy,  iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  res_3_ciy,  iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  res_4_ciy,  iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  res_5_ciy,  iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  res_6_ciy,  iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  res_7_ciy,  iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  set_0_ciy,  iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  set_1_ciy,  iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  set_2_ciy,  iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  set_3_ciy,  iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  set_4_ciy,  iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  set_5_ciy,  iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  set_6_ciy,  iyndoc
dw iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  iyndoc,  set_7_ciy,  iyndoc

ed_opcodes:
dw ndoc,     ndoc,     ndoc,      ndoc,      ndoc,    ndoc,    ndoc,    ndoc,
dw ndoc,     ndoc,     ndoc,      ndoc,      ndoc,    ndoc,    ndoc,    ndoc,
dw ndoc,     ndoc,     ndoc,      ndoc,      ndoc,    ndoc,    ndoc,    ndoc,
dw ndoc,     ndoc,     ndoc,      ndoc,      ndoc,    ndoc,    ndoc,    ndoc,
dw ndoc,     ndoc,     ndoc,      ndoc,      ndoc,    ndoc,    ndoc,    ndoc,
dw ndoc,     ndoc,     ndoc,      ndoc,      ndoc,    ndoc,    ndoc,    ndoc,
dw ndoc,     ndoc,     ndoc,      ndoc,      ndoc,    ndoc,    ndoc,    ndoc,
dw ndoc,     ndoc,     ndoc,      ndoc,      ndoc,    ndoc,    ndoc,    ndoc,
dw in_b_bc,  out_bc_b, sbc_hl_bc, ld_cnn_bc, neg_,    retn_,   im_0,    ld_i_a
dw in_c_bc,  out_bc_c, adc_hl_bc, ld_bc_cnn, ndoc,    reti,    ndoc,    ld_r_a
dw in_d_bc,  out_bc_d, sbc_hl_de, ld_cnn_de, ndoc,    ndoc,    im_1,    ld_a_i
dw in_e_bc,  out_bc_e, adc_hl_de, ld_de_cnn, ndoc,    ndoc,    im_2,    ld_a_r
dw in_h_bc,  out_bc_h, sbc_hl_hl, ld_cnn_hl, ndoc,    ndoc,    ndoc,    rrd
dw in_l_bc,  out_bc_l, adc_hl_hl, ld_hl_cnn, ndoc,    ndoc,    ndoc,    rld
dw in_f_bc,  ndoc,     sbc_hl_sp, ld_cnn_sp, ndoc,    ndoc,    ndoc,    ndoc
dw in_a_bc,  out_bc_a, adc_hl_sp, ld_sp_cnn, ndoc,    ndoc,    ndoc,    ndoc
dw ndoc,     ndoc,     ndoc,      ndoc,      ndoc,    ndoc,    ndoc,    ndoc,
dw ndoc,     ndoc,     ndoc,      ndoc,      ndoc,    ndoc,    ndoc,    ndoc,
dw ndoc,     ndoc,     ndoc,      ndoc,      ndoc,    ndoc,    ndoc,    ndoc,
dw ndoc,     ndoc,     ndoc,      ndoc,      ndoc,    ndoc,    ndoc,    ndoc,
dw ldi,      cpi,      ini,       outi,      ndoc,    ndoc,    ndoc,    ndoc
dw ldd,      cpd,      ind,       outd,      ndoc,    ndoc,    ndoc,    ndoc
dw ldir,     cpir,     inir,      otir,      ndoc,    ndoc,    ndoc,    ndoc
dw lddr,     cpdr,     indr,      otdr,      ndoc,    ndoc,    ndoc,    ndoc
dw ndoc,     ndoc,     ndoc,      ndoc,      ndoc,    ndoc,    ndoc,    ndoc,
dw ndoc,     ndoc,     ndoc,      ndoc,      ndoc,    ndoc,    ndoc,    ndoc,
dw ndoc,     ndoc,     ndoc,      ndoc,      ndoc,    ndoc,    ndoc,    ndoc,
dw ndoc,     ndoc,     ndoc,      ndoc,      ndoc,    ndoc,    ndoc,    ndoc,
dw ndoc,     ndoc,     ndoc,      ndoc,      ndoc,    ndoc,    ndoc,    ndoc,
dw ndoc,     ndoc,     ndoc,      ndoc,      ndoc,    ndoc,    ndoc,    ndoc,
dw ndoc,     ndoc,     ndoc,      ndoc,      ndoc,    ndoc,    ndoc,    ndoc,
dw ndoc,     ndoc,     ndoc,      ndoc,      ndoc,    ndoc,    ndoc,    ndoc,

;*************> Loads of lovely registers <***********************************;
reg_bc:         dw 0    ; General purpose register:     BC
reg_bc2:        dw 0    ; Alternative register pair:    BC'
reg_de:         dw 0    ; General purpose register:     DE
reg_de2:        dw 0    ; Alternative register pair:    DE'
reg_hl:         dw 0    ; General purpose register:     HL
reg_hl2:        dw 0    ; Alternative register pair:    HL'
reg_af:         dw 0    ; General purpose accumulator:  AF
reg_af2:        dw 0    ; Alternative register pair:    AF'

reg_ixl:                ; Indexing register:            IX
reg_ix:         db 0    ; Low byte of IX:               IXL
reg_ixh:        db 0    ; High byte of IX:              IXH

reg_iyl:                ; Indexing register:            IY
reg_iy:         db 0    ; Low byte of IY:               IYL
reg_iyh:        db 0    ; High byte of IY:              IYH

reg_sp:         dw 0    ; Stack pointer:                SP
reg_pc:         dw 0    ; Program counter:              PC
ireg_iff1:      db 0    ; interrupt Flip-Flop 2:        IFF1
ireg_iff2:      db 0    ; interrupt Flip-Flop 2:        IFF2
ireg_im:        db 0    ; Interrupt mode:               IM
ireg_i:         db 0    ; Interrupt register:           I
ireg_r:         db 0    ; Interrupt register:           R

;*************> Constants and variables <*************************************;
align 2
scr_seg:        dw 0b800h       ; Video page segment
bios_seg:       dw 00040h       ; Bios data segment
code_seg:       dw 0            ; Segment for emulator
z80_seg :       dw 0            ; Segment for z80 code
main_stack:     dw 0            ; Just in case...
old_int9:       dd 0            ; Offset and segment for old Interrupt 9

frame_count:    dw 4000         ; Interrupt ticker
interrupt_speed: dw 9216
flash_count:    db 16           ; Inverted blinking (a la spectrum)
flash_ff:       db 0            ; Flashing flip-flop
fresh:          db 0            ; 1 to force refresh (halt)

; Spectrum I/O port emulation
; Values are active low unless stated

; Keygroups to simulate spectrum keyboard
keygrp0:        db 255          ; Keys 'CAPS Shift' to 'V'
keygrp1:        db 255          ; Keys 'A' to 'G'
keygrp2:        db 255          ; Keys 'Q' to 'T'
keygrp3:        db 255          ; Keys '1' to '5'
keygrp4:        db 255          ; Keys '6' to '0'
keygrp5:        db 255          ; Keys 'Y' to 'P'
keygrp6:        db 255          ; Keys 'H' to 'Enter'
keygrp7:        db 255          ; Keys 'B' to 'Space'
kemstat:	db 0		; Kempston joystick emulation (active high)

specrom_stat:   dw 0		; 1 if spectrum rom is paged in
new_scan:       dw 0            ; Temp storage

statbyte:	db 7		; Redraw,attributes,registers
soundstat:	db 255		; Sound
mousestat:	db 0		; Mouse presence
                      
; For converting Scan codes to Keygroup codes
; The keyboard input scan code is used as an offset into this table where the
; resulting high byte is the ZX Spectrum keyboard segment (0 to 7) and the low
; byte is the column bitmask. This corresponds to the bit patterns used for 
; reading port 254.

; Keyboard segment 8 is used for the Kempston joytick emulation on port 31
; where bits 0,1,2,3 and 4 are mapped to the directions and fire. The 'Esc' 
; key is mapped onto bit 5 and this is how the emulator checks for the Alt-Esc
; combination to quit.

align 2
scan_conv:      dw -1           ; Scancode 000, No key
		dw 00820h	; Scancode 001, Esc
                dw 00301h       ; Scancode 002, 1
                dw 00302h       ; Scancode 003, 2
                dw 00304h       ; Scancode 004, 3
                dw 00308h       ; Scancode 005, 4
                dw 00310h       ; Scancode 006, 5
                dw 00410h       ; Scancode 007, 6
                dw 00408h       ; Scancode 008, 7
                dw 00404h       ; Scancode 009, 8
                dw 00402h       ; Scancode 00a, 9
                dw 00401h       ; Scancode 00b, 0
                dw -1           ; Scancode 00c, -
                dw -1           ; Scancode 00d, =
                dw -1           ; Scancode 00e, Backspace
                dw -1           ; Scancode 00f, Tab
                dw 00201h       ; Scancode 010, q
                dw 00202h       ; Scancode 011, w
                dw 00204h       ; Scancode 012, e
                dw 00208h       ; Scancode 013, r
                dw 00210h       ; Scancode 014, t
                dw 00510h       ; Scancode 015, y
                dw 00508h       ; Scancode 016, u
                dw 00504h       ; Scancode 017, i
                dw 00502h       ; Scancode 018, o
                dw 00501h       ; Scancode 019, p
                dw -1           ; Scancode 01a, [
                dw -1           ; Scancode 01b, ]
                dw 00601h       ; Scancode 01c, Enter
                dw -1           ; Scancode 01d, Ctrl
                dw 00101h       ; Scancode 01e, a
                dw 00102h       ; Scancode 01f, s
                dw 00104h       ; Scancode 020, d
                dw 00108h       ; Scancode 021, f
                dw 00110h       ; Scancode 022, g
                dw 00610h       ; Scancode 023, h
                dw 00608h       ; Scancode 024, j
                dw 00604h       ; Scancode 025, k
                dw 00602h       ; Scancode 026, l
                dw -1           ; Scancode 027, ;
                dw -1           ; Scancode 028, '
                dw -1           ; Scancode 029, `
                dw 00001h       ; Scancode 02a, Left Shift
                dw -1           ; Scancode 02b, Backslash
                dw 00002h       ; Scancode 02c, z
                dw 00004h       ; Scancode 02d, x
                dw 00008h       ; Scancode 02e, c
                dw 00010h       ; Scancode 02f, v
                dw 00710h       ; Scancode 030, b
                dw 00708h       ; Scancode 031, n
                dw 00704h       ; Scancode 032, m
                dw -1           ; Scancode 033, ,
                dw -1           ; Scancode 034, .
                dw -1           ; Scancode 035, /
                dw 00702h       ; Scancode 036, Right Shift
                dw -1           ; Scancode 037, Grey *
                dw 00810h       ; Scancode 038, Alt
                dw 00701h       ; Scancode 039, Space bar
                dw -1           ; Scancode 03a, Caps Lock
                dw -1           ; Scancode 03b, F1
                dw -1           ; Scancode 03c, F2
                dw -1           ; Scancode 03d, F3
                dw -1           ; Scancode 03e, F4
                dw -1           ; Scancode 03f, F5
                dw -1           ; Scancode 040, F6
                dw -1           ; Scancode 041, F7
                dw -1           ; Scancode 042, F8
                dw 00830h       ; Scancode 043, F9
                dw -1           ; Scancode 044, F10
                dw -1           ; Scancode 045, Num Lock
                dw -1           ; Scancode 046, Scroll Lock
                dw -1           ; Scancode 047, Home
                dw 00808h       ; Scancode 048, Cursor up
                dw -1           ; Scancode 049, PgUp
                dw -1           ; Scancode 04a, Grey minus
                dw 00802h       ; Scancode 04b, Cursor left
                dw -1           ; Scancode 04c, Num 5
                dw 00801h       ; Scancode 04d, Cursor right
                dw -1           ; Scancode 04e, Grey plus
                dw -1           ; Scancode 04f, End
                dw 00804h       ; Scancode 050, Cursor down
                dw -1           ; Scancode 051, PgDn
                dw -1           ; Scancode 052, Ins
                dw -1           ; Scancode 053, Del

; Binary character definitions for the custom text mode
new_chars:  db 000h,001h,002h,003h,004h,005h,006h,007h,008h,009h,00Ah,00Bh,00Ch,00Dh,00Eh,00Fh
            db 010h,011h,012h,013h,014h,015h,016h,017h,018h,019h,01Ah,01Bh,01Ch,01Dh,01Eh,01Fh
            db 020h,021h,022h,023h,024h,025h,026h,027h,028h,029h,02Ah,02Bh,02Ch,02Dh,02Eh,02Fh
            db 030h,031h,032h,033h,034h,035h,036h,037h,038h,039h,03Ah,03Bh,03Ch,03Dh,03Eh,03Fh
            db 040h,041h,042h,043h,044h,045h,046h,047h,048h,049h,04Ah,04Bh,04Ch,04Dh,04Eh,04Fh
            db 050h,051h,052h,053h,054h,055h,056h,057h,058h,059h,05Ah,05Bh,05Ch,05Dh,05Eh,05Fh
            db 060h,061h,062h,063h,064h,065h,066h,067h,068h,069h,06Ah,06Bh,06Ch,06Dh,06Eh,06Fh
            db 070h,071h,072h,073h,074h,075h,076h,077h,078h,079h,07Ah,07Bh,07Ch,07Dh,07Eh,07Fh
            db 080h,081h,082h,083h,084h,085h,086h,087h,088h,089h,08Ah,08Bh,08Ch,08Dh,08Eh,08Fh
            db 090h,091h,092h,093h,094h,095h,096h,097h,098h,099h,09Ah,09Bh,09Ch,09Dh,09Eh,09Fh
            db 0A0h,0A1h,0A2h,0A3h,0A4h,0A5h,0A6h,0A7h,0A8h,0A9h,0AAh,0ABh,0ACh,0ADh,0AEh,0AFh
            db 0B0h,0B1h,0B2h,0B3h,0B4h,0B5h,0B6h,0B7h,0B8h,0B9h,0BAh,0BBh,0BCh,0BDh,0BEh,0BFh
            db 0C0h,0C1h,0C2h,0C3h,0C4h,0C5h,0C6h,0C7h,0C8h,0C9h,0CAh,0CBh,0CCh,0CDh,0CEh,0CFh
            db 0D0h,0D1h,0D2h,0D3h,0D4h,0D5h,0D6h,0D7h,0D8h,0D9h,0DAh,0DBh,0DCh,0DDh,0DEh,0DFh
            db 0E0h,0E1h,0E2h,0E3h,0E4h,0E5h,0E6h,0E7h,0E8h,0E9h,0EAh,0EBh,0ECh,0EDh,0EEh,0EFh
            db 0F0h,0F1h,0F2h,0F3h,0F4h,0F5h,0F6h,0F7h,0F8h,0F9h,0FAh,0FBh,0FCh,0FDh,0FEh,0FFh

; DI positioning table for screen emulation. This is used to translate the 
; Spectrum display offsets into the linear offsets used by the PC screen mode

align 2
pos_table:  dw 0   ,320 ,640 ,960 ,1280,1600,1920,2240
            dw 40  ,360 ,680 ,1000,1320,1640,1960,2280
            dw 80  ,400 ,720 ,1040,1360,1680,2000,2320
            dw 120 ,440 ,760 ,1080,1400,1720,2040,2360
            dw 160 ,480 ,800 ,1120,1440,1760,2080,2400
            dw 200 ,520 ,840 ,1160,1480,1800,2120,2440
            dw 240 ,560 ,880 ,1200,1520,1840,2160,2480
            dw 280 ,600 ,920 ,1240,1560,1880,2200,2520
            dw 2560,2880,3200,3520,3840,4160,4480,4800
            dw 2600,2920,3240,3560,3880,4200,4520,4840
            dw 2640,2960,3280,3600,3920,4240,4560,4880
            dw 2680,3000,3320,3640,3960,4280,4600,4920
            dw 2720,3040,3360,3680,4000,4320,4640,4960
            dw 2760,3080,3400,3720,4040,4360,4680,5000
            dw 2800,3120,3440,3760,4080,4400,4720,5040
            dw 2840,3160,3480,3800,4120,4440,4760,5080
            dw 5120,5440,5760,6080,6400,6720,7040,7360
            dw 5160,5480,5800,6120,6440,6760,7080,7400
            dw 5200,5520,5840,6160,6480,6800,7120,7440
            dw 5240,5560,5880,6200,6520,6840,7160,7480
            dw 5280,5600,5920,6240,6560,6880,7200,7520
            dw 5320,5640,5960,6280,6600,6920,7240,7560
            dw 5360,5680,6000,6320,6640,6960,7280,7600
            dw 5400,5720,6040,6360,6680,7000,7320,7640

; Spectrum to PC colour translation

attr_table:
        db 000h,001h,002h,003h,004h,005h,006h,007h,010h,011h,012h,013h,014h,015h,016h,017h
        db 020h,021h,022h,023h,024h,025h,026h,027h,030h,031h,032h,033h,034h,035h,036h,037h
        db 040h,041h,042h,043h,044h,045h,046h,047h,050h,051h,052h,053h,054h,055h,056h,057h
        db 060h,061h,062h,063h,064h,065h,066h,067h,070h,071h,072h,073h,074h,075h,076h,077h
        db 000h,009h,00ah,00bh,00ch,00dh,00eh,00fh,090h,099h,09ah,09bh,09ch,09dh,09eh,09fh
        db 0a0h,0a9h,0aah,0abh,0ach,0adh,0aeh,0afh,0b0h,0b9h,0bah,0bbh,0bch,0bdh,0beh,0bfh
        db 0c0h,0c9h,0cah,0cbh,0cch,0cdh,0ceh,0cfh,0d0h,0d9h,0dah,0dbh,0dch,0ddh,0deh,0dfh
        db 0e0h,0e9h,0eah,0ebh,0ech,0edh,0eeh,0efh,0f0h,0f9h,0fah,0fbh,0fch,0fdh,0feh,0ffh
; With flash
        db 000h,001h,002h,003h,004h,005h,006h,007h,010h,011h,012h,013h,014h,015h,016h,017h
        db 020h,021h,022h,023h,024h,025h,026h,027h,030h,031h,032h,033h,034h,035h,036h,037h
        db 040h,041h,042h,043h,044h,045h,046h,047h,050h,051h,052h,053h,054h,055h,056h,057h
        db 060h,061h,062h,063h,064h,065h,066h,067h,070h,071h,072h,073h,074h,075h,076h,077h
        db 000h,009h,00ah,00bh,00ch,00dh,00eh,00fh,090h,099h,09ah,09bh,09ch,09dh,09eh,09fh
        db 0a0h,0a9h,0aah,0abh,0ach,0adh,0aeh,0afh,0b0h,0b9h,0bah,0bbh,0bch,0bdh,0beh,0bfh
        db 0c0h,0c9h,0cah,0cbh,0cch,0cdh,0ceh,0cfh,0d0h,0d9h,0dah,0dbh,0dch,0ddh,0deh,0dfh
        db 0e0h,0e9h,0eah,0ebh,0ech,0edh,0eeh,0efh,0f0h,0f9h,0fah,0fbh,0fch,0fdh,0feh,0ffh

; Second colour table
        db 000h,001h,002h,003h,004h,005h,006h,007h,010h,011h,012h,013h,014h,015h,016h,017h
        db 020h,021h,022h,023h,024h,025h,026h,027h,030h,031h,032h,033h,034h,035h,036h,037h
        db 040h,041h,042h,043h,044h,045h,046h,047h,050h,051h,052h,053h,054h,055h,056h,057h
        db 060h,061h,062h,063h,064h,065h,066h,067h,070h,071h,072h,073h,074h,075h,076h,077h
        db 000h,009h,00ah,00bh,00ch,00dh,00eh,00fh,090h,099h,09ah,09bh,09ch,09dh,09eh,09fh
        db 0a0h,0a9h,0aah,0abh,0ach,0adh,0aeh,0afh,0b0h,0b9h,0bah,0bbh,0bch,0bdh,0beh,0bfh
        db 0c0h,0c9h,0cah,0cbh,0cch,0cdh,0ceh,0cfh,0d0h,0d9h,0dah,0dbh,0dch,0ddh,0deh,0dfh
        db 0e0h,0e9h,0eah,0ebh,0ech,0edh,0eeh,0efh,0f0h,0f9h,0fah,0fbh,0fch,0fdh,0feh,0ffh
; With flash
        db 000h,010h,020h,030h,040h,050h,060h,070h,001h,011h,021h,031h,041h,051h,061h,071h
        db 002h,012h,022h,032h,042h,052h,062h,072h,003h,013h,023h,033h,043h,053h,063h,073h
        db 004h,014h,024h,034h,044h,054h,064h,074h,005h,015h,025h,035h,045h,055h,065h,075h
        db 006h,016h,026h,036h,046h,056h,066h,076h,007h,017h,027h,037h,047h,057h,067h,077h
        db 000h,090h,0a0h,0b0h,0c0h,0d0h,0e0h,0f0h,009h,099h,0a9h,0b9h,0c9h,0d9h,0e9h,0f9h
        db 00ah,09ah,0aah,0bah,0cah,0dah,0eah,0fah,00bh,09bh,0abh,0bbh,0cbh,0dbh,0ebh,0fbh
        db 00ch,09ch,0ach,0bch,0cch,0dch,0ech,0fch,00dh,09dh,0adh,0bdh,0cdh,0ddh,0edh,0fdh
        db 00eh,09eh,0aeh,0beh,0ceh,0deh,0eeh,0feh,00fh,09fh,0afh,0bfh,0cfh,0dfh,0efh,0ffh

; New palette settings with proper yellow
newpal:         db 000h,001h,004h,005h,002h,003h,006h,007h
                db 008h,009h,024h,02dh,012h,01bh,036h,03fh

; Storage for plus D startup 1/2 sector when loading snapshots
auto_header:    times 256 db 0

; A bit of text for the watch window
debug_text: db "                                 PC 0000"
            db "                                 AF 0000"
            db "                                 BC 0000"
            db "                                 DE 0000"
            db "                                 HL 0000"
            db "                                 AF'0000"
            db "                                 BC'0000"
            db "                                 DE'0000"
            db "                                 HL'0000"
            db "                                 IX 0000"
            db "                                 IY 0000"
            db "                                 SP 0000"
            db "                                 IR 0000"
            db "                                 IM 0000"
            db "                                  ",128,129," ",130,131," "
            db "                                  ",132,133," ",134,135," "
            db "                                 fr:0000",36

; Filename template for loading and saving files
last_file:	db "________.___",0

; Storage area fpr tape header
header:         times 17 db 0

; This is the emulator logo that sits at the bottom right.
logobox:
db 00Eh,005h,000h,007h,000h,00dh,008h,00fh,000h,00fh,000h,00dh,000h,007h
db 01Bh,007h,000h,00dh,000h,00fh,018h,00fh,000h,00dh,000h,007h,000h,005h
db 018h,00dh,078h,00fh,0E3h,00fh,09Dh,00dh,0B6h,007h,0DFh,005h,080h,005h
db 00Eh,00fh,06Dh,00fh,0B6h,00dh,0D9h,007h,0F6h,005h,0DAh,005h,0C0h,007h
db 003h,00fh,06Dh,00dh,0F6h,007h,019h,005h,086h,005h,0DAh,007h,0C0h,00dh
db 01Bh,00dh,06Dh,007h,086h,005h,0D9h,005h,086h,007h,0DAh,00dh,0C0h,00fh
db 00Eh,007h,078h,005h,0E3h,005h,08Dh,007h,083h,00dh,0DAh,00fh,0C0h,00fh
db 000h,005h,060h,005h,000h,007h,000h,00dh,000h,00fh,000h,00fh,000h,005h
db 000h,005h,060h,007h,000h,00dh,000h,00fh,000h,00fh,000h,00dh,000h,007h
db 000h,007h,000h,00dh,000h,00fh,000h,00fh,000h,00dh,000h,007h,000h,005h
db 00Fh,00dh,080h,00fh,000h,00fh,0C0h,00dh,020h,007h,000h,005h,000h,005h
db 00Ch,00fh,000h,00fh,000h,00dh,0C0h,007h,060h,005h,000h,005h,000h,007h
db 00Ch,00fh,03Fh,00dh,036h,007h,0CEh,005h,073h,005h,09Bh,007h,000h,00dh
db 00Fh,00dh,035h,007h,0B6h,005h,0C3h,005h,066h,007h,0DFh,00dh,000h,00fh
db 00Ch,007h,035h,005h,0B6h,005h,0CFh,007h,066h,00dh,0D8h,00fh,000h,00fh
db 00Ch,005h,035h,005h,0B6h,007h,0DBh,00dh,066h,00fh,0D8h,00fh,000h,00dh
db 00Fh,005h,0B5h,007h,09Eh,00dh,0CFh,00fh,033h,00fh,098h,00dh,000h,007h
db 000h,007h,000h,007h,000h,007h,000h,007h,000h,007h,000h,007h,000h,007h
db 000h,007h,000h,007h,000h,007h,000h,007h,000h,007h,000h,007h,000h,007h
db 070h,007h,000h,007h,000h,007h,000h,007h,000h,007h,000h,007h,000h,007h
db 08Bh,007h,077h,007h,060h,007h,048h,007h,0E4h,007h,098h,007h,0B8h,007h
db 0B9h,00fh,055h,00fh,050h,00fh,050h,00fh,094h,00fh,0A4h,00fh,0A4h,00fh
db 0C9h,00fh,077h,00fh,010h,00fh,060h,00fh,0E7h,00fh,0A4h,00fh,0B8h,00fh
db 0B9h,00fh,011h,00fh,020h,00fh,050h,00fh,084h,00fh,0BCh,00fh,0A8h,00fh
db 08Bh,007h,091h,007h,072h,007h,04Ah,007h,084h,007h,0A4h,007h,0A4h,007h
db 070h,007h,000h,007h,004h,007h,000h,007h,000h,007h,000h,007h,000h,007h
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
db 000h,000h,001h,002h,001h,026h,001h,064h,001h,041h,001h,010h,000h,000h
db 000h,000h,001h,002h,001h,026h,001h,064h,001h,041h,001h,010h,000h,000h
db 000h,000h,003h,00ah,003h,0aeh,003h,0ech,003h,0c9h,003h,090h,000h,000h
db 000h,000h,003h,002h,003h,026h,003h,064h,003h,041h,003h,010h,000h,000h
db 000h,000h,007h,00ah,007h,0aeh,007h,0ech,007h,0c9h,007h,090h,000h,000h
db 000h,000h,007h,00ah,007h,0aeh,007h,0ech,007h,0c9h,007h,090h,000h,000h
db 000h,000h,00fh,00ah,00fh,0aeh,00fh,0ech,00fh,0c9h,00fh,090h,000h,000h
db 000h,000h,00fh,00ah,00fh,0aeh,00fh,0ech,00fh,0c9h,00fh,090h,000h,000h
db 000h,000h,01fh,00ah,01fh,0aeh,01fh,0ech,01fh,0c9h,01fh,090h,000h,000h
db 000h,000h,01fh,00ah,01fh,0aeh,01fh,0ech,01fh,0c9h,01fh,090h,000h,000h
db 000h,000h,03fh,00ah,03fh,0aeh,03fh,0ech,03fh,0c9h,03fh,090h,000h,000h
db 000h,000h,03fh,00ah,03fh,0aeh,03fh,0ech,03fh,0c9h,03fh,090h,000h,000h
db 000h,000h,07fh,002h,07fh,026h,07fh,064h,07fh,041h,07fh,010h,000h,000h
db 000h,000h,07fh,00ah,07fh,0aeh,07fh,0ech,07fh,0c9h,07fh,090h,000h,000h
db 000h,000h,0ffh,002h,0Ffh,026h,0ffh,064h,0Ffh,041h,0ffh,010h,000h,000h
db 000h,000h,0ffh,002h,0Ffh,026h,0ffh,064h,0Ffh,041h,0ffh,010h,000h,000h

; This is the custom character set used by the emulator user interface
charset:
db 0,0,0,0,0,0,0,0
db 0,16,16,16,16,0,16,0
db 0,36,36,0,0,0,0,0
db 0,36,126,36,36,126,36,0
db 0,8,62,40,62,10,62,8
db 0,98,100,8,16,38,70,0
db 0,16,40,16,42,68,58,0
db 0,8,16,0,0,0,0,0
db 0,4,8,8,8,8,4,0
db 0,32,16,16,16,16,32,0
db 0,0,20,8,62,8,20,0
db 0,0,8,8,62,8,8,0
db 0,0,0,0,0,8,8,16
db 0,0,0,0,62,0,0,0
db 0,0,0,0,0,24,24,0
db 0,0,2,4,8,16,32,0
db 0,60,70,74,82,98,60,0
db 0,24,40,8,8,8,62,0
db 0,60,66,2,60,64,126,0
db 0,60,66,12,2,66,60,0
db 0,8,24,40,72,126,8,0
db 0,126,64,124,2,66,60,0
db 0,60,64,124,66,66,60,0
db 0,126,2,4,8,16,16,0
db 0,60,66,60,66,66,60,0
db 0,60,66,66,62,2,60,0
db 0,0,0,16,0,0,16,0
db 0,0,16,0,0,16,16,32
db 0,0,4,8,16,8,4,0
db 0,0,0,62,0,62,0,0
db 0,0,16,8,4,8,16,0
db 0,60,66,4,8,0,8,0
db 0,60,74,86,94,64,60,0
db 0,60,66,66,126,66,66,0
db 0,124,66,124,66,66,124,0
db 0,60,66,64,64,66,60,0
db 0,120,68,66,66,68,120,0
db 0,126,64,124,64,64,126,0
db 0,126,64,124,64,64,64,0
db 0,60,66,64,78,66,60,0
db 0,66,66,126,66,66,66,0
db 0,62,8,8,8,8,62,0
db 0,2,2,2,66,66,60,0
db 0,68,72,112,72,68,66,0
db 0,64,64,64,64,64,126,0
db 0,66,102,90,66,66,66,0
db 0,66,98,82,74,70,66,0
db 0,60,66,66,66,66,60,0
db 0,124,66,66,124,64,64,0
db 0,60,66,66,82,74,60,0
db 0,124,66,66,124,68,66,0
db 0,60,64,60,2,66,60,0
db 0,254,16,16,16,16,16,0
db 0,66,66,66,66,66,60,0
db 0,66,66,66,66,36,24,0
db 0,66,66,66,66,90,36,0
db 0,66,36,24,24,36,66,0
db 0,130,68,40,16,16,16,0
db 0,126,4,8,16,32,126,0
db 0,14,8,8,8,8,14,0
db 0,0,64,32,16,8,4,0
db 0,112,16,16,16,16,112,0
db 0,16,56,84,16,16,16,0
db 0,0,0,0,0,0,0,255
db 0,28,34,120,32,32,126,0
db 0,0,56,4,60,68,60,0
db 0,32,32,60,34,34,60,0
db 0,0,28,32,32,32,28,0
db 0,4,4,60,68,68,60,0
db 0,0,56,68,120,64,60,0
db 0,12,16,24,16,16,16,0
db 0,0,60,68,68,60,4,56
db 0,64,64,120,68,68,68,0
db 0,16,0,48,16,16,56,0
db 0,4,0,4,4,4,36,24
db 0,32,40,48,48,40,36,0
db 0,16,16,16,16,16,12,0
db 0,0,104,84,84,84,84,0
db 0,0,120,68,68,68,68,0
db 0,0,56,68,68,68,56,0
db 0,0,120,68,68,120,64,64
db 0,0,60,68,68,60,4,6
db 0,0,28,32,32,32,32,0
db 0,0,56,64,56,4,120,0
db 0,16,56,16,16,16,12,0
db 0,0,68,68,68,68,56,0
db 0,0,68,68,40,40,16,0
db 0,0,68,84,84,84,40,0
db 0,0,68,40,16,40,68,0
db 0,0,68,68,68,60,4,56
db 0,0,124,8,16,32,124,0
db 0,14,8,48,8,8,14,0
db 0,8,8,8,8,8,8,0
db 0,112,16,12,16,16,112,0
db 0,20,40,0,0,0,0,0
db 60,66,153,161,161,153,66,60
db 0
db 00011001b
db 00100010b
db 00010010b
db 00001010b
db 00110001b
db 0,0,0
db 10110000b
db 00101000b
db 00110000b
db 00101000b
db 10101000b
db 0,0,0
db 00010111b
db 00101010b
db 00111010b
db 00101010b
db 00101010b
db 0,0,0
db 01110000b
db 00100000b
db 00100000b
db 00100000b
db 00100000b
db 0,0,0
db 01100111b
db 01010100b
db 01100111b
db 01010100b
db 01010111b
db 0,0,0
db 00110000b
db 01000000b
db 01010000b
db 01010000b
db 00110000b
db 0,0,0
db 00110101b
db 01000111b
db 00100111b
db 00010111b
db 01100101b
db 0,0,0
db 01100000b
db 01010000b
db 01010000b
db 01010000b
db 01100000b
db 0,0

