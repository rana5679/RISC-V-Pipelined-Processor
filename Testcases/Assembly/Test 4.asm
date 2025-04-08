lui x1, 1 # x1 = 4096
auipc x2, 1 # x2 = 4100
jal x3, L1 # x3 = 12
addi x2, x2, 5 # skipped
addi x2, x2, 5 # skipped
jalr x0, x4, 0 # skipped at first; then jumps to addi (28)
L1:
jalr x4, x0, 20 # x4 =28
ecall
