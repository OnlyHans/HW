.text

NIZ1:              .asciz "yxem Nx yzcdxo, am knxfx Vcjs, Gbnnws rx ejnm nj Zxcj."    
SEZNAM1:      .asciz  "xfjrmansobyzcdwke"    

SEZNAM2:      .asciz  "adegiklmnoprstuvz"             

                       .align
                       .global __start

__start:

          ldr r4, =NIZ1
          ldr r5, =SEZNAM1
          ldr r6, =SEZNAM2
          mov r7, #0
          mov r8, #0
loop:
          add r9, r4, r7
          ldrb r0, [r9]
loop2:    add r10, r5, r8          
          ldrb r1, [r10]
          cmp r1, r0
          bne naprej
          add r11, r6, r8
          ldrb r2, [r11]
          cmp r2, #97
          blo je_velika
          sub r2, #32
je_velika:          
          strb r2, [r9]
          
naprej:   add r8, #1
          cmp r1, #0
          beq nazaj
          b loop2
nazaj:    
          mov r8, #0      
          add r7, #1
          b loop          
__end:               b __end
