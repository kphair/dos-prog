org	0100h

%include "macros.asm"

; Jump tables for the various instruction emulation routines
; Also allocates space for the variables used in the emulation
%include "jmptable.asm"

; The core of the emulator: CPU Flags, screen update, keyboard, all
; first-level opcodes
%include "z80emul.asm"

; 0CDh-prefix opcodes
%include "cb_emul.asm"

; 0EDh-prefix opcodes
%include "ed_emul.asm"

; IX-register emulation
%include "ix_emul.asm"

; IY-register emulation
; File is duplicate of IX_EMUL.ASM, with search and replace done to change
; ALL occurences of IX to IY.
%include "iy_emul.asm"

; 48k Spectrum ROM
specrom:
incbin "48krom.bin"

; Multiface ROM
mf_rom:
incbin "mf_rom.bin"

mf_ram:
intro_screen:
; Intro screen (in Spectrum display format)
; We start off with the title screen in the Multiface 1's 8K RAM since we'll
; only need it the once

incbin "intro13.scr"
times 8192-($-mf_ram) db 0	; pad it out to the 8K page
