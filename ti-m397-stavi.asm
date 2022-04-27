#target rom
#code ZX48_128,0,4096;

;       there were two different wirings : 0x10 and 0x80
BIT_SEND        equ     0x10

FLAG_SEND       equ     BIT_SEND
FLAG_LOW        equ     0x40
FLAG_HI         equ     (FLAG_SEND|FLAG_LOW)
FLAG_MASK       equ     (FLAG_SEND|FLAG_LOW)

	di			; 
	xor	a		; 
	out	($FF),a		; 
	jp	J0ff2		; 

	ORG	$08

J0008:	di			;  ti_on (J0008)
	push	hl		; 
	push	af		; 
	push	iy		; 
	pop	hl		; 
	ld	a,h		; 
	or	l		; 
	jr	nz,J0039	; 
	pop	af		; 
	pop	hl		; 
	ret			; 
;
J0015:	res	5,(iy+$01)	;  read_key (J0015)
	set	3,(iy+$01)	; 
	call	J031d		;  cbas_i (J031d)
	defw	$02bf		;  KEYBOARD ($02bf)
;
	xor	a		; 
	bit	5,(iy+$01)	; 
	ret	z		; 
	ld	a,($5C08)	;  LAST_K ($5C08)
	cp	$61		; 
	ret	c		; 
	and	$DF		; 
	ret			; 
;
J0031:	ld	a,$0D		; 
	call	J031d		;  cbas_i (J031d)
	defw	$0010		;  PRINT_CHAR ($0010)
;
	ret			; 
;
J0039:	pop	af		; 
	ld	hl,$213A	;  system_flags ($213A)
	bit	2,(hl)		; 
	jp	nz,J022d	; 
	bit	4,(hl)		; 
	jp	nz,J064f	; 
	bit	5,(hl)		; 
	jp	nz,J0255	; 
	bit	0,(hl)		; 
	res	0,(hl)		; 
	pop	hl		; 
	ret	nz		; 
	ld	hl,($5C5D)	;  CH_ADD ($5C5D)
	ld	($213F),hl	;  ch_add_tmp ($213F)
	ld	a,(hl)		; 
	cp	$2A		; 
	jr	nz,J007e	; 
	dec	hl		; 
	ld	a,(hl)		; 
	cp	$A5		; 
	jr	c,J007e		; 
	ld	($5C5D),hl	;  CH_ADD ($5C5D)
	ld	de,D026b	; 
	ld	a,(hl)		; 
	ld	b,a		; 
	ex	de,hl		; 
	ld	a,(hl)		; 
J006d:	cp	b		; 
	jr	z,J008c		; 
J0070:	cp	$FE		; 
	inc	hl		; 
	ld	a,(hl)		; 
	jr	nz,J0070	; 
	inc	hl		; 
	inc	hl		; 
	inc	hl		; 
	ld	a,(hl)		; 
	cp	$FF		; 
	jr	nz,J006d	; 
J007e:	ld	hl,($213B)	;  error_proc ($213B)
	jp	(hl)		; 
;
J0082:	ld	hl,$000b	; 
	push	hl		; 
	ld	hl,($213F)	;  ch_add_tmp ($213F)
	jp	J0603		;  ti_ret (J0603)
;
J008c:	inc	de		; 
	ld	($5C5D),de	;  CH_ADD ($5C5D)
	inc	hl		; 
	push	hl		; 
	call	J031d		;  cbas_i (J031d)
	defw	$0020		;  COLLECT_NEXT_CHARACTER ($0020)
;
	pop	hl		; 
J0099:	ld	de,D00c5	; 
	ld	a,(hl)		; 
	cp	$FE		; 
	jr	z,J00b8		; 
	add	a,e		; 
	ld	e,a		; 
	jr	nc,J00a6	; 
	inc	d		; 
J00a6:	push	hl		; 
	ld	hl,J00b4	; 
	push	hl		; 
	ex	de,hl		; 
	ld	e,(hl)		; 
	inc	hl		; 
	ld	d,(hl)		; 
	push	de		; 
	ld	hl,($5C5D)	;  CH_ADD ($5C5D)
	ret			; 
;
J00b4:	pop	hl		; 
	inc	hl		; 
	jr	J0099		; 
;
J00b8:	call	J033e		; 
	inc	hl		; 
	ld	e,(hl)		; 
	inc	hl		; 
	ld	d,(hl)		; 
	ex	de,hl		; 
	ld	de,J06dc	; 
	push	de		; 
	jp	(hl)		; 
;
D00c5:	defw	J00ea		; 
	defw	J00fa		; 
	defw	J0117		; 
	defw	J0149		; 
	defw	J014f		; 
	defw	J0179		; 
	defw	J01b1		; 
	defw	J01be		; 
	defw	J01ca		; 
	defw	J01fe		; 
	defw	J0217		; 
	defw	J01ec		; 
	defw	J01f3		; 
	defw	J096d		; 
	defw	J0ba8		; 
	defw	J0872		; 
	defw	J07a4		; 
;
J00e7:	jp	J046a		; 
J00ea:	call	J0223		; 
	jr	z,J00e7		; 
	call	J0663		; 
	ret	z		; 
	call	J0241		; 
	ld	($2134),a	;  tmp_1 ($2134)
	ret			; 
;
J00fa:	call	J0223		; 
	jr	nz,J00e7	; 
	ld	hl,($5C5D)	;  CH_ADD ($5C5D)
J0102:	ld	a,(hl)		; 
	cp	$24		; 
	jr	z,J010e		; 
	cp	$22		; 
	jr	z,J010e		; 
	dec	hl		; 
	jr	J0102		; 
;
J010e:	ld	($5C5D),hl	;  CH_ADD ($5C5D)
	call	J031d		;  cbas_i (J031d)
	defw	$0020		;  COLLECT_NEXT_CHARACTER ($0020)
;
	ret			; 
;
J0117:	ld	a,(hl)		; 
	call	J0265		; 
	jr	z,J00e7		; 
	cp	$5B		; 
	jr	c,J0123		; 
	sub	$20		; 
J0123:	ld	hl,$0000	; 
	add	hl,sp		; 
	inc	hl		; 
	inc	hl		; 
	ld	e,(hl)		; 
	inc	hl		; 
	ld	d,(hl)		; 
	inc	de		; 
	ld	b,a		; 
J012e:	ld	a,(de)		; 
	and	a		; 
	jr	z,J00e7		; 
	cp	b		; 
	jr	z,J0138		; 
	inc	de		; 
	jr	J012e		; 
;
J0138:	ld	($2136),a	;  tmp_2 ($2136)
J013b:	inc	de		; 
	ld	a,(de)		; 
	and	a		; 
	jr	nz,J013b	; 
	ld	(hl),d		; 
	dec	hl		; 
	ld	(hl),e		; 
	call	J031d		;  cbas_i (J031d)
	defw	$0020		;  COLLECT_NEXT_CHARACTER ($0020)
;
	ret			; 
;
J0149:	ld	hl,$213A	;  system_flags ($213A)
	set	1,(hl)		; 
	ret			; 
;
J014f:	ld	a,(hl)		; 
	call	J0265		; 
	jr	z,J0172		; 
	call	J0217		; 
	call	J0223		; 
	jp	z,J046a		; 
	call	J0663		; 
	ret	z		; 
	call	J024b		; 
	ld	($214B),bc	;  rec_num ($214B)
	ld	a,($213A)	;  system_flags ($213A)
	set	3,a		; 
J016e:	ld	($213A),a	;  system_flags ($213A)
	ret			; 
;
J0172:	ld	a,($213A)	;  system_flags ($213A)
	res	3,a		; 
	jr	J016e		; 
;
J0179:	call	J0217		; 
	call	J0223		; 
	jp	nz,J046a	; 
J0182:	ld	hl,($5C5D)	;  CH_ADD ($5C5D)
	ld	a,(hl)		; 
	call	J0265		; 
	jr	z,J01aa		; 
	call	J0217		; 
	cp	$AC		; 
	jp	nz,J046a	; 
	call	J031d		;  cbas_i (J031d)
	defw	$0020		;  COLLECT_NEXT_CHARACTER ($0020)
;
	call	J0223		; 
	jp	z,J046a		; 
	call	J0663		; 
	ret	z		; 
	call	J024b		; 
	ld	($214B),bc	;  rec_num ($214B)
	ret			; 
;
J01aa:	ld	hl,$0000	; 
	ld	($214B),hl	;  rec_num ($214B)
	ret			; 
;
J01b1:	ld	a,(hl)		; 
	call	J0265		; 
	jp	nz,J00ea	; 
	ld	a,$80		; 
	ld	($2134),a	;  tmp_1 ($2134)
	ret			; 
;
J01be:	ld	a,(hl)		; 
	call	J0265		; 
	ld	a,$80		; 
	ld	($2134),a	;  tmp_1 ($2134)
	jp	nz,J00fa	; 
J01ca:	ld	a,(hl)		; 
	and	$DF		; 
	cp	$4E		; 
J01cf:	jr	z,J01e1		; 
	cp	$0D		; 
	jr	z,J01dc		; 
	cp	$1A		; 
	jr	z,J01dc		; 
	jp	J046a		; 
