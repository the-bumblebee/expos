# Satge 6

In this stage, we will be running our first user program, `squares.xsm`, in unprivileged mode.

## Files Included

### 1. expl_progs/squares.xsm

This is the user program that we wish to run, which calculates the sqaures of the first 5 natural numbers. This will be loaded as INIT program by the OS startup code. Since the code section occupies the first two pages, the code address begins from logical addess 0 (just for this example, all other user programs will have code section in pages 4 to 7 and thus code address begins at 2048 [4*512]). Hence the labels used were translated accordingly.

### 2. spl_progs/haltprog.spl

This spl program has only a "halt" statement and will be used as the interrupt handler 10 and also the exception handler. At the end of the user program, an INT 10 instruction is used to give control back to the os and invokes software interrupt handler 10. An exception handler routine is required when the machine encounter unexpected events within the user program. The default action is to halt the machine.

### 3. spl_progs/os_startup.xsm

This is the OS startup code that loads the rest of the program from disk to memory. It sets up the page table for the INIT program, sets values for the PTBR and PTLR registers and also sets the stack. Once everything is set, the code transfers control to the INIT program using IRET instruction.

## Compiling SPL Programs

It is assumed that both the eXpOS package and this repository are set up at home directory. If not, follow the main [README.md](/README.md).

```
$ cd ~/myexpos/spl/
$ ./spl ~/expos-roadmap/spl_progs/haltprog.spl
$ ./spl ~/expos-roadmap/spl_progs/os_startup.spl
```

This will generate corresponding xsm files:`haltprog.xsm` and `os_startup.xsm`.

## Loading Programs to Disk

Run the following commands to run the XFS interface.

```
$ cd ~/myexpos/xfs-interface/
$ ./xfs-interface
```

Within the XFS interface program, type in the following commands at the prompt.

```
# load --init ~/expos-roadmap/expl_progs/squares.xsm
# load --int=10 ~/expos-roadmap/spl_progs/haltprog.xsm
# load --exhandler ~/expos-roadmap/spl_progs/haltprog.xsm
# load --os ~/expos-roadmap/spl_progs/os_startup.xsm
# exit
```

## Running XSM Machine

Running the machine in debug mode with timer off.

```
$ cd ~/myexpos/xsm/
$ ./xsm --debug --timer 0
```

During each iteration use `r` command in debug mode to see the values of R0 and R1, with R1 having the sqaure of the number in R0. USe `c` to conitnue execution till next breakpoint.
