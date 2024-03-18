//go:build !noasm && arm64
// Code generated by Vecgo. DO NOT EDIT.

TEXT ·_dot_product_neon(SB), $0-32
	MOVD a+0(FP), R0
	MOVD b+8(FP), R1
	MOVD n+16(FP), R2
	MOVD result+24(FP), R3
	WORD $0xa9bf7bfd       // stp	x29, x30, [sp,
	WORD $0x91001c48       // add	x8, x2,
	WORD $0xf100005f       // cmp	x2,
	WORD $0x9a82b108       // csel	x8, x8, x2, lt
	WORD $0x910003fd       // mov	x29, sp
	WORD $0x927df109       // and	x9, x8,
	WORD $0x9343fd08       // asr	x8, x8,
	WORD $0xcb090049       // sub	x9, x2, x9
	WORD $0x7100051f       // cmp	w8,
	WORD $0x5400032b       // b.lt	.LBB0_6
	WORD $0xb27d7fea       // mov	x10,
	WORD $0xaa0103ec       // mov	x12, x1
	WORD $0x8b080d4a       // add	x10, x10, x8, lsl
	WORD $0x927d7d4a       // and	x10, x10,
	WORD $0x9100214a       // add	x10, x10,
	WORD $0x6f00e400       // movi	v0.2d,
	WORD $0x6f00e401       // movi	v1.2d,
	WORD $0x8b0a080b       // add	x11, x0, x10, lsl

LBB0_2:
	WORD $0xacc10c02 // ldp	q2, q3, [x0],
	WORD $0x71000508 // subs	w8, w8,
	WORD $0xacc11584 // ldp	q4, q5, [x12],
	WORD $0x4e22cc80 // fmla	v0.4s, v4.4s, v2.4s
	WORD $0x4e23cca1 // fmla	v1.4s, v5.4s, v3.4s
	WORD $0x54ffff61 // b.ne	.LBB0_2
	WORD $0x8b0a0821 // add	x1, x1, x10, lsl
	WORD $0xaa0b03e0 // mov	x0, x11
	WORD $0x7100053f // cmp	w9,
	WORD $0x5400016b // b.lt	.LBB0_7

LBB0_4:
	WORD $0x92407d28 // and	x8, x9,
	WORD $0xf100211f // cmp	x8,
	WORD $0x54000142 // b.hs	.LBB0_8
	WORD $0x2f00e402 // movi	d2,
	WORD $0xaa1f03e9 // mov	x9, xzr
	WORD $0x14000024 // b	.LBB0_11

LBB0_6:
	WORD $0x6f00e401 // movi	v1.2d,
	WORD $0x6f00e400 // movi	v0.2d,
	WORD $0x7100053f // cmp	w9,
	WORD $0x54fffeea // b.ge	.LBB0_4

LBB0_7:
	WORD $0x2f00e402 // movi	d2,
	WORD $0x14000027 // b	.LBB0_13

LBB0_8:
	WORD $0x9240092a // and	x10, x9,
	WORD $0x2f00e402 // movi	d2,
	WORD $0xcb0a0109 // sub	x9, x8, x10
	WORD $0x9100400b // add	x11, x0,
	WORD $0x9100402c // add	x12, x1,
	WORD $0xaa0903ed // mov	x13, x9

