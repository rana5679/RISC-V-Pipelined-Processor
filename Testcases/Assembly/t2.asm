addi x1, x0, -6
addi x2, x0, -12
addi x3, x0, -14

sb x1, 0(x0)
sh x2, 1(x0)
sw x3, 3(x0)

lb x4, 0(x0) # x4 = -6
lbu x5, 0(x0) # x5 = 250
lh x6, 1(x0) # x6 = -12
lhu x7, 1(x0) # x7 = 65524
lw x8, 3(x0) # x8 = -14
