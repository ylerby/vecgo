//go:build !noasm && amd64
// Code generated by Vecgo. DO NOT EDIT.

#include "textflag.h"

TEXT ·_dot_product_avx(SB), $0-32
	MOVQ a+0(FP), DI
	MOVQ b+8(FP), SI
	MOVQ n+16(FP), DX
	MOVQ res+24(FP), CX
	BYTE $0x55               // pushq	%rbp
	WORD $0x8948; BYTE $0xe5 // movq	%rsp, %rbp
	LONG $0xf8e48348         // andq	$-8, %rsp
	LONG $0x07428d4c         // leaq	7(%rdx), %r8
	WORD $0x8548; BYTE $0xd2 // testq	%rdx, %rdx
	LONG $0xc2490f4c         // cmovnsq	%rdx, %r8
	LONG $0xc057f8c5         // vxorps	%xmm0, %xmm0, %xmm0
	WORD $0xc031             // xorl	%eax, %eax
	LONG $0xf8e08349         // andq	$-8, %r8
	JLE  LBB0_2

LBB0_1:
	LONG $0x0c10fcc5; BYTE $0x87 // vmovups	(%rdi,%rax,4), %ymm1
	LONG $0x0c59f4c5; BYTE $0x86 // vmulps	(%rsi,%rax,4), %ymm1, %ymm1
	LONG $0xc158fcc5             // vaddps	%ymm1, %ymm0, %ymm0
	LONG $0x08c08348             // addq	$8, %rax
	WORD $0x394c; BYTE $0xc0     // cmpq	%r8, %rax
	JL   LBB0_1

LBB0_2:
	LONG $0x0958fac5               // vaddss	(%rcx), %xmm0, %xmm1
	LONG $0xd016fac5               // vmovshdup	%xmm0, %xmm2
	LONG $0xc958eac5               // vaddss	%xmm1, %xmm2, %xmm1
	LONG $0x0579e3c4; WORD $0x01d0 // vpermilpd	$1, %xmm0, %xmm2
	LONG $0xc958eac5               // vaddss	%xmm1, %xmm2, %xmm1
	LONG $0x0479e3c4; WORD $0xffd0 // vpermilps	$255, %xmm0, %xmm2
	LONG $0xc958eac5               // vaddss	%xmm1, %xmm2, %xmm1
	LONG $0x197de3c4; WORD $0x01c0 // vextractf128	$1, %ymm0, %xmm0
	LONG $0xc958fac5               // vaddss	%xmm1, %xmm0, %xmm1
	LONG $0xd016fac5               // vmovshdup	%xmm0, %xmm2
	LONG $0xc958eac5               // vaddss	%xmm1, %xmm2, %xmm1
	LONG $0x0579e3c4; WORD $0x01d0 // vpermilpd	$1, %xmm0, %xmm2
	LONG $0xc958eac5               // vaddss	%xmm1, %xmm2, %xmm1
	LONG $0x0479e3c4; WORD $0xffc0 // vpermilps	$255, %xmm0, %xmm0
	LONG $0xc158fac5               // vaddss	%xmm1, %xmm0, %xmm0
	LONG $0x0111fac5               // vmovss	%xmm0, (%rcx)
	WORD $0x3948; BYTE $0xd0       // cmpq	%rdx, %rax
	JGE  LBB0_7
	WORD $0x8941; BYTE $0xd1       // movl	%edx, %r9d
	WORD $0x2941; BYTE $0xc1       // subl	%eax, %r9d
	WORD $0x8949; BYTE $0xc0       // movq	%rax, %r8
	WORD $0xf749; BYTE $0xd0       // notq	%r8
	WORD $0x0149; BYTE $0xd0       // addq	%rdx, %r8
	LONG $0x03e18349               // andq	$3, %r9
	JE   LBB0_5

LBB0_4:
	LONG $0x0c10fac5; BYTE $0x87 // vmovss	(%rdi,%rax,4), %xmm1
	LONG $0x0c59f2c5; BYTE $0x86 // vmulss	(%rsi,%rax,4), %xmm1, %xmm1
	LONG $0xc058f2c5             // vaddss	%xmm0, %xmm1, %xmm0
	LONG $0x0111fac5             // vmovss	%xmm0, (%rcx)
	LONG $0x01c08348             // addq	$1, %rax
	LONG $0xffc18349             // addq	$-1, %r9
	JNE  LBB0_4

LBB0_5:
	LONG $0x03f88349 // cmpq	$3, %r8
	JB   LBB0_7

