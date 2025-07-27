# RISC-V-Pipelined-Processor

## Release Notes:
  ### What works:
* Support for all 42 rv32i user-level instructions.
* Implementing Von Neumann Architecture by using a single memory for both instructions and data.
* Improved branching and jumping [control flow] behavior by moving the branch prediction logic and target address adders to the ID stage and correctly handling the resulting hazards.
  ### To be added later (hopefully):
* There is currently no branch prediction mechanism.
* No support for C or M extensions.
  ### Issues:
* FPGA output does not behave as expected, displaying some values but not others. This is due to how the hex files are read by the FPGA.
  ### Assumptions:
* The input files to the memory are formatted in hexadecimal, with one byte per line.
* Since a unified memory is used for both the program data and instructions, the user is assumed to write their programs in such a way that the stores/loads do not overlap with the instructions.
