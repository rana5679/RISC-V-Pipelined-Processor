addi x1, x0, -6
nop
nop
nop
addi x2, x0, -12
nop
nop
nop
addi x3, x0, -14
nop
nop
nop

sb x1, 0(x0)
nop
nop
nop
sh x2, 1(x0)
nop
nop
nop
sw x3, 3(x0)
nop
nop
nop

lb x4, 0(x0) # x4 = -6
nop
nop
nop
lbu x5, 0(x0) # x5 = 250
nop
nop
nop
lh x6, 1(x0) # x6 = -12
nop
nop
nop
lhu x7, 1(x0) # x7 = 65524
nop
nop
nop
lw x8, 3(x0) # x8 = -14
ecall
