# Stage 14: Round Robin Scheduler

In this stage, we will implement the round robin scheduler module. Another user program is hand created and along with init and idle, this is also loaded.

## Files Included

### 1. spl_progs/module_scheduler.spl

* Obtain the current PID from System Status Table.
* BP is pushed to the top of the stack. The OS kernel expects the caller to save all the registers except BP. (In ExpL compiler, this convention is followed.)
* The Process Table Entry curresponding to the current PID is obtained. KPTR (SP % 512), PTBR and PTLR fields are set.
* Iterate through Process Table entries to find a process in READY or CREATED state. If no process is found, idle program is selected to be scheduled.
* Save the new PID and find the new Process Table entry. SP is set as UAPage * 512 + KPTR. PTBR and PTLR registers are restored.
* PID field in System Status Table is updated.
* Check if the process is in CREATED state. If CREATED, set SP to UPTR, STATE to RUNNING and MODE FLAG to 0. Then pass execution to user mode using `ireturn`.
* If READY state, change STATE to RUNNING. Restore BP and return to the caller (here, it would be timer interrupt. Int 10 also calls the scheduler but execution won't return back to int 10).

### 2. spl_progs/boot_module.spl

The boot module is modified to load the `evenNum.xsm` executable and also to set up its Page Table and Process Table entries. The STATE field of the rest of the Process Table entries are set to TERMINATED.

### 3. spl_progs/sample_timer.spl

The timer ISR is modified to invoke the schefduler module. The scheduling is done solely by the scheduler and as such, the old primitive scheduling used in the timer is discarded. The timer is expected to backup the user context and set the STATE of the process from RUNNING to READY. After the call to the scheduler, the user context of the newly scheduled process is restored (assuming that scheduler returns control back to timer, else the control is directly passed to the user mode from the scheduler). SP is updated with the value in Page Table. The MODE flag is set to 0 and then the control is passed to user mode.

### 4. spl_progs/interrupt_10.spl

The ExpL compiler sets every user program to execute the `INT 10` instruction at the end of the execution. Prior to thus stage, the int 10 ISR contained only a halt instruction. The int 10 routine is rewritten as follows,

* Change state of the invoking process to TERMINATED.
* Iterate over all Process Table Entries to check whether all processes except idle are terminated. In that case, halt the system. Else, call the scheduler. There will be no return to this process as the scheduler will not schedule this process again.

### 5. expl_progs/evenNum.expl

A user program written in ExpL language that prints even numbers from 1-100. This is loaded as follows using `xfs-interface`.
```
load --exec <path_to_file.xsm>
```
The file is loaded to disk block 69 (dump the contents of INODE TABLE to get this).

| Region | Memory Pages |
|---|---|
| Stack | 84 - 85 |
| Heap | 86 - 87 |
| UAPage | 88 |

### 6. expl_progs/oddNum.expl

A user program written in ExpL language which prints odd numbes from 1-100. This is loaded as the init program.

| Region | Memory Pages |
|---|---|
| Stack | 76 - 77 |
| Heap | 78 - 79 |
| UAPage | 80 |

### Unchanged files:

### 1. expl_progs/idle.expl

This is the idle program written in ExpL language. It contains an infininte loop. The program is compiled and loaded to disk blocks 11 and 12. The OS bootstrap loader must load this program to memory pages 69 and 70.

As idle program doesn't use library functions or dynamic memory allocation, it doesn't need library or heap pages. Only one page is needed for stack, as its memory requirements are low.

| Region | Memory Pages |
|---|---|
| Stack | 81 |
| UAPage | 82 |

For details, see Disk and Memory layout below or [click here](https://exposnitc.github.io/os_implementation.html).

(Remains unchanged as in stage 12)

### 2. spl_progs/sample_timer.spl

The timer is modified to alternate between the two processes upon interruption.

UPTR of current process is set. The SP set to UArea Page * 512 - 1 for kernel stack. Then the user context is backed up. Only after this, the registers could be used. The KTPR, PTBR, PTLR and STATE(READY) fields of current process are set. PTBR and PTLR registers set to the new process's values. SP is changed to point to the new process's kernel stack. PID value of the new process is set in System Status Table. Checking for CREATED state, so as to avoid restoring. STATE of process set to RUNNING. The user context is restored. SP is set to point to the top of the user stack.  Do note that this calculation uses only constants and do not use registers, as registers should not be used beyond `restore`.

(Remains unchanged as in stage 12)

### 3. spl_progs/haltprog.spl

A program with just a "halt" instruction. Used as the exception handler.

(Remains unchanged as in stages 6-13)

### 4. spl_progs/console_output.spl

The interrupt 7 routine programs used for printing to the terminal screen. This program requires 3 arguments- argument 1 is -2 (file descriptor for terminal), argument 2 is the value to be printed and argument 3 is could be anything (exists solely for the purpose of convention). If argument 1 is -2, prints value to the terminal, else, returns -1.

(Remains unchanged as in stage 11-13)

### 5. spl_progs/os_startup.spl

The OS startup code is modified to load only the boot module and idle program to disk. The boot module is then invoked, after which, the tables for the idle program is initialised. The STATE of the program is set to RUNNING as it is scheduled to run first. The PTBR and PTLR registers are set and the ireturn statement passes control to the user programs.

(Remains unchanged as in stage 13)

## Compiling SPL Programs

It is assumed that both the eXpOS package and this repository are set up at home directory. If not, follow the main [README.md](/README.md).

A bash script, `run.sh`, containing commands for compiling the expl programs and spl programs is provided. Another file `batch-xfs` contains commands to be run by the `xfs-interface` tool for loading the programs to appropriate disk blocks.

First, set executable permission for the bash script:

```
$ cd ~/expos-roadmap/stage14
$ sudo chmod +x run.sh
```

Then run the bash script:

```
$ ./run.sh
```

This will generate corresponding xsm files: `oddNum.xsm`(init program), `evenNum.xsm`, `idle.xsm` in the `expl_progs` directory and `module_boot.xsm`, `module_scheduler.xsm`, `interrupt_10.xsm`, `haltprog.xsm`, `os_startup.xsm`, `sample_timer.xsm`, `console_output.xsm` in the `spl_progs` directory.

Then run:

```
$ cd ~/myexpos/xfs-interface
$ ./xfs-interface run ~/expos-roadmap/stage14/batch-xfs
```

This will load the compiled spl programs and the user programs to disk.

### Note1: 

A bash script `rm.sh` is provided to remove all the `xsm` files.

### Note2:

To view the disk block of `evenNum.xsm`, dump the inode table using the following commands,

```
$ cd ~/myexpos/xfs-interface
$ ./xfs-inerface
```

This fires up the `xfs-interface` tool. Execute the below commands within the tool:

```
# dump --inodeusertable
# exit
```

A file named `inodeusertable.txt` can be found within the xfs-interface directory. Open the file and search for `evenNum.xsm`. Each inode table table entry is 16 words long, with each word showing up in new line. The 2nd word is the filename and the first data block is the 9th word. So, the 8th line after the line with `evenNum.xsm` contains the disk block of the file. (Here it was 69).

For more info on Inode Table, click [here](https://exposnitc.github.io/os_design-files/disk_ds.html#inode_table).

## Running XSM Machine

Run the machine:

```
$ cd ~/myexpos/xsm/
$ ./xsm --timer 20
```

You will get an output of numbers from 1 - 100 in order if the value of timer is small, and out of order as value increases.

## Explanation

1. [Disk and Memory Organization](https://exposnitc.github.io/os_implementation.html) page.

2. [Page Table](https://exposnitc.github.io/arch_spec-files/paging_hardware.html) for more info.

3. [Process Table](https://exposnitc.github.io/os_design-files/process_table.html).

4. [System Status Table](https://exposnitc.github.io/os_design-files/mem_ds.html#ss_table).
