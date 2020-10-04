# Stage 10: Console Output

In this stage, we will rewrite the user program to enable it to write to the terminal. The main datastructures we are concerned with, here, are the system status table, process table and page table.

## Files Included

### 1. expl_progs/squares.xsm

The program is rewritten so that write system call is issued to print the squared value. The registers in use are saved to the user stack, after which the system call number (for write - 5) and arguments are pushed. Argument 1 is the file descriptor (for terminal, -2), argument 2 is the value to be printed and argument 3 could be any value (not in use but by convention, 3 arguments required). Then a space for return value is allocated in the stack. The interrupt is invoked with the `INT` instruction (`INT 7` for write). Do note that comments cannot be written in xsm programs.

### 2. spl_progs/haltprog.spl

A program with just a "halt" instruction. Used both as an interrupt 10 routine and an exception handler. (Remains unchanged as in stages 6-9)

### 3. spl_progs/sample_timer.spl

A program to be used as timer interrupt routine. Prints "TIMER" to the console on interrupt. This is not used in this stage. (Remains unchanged as in stage 9)

### 4. spl_progs/console_output.spl

The intrrupt 7 routine programs used for printing to the terminal screen. This program requires 3 arguments- argument 1 is -2 (file descriptor for terminal), argument 2 is the value to be printed and argument 3 is could be anything (exists solely for the purpose of convention). If argument 1 is -2, prints value to the terminal, else, returns -1.

### 5. spl_progs/os_startup.spl

The startup code is modified to load the interrupt 7 routine from disk to memory.

## Compiling SPL Programs

It is assumed that both the eXpOS package and this repository are set up at home directory. If not, follow the main [README.md](/README.md).

Starting from this stage, a bash script, `run.sh`, containing commands for compiling the spl programs and XFS-interface commands for loading the required files. Another file, `batch-xfs` is also provided that contains commands to be run by the `xfs-interface` tool.

First, set executable permission for the bash script:

```
$ cd ~/expos-roadmap/stage10
$ sudo chmod +x run.sh
```

Then run the bash script:

```
$ ./run.sh
```

This will generate corresponding xsm files:`haltprog.xsm`, `os_startup.xsm`, `sample_timer.xsm` and `console_output.xsm`.

Then run:

```
$ cd ~/myexpos/xfs-interface
$ ./xfs-interface run ~/expos-roadmap/stage10/batch-xfs
```

This will load the compiled spl programs and also the `squares.xsm` xsm program to the disk.

## Running XSM Machine

Run the machine:

```
$ cd ~/myexpos/xsm/
$ ./xsm
```

The result will be written to the console.

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
| 29 - 30 | Interrupt 7 Routine: Write |
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
| 16 - 17 | Interrupt 7 Routine: Write |
| ... | ... |
| 22 - 23 | Interrupt 10 Routine: Exit |
| ... | ... |
| 56 | Process Table* |
| 57 | System Status Table* |
| 58 | Page Tables* |
| ... | ... |
| 63- 64 | Expos Library |
| 65 - 66 | Init/Login Code |
| ... | ... |

\* Contains other data structures in addition to the given content.

The OS startup program loads the disk blocks to their corresponding page numbers.

**Note:** For a more detailed organization of the memory and disk refer to the [OS implemenation](https://exposnitc.github.io/os_implementation.html) page.

### 3. Page Table for INIT Program (Same as stage 7)

PTBR is set to PAGE_TABLE_BASE (29696 - page 58) and PTLR to 10 (2 pages for library, 2 for heap, 4 for code, 2 for stack). The page table is then set as follows.

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

### 4. Process Table

A process table entry for each process present in the system. PROCESS_TABLE points to starting address of the process table (28672 - page 58). The table has space for 16 entires and each entry have 16 words (a total of 256 words). An entry has the following fields.

| Offset: | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Field: | TICK | PID* | PPID | USERID | STATE | STATE | SWAP FLAG | INODE INDEX | INPUT BUFFER | MODE FLAG | USER AREA SWAP STATUS | USER AREA PAGE NUMBER* | KERNEL STACK POINTER(KPTR) | USER STACK POINTER(UPTR)* | PTBR | PTLR |

\* We are concerned only with these fields, for now.

More info [here](https://exposnitc.github.io/os_design-files/process_table.html).

### 5. System Status Table

8 bytes long and with the following format,

| Offset | Field | Description |
|---|---|---|
| 0 | CURRENT_USER_ID | ... |
| 1 | CURRENT_PID | PID of currently running process |
| 2 | MEM_FREE_COUNT | ... |
| 3 | WAIT_MEM_COUNT | ... |
| 4 | SWAPPED CONTENT | ... |
| 5 | PAGING STATUS | ... |
| 6 | CURRENT_PID2(NEXSM) | ... |
| 7 | LOGOUT_STATUS(NEXSM) | ... |

The table starts at address 29650 (page 57). SYSTEM_STATUS_TABLE points to this location.

More info [here](https://exposnitc.github.io/os_design-files/mem_ds.html#ss_table).
