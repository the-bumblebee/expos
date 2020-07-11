# Stage 6: Running a User Program

In this stage, we will be running our first user program, `squares.xsm`, in unprivileged mode.

## Files Included

### 1. expl_progs/squares.xsm

This is the user program that we wish to run, which calculates the sqaures of the first 5 natural numbers. This will be loaded as INIT program by the OS startup code. Since the code section occupies the first two pages, the code address begins from logical addess 0 (just for this example, all other user programs will have code section in pages 4 to 7 and thus code address begins at 4\*512, which is 2048). Hence the labels used were translated accordingly.

### 2. spl_progs/haltprog.spl

This spl program has only a "halt" statement and will be used as the interrupt handler 10 and also the exception handler. At the end of the user program, an INT 10 instruction is used to give control back to the os and invoke software interrupt handler 10. An exception handler routine is required when the machine encounters unexpected events within the user program. The default action is to halt the machine.

### 3. spl_progs/os_startup.spl

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
# load --init $HOME/expos-roadmap/expl_progs/squares.xsm
# load --int=10 $HOME/expos-roadmap/spl_progs/haltprog.xsm
# load --exhandler $HOME/expos-roadmap/spl_progs/haltprog.xsm
# load --os $HOME/expos-roadmap/spl_progs/os_startup.xsm
# exit
```

`~` doesn't work within the XFS interface program and so `$HOME` has to be used.

## Running XSM Machine

Running the machine in debug mode with timer off.

```
$ cd ~/myexpos/xsm/
$ ./xsm --debug --timer 0
```

During each iteration use `r` command in debug mode to see the values of R0 and R1, with R1 having the sqaure of the number in R0. USe `c` to conitnue execution till next breakpoint.

## Explanation

### 1. Disk

The files are loaded into the following disk blocks.

| Block Number | Contents |
|---|---|
| 0 - 1 | Bootstrap/OS startup code |
| ... | ... |
| 7 - 8 | Init/Login Code |
| ... | ... |
| 15 - 16 | Exception Handler |
| ... | ... |
| 35 - 36 | Interrupt 10 Routine: Exit |
| ... | ... |

### 2. Memory

The ROM code (present in page 0) on the machine loads the OS startup code from disk block 0 to memory page 1 and sets IP to 512, which is the first instruction in page 1. The following is the memory layout.

| Physical Page Number | Contents |
|---|---|
| 0 | ROM Code |
| 1 | Page for OS startup code |
| 2 - 3 | Exception Handler |
| ... | ... |
| 22 - 23 | Interrupt 10 Routine: Exit |
| ... | ... |
| 58 | Page Tables* |
| ... | ... |
| 65 - 66 | Init/Login Code |
| ... | ... |

\* Page tables are stored at 58th page along with other necessary data structures, which we will see in due course of time.)

The OS startup program loads the disk blocks to their corresponding page numbers.

### 3. Page Table for INIT Program

A page table maps a user program's virtual address space to the machine's physical address space. Each page table entry for a logical page is of 2 words. The first word is the physical page number and the second word contains a series of flags such as reference bit, valid/invalid bit, write permission bit and dirty bit. The OS startup code sets PTBR to PAGE_TABLE_BASE (which has a value of 29696 - page 58) and PTLR to 3 (2 pages for code section and 1 page for stack). The page table is then set as follows.

| Memory Address | Physical Page Number | Flags |
|---|---|---|
| PTBR | 65 | 0100 |
| PTBR + 2 | 66 | 0100 |
| PTBR + 4 | 76 | 0110 |

The init program starts from logical address 0. Hence, 0 is pushed to the top of the stack. Here, page 76 is allocated as the stack for the INIT program and its corresponding physical address is 76\*512. 0 is stored at this location. Since, within the user program, stack begins at 2\*512, this value is stored in SP. The OS startup code, then, transfers control to the INIT program using the IRET instruction.
