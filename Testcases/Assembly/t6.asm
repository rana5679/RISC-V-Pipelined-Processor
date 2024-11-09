addi x1, x0, 3  # x1 = 3
nop
nop
nop
add x1, x1, x1 # x1 = 6
nop
nop
nop
sub x2, x0, x1 # x2 = -6
nop
nop
nop
addi x1, x1, -3 # x1 = 3
nop
nop
nop
xor x3, x1, x2  # x3 = -7
nop
nop
nop
xori x3, x3, 12 # x3 = -11
nop
nop
nop
or x4, x1, x2 # x4 = -5
nop
nop
nop
ori x4, x4, 6 # x4 = -1
nop
nop
nop
andi x5, x2, 6 # x5 = 2  
nop
nop
nop
and x5, x5, x3 # x5 = 0
nop
nop
nop
slli x4, x4, 1 # x4 = -2
nop
nop
nop
srai x4, x4, 1 # x4 = -1
nop
nop
nop
srli x4, x4, 1 # x4 = really big number
nop
nop
nop
slt x6, x3, x2 # x6 = 1
nop
nop
nop
sltu x6, x3, x6 # x6 = 0
nop
nop
nop
slti x5, x2, 0 # x5 = 1
nop
nop
nop
sltiu x6, x5, -1 # x6 = 1
ecall