;
J01dc:	xor	a		; 
	ld	($2134),a	;  tmp_1 ($2134)
	ret			; 
;
J01e1:	ld	a,$01		; 
	ld	($2134),a	;  tmp_1 ($2134)
	call	J031d		;  cbas_i (J031d)
	defw	$0020		;  COLLECT_NEXT_CHARACTER ($0020)
;
	ret			; 
;
J01ec:	ld	a,(hl)		; 
	and	$DF		; 
	cp	$44		; 
	jr	J01cf		; 
;
J01f3:	ld	a,($2134)	;  tmp_1 ($2134)
	ld	($2139),a	;  tmp_4 ($2139)
	and	a		; 
	jr	nz,J01ec	; 
	jr	J01dc		; 
;
J01fe:	xor	a		; 
	ld	($2134),a	;  tmp_1 ($2134)
	ld	a,(hl)		; 
	call	J0265		; 
	ret	z		; 
	cp	$CC		; 
	jp	nz,J046a	; 
	ld	($2134),a	;  tmp_1 ($2134)
	call	J031d		;  cbas_i (J031d)
	defw	$0020		;  COLLECT_NEXT_CHARACTER ($0020)
;
	jp	J00fa		; 
;
J0217:	ld	a,(hl)		; 
	cp	$3B		; 
	jp	nz,J046a	; 
	call	J031d		;  cbas_i (J031d)
	defw	$0020		;  COLLECT_NEXT_CHARACTER ($0020)
;
	ret			; 
;
J0223:	ld	hl,$213A	;  system_flags ($213A)
	set	2,(hl)		; 
	call	J031d		;  cbas_i (J031d)
	defw	$24FB		;  SCANNING ($24FB)
;
J022d:	res	2,(hl)		; 
	res	0,(hl)		; 
	pop	hl		; 
	pop	de		; 
	ld	hl,J022d	; 
	and	a		; 
	sbc	hl,de		; 
	jp	nz,J0462	; 
	bit	6,(iy+$01)	; 
	ret			; 
;
J0241:	ld	hl,$213A	;  system_flags ($213A)
	set	5,(hl)		; 
	call	J031d		;  cbas_i (J031d)
	defw	$1E94		;  FIND ($1E94)
;
J024b:	ld	hl,$213A	;  system_flags ($213A)
	set	5,(hl)		; 
	call	J031d		;  cbas_i (J031d)
	defw	$1E99		;  FIND ($1E99)
;
J0255:	res	5,(hl)		; 
	res	0,(hl)		; 
	pop	hl		; 
	pop	de		; 
	ld	hl,$1EA0	; 
	and	a		; 
	sbc	hl,de		; 
	ret	nz		; 
	jp	J0462		; 
;
J0265:	cp	$0D		; 
	ret	z		; 
	cp	$3A		; 
	ret			; 
;
D026b:
        defb    $CF,$0E,$FE,$02,$17,$07                                                 ; CAT
        defb    $EF,$1C,$06,$FE,$0A,$39,$0C                                             ; LOAD
        defb    $F8,$1A,$06,$FE,$0A,$EE,$09                                             ; SAVE
        defb    $D3,$00,$14,$02,$14,$04,$49,$4F,$41,$52,$00,$08,$06,$FE,$0A,$E5,$08     ; OPEN
        defb    $D4,$0C,$06,$FE,$0A,$D5,$08                                             ; CLOSE
        defb    $F5,$04,$23,$00,$00,$0A,$06,$FE,$0C,$48,$07                             ; PRINT
        defb    $EE,$04,$23,$00,$00,$14,$20,$FE,$00,$00,$00                             ; INPUT
        defb    $F0,$1E,$FE,$00,$80,$08                                                 ; LIST
        defb    $E5,$04,$23,$00,$00,$06,$FE,$0C,$53,$08                                 ; RESTORE
        defb    $D5,$02,$06,$FE,$0A,$A7,$0C                                             ; MERGE
        defb    $EC,$02,$16,$06,$FE,$0A,$44,$08                                         ; GOTO
        defb    $ED,$0E,$18,$06,$FE,$0A,$34,$08                                         ; GOSUB
        defb    $FC,$06,$FE,$0C,$4E,$08                                                 ; DRAW
        defb    $D0,$02,$12,$18,$06,$FE,$0A,$9E,$0E                                     ; FORMAT
        defb    $D2,$02,$10,$06,$FE,$0A,$BB,$08                                         ; ERASE
        defb    $F1,$02,$04,$AC,$00,$02,$06,$FE,$08,$69,$09                             ; LET
        defb    $D1,$02,$04,$AC,$00,$02,$06,$FE,$0A,$2F,$09                             ; MOVE
        defb    $E9,$02,$06,$FE,$06,$C6,$08                                             ; DIM
        defb    $AB,$02,$04,$50,$55,$56,$49,$00,$06,$FE,$04,$BA,$0E                     ; ATTR
        defb    $FF,$0E,$06,$FE,$08,$5E,$08                                             ; NEXT ( should be F3, not FF )
        defb    $FF                                                                     ; * EOT *
;
J031d:	ld	($213F),hl	;  cbas_i (J031d) ch_add_tmp ($213F)
	ld	($2141),de	;  cbas_de_tmp ($2141)
	pop	hl		; 
	ld	e,(hl)		; 
	inc	hl		; 
	ld	d,(hl)		; 
	inc	hl		; 
	push	hl		; 
	ld	hl,$213A	;  system_flags ($213A)
	set	0,(hl)		; 
	ld	hl,J0008	;  ti_on (J0008)
	push	hl		; 
	push	de		; 
	ld	hl,($213F)	;  ch_add_tmp ($213F)
	ld	de,($2141)	;  cbas_de_tmp ($2141)
	jp	J0603		;  ti_ret (J0603)
;
J033e:	inc	hl		; 
	ld	($213F),hl	;  ch_add_tmp ($213F)
	ld	a,(hl)		; 
	or	a		; 
	jr	z,J034c		; 
	ld	b,a		; 
J0347:	pop	hl		; 
J0348:	inc	sp		; 
	djnz	J0348		; 
	push	hl		; 
J034c:	ld	hl,($5C5D)	;  CH_ADD ($5C5D)
	ld	a,(hl)		; 
	call	J0265		; 
	jp	nz,J046a	; 
	ld	hl,($213F)	;  ch_add_tmp ($213F)
	call	J0663		; 
	ret	nz		; 
	ld	hl,$1BF4	;  STMT-NEXT ($1BF4)
	ex	(sp),hl		; 
	jp	J0603		;  ti_ret (J0603)
;
J0364:	ld	($2103),bc	;  putcom_i (J0364) reg_c ($2103)
	ld	($2105),de	;  reg_de ($2105)
	ld	($2107),hl	;  reg_hl ($2107)
	push	af		; 
	pop	hl		; 
	ld	($2101),hl	;  reg_f ($2101)
	ld	($2109),ix	;  reg_ix ($2109)
	ld	($210B),iy	;  reg_iy ($210B)
J037c:	ld	a,$C0		; 
	ld	($212F),a	;  block_type ($212F)
	ld	a,$0D		; 
	ld	($2130),a	;  block_len ($2130)
J0386:	ld	hl,$2100	;  command ($2100)
	call	J0495		;  putlock_i (J0495)
	ret	z		; 
	call	J0412		; 
	jr	c,J0386		; 
	jp	J046c		; 
;
J0395:	ld	($2130),a	;  putdat_i (J0395) block_len ($2130)
	ld	a,$D0		; 
	ld	($212F),a	;  block_type ($212F)
J039d:	ld	hl,$2000	;  bufdat ($2000)
	call	J0495		;  putlock_i (J0495)
	ret	z		; 
	call	J0412		; 
	jr	c,J039d		; 
	jp	J046c		; 
;
J03ac:	call	J04d6		;  getblock_i (J04d6) getheader_i (J03ac)
	jr	z,J03b9		; 
	call	J0412		; 
	jr	c,J03ac		;  getheader_i (J03ac)
	jp	J046a		; 
;
J03b9:	ld	a,($212F)	;  block_type ($212F)
	cp	$C0		; 
	jr	z,J03c2		; 
	and	a		; 
	ret			; 
;
J03c2:	ld	hl,($2101)	;  reg_f ($2101)
	push	hl		; 
	pop	af		; 
	ld	bc,($2103)	;  reg_c ($2103)
	ld	de,($2105)	;  reg_de ($2105)
	ld	hl,($2107)	;  reg_hl ($2107)
	ld	ix,($2109)	;  reg_ix ($2109)
	scf			; 
	ret			; 
;
J03d8:	push	hl		;  print_message (J03d8)
	ld	a,$FE		; 
	call	J031d		;  cbas_i (J031d)
	defw	$1601		;  CHAN_OPEN ($1601)
;
	ld	a,$FF		; 
	ld	($5C8C),a	;  SCR_CT ($5C8C)
	call	J0015		;  read_key (J0015)
	cp	$53		; 
	jr	nz,J03f3	; 
J03ec:	call	J0015		;  read_key (J0015)
	cp	$51		; 
	jr	nz,J03ec	; 
