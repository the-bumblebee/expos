# Stage 12: Introduction to Mutliprogramming

In this stage, we will load two processes into memory and put tme on concurrent execution. The timer interrupt handler is modified to implement a very primitive scheduler. The two processes are init and idle.

## Questions

1. Why idle program?
2. Why KPTR offset?

## Files Included

### 1. expl_progs/idle.expl

This is the idle program written in ExpL language. It contains an infininte loop. The program is compiled and loaded to disk blocks 11 and 12. The OS bootstrap loader must load this program to memory pages 69 and 70.

As idle program doesn't use library functions or dynamic memory allocation, it doesn't need library or heap pages. Only one page is needed for stack, as its memory requirements are low.

Stack is allocated at 81 and User Page Area allocated at page 82.

For details, see Disk and Memory layout below or [click here](https://exposnitc.github.io/os_implementation.html).

### 2. spl_progs/os_startup.spl

Several data structures are set up so that the OS is able to keep track of the state of each process.

PID of idle - 0 and init - 1.

Page table starting address: `[PAGE_TABLE_BASE + 20*PID]`

Process table starting address: `[PROCESS_TABLE + 16*PID]`

Changes are made as the PID of init is 1 here (in earlier stages, it was 0).

The bootstrap loader schedules the init program first. The STATE field in Process Table entry is set to RUNNING for the init program and CREATED(never scheduled before for execution) for idle program. STATE field occupiees 2 words. But 2nd word not used for CREATED and RUNNING.

User Page Area allocated for idle and UPTR(8*512) and KPTR(0) fields set in the Process Table. KPTR stores offset of the kernel stack pointer within User Page Area.

When a process is executing in user mode, the active stack will be the user stack. When the process switches to kernel mode, the first action by the kernel code will be to save the SP value to UPTR and set the SP register to the physical address of the top of the kernel stack. When a process enters the kernel mode from user mode, the kernel stack will always be empty. Hence, SP must be set to value (User Area Page Number * 512 - 1) whenever kernel mode is entered from the user mode.

Before IRET instruction and switch from kernel mode to user mode, the SP set to in UPTR field. The kernel stack will be empty as there is no kernel context to be remembered. 

### 3. spl_progs/sample_timer.spl

The timer is modified to alternate between the two processes upon interruption.

UPTR of current process is set. The SP set to UArea Page * 512 - 1 for kernel stack. Then the user context is backed up. Only after this, the registers could be used. The KTPR, PTBR, PTLR and STATE(READY) fields of current process are set. PTBR and PTLR registers set to the new process's values. SP is changed to point to the new process's kernel stack. PID value of the new process is set in System Status Table. Checking for CREATED state, so as to avoid restoring. STATE of process set to RUNNING. The user context is restored. SP is set to point to the top of the user stack.  Do note that this calculation uses only constants and do not use registers, as registers should not be used beyond `restore`.

### Unchanged files:

### 1. expl_progs/numbers.expl

This is the user program written in ExpL language which prints the first 50 natural numbers. This program also uses exposcall() function to write the result on to the screen. The ExpL compiler translates the exposcall() to the corresponding low level system call and produces `numbers.xsm` in the same directory, on compiling.

Stack pages: 76, 77. User Area Page: 80.

(Remains unchanged as in stage 11)

### 2. spl_progs/haltprog.spl

A program with just a "halt" instruction. Used both as an interrupt 10 routine and an exception handler. (Remains unchanged as in stages 6-11)

### 3. spl_progs/console_output.spl

The interrupt 7 routine programs used for printing to the terminal screen. This program requires 3 arguments- argument 1 is -2 (file descriptor for terminal), argument 2 is the value to be printed and argument 3 is could be anything (exists solely for the purpose of convention). If argument 1 is -2, prints value to the terminal, else, returns -1.
(Remains unchanged as in stage 11)

## Compiling SPL Programs

It is assumed that both the eXpOS package and this repository are set up at home directory. If not, follow the main [README.md](/README.md).

A bash script, `run.sh`, containing commands for compiling the expl programs and spl programs is provided. Another file `batch-xfs` contains commands to be run by the `xfs-interface` tool for loading the programs to appropriate disk blocks.

First, set executable permission for the bash script:

```
$ cd ~/expos-roadmap/stage12
$ sudo chmod +x run.sh
```

Then run the bash script:

```
$ ./run.sh
```

This will generate corresponding xsm files: `numbers.xsm`(init program), `idle.xsm` in the `expl_progs` directory and `haltprog.xsm`, `os_startup.xsm`, `sample_timer.xsm`, `console_output.xsm` in the `spl_progs` directory.

Then run:

```
$ cd ~/myexpos/xfs-interface
$ ./xfs-interface run ~/expos-roadmap/stage12/batch-xfs
```

This will load the compiled spl programs and also the init and idle programs to the disk.

## Running XSM Machine

Run the machine:

```
$ cd ~/myexpos/xsm/
$ ./xsm --timer 20
```

Result same as stage 11. To see changes add write call to idle and run.

## Explanation

### 1. Disk

The files are loaded into the following disk blocks.

| Block Number | Contents |
|---|---|
| 0 - 1 | Bootstrap/OS startup code |
| ... | ... |
| 7 - 8 | Init/Login Code |
| ... | ... |
| **11 - 12** | **Idle Process** |
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
| **69 - 70** | **Idle Process** |
| ... | ... |

\* Contains other data structures in addition to the given content.

The OS startup program loads the disk blocks to their corresponding page numbers.

**Note:** For a more detailed organization of the memory and disk refer to the [OS implemenation](https://exposnitc.github.io/os_implementation.html) page.

### 3. Page Table

PTBR is set to PAGE_TABLE_BASE (29696 - page 58) and PTLR to 10 (2 pages for library, 2 for heap, 4 for code, 2 for stack). The page table of the init program as follows.

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

For idle program, only entries are for code(69, 70) and stack(81).

The second entry in the header([65\*512 + 2]) is the entry point of the program and is pushed into the stack(starting address: 76\*512). SP is set to 8\*512 which is the logical address of the stack.

Read [Paging Hardware](https://exposnitc.github.io/arch_spec-files/paging_hardware.html) for more info.

### 4. Process Table

A process table entry for each process present in the system. PROCESS_TABLE points to starting address of the process table (28672 - page 58). The table has space for 16 entires and each entry have 16 words (a total of 256 words). An entry has the following fields.

| Offset: | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Field: | TICK | PID* | PPID | USERID | STATE* | STATE | SWAP FLAG | INODE INDEX | INPUT BUFFER | MODE FLAG | USER AREA SWAP STATUS | USER AREA PAGE NUMBER* | KERNEL STACK POINTER(KPTR)* | USER STACK POINTER(UPTR)* | PTBR* | PTLR* |

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
