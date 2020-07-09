# Stage 8: Handling Timer Interrupt

In this stage, we will write a timer interrupt routine and load it into memory.

## Files Included

### 1. expl_progs/squares.xsm

A program to print squares of first 6 natural numbers. (Remains unchanged as in stage 7)

### 2. spl_progs/haltprog.spl

A program with just a "halt" instruction. Used both as an interrupt 10 routine and an exception handler. (Remains unchanged as in stage 6-7)

### 3. spl_progs/sample_timer.spl

A program to be used as timer interrupt routine. Prints "TIMER" to the console on interrupt.

### 4. spl_progs/os_startup.spl

The startup code is modified to load the the timer interrupt routine from disk to memory.

## Compiling SPL Programs

It is assumed that both the eXpOS package and this repository are set up at home directory. If not, follow the main [README.md](/README.md).

```
$ cd ~/myexpos/spl/
$ ./spl ~/expos-roadmap/spl_progs/haltprog.spl
$ ./spl ~/expos-roadmap/spl_progs/os_startup.spl
$ ./spl ~/expos-roadmap/spl_progs/sample_timer.spl
```

This will generate corresponding xsm files:`haltprog.xsm`, `os_startup.xsm`, and `sample_timer.xsm`.

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
# load --int=timer $HOME/expos-roadmap/spl_progs/sample_timer.xsm
# exit
```

`~` doesn't work within the XFS interface program and so `$HOME` has to be used.

## Running XSM Machine

Running the machine in debug mode with timer enabled.

```
$ cd ~/myexpos/xsm/
$ ./xsm --timer 2
```

The timer interrupts after every 2 instructions and the timer interrupt routine is executed.

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
| 17 - 18 | Timer Interrupt Routine |
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
| 4 - 5 | Timer Interrupt Routine |
| ... | ... |
| 22 - 23 | Interrupt 10 Routine: Exit |
| ... | ... |
| 63- 64 | Expos Library |
| 65 - 66 | Init/Login Code |
| ... | ... |

The OS startup program loads the disk blocks to their corresponding page numbers.

### 3. Page Table for INIT Program (Same as stage 7)

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
