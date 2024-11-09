lui x1, 1 # x1 = 4096
nop
nop
nop
auipc x2, 1 # x2 = 4112
nop
nop
nop
jal x3, L1 # x3 = 36
nop
nop
nop
addi x2, x2, 5 # skipped
nop
nop
nop
addi x2, x2, 5 # skipped at first; then x2 = 4117
nop
nop
nop
jalr x0, x4, 0 # skipped at first; then jumps to addi (84)
nop
nop
nop
L1:
jalr x4, x0, 60 # x4 = 100
nop
nop
nop
addi x1, x0, 1 # x1 = 1
ecall