J03f3:	call	J0031		; 
	pop	hl		; 
	push	hl		; 
	ld	a,h		; 
	rra			; 
	ld	b,$00		; 
	jr	c,J0400		; 
	ld	b,$21		; 
J0400:	pop	hl		; 
	inc	b		; 
	ld	a,b		; 
	cp	$21		; 
	ret	z		; 
	ld	a,(hl)		; 
	or	a		; 
	ret	z		; 
	inc	hl		; 
	push	hl		; 
	call	J031d		;  cbas_i (J031d)
	defw	$0010		;  PRINT_CHAR ($0010)
;
	jr	J0400		; 
;
J0412:	ld	a,$7F		; 
	in	a,($FE)		; 
	rra			; 
	ret	c		; 
	ld	a,$FE		; 
	in	a,($FE)		; 
	rra			; 
	ret	c		; 
	ld	a,$14		; 
	ret			; 
;
J0421:	ld	($2102),a	;  reg_a ($2102)
	and	a		; 
	ret	z		; 
	cp	$81		; 
	ld	de,D043F	; 
	jr	z,J0433		; 
	cp	$4B		; 
	ld	de,D0452	; 
	ret	nz		; 
J0433:	push	hl		; 
	ld	hl,$210D	;  error_message ($210D)
	ex	de,hl		; 
	ld	bc,$0020	;  COLLECT_NEXT_CHARACTER ($0020)
	ldir			; 
	pop	hl		; 
	ret			; 
;
D043F:	defb	'Supersede (Y/N) ? '	; 
	defb	$00			; 
D0452:	defb	'Wrong data type'	; 
	defb	$00			; 
;
J0462:	ex	de,hl		; 
	call	J031d		;  cbas_i (J031d)
	defw	$007b		;  LD_A(HL) ($007b)
;
	jr	J046c		; 
;
J046a:	ld	a,$0B		; 
J046c:	ld	sp,($5C3D)	;  ERR_SP ($5C3D)
	ld	(iy+$00),a	; 
	ld	hl,($5C5D)	;  CH_ADD ($5C5D)
	ld	($5C5F),hl	;  X_PTR ($5C5F)
	ld	hl,$16C5	;  SET_STK ($16C5)
	push	hl		; 
	jp	J0603		;  ti_ret (J0603)
;
J0480:	ld	(iy+$00),$FF	; 
	ld	hl,$213A	;  system_flags ($213A)
	bit	1,(hl)		; 
	res	1,(hl)		; 
	jp	z,J0603		;  ti_ret (J0603)
J048e:	ld	hl,$1B76	;  STMT-RET ($1B76)
	push	hl		; 
	jp	J0603		;  ti_ret (J0603)
;
J0495:	push	de		;  putlock_i (J0495)
	push	bc		; 
	push	hl		; 
	ld	a,$0A		; 
	ld	($2132),a	;  counter ($2132)
J049d:	ld	hl,$212F	;  block_type ($212F)
	ld	b,$03		; 
	ld	c,$00		; 
	call	J052e		; 
	ld	a,($2130)	;  block_len ($2130)
	ld	b,a		; 
	pop	hl		; 
	push	hl		; 
	call	J052e		; 
	ld	a,c		; 
	neg			; 
	call	J052a		; 
	ld	hl,$2131	;  block_flag ($2131)
	call	J0581		; 
	ld	a,($2131)	;  block_flag ($2131)
	cp	$B0		; 
	jr	nz,J04c8	; 
	xor	a		; 
J04c4:	pop	hl		; 
	pop	bc		; 
	pop	de		; 
	ret			; 
;
J04c8:	ld	a,($2132)	;  counter ($2132)
	dec	a		; 
	ld	($2132),a	;  counter ($2132)
	jr	nz,J049d	; 
J04d1:	ld	a,$03		; 
	and	a		; 
	jr	J04c4		; 
;
J04d6:	push	de		;  getblock_i (J04d6)
	push	bc		; 
	push	hl		; 
	ld	a,$0A		; 
	ld	($2132),a	;  counter ($2132)
J04de:	ld	hl,$212F	;  block_type ($212F)
	ld	b,$03		; 
	ld	c,$00		; 
	call	J0583		; 
	ld	a,($212F)	;  block_type ($212F)
	cp	$C0		; 
	jr	z,J04f5		; 
	cp	$D0		; 
	jr	z,J04fa		; 
	jr	J04de		; 
;
J04f5:	ld	hl,$2100	;  command ($2100)
	jr	J04fd		; 
;
J04fa:	ld	hl,$2000	;  bufdat ($2000)
J04fd:	ld	a,($2130)	;  block_len ($2130)
	ld	b,a		; 
	call	J0583		; 
	ld	hl,$2131	;  block_flag ($2131)
	call	J0581		; 
	ld	a,c		; 
	and	a		; 
	jr	z,J0523		; 
	ld	a,($2132)	;  counter ($2132)
	dec	a		; 
	ld	($2132),a	;  counter ($2132)
	jr	z,J051e		; 
	ld	a,$E0		; 
	call	J052a		; 
	jr	J04de		; 
;
J051e:	ld	a,$04		; 
	and	a		; 
	jr	J04c4		; 
;
J0523:	ld	a,$B0		; 
	call	J052a		; 
	jr	J04c4		; 
;
J052a:	ld	b,$01		; 
	jr	J052f		; 
;
J052e:	ld	a,(hl)		; 
J052f:	ld	d,a		; 
	add	a,c		; 
	ld	c,a		; 
	push	bc		; 
	ld	a,d		; 
	and	$0F		; 
	out	($EF),a		; 
	ld	e,a		; 
	ld	a,d		; 
	and	$F0		; 
	rrca			; 
	rrca			; 
	rrca			; 
	rrca			; 
	ld	d,a		; 
	ld	bc,FLAG_MASK	; 
J0544:	in	a,($EF)		; 
	and	c		; 
	cp	FLAG_LOW	; 
	jr	z,J054f		; 
	djnz	J0544		; 
	jr	J0572		; 
;
J054f:	ld	a,e		; 
	or	FLAG_SEND	; 
	out	($EF),a		; 
	ld	b,$00		; 
J0556:	in	a,($EF)		; 
	and	c		; 
	cp	FLAG_HI		; 
	jr	z,J0561		; 
	djnz	J0556		; 
	jr	J0572		; 
;
J0561:	ld	a,d		; 
	or	FLAG_SEND	; 
	out	($EF),a		; 
	ld	a,d		; 
	out	($EF),a		; 
	ld	b,$00		; 
J056b:	in	a,($EF)		; 
	and	c		; 
	jr	z,J057b		; 
	djnz	J056b		; 
J0572:	ld	a,$00		; 
	out	($EF),a		; 
	pop	bc		; 
	pop	hl		; 
	jp	J04d1		; 
;
J057b:	pop	bc		; 
	inc	hl		; 
	djnz	J052e		; 
	xor	a		; 
	ret			; 
;
J0581:	ld	b,$01		; 
J0583:	push	bc		; 
	ld	a,FLAG_LOW	; 
	out	($EF),a		; 
	ld	bc,FLAG_MASK	; 
J058b:	in	a,($EF)		; 
	ld	e,a		; 
	and	c		; 
	cp	FLAG_SEND	; 
	jr	z,J0597		; 
	djnz	J058b		; 
	jr	J0572		; 
;
J0597:	ld	a,FLAG_HI	; 
	out	($EF),a		; 
	ld	b,$00		; 
J059d:	in	a,($EF)		; 
	ld	d,a		; 
	and	c		; 
	jr	z,J05a7		; 
	djnz	J059d		; 
	jr	J0572		; 
;
J05a7:	out	($EF),a		; 
	ld	a,e		; 
	and	$0F		; 
	ld	e,a		; 
	ld	a,d		; 
	and	$0F		; 
	rlca			; 
	rlca			; 
	rlca			; 
	rlca			; 
	or	e		; 
	ld	(hl),a		; 
	pop	bc		; 
	add	a,c		; 
	ld	c,a		; 
	inc	hl		; 
	djnz	J0583		; 
	xor	a		; 
	ret			; 
;
D05BE:	defb	'START'		; 
	defb	$00		; 
;
	ORG	$05CD
;
J05cd:	inc	l		; 
	push	hl		; 
	push	hl		; 
	ex	de,hl		; 
	ld	hl,RST128k	; 
	ld	bc,$0026	; 
	ldir			; 
	ret			; 

RST128k:
	.phase $7ffd

	push	bc		; 
	pop	iy		; 
J05dd:	dec	bc		; 
	inc	b		; 
	djnz	J05dd		; 
	pop	bc		; 
	ld	a,$10		; 
	out	(c),a		; 
	call	J0604		;  ti_ret_noei (J0604)
	ld	a,($3880)	; 
	inc	a		; 
	jr	nz,J05f3	; 
J05ef:	rst	8		; 
	jp	J0ee1		; 
;
J05f3:	ld	a,$EF		; 
	in	a,($FE)		; 
	rra			; 
	jr	c,J05ef		; 
	xor	a		; 
	out	(c),a		; 
	jp	$00c7		;  ROM128_RST0 ($00c7)

	.dephase

	ORG	$0603
