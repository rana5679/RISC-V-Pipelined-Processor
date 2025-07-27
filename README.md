# RISC-V-Pipelined-Processor

## Release Notes:
  ### What works:
* Support for all 42 rv32i user-level instructions.
* Implementing Von Neumann Architecture by using a single memory for both instructions and data.
* Improved branching and jumping [control flow] behavior by moving the branch prediction logic and target address adders to the ID stage and correctly handling the resulting hazards.
  ### Future Improvements (hopefully):
* Self modifying code
  * In the combined data memory we wanted to assign the first half of the memory to
the instructions and the second half to the data. We would then handle any
incorrect memory accesses by modifying the address to be accessed.
* Separate memory banks
  * To handle Problem 2 (Pipeline Report) more elegantly, we thought of having four different memory
banks that sequentially store the bytes of each word to be able to directly load hex
files into them.
* Supporting Extensions
 * We want to support other extensions in RISC-V such as the C and M extensions.
* Fixing FPGA display
  * We would like to fix the issues in the current FPGA implemengtation.
* Branch prediction mechanism.
  ### Issues:
* FPGA output does not behave as expected, displaying some values but not others. This is due to how the hex files are read by the FPGA.
  ### Assumptions:
* The input files to the memory are formatted in hexadecimal, with one byte per line.
* Since a unified memory is used for both the program data and instructions, the user is assumed to write their programs in such a way that the stores/loads do not overlap with the instructions.
