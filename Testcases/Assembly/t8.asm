addi x1, x0, 1 # x1 = 1
nop
nop
nop
addi x2, x0, 1 # x2 = 1
nop
nop
nop
addi x3, x0, -1 # x3 = -1
nop
nop
nop
addi x4, x0, -2 # x4 = -2
nop
nop
nop

beq x0, x0, L1 # branch taken
nop
nop
nop
add x2, x2, x2 # skipped
nop
nop
nop
L1: 
beq x0, x1, L2 # branch not taken
nop
nop
nop
add x1, x1, x1 # x1 = 2
nop
nop
nop

blt x0, x1, L2 # taken
nop
nop
nop
add x2, x2, x2 # skipped
nop
nop
nop
L2:
blt x1, x0, L3 # not taken
nop
nop
nop
add x1, x1, x1 # x1 = 4
nop
nop
nop

bge x0, x0, L3 #taken
nop
nop
nop
add x2, x2, x2 # skipped
nop
nop
nop
L3:
bge x0, x1, L4 # not taken
nop
nop
nop
add x1, x1, x1 # x1 = 8
nop
nop
nop

bne x1, x2, L4 # taken
nop
nop
nop
add x2, x2, x2 # skipped
nop
nop
nop

L4:
bne x0, x0, L5 # not taken
nop
nop
nop
add x1, x1, x1 # x1 = 16
nop
nop
nop

bltu x0, x3, L5 # taken
nop
nop
nop
add x2, x2, x2 #skipped
nop
nop
nop

L5:
bltu x3, x4, L6 # not taken
nop
nop
nop
add x1, x1, x1 # x1 = 32
nop
nop
nop

bgeu x3, x1, L6 # taken
nop
nop
nop
add x2, x2, x2 # skipped
nop
nop
nop

L6:
bgeu x2, x3, L1 # not taken
nop
nop
nop
add x1, x1, x1 # x1 = 64
ecall

