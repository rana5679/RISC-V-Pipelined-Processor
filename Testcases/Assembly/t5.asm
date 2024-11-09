addi x1, x0, 3  # x1 = 3
add x1, x1, x1 # x1 = 6
sub x2, x0, x1 # x2 = -6
addi x1, x1, -3 # x1 = 3
xor x3, x1, x2  # x3 = -7
fence.i
xori x3, x3, 12 # x3 = -11
or x4, x1, x2 # x4 = -5
ori x4, x4, 6 # x4 = -1
ebreak
andi x5, x2, 6 # x5 = 2  
and x5, x5, x3 # x5 = 0
slli x4, x4, 1 # x4 = -2
srai x4, x4, 1 # x4 = -1
ecall
srli x4, x4, 1 # x4 = really big number
slt x6, x3, x2 # x6 = 1
sltu x6, x3, x6 # x6 = 0
slti x5, x2, 0 # x5 = 1
sltiu x6, x5, -1 # x6 = 1