;
J0603:	ei			;  ti_ret (J0603)
J0604:	ret			;  ti_ret_noei (J0604)
;
	jp	J0395		;  putdat_i (J0395)
	jp	J0364		;  putcom_i (J0364)
	jp	J03ac		;  getheader_i (J03ac)
	jp	J0495		;  putlock_i (J0495)
	jp	J04d6		;  getblock_i (J04d6)
	jp	J0d94		;  getrec_i (J0d94)
	jp	J0dbf		;  rdmem_i (J0dbf)
	jp	J0b54		;  wrmem_i (J0b54)
	jp	J031d		;  cbas_i (J031d)
	jp	J0a61		;  savep_i (J0a61)
	jp	J0cc1		;  loadp_i (J0cc1)
	jp	J0688		;  interact_i (J0688)
;
J0629:	ld	a,($2136)	;  tmp_2 ($2136)
	bit	7,a		; 
	ret	nz		; 
	ld	hl,($2149)	;  txt_addr ($2149)
J0632:	call	J0663		; 
	ret	z		; 
	push	hl		; 
	inc	hl		; 
	ld	c,(hl)		; 
	inc	hl		; 
	ld	b,(hl)		; 
	inc	bc		; 
	inc	bc		; 
	inc	bc		; 
	pop	hl		; 
	call	J031d		;  cbas_i (J031d)
	defw	$19E8		;  RECLAIM_2 ($19E8)
;
	ret			; 
;
J0645:	ld	hl,$213A	;  system_flags ($213A)
	set	4,(hl)		; 
	call	J031d		;  cbas_i (J031d)
	defw	$28B2		;  LOOK-VARS ($28B2)
;
J064f:	res	4,(hl)		; 
	res	0,(hl)		; 
	pop	hl		; 
	ex	(sp),hl		; 
	push	af		; 
	ld	de,J064f	; 
	ex	de,hl		; 
	and	a		; 
	sbc	hl,de		; 
	jp	nz,J0462	; 
	pop	af		; 
	pop	hl		; 
	ret			; 
;
J0663:	bit	7,(iy+$01)	; 
	ret			; 
;
J0668:	call	J031d		;  cbas_i (J031d)
	defw	$2BF1		;  STK-FETCH ($2BF1)
;
J066d:	ld	hl,$2000	;  copy_txt_to_buf (J066d) bufdat ($2000)
J0670:	push	hl		; 
	and	a		; 
	ld	hl,$0040	; 
	sbc	hl,bc		; 
	pop	hl		; 
	jr	c,J0682		; 
	ld	a,b		; 
	or	c		; 
	jr	z,J0682		; 
	ex	de,hl		; 
	ldir			; 
	ex	de,hl		; 
J0682:	ld	(hl),$00	; 
	inc	hl		; 
	inc	a		; 
	ld	b,a		; 
	ret			; 
;
J0688:	call	J03ac		;  interact_i (J0688) getheader_i (J03ac)
	jr	nc,J0688	;  interact_i (J0688)
	ld	a,($2100)	;  command ($2100)
	cp	$80		; 
	ret	z		; 
	cp	$83		; 
	jr	z,J06b1		; 
	cp	$82		; 
	jr	z,J06a4		; 
	cp	$81		; 
	jr	nz,J0688	;  interact_i (J0688)
	call	J06d5		; 
	jr	J06c8		; 
;
J06a4:	call	J06d5		; 
J06a7:	ld	a,$BF		; 
	in	a,($FE)		; 
	bit	0,a		; 
	jr	nz,J06a7	; 
	jr	J06c8		; 
;
J06b1:	call	J06d5		; 
J06b4:	call	J031d		;  cbas_i (J031d)
	defw	$028e		;  KEYBOARD_SCANNING ($028e)
;
	inc	de		; 
	ld	a,d		; 
	or	e		; 
	jr	nz,J06b4	; 
J06be:	call	J0015		;  read_key (J0015)
	jr	z,J06be		; 
	call	J031d		;  cbas_i (J031d)
	defw	$0010		;  PRINT_CHAR ($0010)
;
J06c8:	ld	a,$91		; 
	ld	($2100),a	;  command ($2100)
	ld	a,($5C08)	;  LAST_K ($5C08)
	call	J0364		;  putcom_i (J0364)
	jr	J0688		;  interact_i (J0688)
;
J06d5:	ld	hl,$2000	;  bufdat ($2000)
	call	J03d8		;  print_message (J03d8)
	ret			; 
;
J06dc:	call	J0688		;  interact_i (J0688)
J06df:	ld	hl,($213D)	;  return_proc ($213D)
	jp	(hl)		; 
;
J06e3:	bit	7,(iy+$0C)	; 
	jr	z,J06ec		; 
	call	J0031		; 
J06ec:	ld	a,($2102)	;  reg_a ($2102)
	ld	b,a		; 
	ld	a,($5CB1)	;  NMIADD_HI ($5CB1)
	cp	$00		; 
	ld	a,b		; 
	jr	nz,J0711	; 
	or	a		; 
	jp	z,J0480		; 
	call	J0031		; 
	call	J0031		; 
	ld	hl,$210D	;  error_message ($210D)
	call	J03d8		;  print_message (J03d8)
	call	J0031		; 
	call	J0031		; 
	jp	J046a		; 
;
J0711:	ld	($5CB0),a	;  NMIADD_LO ($5CB0)
	jp	J0480		; 
;
	ld	a,($2134)	;  tmp_1 ($2134)
	or	a		; 
	jr	z,J072b		; 
	call	J0668		; 
	call	J0395		;  putdat_i (J0395)
	ld	a,$0C		; 
J0725:	ld	($2100),a	;  command ($2100)
	jp	J0364		;  putcom_i (J0364)
;
J072b:	ld	a,$0B		; 
	jr	J0725		; 
;
J072f:	ld	a,$13		; 
	ld	($2100),a	;  command ($2100)
	ld	a,($2134)	;  tmp_1 ($2134)
	ld	($212E),a	;  channel ($212E)
	call	J0364		;  putcom_i (J0364)
J073d:	call	J03ac		;  getheader_i (J03ac)
	jr	nc,J073d	; 
	ret			; 
;
J0743:	ld	hl,($213D)	;  return_proc ($213D)
	ex	(sp),hl		; 
	ret			; 
;
	call	J072f		; 
	jr	nz,J0743	; 
	ld	a,($2004)	;  bufdat_4 ($2004)
	or	a		; 
	jr	z,J0775		; 
	ld	hl,($214B)	;  rec_num ($214B)
	ld	a,h		; 
	or	l		; 
	jr	nz,J0743	; 
	call	J077f		; 
	jr	nc,J0743	; 
	ld	($214B),bc	;  rec_num ($214B)
	ld	a,c		; 
J0764:	call	J0395		;  putdat_i (J0395)
	ld	c,$00		; 
	ld	a,($2134)	;  tmp_1 ($2134)
	ld	b,a		; 
	ld	de,($214B)	;  rec_num ($214B)
	ld	a,$0F		; 
	jr	J0725		; 
;
J0775:	ld	a,($200C)	;  bufdat_12 ($200C)
	push	af		; 
	call	J077f		; 
	pop	af		; 
	jr	J0764		; 
;
J077f:	ld	hl,$2000	;  bufdat ($2000)
	ld	b,$00		; 
J0784:	ld	(hl),$20	; 
	inc	hl		; 
	djnz	J0784		; 
	call	J031d		;  cbas_i (J031d)
	defw	$2BF1		;  STK-FETCH ($2BF1)
;
	ld	a,b		; 
	or	c		; 
	jr	nz,J0793	; 
	ret			; 
;
J0793:	ld	a,b		; 
	or	a		; 
	jr	z,J079a		; 
	ld	bc,$0100	; 
J079a:	push	bc		; 
	ld	hl,$2000	;  bufdat ($2000)
	ex	de,hl		; 
	ldir			; 
	pop	bc		; 
	scf			; 
	ret			; 
;
J07a4:	call	J0645		; 
	ld	a,(hl)		; 
	jr	nc,J07bc	; 
	cp	$61		; 
	jr	c,J07b0		; 
	sub	$20		; 
J07b0:	or	$80		; 
	ld	b,a		; 
	inc	hl		; 
	ld	a,(hl)		; 
	cp	$24		; 
	jp	nz,J046a	; 
	dec	hl		; 
	ld	a,b		; 
J07bc:	ld	($2136),a	;  tmp_2 ($2136)
	ld	($2149),hl	;  txt_addr ($2149)
	bit	7,(hl)		; 
	jr	z,J07ce		; 
	inc	hl		; 
	inc	hl		; 
	inc	hl		; 
	ld	a,(hl)		; 
	dec	a		; 
	jp	nz,J046a	; 
J07ce:	ld	a,c		; 
	and	$60		; 
	cp	$40		; 
	jp	nz,J046a	; 
	call	J0182		; 
	call	J0149		; 
	ld	b,$10		; 
	call	J0347		; 
	ld	hl,J06df	; 
	push	hl		; 
	call	J072f		; 
	ret	nz		; 
	ld	a,($2004)	;  bufdat_4 ($2004)
	or	a		; 
	jr	nz,J0818	; 
	ld	a,($2134)	;  tmp_1 ($2134)
	ld	de,($214B)	;  rec_num ($214B)
	ld	c,$00		; 
