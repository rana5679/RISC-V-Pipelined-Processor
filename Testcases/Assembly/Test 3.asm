addi x1, x0, 1 # x1 = 1
addi x2, x0, 1 # x2 = 1
addi x3, x0, -1 # x3 = -1
addi x4, x0, -2 # x4 = -2

beq x0, x0, L1 # branch taken
add x2, x2, x2 # skipped
L1: 
beq x0, x1, L2 # branch not taken
add x1, x1, x1 # x1 = 2

blt x2, x1, L2 # taken
add x2, x2, x2 # skipped
L2:
blt x1, x0, L3 # not taken
add x1, x1, x1 # x1 = 4

bge x0, x0, L3 # taken
add x2, x2, x2 # skipped
L3:
bge x0, x1, L4 # not taken
add x1, x1, x1 # x1 = 8

bne x1, x2, L4 # taken
add x2, x2, x2 # skipped

L4:
bne x0, x0, L5 # not taken
add x1, x1, x1 # x1 = 16

bltu x0, x3, L5 # taken
add x2, x2, x2 # skipped

L5:
bltu x3, x4, L6 # not taken
add x1, x1, x1 # x1 = 32

bgeu x3, x1, L6 # taken
add x2, x2, x2 # skipped

L6:
bgeu x2, x3, L1 # not taken
add x1, x1, x1 # x1 = 64
add x5, x1, x0 # x5 = 64
addi x5, x5, 1 # x5 = 65
beq x1, x5, L7 # not taken
ecall
L7:
addi x1, x1, 0 