LBB0_9:
	WORD $0x3cdf0163 // ldur	q3, [x11,
	WORD $0xf10021ad // subs	x13, x13,
	WORD $0x3cdf0184 // ldur	q4, [x12,
	WORD $0x6e24dc63 // fmul	v3.4s, v3.4s, v4.4s
	WORD $0x5e0c0464 // mov	s4, v3.s[1]
	WORD $0x1e232842 // fadd	s2, s2, s3
	WORD $0x5e140465 // mov	s5, v3.s[2]
	WORD $0x5e1c0463 // mov	s3, v3.s[3]
	WORD $0x1e242842 // fadd	s2, s2, s4
	WORD $0x3cc20564 // ldr	q4, [x11],
	WORD $0x1e252842 // fadd	s2, s2, s5
	WORD $0x3cc20585 // ldr	q5, [x12],
	WORD $0x6e25dc84 // fmul	v4.4s, v4.4s, v5.4s
	WORD $0x1e232842 // fadd	s2, s2, s3
	WORD $0x5e0c0483 // mov	s3, v4.s[1]
	WORD $0x1e242842 // fadd	s2, s2, s4
	WORD $0x5e140485 // mov	s5, v4.s[2]
	WORD $0x1e232842 // fadd	s2, s2, s3
	WORD $0x5e1c0483 // mov	s3, v4.s[3]
	WORD $0x1e252842 // fadd	s2, s2, s5
	WORD $0x1e232842 // fadd	s2, s2, s3
	WORD $0x54fffd61 // b.ne	.LBB0_9
	WORD $0xb400014a // cbz	x10, .LBB0_13

LBB0_11:
	WORD $0xd37ef52b // lsl	x11, x9,
	WORD $0xcb090108 // sub	x8, x8, x9
	WORD $0x8b0b002a // add	x10, x1, x11
	WORD $0x8b0b000b // add	x11, x0, x11

LBB0_12:
	WORD $0xbc404563 // ldr	s3, [x11],
	WORD $0xbc404544 // ldr	s4, [x10],
	WORD $0xf1000508 // subs	x8, x8,
	WORD $0x1f040862 // fmadd	s2, s3, s4, s2
	WORD $0x54ffff81 // b.ne	.LBB0_12

LBB0_13:
	WORD $0x1e222802 // fadd	s2, s0, s2
	WORD $0x6e040440 // mov	v0.s[0], v2.s[0]
	WORD $0x4e20d420 // fadd	v0.4s, v1.4s, v0.4s
	WORD $0x6e20d400 // faddp	v0.4s, v0.4s, v0.4s
	WORD $0x6e20d400 // faddp	v0.4s, v0.4s, v0.4s
	WORD $0xbd000060 // str	s0, [x3]
	WORD $0xa8c17bfd // ldp	x29, x30, [sp],
	WORD $0xd65f03c0 // ret

TEXT ·_squared_l2_neon(SB), $0-32
	MOVD a+0(FP), R0
	MOVD b+8(FP), R1
	MOVD n+16(FP), R2
	MOVD result+24(FP), R3
	WORD $0xa9bf7bfd       // stp	x29, x30, [sp,
	WORD $0xf100005f       // cmp	x2,
	WORD $0x91000c4a       // add	x10, x2,
	WORD $0x9a82b149       // csel	x9, x10, x2, lt
	WORD $0xf1001d5f       // cmp	x10,
	WORD $0x927ef528       // and	x8, x9,
	WORD $0x910003fd       // mov	x29, sp
	WORD $0x6f00e400       // movi	v0.2d,
	WORD $0xcb080048       // sub	x8, x2, x8
	WORD $0x540000e2       // b.hs	.LBB1_2
	WORD $0xaa0003ec       // mov	x12, x0
	WORD $0x6e004001       // ext	v1.16b, v0.16b, v0.16b,
	WORD $0x0e21d400       // fadd	v0.2s, v0.2s, v1.2s
	WORD $0x7e30d800       // faddp	s0, v0.2s
	WORD $0xb5000248       // cbnz	x8, .LBB1_5
	WORD $0x1400003f       // b	.LBB1_11

LBB1_2:
	WORD $0x9342fd29 // asr	x9, x9,
	WORD $0xaa0103eb // mov	x11, x1
	WORD $0x6f00e400 // movi	v0.2d,
	WORD $0xd37ef52a // lsl	x10, x9,
	WORD $0x8b09100c // add	x12, x0, x9, lsl

