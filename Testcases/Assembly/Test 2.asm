addi x12, x0, 512
addi x1, x0, -6
addi x2, x0, -12
addi x3, x0, -14

sb x1, 0(x12)
sh x2, 1(x12)
sw x3, 3(x12)

lb x4, 0(x12) # x4 = -6
addi x9, x4, 0 # x9 = -6
lbu x5, 0(x12) # x5 = 250
addi x9, x5, 0 # x9 = 250
lh x6, 1(x12) # x6 = -12
addi x9, x6, 0 # x9 = -12
lhu x7, 1(x12) # x7 = 65524
addi x9, x7, 0 # x9 = 65524
lw x8, 3(x12) # x8 = -14
addi x9, x8, 0 # x9 = -14
ecall