J07f8:	call	J0d94		;  getrec_i (J0d94)
	push	bc		; 
	call	J0629		; 
	pop	bc		; 
	call	J081f		; 
	ld	a,($2136)	;  tmp_2 ($2136)
	and	$7F		; 
	ld	(hl),a		; 
	inc	hl		; 
	ld	(hl),c		; 
	inc	hl		; 
	ld	(hl),b		; 
	inc	hl		; 
	ld	de,$2000	;  bufdat ($2000)
	ex	de,hl		; 
	ld	a,b		; 
	or	c		; 
	ret	z		; 
	ldir			; 
	ret			; 
;
J0818:	ld	de,$0000	; 
	ld	c,$FF		; 
	jr	J07f8		; 
;
J081f:	push	bc		; 
	ld	a,c		; 
	add	a,$03		; 
	ld	c,a		; 
	jr	nc,J0827	; 
	inc	b		; 
J0827:	ld	hl,($5C59)	;  E_LINE ($5C59)
	dec	hl		; 
	push	hl		; 
	call	J031d		;  cbas_i (J031d)
	defw	$1655		;  MAKE_ROOM ($1655)
;
	pop	hl		; 
	pop	bc		; 
	ret			; 
;
	ld	a,$0A		; 
	call	J0725		; 
	ld	a,($2139)	;  tmp_4 ($2139)
	or	a		; 
	ret	z		; 
	call	J0e7e		; 
	jp	nz,J06df	; 
	call	J0668		; 
	call	J0395		;  putdat_i (J0395)
	ld	a,$07		; 
	jr	J0855		; 
;
	ld	a,$09		; 
	jp	J0725		; 
;
	ld	a,$16		; 
J0855:	ld	($2100),a	;  command ($2100)
	ld	a,($2134)	;  tmp_1 ($2134)
	jp	J0364		;  putcom_i (J0364)
;
	ld	a,($2134)	;  tmp_1 ($2134)
	and	a		; 
	ld	a,$1F		; 
	jp	z,J0725		; 
	call	J0668		; 
	call	J0395		;  putdat_i (J0395)
	ld	a,$20		; 
	jp	J0725		; 
;
J0872:	ld	hl,($5C5D)	;  CH_ADD ($5C5D)
	ld	a,(hl)		; 
	cp	$23		; 
	jr	z,J0894		; 
	call	J0265		; 
	jp	nz,J046a	; 
	ld	a,$03		; 
J0882:	ld	($2100),a	;  command ($2100)
	ld	b,$0E		; 
	call	J0347		; 
	ld	hl,J06dc	; 
	push	hl		; 
	call	J0149		; 
	jp	J037c		; 
;
J0894:	call	J031d		;  cbas_i (J031d)
	defw	$0020		;  COLLECT_NEXT_CHARACTER ($0020)
;
	ld	hl,($5C5D)	;  CH_ADD ($5C5D)
	ld	a,(hl)		; 
	call	J0265		; 
	jr	nz,J08a6	; 
	ld	a,$0E		; 
	jr	J0882		; 
;
J08a6:	call	J0223		; 
	jp	z,J046c		; 
	call	J0663		; 
	jr	z,J0882		; 
	call	J0241		; 
	ld	($2104),a	;  reg_b ($2104)
	ld	a,$0D		; 
	jr	J0882		; 
;
	call	J0668		; 
	call	J0395		;  putdat_i (J0395)
	ld	a,$04		; 
	jp	J0855		; 
;
	call	J0668		; 
	call	J0395		;  putdat_i (J0395)
	ld	a,$02		; 
	ld	($2100),a	;  command ($2100)
	xor	a		; 
	jp	J0364		;  putcom_i (J0364)
;
	ld	a,($2134)	;  tmp_1 ($2134)
	cp	$80		; 
	jr	nc,J08e1	; 
	ld	a,$01		; 
J08de:	jp	J0855		; 
;
J08e1:	ld	a,$1D		; 
	jr	J08de		; 
;
	ld	a,($2136)	;  tmp_2 ($2136)
	ld	d,$00		; 
	cp	$49		; 
	jr	nz,J08f2	; 
	set	0,d		; 
	jr	J0909		; 
;
J08f2:	cp	$4F		; 
	jr	nz,J08fa	; 
	set	1,d		; 
	jr	J0909		; 
;
J08fa:	cp	$52		; 
	jr	nz,J0904	; 
	set	0,d		; 
	set	1,d		; 
	jr	J0909		; 
;
J0904:	cp	$41		; 
	jp	nz,J046a	; 
J0909:	ld	a,d		; 
	ld	($2136),a	;  tmp_2 ($2136)
	call	J031d		;  cbas_i (J031d)
	defw	$2BF1		;  STK-FETCH ($2BF1)
;
	call	J066d		;  copy_txt_to_buf (J066d)
	call	J0395		;  putdat_i (J0395)
	ld	e,$01		; 
	ld	a,($213A)	;  system_flags ($213A)
	bit	3,a		; 
	jr	z,J0926		; 
	dec	e		; 
	ld	ix,($214B)	;  rec_num ($214B)
J0926:	ld	a,($2136)	;  tmp_2 ($2136)
	ld	d,a		; 
	ld	a,$00		; 
	jp	J0855		; 
;
	ld	hl,$1720	; 
	ld	($5C82),hl	;  ECHO_E ($5C82)
	ld	hl,$50E0	; 
	ld	($5C86),hl	;  DF_CCL ($5C86)
	ld	hl,$1721	; 
	ld	($5C8A),hl	;  S_POSNL ($5C8A)
	ld	a,$06		; 
J0943:	ld	($2100),a	;  command ($2100)
	call	J031d		;  cbas_i (J031d)
	defw	$2BF1		;  STK-FETCH ($2BF1)
;
	ld	hl,$2080	; 
	push	bc		; 
	push	hl		; 
	call	J0670		; 
	call	J0668		; 
	ex	de,hl		; 
	pop	hl		; 
	pop	bc		; 
	add	a,c		; 
	inc	a		; 
	ldir			; 
	ex	de,hl		; 
	ld	(hl),$00	; 
	call	J0395		;  putdat_i (J0395)
	ld	a,($2102)	;  reg_a ($2102)
	jp	J0364		;  putcom_i (J0364)
;
	ld	a,$05		; 
	jr	J0943		; 
;
J096d:	call	J0223		; 
	jr	nz,J098b	; 
	ld	hl,($5C5D)	;  CH_ADD ($5C5D)
	ld	a,(hl)		; 
	ld	($2133),a	;  file_type ($2133)
	cp	$CA		; 
	jr	z,J098e		; 
	cp	$AF		; 
	jr	z,J099c		; 
	cp	$AA		; 
	jr	z,J09bc		; 
	cp	$E4		; 
	jr	z,J09c5		; 
	jr	J09e5		; 
;
J098b:	jp	J046a		; 
;
J098e:	call	J031d		;  cbas_i (J031d)
	defw	$0020		;  COLLECT_NEXT_CHARACTER ($0020)
;
	call	J0223		; 
	jr	z,J098b		; 
	ld	a,$02		; 
	jr	J09e5		; 
;
J099c:	call	J031d		;  cbas_i (J031d)
	defw	$0020		;  COLLECT_NEXT_CHARACTER ($0020)
;
	call	J0223		; 
	jr	z,J098b		; 
	ld	hl,($5C5D)	;  CH_ADD ($5C5D)
	ld	a,(hl)		; 
	cp	$2C		; 
	jr	nz,J098b	; 
	call	J031d		;  cbas_i (J031d)
	defw	$0020		;  COLLECT_NEXT_CHARACTER ($0020)
;
	call	J0223		; 
	jr	z,J098b		; 
	ld	a,$03		; 
	jr	J09e5		; 
;
J09bc:	call	J031d		;  cbas_i (J031d)
	defw	$0020		;  COLLECT_NEXT_CHARACTER ($0020)
;
	ld	a,$04		; 
	jr	J09e5		; 
;
J09c5:	call	J031d		;  cbas_i (J031d)
	defw	$0020		;  COLLECT_NEXT_CHARACTER ($0020)
;
	call	J0645		; 
	jr	c,J098b		; 
	ld	a,c		; 
	and	$60		; 
	jr	z,J09d8		; 
	cp	$40		; 
	jr	nz,J098b	; 
J09d8:	ld	($2145),hl	;  rec_len ($2145)
	ld	hl,($5C5D)	;  CH_ADD ($5C5D)
	inc	hl		; 
	inc	hl		; 
	ld	($5C5D),hl	;  CH_ADD ($5C5D)
	ld	a,$05		; 
J09e5:	ld	($2133),a	;  file_type ($2133)
	ld	hl,($5C5D)	;  CH_ADD ($5C5D)
	jp	J01ca		; 
;
	ld	hl,J06df	; 
	ex	(sp),hl		; 
	ld	a,($2133)	;  file_type ($2133)
	cp	$05		; 
	jp	z,J0a47		; 
	cp	$04		; 
	jp	z,J0a3d		; 
	cp	$03		; 
	jp	z,J0a28		; 
	cp	$02		; 
	jp	z,J0a22		; 
	ld	hl,$0000	; 
	push	hl		; 