LBB1_3:
	WORD $0x3cc10401 // ldr	q1, [x0],
	WORD $0x3cc10562 // ldr	q2, [x11],
	WORD $0xf1000529 // subs	x9, x9,
	WORD $0x4ea2d421 // fsub	v1.4s, v1.4s, v2.4s
	WORD $0x4e21cc20 // fmla	v0.4s, v1.4s, v1.4s
	WORD $0x54ffff61 // b.ne	.LBB1_3
	WORD $0x8b0a0821 // add	x1, x1, x10, lsl
	WORD $0x6e004001 // ext	v1.16b, v0.16b, v0.16b,
	WORD $0x0e21d400 // fadd	v0.2s, v0.2s, v1.2s
	WORD $0x7e30d800 // faddp	s0, v0.2s
	WORD $0xb40005e8 // cbz	x8, .LBB1_11

LBB1_5:
	WORD $0xf100211f // cmp	x8,
	WORD $0x540000a2 // b.hs	.LBB1_7
	WORD $0xaa0c03e9 // mov	x9, x12
	WORD $0xaa0103ea // mov	x10, x1
	WORD $0xaa0803eb // mov	x11, x8
	WORD $0x14000023 // b	.LBB1_10

LBB1_7:
	WORD $0x927df10d // and	x13, x8,
	WORD $0x9240090b // and	x11, x8,
	WORD $0xd37ef5aa // lsl	x10, x13,
	WORD $0x9100402e // add	x14, x1,
	WORD $0x8b0a0189 // add	x9, x12, x10
	WORD $0x8b0a002a // add	x10, x1, x10
	WORD $0x9100418c // add	x12, x12,
	WORD $0xaa0d03ef // mov	x15, x13

LBB1_8:
	WORD $0xad7f8d81 // ldp	q1, q3, [x12,
	WORD $0x9100818c // add	x12, x12,
	WORD $0xf10021ef // subs	x15, x15,
	WORD $0xad7f91c2 // ldp	q2, q4, [x14,
	WORD $0x910081ce // add	x14, x14,
	WORD $0x4ea2d421 // fsub	v1.4s, v1.4s, v2.4s
	WORD $0x6e21dc21 // fmul	v1.4s, v1.4s, v1.4s
	WORD $0x5e0c0422 // mov	s2, v1.s[1]
	WORD $0x1e212800 // fadd	s0, s0, s1
	WORD $0x5e140425 // mov	s5, v1.s[2]
	WORD $0x5e1c0421 // mov	s1, v1.s[3]
	WORD $0x1e222800 // fadd	s0, s0, s2
	WORD $0x4ea4d462 // fsub	v2.4s, v3.4s, v4.4s
	WORD $0x1e252800 // fadd	s0, s0, s5
	WORD $0x6e22dc42 // fmul	v2.4s, v2.4s, v2.4s
	WORD $0x1e212800 // fadd	s0, s0, s1
	WORD $0x5e0c0441 // mov	s1, v2.s[1]
	WORD $0x5e140443 // mov	s3, v2.s[2]
	WORD $0x1e222800 // fadd	s0, s0, s2
	WORD $0x1e212800 // fadd	s0, s0, s1
	WORD $0x5e1c0441 // mov	s1, v2.s[3]
	WORD $0x1e232800 // fadd	s0, s0, s3
	WORD $0x1e212800 // fadd	s0, s0, s1
	WORD $0x54fffd21 // b.ne	.LBB1_8
	WORD $0xeb0d011f // cmp	x8, x13
	WORD $0x540000e0 // b.eq	.LBB1_11

LBB1_10:
	WORD $0xbc404521 // ldr	s1, [x9],
	WORD $0xbc404542 // ldr	s2, [x10],
	WORD $0xf100056b // subs	x11, x11,
	WORD $0x1e223821 // fsub	s1, s1, s2
	WORD $0x1f010020 // fmadd	s0, s1, s1, s0
	WORD $0x54ffff61 // b.ne	.LBB1_10

LBB1_11:
	WORD $0xbd000060 // str	s0, [x3]
	WORD $0xa8c17bfd // ldp	x29, x30, [sp],
	WORD $0xd65f03c0 // ret