LBB0_6:
	LONG $0x0c10fac5; BYTE $0x87   // vmovss	(%rdi,%rax,4), %xmm1
	LONG $0x0c59f2c5; BYTE $0x86   // vmulss	(%rsi,%rax,4), %xmm1, %xmm1
	LONG $0xc058f2c5               // vaddss	%xmm0, %xmm1, %xmm0
	LONG $0x0111fac5               // vmovss	%xmm0, (%rcx)
	LONG $0x4c10fac5; WORD $0x0487 // vmovss	4(%rdi,%rax,4), %xmm1
	LONG $0x4c59f2c5; WORD $0x0486 // vmulss	4(%rsi,%rax,4), %xmm1, %xmm1
	LONG $0xc058f2c5               // vaddss	%xmm0, %xmm1, %xmm0
	LONG $0x0111fac5               // vmovss	%xmm0, (%rcx)
	LONG $0x4c10fac5; WORD $0x0887 // vmovss	8(%rdi,%rax,4), %xmm1
	LONG $0x4c59f2c5; WORD $0x0886 // vmulss	8(%rsi,%rax,4), %xmm1, %xmm1
	LONG $0xc058f2c5               // vaddss	%xmm0, %xmm1, %xmm0
	LONG $0x0111fac5               // vmovss	%xmm0, (%rcx)
	LONG $0x4c10fac5; WORD $0x0c87 // vmovss	12(%rdi,%rax,4), %xmm1
	LONG $0x4c59f2c5; WORD $0x0c86 // vmulss	12(%rsi,%rax,4), %xmm1, %xmm1
	LONG $0xc058f2c5               // vaddss	%xmm0, %xmm1, %xmm0
	LONG $0x0111fac5               // vmovss	%xmm0, (%rcx)
	LONG $0x04c08348               // addq	$4, %rax
	WORD $0x3948; BYTE $0xc2       // cmpq	%rax, %rdx
	JNE  LBB0_6

LBB0_7:
	WORD $0x8948; BYTE $0xec // movq	%rbp, %rsp
	BYTE $0x5d               // popq	%rbp
	WORD $0xf8c5; BYTE $0x77 // vzeroupper
	BYTE $0xc3               // retq

TEXT ·_squared_l2_avx(SB), $0-32
	MOVQ vec1+0(FP), DI
	MOVQ vec2+8(FP), SI
	MOVQ n+16(FP), DX
	MOVQ result+24(FP), CX
	BYTE $0x55               // pushq	%rbp
	WORD $0x8948; BYTE $0xe5 // movq	%rsp, %rbp
	LONG $0xf8e48348         // andq	$-8, %rsp
	LONG $0x07428d4c         // leaq	7(%rdx), %r8
	WORD $0x8548; BYTE $0xd2 // testq	%rdx, %rdx
	LONG $0xc2490f4c         // cmovnsq	%rdx, %r8
	LONG $0xc057f8c5         // vxorps	%xmm0, %xmm0, %xmm0
	WORD $0xc031             // xorl	%eax, %eax
	LONG $0xf8e08349         // andq	$-8, %r8
	JLE  LBB1_2

LBB1_1:
	LONG $0x0c10fcc5; BYTE $0x87 // vmovups	(%rdi,%rax,4), %ymm1
	LONG $0x0c5cf4c5; BYTE $0x86 // vsubps	(%rsi,%rax,4), %ymm1, %ymm1
	LONG $0xc959f4c5             // vmulps	%ymm1, %ymm1, %ymm1
	LONG $0xc158fcc5             // vaddps	%ymm1, %ymm0, %ymm0
	LONG $0x08c08348             // addq	$8, %rax
	WORD $0x394c; BYTE $0xc0     // cmpq	%r8, %rax
	JL   LBB1_1

LBB1_2:
	LONG $0xc957f0c5         // vxorps	%xmm1, %xmm1, %xmm1
	WORD $0x3948; BYTE $0xd0 // cmpq	%rdx, %rax
	JGE  LBB1_7
	WORD $0x8941; BYTE $0xd1 // movl	%edx, %r9d
	WORD $0x2941; BYTE $0xc1 // subl	%eax, %r9d
	WORD $0x8949; BYTE $0xc0 // movq	%rax, %r8
	WORD $0xf749; BYTE $0xd0 // notq	%r8
	WORD $0x0149; BYTE $0xd0 // addq	%rdx, %r8
	LONG $0xc957f0c5         // vxorps	%xmm1, %xmm1, %xmm1
	LONG $0x03e18349         // andq	$3, %r9
	JE   LBB1_5