J0a0d:	call	J0668		; 
	ex	af,af'		; 
	ld	hl,($5C53)	;  PROG ($5C53)
	ex	de,hl		; 
	ld	hl,($5C59)	;  E_LINE ($5C59)
	scf			; 
	sbc	hl,de		; 
	ld	b,h		; 
	ld	c,l		; 
	pop	hl		; 
	ld	a,$00		; 
	jr	J0a61		;  savep_i (J0a61)
;
J0a22:	call	J024b		; 
	push	bc		; 
	jr	J0a0d		; 
;
J0a28:	call	J024b		; 
	push	bc		; 
	call	J024b		; 
	push	bc		; 
J0a30:	call	J0668		; 
	ex	af,af'		; 
	pop	de		; 
	pop	bc		; 
	ld	hl,$0000	; 
	ld	a,$03		; 
	jr	J0a61		;  savep_i (J0a61)
;
J0a3d:	ld	hl,$1B00	; 
	push	hl		; 
	ld	hl,$4000	; 
	push	hl		; 
	jr	J0a30		; 
;
J0a47:	call	J0668		; 
	ex	af,af'		; 
	ld	hl,($2145)	;  rec_len ($2145)
	bit	6,(hl)		; 
	ld	a,$01		; 
	jr	z,J0a56		; 
	ld	a,$02		; 
J0a56:	inc	hl		; 
	ld	c,(hl)		; 
	inc	hl		; 
	ld	b,(hl)		; 
	dec	hl		; 
	inc	bc		; 
	inc	bc		; 
	ex	de,hl		; 
	ld	hl,$0000	; 
J0a61:	push	hl		;  savep_i (J0a61)
	push	de		; 
	push	bc		; 
	push	af		; 
	ld	($2147),de	;  rec_addr ($2147)
	ld	($2145),bc	;  rec_len ($2145)
	ld	a,$12		; 
	ld	($2100),a	;  command ($2100)
	call	J0364		;  putcom_i (J0364)
	call	J0e7e		; 
	jr	nz,J0ac9	; 
	ld	a,($2104)	;  reg_b ($2104)
	ld	($212E),a	;  channel ($212E)
	ex	af,af'		; 
	call	J0395		;  putdat_i (J0395)
	ld	a,$02		; 
	ld	($2100),a	;  command ($2100)
	ld	a,$01		; 
	call	J0b4e		; 
	jr	z,J0ad9		; 
	cp	$21		; 
	jr	z,J0ad9		; 
	cp	$20		; 
	jr	z,J0ad9		; 
	cp	$23		; 
	jr	nz,J0ac9	; 
	ld	a,($2134)	;  tmp_1 ($2134)
	and	a		; 
	jr	nz,J0ad1	; 
	ld	hl,$210D	;  error_message ($210D)
	push	hl		; 
	call	J03d8		;  print_message (J03d8)
	ld	a,$81		; 
	ld	($2102),a	;  reg_a ($2102)
	call	J0421		; 
	pop	hl		; 
	call	J03d8		;  print_message (J03d8)
J0ab5:	call	J0015		;  read_key (J0015)
	cp	$59		; 
	jr	z,J0acc		; 
	cp	$4E		; 
	jr	nz,J0ab5	; 
	call	J031d		;  cbas_i (J031d)
	defw	$0010		;  PRINT_CHAR ($0010)
;
	xor	a		; 
	ld	($2102),a	;  reg_a ($2102)
J0ac9:	jp	J0b36		; 
;
J0acc:	call	J031d		;  cbas_i (J031d)
	defw	$0010		;  PRINT_CHAR ($0010)
;
J0ad1:	call	J0b3f		; 
	call	z,J0b46		; 
	jr	nz,J0ac9	; 
J0ad9:	call	J0b3f		; 
	jr	nz,J0ac9	; 
	pop	af		; 
	pop	bc		; 
	pop	de		; 
	pop	hl		; 
	push	hl		; 
	push	de		; 
	push	bc		; 
	push	af		; 
	ld	($2000),a	;  bufdat ($2000)
	cp	$00		; 
	jr	nz,J0b01	; 
	ld	($2001),hl	;  bufdat_1 ($2001)
	ld	hl,($5C4B)	;  VARS ($5C4B)
	and	a		; 
	sbc	hl,de		; 
	ld	($2005),hl	;  bufdat_5 ($2005)
	ld	($2003),bc	;  bufdat_3 ($2003)
	ld	a,$07		; 
	jr	J0b0b		; 
;
J0b01:	ld	($2001),bc	;  bufdat_1 ($2001)
	ld	($2003),de	;  bufdat_3 ($2003)
	ld	a,$05		; 
J0b0b:	ld	($212D),a	;  header_len ($212D)
	call	J0395		;  putdat_i (J0395)
	ld	a,($212E)	;  channel ($212E)
	ld	b,a		; 
	ld	c,$00		; 
	ld	d,c		; 
	ld	a,($212D)	;  header_len ($212D)
	ld	e,a		; 
	ld	a,$0F		; 
	ld	($2100),a	;  command ($2100)
	call	J0b4e		; 
	jr	nz,J0b2c	; 
	call	J0b54		;  wrmem_i (J0b54)
	jr	nz,J0b2c	; 
	xor	a		; 
J0b2c:	push	af		; 
	call	J0b46		; 
	jr	z,J0b35		; 
	pop	hl		; 
	jr	J0b36		; 
;
J0b35:	pop	af		; 
J0b36:	or	a		; 
	call	J0421		; 
	pop	af		; 
	pop	bc		; 
	pop	de		; 
	pop	hl		; 
	ret			; 
;
J0b3f:	ld	de,$0201	; 
J0b42:	ld	a,$00		; 
	jr	J0b48		; 
;
J0b46:	ld	a,$01		; 
J0b48:	ld	($2100),a	;  command ($2100)
	ld	a,($212E)	;  channel ($212E)
J0b4e:	call	J0364		;  putcom_i (J0364)
	jp	J0e7e		; 
;
J0b54:	push	bc		;  wrmem_i (J0b54)
	push	de		; 
	push	hl		; 
J0b57:	ld	hl,($2145)	;  rec_len ($2145)
	ld	bc,$0100	; 
	or	a		; 
	sbc	hl,bc		; 
	jr	nc,J0b6e	; 
	ld	hl,($2145)	;  rec_len ($2145)
	ld	a,h		; 
	or	l		; 
	jr	z,J0ba2		; 
	ld	c,l		; 
	ld	b,h		; 
	ld	hl,$0000	; 
J0b6e:	ld	($2145),hl	;  rec_len ($2145)
	ld	de,$2000	;  bufdat ($2000)
	ld	hl,($2147)	;  rec_addr ($2147)
	push	bc		; 
	ldir			; 
	ld	($2147),hl	;  rec_addr ($2147)
	pop	bc		; 
	ld	a,c		; 
	push	bc		; 
	call	J0395		;  putdat_i (J0395)
	pop	de		; 
	jr	nz,J0b9f	; 
	ld	a,($212E)	;  channel ($212E)
	ld	b,a		; 
	ld	c,$00		; 
	ld	a,$0F		; 
	ld	($2100),a	;  command ($2100)
	call	J0364		;  putcom_i (J0364)
	jr	nz,J0b9f	; 
	call	J0e7e		; 
	jr	c,J0b9f		; 
	jr	nz,J0ba3	; 
	jr	J0b57		; 
;
J0b9f:	scf			; 
	jr	J0ba4		; 
;
J0ba2:	xor	a		; 
J0ba3:	or	a		; 
J0ba4:	pop	hl		; 
	pop	de		; 
	pop	bc		; 
	ret			; 
;
J0ba8:	call	J0223		; 
	jr	nz,J0bc4	; 
	ld	hl,($5C5D)	;  CH_ADD ($5C5D)
	ld	a,(hl)		; 
	ld	($2133),a	;  file_type ($2133)
	call	J0265		; 
	ret	z		; 
	cp	$AF		; 
	jr	z,J0bc7		; 
	cp	$AA		; 
	jr	z,J0bf4		; 
	cp	$E4		; 
	jr	z,J0bfd		; 
J0bc4:	jp	J046a		; 
;
J0bc7:	call	J031d		;  cbas_i (J031d)
	defw	$0020		;  COLLECT_NEXT_CHARACTER ($0020)
;
	call	J0265		; 
	jr	z,J0be2		; 
	call	J0223		; 
	jr	z,J0bc4		; 
	ld	hl,($5C5D)	;  CH_ADD ($5C5D)
	ld	a,(hl)		; 
	cp	$2C		; 
	jr	z,J0be6		; 
	ld	a,$02		; 
	jr	J0c35		; 
;
J0be2:	ld	a,$15		; 
	jr	J0c35		; 
;
J0be6:	call	J031d		;  cbas_i (J031d)
	defw	$0020		;  COLLECT_NEXT_CHARACTER ($0020)
;
	call	J0223		; 
	jr	z,J0bc4		; 
	ld	a,$16		; 
	jr	J0c35		; 
