# Stage 16 Assignment 1

Use the XSM debugger to print out the contents of the Terminal Status Table and the input buffer (by dumping process table entry of the process to which read was performed) before and after reading data from the input port to the input buffer of the process, inside the terminal interrupt handler. 

## Compiling SPL Programs

```
$ cd ~/expos-roadmap/stage16_assignment2
$ sudo chmod +x run.sh

$ ./run.sh

$ cd ~/myexpos/xfs-interface
$ ./xfs-interface run ~/expos-roadmap/stage16_assignment2/batch-xfs

$ cd ~/myexpos/xsm/
$ ./xsm --debug
```
* Enter N.
* In the first breakpoint, type `tst` to print Terminal Status Table and `pcb 1` to print Process Table of init program.
* In the second breakpoint, do the same.