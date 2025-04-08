addi s0, x0, 512 # base address for store/load
addi s1, x0, 1 # s1 = 1

sw s1, 0(s0)
lw s2, 0(s0) # s2 = 1
beq s1, s2, L1 # taken after stall (handles load use)
addi s2, s2, 15 
addi s2, s2, 15
addi s2, s2, 15

L1:
addi s2, s2, 1 # should be s2 = 2
lui s1, 1 # s1 = 4096
lui s2, 1 # s2 = 4096
beq s1, s2, L2 # should branch (handles lui)
addi s2, s2, -96 # skipped, but would result in s2 = 4000
addi s2, s2, 15
addi s2, s2, 15

L2:
addi s1, x0, 18 # s1 = 18
addi s2, x0, 9 # s2 = 9
add s2, s2, s2 # s2 = 18
beq s1, s2, L3 # taken (handles R format)
sub s2, s2, s2 # would be skipped but sets s2 = 0
addi s2, s2, 15
addi s2, s2, 15

L3:
sub s2, s2, s2 # s2 = 0
addi s2, s2, 9 # s2 = 9
bne s2, s1, L4 # taken (handles I format) [note that s1 = x9 BUT since i-format, signalB should not be set and s1 should be 18, if not taken then there's an issue]
addi s2, s2, 15
addi s2, s2, 15
addi s2, s2, 15

L4: 
auipc s1, 0 
addi s1, s1, 8
auipc s2, 0
beq s1, s2, L5 # taken 
sub s2, s1, s2
addi s2, s2, 15
addi s2, s2, 15

L5:
auipc s0, 0
addi s0, s0, 12 # s0 had address of instruction after jal
jal s1, L6
addi x1, x0, 3 # skipped

L6:
beq s0, s1, L7 # tests branch after jump
add s1, s1, x0
add s1, s1, x0
add s1, s1, x0

L7: 
ecall
