# Stage 6: Running a User Program

In this stage, we will rewrite the user program and the OS startup ccording to the expos ABI.

## Files Included

### 1. expl_progs/squares.xsm

This program is rewritten to include an 8 word header before the first instruction. Hence, the first instruction is loaded into memory address 2056. The entry point address is specified by the second word in the header. The library code is loaded into pages 0 and 1 of every user program. Library code is not part of the user program. Pages 2 and 3 are allocated for heap. Pages 4 to 7 are allocated for user program code. Pages 8 and 9 are allocated for the stack.

### 2. spl_progs/haltprog.spl

This spl program has only a "halt" statement and will be used as the interrupt handler 10 and also the exception handler. At the end of the user program, an INT 10 instruction is used to give control back to the os and invoke software interrupt handler 10. An exception handler routine is required when the machine encounters unexpected events within the user program. The default action is to halt the machine. (Remains unchanged as in stage 6)

### 3. spl_progs/os_startup.spl

This is the startup code and it is rewritten to load the library code and also set up the page table to include 10 logical pages.

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
# load --library $HOME/myexpos/expl/library.lib
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
| 13 - 14 | Expos Library |
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
| 63- 64 | Expos Library |
| 65 - 66 | Init/Login Code |
| ... | ... |

The OS startup program loads the disk blocks to their corresponding page numbers.

### 3. Page Table for INIT Program

PTBR is set to PAGE_TABLE_BASE and PTLR to 10 (2 pages for library, 2 for heap, 4 for code, 2 for stack). The page table is then set as follows.

| Memory Address | Physical Page Number | Flags |
|---|---|---|
| PTBR | 63 | 0100 |
| PTBR + 2 | 64 | 0100 |
| PTBR + 4 | 78 | 0110 |
| PTBR + 6 | 79 | 0110 |
| PTBR + 8 | 65 | 0100 |
| PTBR + 10 | 66 | 0100 |
| PTBR + 12 | -1 | 0000 |
| PTBR + 14 | -1 | 0000 |
| PTBR + 16 | 76 | 0110 |
| PTBR + 18 | 77 | 0110 |

The second entry in the header([65\*512 + 2]) is the entry point of the program and is pushed into the stack(starting address: 76\*512). SP is set to 8\*512 which is the logical address of the stack.