LBB1_4:
	LONG $0x1410fac5; BYTE $0x87 // vmovss	(%rdi,%rax,4), %xmm2
	LONG $0x145ceac5; BYTE $0x86 // vsubss	(%rsi,%rax,4), %xmm2, %xmm2
	LONG $0xd259eac5             // vmulss	%xmm2, %xmm2, %xmm2
	LONG $0xc958eac5             // vaddss	%xmm1, %xmm2, %xmm1
	LONG $0x01c08348             // addq	$1, %rax
	LONG $0xffc18349             // addq	$-1, %r9
	JNE  LBB1_4

LBB1_5:
	LONG $0x03f88349 // cmpq	$3, %r8
	JB   LBB1_7

LBB1_6:
	LONG $0x1410fac5; BYTE $0x87   // vmovss	(%rdi,%rax,4), %xmm2
	LONG $0x5c10fac5; WORD $0x0487 // vmovss	4(%rdi,%rax,4), %xmm3
	LONG $0x145ceac5; BYTE $0x86   // vsubss	(%rsi,%rax,4), %xmm2, %xmm2
	LONG $0xd259eac5               // vmulss	%xmm2, %xmm2, %xmm2
	LONG $0xc958eac5               // vaddss	%xmm1, %xmm2, %xmm1
	LONG $0x545ce2c5; WORD $0x0486 // vsubss	4(%rsi,%rax,4), %xmm3, %xmm2
	LONG $0xd259eac5               // vmulss	%xmm2, %xmm2, %xmm2
	LONG $0xc958eac5               // vaddss	%xmm1, %xmm2, %xmm1
	LONG $0x5410fac5; WORD $0x0887 // vmovss	8(%rdi,%rax,4), %xmm2
	LONG $0x545ceac5; WORD $0x0886 // vsubss	8(%rsi,%rax,4), %xmm2, %xmm2
	LONG $0xd259eac5               // vmulss	%xmm2, %xmm2, %xmm2
	LONG $0xc958eac5               // vaddss	%xmm1, %xmm2, %xmm1
	LONG $0x5410fac5; WORD $0x0c87 // vmovss	12(%rdi,%rax,4), %xmm2
	LONG $0x545ceac5; WORD $0x0c86 // vsubss	12(%rsi,%rax,4), %xmm2, %xmm2
	LONG $0xd259eac5               // vmulss	%xmm2, %xmm2, %xmm2
	LONG $0xc958eac5               // vaddss	%xmm1, %xmm2, %xmm1
	LONG $0x04c08348               // addq	$4, %rax
	WORD $0x3948; BYTE $0xc2       // cmpq	%rax, %rdx
	JNE  LBB1_6

LBB1_7:
	LONG $0xc858f2c5               // vaddss	%xmm0, %xmm1, %xmm1
	LONG $0xd016fac5               // vmovshdup	%xmm0, %xmm2
	LONG $0xca58f2c5               // vaddss	%xmm2, %xmm1, %xmm1
	LONG $0x0579e3c4; WORD $0x01d0 // vpermilpd	$1, %xmm0, %xmm2
	LONG $0xca58f2c5               // vaddss	%xmm2, %xmm1, %xmm1
	LONG $0x0479e3c4; WORD $0xffd0 // vpermilps	$255, %xmm0, %xmm2
	LONG $0xca58f2c5               // vaddss	%xmm2, %xmm1, %xmm1
	LONG $0x197de3c4; WORD $0x01c0 // vextractf128	$1, %ymm0, %xmm0
	LONG $0xc858f2c5               // vaddss	%xmm0, %xmm1, %xmm1
	LONG $0xd016fac5               // vmovshdup	%xmm0, %xmm2
	LONG $0xca58f2c5               // vaddss	%xmm2, %xmm1, %xmm1
	LONG $0x0579e3c4; WORD $0x01d0 // vpermilpd	$1, %xmm0, %xmm2
	LONG $0xca58f2c5               // vaddss	%xmm2, %xmm1, %xmm1
	LONG $0x0479e3c4; WORD $0xffc0 // vpermilps	$255, %xmm0, %xmm0
	LONG $0xc058f2c5               // vaddss	%xmm0, %xmm1, %xmm0
	LONG $0x0111fac5               // vmovss	%xmm0, (%rcx)
	WORD $0x8948; BYTE $0xec       // movq	%rbp, %rsp
	BYTE $0x5d                     // popq	%rbp
	WORD $0xf8c5; BYTE $0x77       // vzeroupper
	BYTE $0xc3                     // retq