;
J0bf4:	call	J031d		;  cbas_i (J031d)
	defw	$0020		;  COLLECT_NEXT_CHARACTER ($0020)
;
	ld	a,$03		; 
	jr	J0c35		; 
;
J0bfd:	call	J031d		;  cbas_i (J031d)
	defw	$0020		;  COLLECT_NEXT_CHARACTER ($0020)
;
	call	J0645		; 
	ld	($214E),hl	;  file_len ($214E)
	ld	a,$00		; 
J0c0a:	jr	c,J0c0e		; 
	ld	a,$80		; 
J0c0e:	ld	($2139),a	;  tmp_4 ($2139)
	ld	a,c		; 
	set	7,a		; 
	ld	($2136),a	;  tmp_2 ($2136)
	and	$60		; 
	jr	z,J0c26		; 
	cp	$40		; 
	jr	z,J0c22		; 
	pop	af		; 
	jr	J0bc4		; 
;
J0c22:	ld	a,$02		; 
	jr	J0c28		; 
;
J0c26:	ld	a,$01		; 
J0c28:	ld	($2134),a	;  tmp_1 ($2134)
	ld	hl,($5C5D)	;  CH_ADD ($5C5D)
	inc	hl		; 
	inc	hl		; 
	ld	($5C5D),hl	;  CH_ADD ($5C5D)
	ld	a,$04		; 
J0c35:	ld	($2133),a	;  file_type ($2133)
	ret			; 
;
	ld	hl,J06df	; 
	ex	(sp),hl		; 
	ld	a,($2133)	;  file_type ($2133)
	cp	$04		; 
	jr	z,J0c9c		; 
	cp	$03		; 
	jr	z,J0c8e		; 
	cp	$16		; 
	jr	z,J0c7e		; 
	cp	$15		; 
	jr	z,J0c70		; 
	cp	$02		; 
	jr	z,J0c58		; 
J0c54:	ld	a,$00		; 
	jr	J0c68		; 
;
J0c58:	call	J024b		; 
	ld	($2150),bc	;  file_start ($2150)
	ld	bc,$0000	; 
	ld	($214E),bc	;  file_len ($214E)
J0c66:	ld	a,$03		; 
J0c68:	ld	($214D),a	;  file_typ ($214D)
	call	J0668		; 
	jr	J0cc1		;  loadp_i (J0cc1)
;
J0c70:	ld	hl,$FFFF	; 
	ld	($214E),hl	;  file_len ($214E)
	ld	hl,$0000	; 
	ld	($2150),hl	;  file_start ($2150)
	jr	J0c66		; 
;
J0c7e:	call	J024b		; 
	ld	($214E),bc	;  file_len ($214E)
	call	J024b		; 
	ld	($2150),bc	;  file_start ($2150)
	jr	J0c66		; 
;
J0c8e:	ld	hl,$1B00	; 
	ld	($214E),hl	;  file_len ($214E)
	ld	hl,$4000	; 
	ld	($2150),hl	;  file_start ($2150)
	jr	J0c66		; 
;
J0c9c:	ld	a,($2134)	;  tmp_1 ($2134)
	ld	($214D),a	;  file_typ ($214D)
	call	J0668		; 
	jr	J0cc1		;  loadp_i (J0cc1)
;
	ld	a,$80		; 
	ld	($2138),a	;  tmp_3 ($2138)
	ld	hl,J06df	; 
	ex	(sp),hl		; 
	call	J0c54		; 
	ld	a,($2102)	;  reg_a ($2102)
	or	a		; 
	ret	nz		; 
	ld	hl,($213F)	;  ch_add_tmp ($213F)
	call	J031d		;  cbas_i (J031d)
	defw	$08ce		;  MERGE ($08ce)
;
	ret			; 
;
J0cc1:	ld	ix,$214D	;  loadp_i (J0cc1) file_typ ($214D)
	ld	a,$12		; 
	ld	($2100),a	;  command ($2100)
	call	J0b4e		; 
	jp	nz,J0d91	; 
	ld	a,($2104)	;  reg_b ($2104)
	ld	($212E),a	;  channel ($212E)
	ld	a,b		; 
	call	J0395		;  putdat_i (J0395)
	ld	de,$0101	; 
	call	J0b42		; 
	jp	nz,J0d91	; 
	ld	de,$0001	; 
	call	J0d94		;  getrec_i (J0d94)
	jp	nz,J0d84	; 
	ld	a,(hl)		; 
	cp	(ix+$00)	; 
	jr	nz,J0cfa	; 
	cp	$00		; 
	jr	z,J0cff		; 
	cp	$04		; 
	jr	c,J0d04		; 
J0cfa:	ld	a,$4B		; 
	jp	J0d84		; 
;
J0cff:	ld	de,$0006	; 
	jr	J0d07		; 
;
J0d04:	ld	de,$0004	; 
J0d07:	ld	a,e		; 
	ld	($212D),a	;  header_len ($212D)
	call	J0d94		;  getrec_i (J0d94)
	jr	nz,J0d84	; 
	ld	a,(ix+$00)	; 
	cp	$00		; 
	jr	z,J0d21		; 
	cp	$03		; 
	jr	z,J0d59		; 
	jr	c,J0d3b		; 
	ld	a,$4B		; 
	jr	J0d84		; 
;
J0d21:	push	ix		; 
	pop	de		; 
	inc	de		; 
	ld	bc,$0006	; 
	ldir			; 
	call	J0e01		; 
	or	a		; 
	jr	nz,J0d84	; 
	ld	l,(ix+$03)	; 
	ld	h,(ix+$04)	; 
	ld	($2145),hl	;  rec_len ($2145)
	jr	J0d81		; 
;
J0d3b:	ld	hl,($214E)	;  file_len ($214E)
	ld	a,($2139)	;  tmp_4 ($2139)
	or	a		; 
	call	nz,J0632	; 
	ld	hl,($2000)	;  bufdat ($2000)
	ld	($2145),hl	;  rec_len ($2145)
	ld	c,l		; 
	ld	b,h		; 
	dec	bc		; 
	dec	bc		; 
	call	J081f		; 
	ld	a,($2136)	;  tmp_2 ($2136)
	ld	(hl),a		; 
	inc	hl		; 
	jr	J0d7e		; 
;
J0d59:	ld	e,(ix+$01)	; 
	ld	d,(ix+$02)	; 
	ld	hl,($2000)	;  bufdat ($2000)
	ld	($2145),hl	;  rec_len ($2145)
	ld	a,e		; 
	or	d		; 
	jr	z,J0d71		; 
	sbc	hl,de		; 
	jr	c,J0d71		; 
	ld	($2145),de	;  rec_len ($2145)
J0d71:	ld	l,(ix+$03)	; 
	ld	h,(ix+$04)	; 
	ld	a,l		; 
	or	h		; 
	jr	nz,J0d7e	; 
	ld	hl,($2002)	;  bufdat_2 ($2002)
J0d7e:	ld	($2147),hl	;  rec_addr ($2147)
J0d81:	call	J0dbf		;  rdmem_i (J0dbf)
J0d84:	push	af		; 
	call	J0b46		; 
	jr	nz,J0d90	; 
	pop	af		; 
	ld	($2102),a	;  reg_a ($2102)
	jr	J0d91		; 
;
J0d90:	pop	hl		; 
J0d91:	jp	J0421		; 
;
J0d94:	push	de		;  getrec_i (J0d94)
	ld	a,($212E)	;  channel ($212E)
	ld	b,a		; 
	ld	a,$10		; 
	ld	($2100),a	;  command ($2100)
	call	J0364		;  putcom_i (J0364)
	jr	nz,J0dbc	; 
J0da3:	call	J03ac		;  getheader_i (J03ac)
	jr	nc,J0da3	; 
	ld	a,($2100)	;  command ($2100)
	cp	$80		; 
	jr	nz,J0dbc	; 
	ld	a,($2102)	;  reg_a ($2102)
	ld	bc,($2105)	;  reg_de ($2105)
	ld	hl,$2000	;  bufdat ($2000)
	or	a		; 
	pop	de		; 
	ret			; 
;
J0dbc:	scf			; 
	pop	de		; 
	ret			; 
;
J0dbf:	push	bc		;  rdmem_i (J0dbf)
	push	de		; 
	push	hl		; 
J0dc2:	ld	hl,($2145)	;  rec_len ($2145)
	ld	de,$0100	; 
	or	a		; 
	sbc	hl,de		; 
	jr	nc,J0dd8	; 
	ld	hl,($2145)	;  rec_len ($2145)
	ld	a,l		; 
	or	h		; 
	jr	z,J0df8		; 
	ex	de,hl		; 
	ld	hl,$0000	; 
J0dd8:	ld	($2145),hl	;  rec_len ($2145)
	call	J0d94		;  getrec_i (J0d94)
	jr	c,J0dfd		; 
	jr	z,J0de6		; 
	cp	$48		; 
	jr	nz,J0dfc	; 
J0de6:	push	af		; 
	ld	a,b		; 
	or	c		; 
	jr	z,J0dfb		; 
	ld	de,($2147)	;  rec_addr ($2147)
	ldir			; 
	ld	($2147),de	;  rec_addr ($2147)
	pop	af		; 
	jr	J0dc2		; 
;
J0df8:	xor	a		; 
	jr	J0dfd		; 
;
J0dfb:	pop	af		; 
J0dfc:	or	a		; 
J0dfd:	pop	hl		; 
	pop	de		; 
	pop	bc		; 
	ret			; 
;
J0e01:	ld	a,($2138)	;  tmp_3 ($2138)
	or	a		; 
	jr	nz,J0e64	; 
	push	ix		; 
	ld	de,($5C53)	;  PROG ($5C53)
	ld	hl,($5C59)	;  E_LINE ($5C59)
	dec	hl		; 
	ld	c,(ix+$03)	; 
	ld	b,(ix+$04)	; 
	push	bc		; 
	call	J031d		;  cbas_i (J031d)
	defw	$19E5		;  RECLAIM_1 ($19E5)
;
	pop	bc		; 
	push	hl		; 
	ld	hl,($5C65)	;  STKEND ($5C65)
	add	hl,bc		; 
	ld	de,$0050	; 
	add	hl,de		; 
	jr	c,J0e60		; 
	sbc	hl,sp		; 
	jr	nc,J0e60	; 
	pop	hl		; 
	call	J031d		;  cbas_i (J031d)
	defw	$1664		;  POINTERS ($1664)
;
	ld	hl,($5C65)	;  STKEND ($5C65)
	ex	de,hl		; 
	lddr			; 
	inc	hl		; 
	ld	c,(ix+$05)	; 
	ld	b,(ix+$06)	; 
	add	hl,bc		; 
	ld	($5C4B),hl	;  VARS ($5C4B)
	ld	l,(ix+$01)	; 
	ld	h,(ix+$02)	; 
	ld	($5C42),hl	;  NEWPPC ($5C42)
	ld	a,h		; 
	or	l		; 
	ld	a,$00		; 
	jr	nz,J0e54	; 
	dec	a		; 
J0e54:	ld	($5C44),a	;  NSPPC ($5C44)
	ld	hl,($5C53)	;  PROG ($5C53)
	ld	($2147),hl	;  rec_addr ($2147)
	pop	hl		; 
	xor	a		; 
	ret			; 
;
J0e60:	ld	a,$FF		; 
	pop	hl		; 
	ret			; 
;
J0e64:	ld	c,(ix+$03)	; 
	ld	b,(ix+$04)	; 
	inc	bc		; 
	call	J031d		;  cbas_i (J031d)
	defw	$0030		;  ALLOC_BC_WORKSPACE ($0030)
;
	ld	(hl),$80	; 
	ex	de,hl		; 
	ld	($2147),hl	;  rec_addr ($2147)
	ld	($213F),hl	;  ch_add_tmp ($213F)
	xor	a		; 
	ld	($2138),a	;  tmp_3 ($2138)
	ret			; 
;
J0e7e:	call	J04d6		;  getblock_i (J04d6)
	call	J0412		; 
	jp	nc,J046c	; 
	jr	nz,J0e7e	; 
	ld	a,($212F)	;  block_type ($212F)
	cp	$C0		; 
	jr	nz,J0e9c	; 
	ld	a,($2100)	;  command ($2100)
	cp	$80		; 
	jr	nz,J0e9c	; 
	ld	a,($2102)	;  reg_a ($2102)
	or	a		; 
	ret			; 
;
J0e9c:	scf			; 
	ret			; 
;
	ld	a,($2139)	;  tmp_4 ($2139)
	or	a		; 
	jr	z,J0eaf		; 
	ld	a,($2134)	;  tmp_1 ($2134)
	ld	($2102),a	;  reg_a ($2102)
	ld	a,$11		; 
	jp	J0943		; 
;
J0eaf:	call	J0668		; 
	call	J0395		;  putdat_i (J0395)
	ld	a,$15		; 
	jp	J0725		; 
;
	ld	a,($2136)	;  tmp_2 ($2136)
	ld	b,$01		; 
	cp	$50		; 
	jr	z,J0ed1		; 
	ld	b,$00		; 
	cp	$55		; 
	jr	z,J0ed1		; 
	ld	b,$02		; 
	cp	$56		; 
	jr	z,J0ed1		; 
	ld	b,$03		; 
J0ed1:	push	bc		; 
	call	J0668		; 
	call	J0395		;  putdat_i (J0395)
	ld	a,$14		; 
	ld	($2100),a	;  command ($2100)
	pop	af		; 
	jp	J0364		;  putcom_i (J0364)
;
J0ee1:	ld	hl,$23FF	;  ti_ram_end ($23FF)
J0ee4:	ld	(hl),$00	; 
	dec	hl		; 
	ld	a,h		; 
	cp	$1F		; 
	jr	nz,J0ee4	; 
	ld	hl,J06e3	; 
	ld	($213D),hl	;  return_proc ($213D)
	ld	hl,J0082	; 
	ld	($213B),hl	;  error_proc ($213B)
	ld	a,$07		; 
	out	($FE),a		; 
	ld	a,$3F		; 
	ld	i,a		; 
	ld	hl,$FFFF	; 
J0f03:	ld	(hl),$00	; 
	dec	hl		; 
	cp	h		; 
	jr	nz,J0f03	; 
	ld	hl,$FFFF	; 
	ld	a,$55		; 
	ld	(hl),a		; 
	cpl			; 
	xor	(hl)		; 
	inc	a		; 
	jr	z,J0f16		; 
	ld	h,$7F		; 
J0f16:	ex	de,hl		; 
	ld	hl,$FF57	; 
	add	hl,de		; 
	ld	sp,hl		; 
	push	de		; 
	ld	de,setup	; 
	push	de		; 
	ld	hl,tsetup	; 
	ld	bc,$004d	; 
	ldir			; 
	pop	hl		; 
	ex	(sp),hl		; 
	jp	J0604		;  ti_ret_noei (J0604)
;
J0f2e:	ld	b,$FF		; 
	ld	a,$C0		; 
	ld	($212F),a	;  block_type ($212F)
	ld	a,$0D		; 
	ld	($2130),a	;  block_len ($2130)
J0f3a:	ld	hl,$2100	;  command ($2100)
	ld	(hl),$17	; 
	call	J0495		;  putlock_i (J0495)
	jr	z,J0f49		; 
	dec	b		; 
	jr	z,J0f8a		; 
	jr	J0f3a		; 
;
J0f49:	call	J03ac		;  getheader_i (J03ac)
	ld	a,($2102)	;  reg_a ($2102)
	or	a		; 
	jr	nz,J0f8a	; 
	ex	de,hl		; 
	ld	hl,$5D10	; 
	ld	a,d		; 
	rrd			; 
	add	a,$31		; 
	ld	(hl),a		; 
	inc	hl		; 
	inc	hl		; 
	ld	a,d		; 
	and	$0F		; 
	add	a,$B1		; 
	ld	(hl),a		; 
	ld	hl,setup2	; 
	push	hl		; 
	jp	J0604		;  ti_ret_noei (J0604)
;
J0f6b:	ld	a,$7F		; 
	in	a,($FE)		; 
	rra			; 
	jr	nc,J0f8a	; 
	ld	hl,D05BE	; 
	ld	de,$2000	;  bufdat ($2000)
	ld	bc,J0008	;  ti_on (J0008)
	ldir			; 
	xor	a		; 
	ld	($214D),a	;  file_typ ($214D)
	call	J0cc1		;  loadp_i (J0cc1)
	ld	a,($2102)	;  reg_a ($2102)
	and	a		; 
	jr	z,J0f91		; 
J0f8a:	ld	hl,$12A9	;  MAIN1 ($12A9)
	push	hl		; 
	jp	J0603		;  ti_ret (J0603)
;
J0f91:	call	J031d		;  cbas_i (J031d)
	defw	$0d6e		;  CLS_LOWER ($0d6e)
;
	ld	hl,$1303	;  MAIN4 ($1303)
	push	hl		; 
	set	7,(iy+$01)	; 
	ld	(iy+$00),$FF	; 
	jp	J048e		; 

        .phase $5cc6

tsetup:	equ	$$
setup:	push	hl		; 
	ld	de,romcode	; 
	ld	hl,$1200	;  SETUP_RAM ($1200)
	ld	bc,$00a0	; 
	ldir			; 
	ex	de,hl		; 
	ld	(hl),$C9	; 
	xor	a		; 
	ld	(romcode+$28),a	; 
	pop	hl		; 
	call	romcode		; 
	ld	hl,J0f2e	; 
callTI:	di			; 
	push	iy		; 
	ld	iy,$0000	; 
	call	J0008		;  ti_on (J0008)
	pop	iy		; 
	jp	(hl)		; 
setup2:	xor	a		; 
	ld	de,copyright	; 
	call	J0c0a		; 
	ld	hl,J0f6b	; 
	jr	callTI		; 

copyright:
	defb	$80,$0D,$7F			; 
	defb	' 91 STAVI 128K  TOS  . '	; 

romcode:

	.dephase
;
J0ff2:	in	a,($FF)		; 
	or	a		; 
	jr	nz,J0ff9	; 
	out	($F4),a		; 
J0ff9:	ld	hl,$7FFC	; 
	ld	sp,hl		; 
	jp	J05cd		; 

