# Stage 16: Console Input (Interrupt 7)

Here, we will implement the interrupt routine for console input. A process must use the `IN` instruction to read data from the console to the input port `P0`. `IN` is a privileged instruction and thus thus the user process must invoke the (read system call)[https://exposnitc.github.io/os_spec-files/systemcallinterface.html]. The read system call invokes the Terminal Read function present in Device Manager module. The `IN` instruction will be executed within this function.

`IN` instruction will not wait for the data to arrive in `P0`. Instead, the XSM machine continues to the next instruction. Hence, XSM machine detects input with the use of the console interrupt. When some number/string is entered from the keyboard and Enter is pressed, the machine raises the console interrupt.

Hence, the correponding process sets its state to WAIT_TERMINAL and invokes the Scheduler. The process can only resume execution once the console interrupt is raised and is scheduled again. Each process also has an input buffer.

## Files Included

### 1. spl_progs/interrupt_console_input.spl

This code is executed when the "Read" system call is encountered. It takes in arguments file descriptor (-1 for console input) and the logical address th where the data is to be stored.

* The MODE flag is set 7 for "Read" system call.

* SP is saved and SP is changed to point to the kernel stack.

* The file descriptor and word address arguments are retrieved from the user stack

* If file descriptor is not -1, return value is set as -1 in the user stack.

* If file descriptor is -1: 
  
  * The physical address corresponding to the logical address of the word is calculated.

  * The registers in use are saved

  * R1 is set to the function number of Terminal Read(4), R2 to the PID of the process and R3 to the logical address of the location.

  * The Device Manager Module is invoked.

  * The registers are popped back.
  
  * Return value is set as 0 in the user stack to indicate success.

* SP is back to the user SP.

* MODE flag is set back to 0.

* Control passed back to user process.

### 2. spl_progs/module_device_manager.spl

The Device Manager Module is modified to add the Terminal Read function support.

* Check if the function number passed in through R2 is 4 for Terminal Read (4) and proceeds only if true.

* Save registers in use.

* R1 is set to the function number of Acquire Terminal (8) and R2 to the PID of the process.

* The Resource Manager Module is invoked.

* The registers are restored.

* `read` statement is used to take input from the console to port `P0`.

* Change STATE of process to WAIT_TERMINAL.

* Registers are pushed to the stack.

* The Scheduler is invoked.

* Registers are restored.

* The physical address of the logical address present in R3 is calculated and the value in the INPUT BUFFER field of the Process Table is transferred to this location.

* Return to the caller.

### 3. spl_progs/console_interrupt_handler.spl

An interrupt is raised when input is entered into the console. This  is handled by the Console Interrupt Handler.

* User SP is saved to UPTR and SP is set the top of the kernel stack.

* The user context is backed up.

* PID and Process Table of the process that is requesting input is obtained.

* The INPUT BUFFER field in the Process Table is set to the value contained in P0.

* The registers in use are pushed to the stack.

* The Resource Manager is invoked.

* Registers are popped back.

* The user context is restored.

* SP is set back to UPTR.

* Control passed back to the user program.

### 4. spl_progs/module_boot.spl

Changes are made to load the Console Interrupt Handler and the Interrupt 6 Routine (Read System Call) from disk to memory.

### Unchanged files:

### 1. expl_progs/idle.expl

| Region | Memory Pages |
|---|---|
| Stack | 81 |
| UAPage | 82 |

### 2. expl_progs/evenNum.expl

| Region | Memory Pages |
|---|---|
| Stack | 84 - 85 |
| Heap | 86 - 87 |
| UAPage | 88 |

### 3. expl_progs/oddNum.expl

| Region | Memory Pages |
|---|---|
| Stack | 76 - 77 |
| Heap | 78 - 79 |
| UAPage | 80 |

### 4. spl_progs/haltprog.spl

### 5. spl_progs/module_scheduler.spl

### 6. spl_progs/os_startup.spl

### 7. spl_progs/sample_timer.spl

### 8. spl_progs/interrupt_10.spl

### 9. spl_progs/interrupt_console_output.spl

### 10. spl_progs/module_resource_manager.spl

## Compiling SPL Programs

It is assumed that both the eXpOS package and this repository are set up at home directory. If not, follow the main [README.md](/README.md).

A bash script, `run.sh`, containing commands for compiling the expl programs and spl programs is provided. Another file `batch-xfs` contains commands to be run by the `xfs-interface` tool for loading the programs to appropriate disk blocks.

First, set executable permission for the bash script:

```
$ cd ~/expos-roadmap/stage16
$ sudo chmod +x run.sh
```

Then run the bash script:

```
$ ./run.sh
```

This will generate corresponding xsm files: `oddNum.xsm`(init program), `evenNum.xsm`, `idle.xsm` in the `expl_progs` directory and `module_boot.xsm`, `module_scheduler.xsm`, `module_device_manager.xsm`, `module_resource_manager.xsm`, `interrupt_10.xsm`, `haltprog.xsm`, `os_startup.xsm`, `sample_timer.xsm`, `interrupt_console_output.xsm`, `interrupt_console_input.xsm`, `console_interrupt_handler.xsm` in the `spl_progs` directory.

Then run:

```
$ cd ~/myexpos/xfs-interface
$ ./xfs-interface run ~/expos-roadmap/stage16/batch-xfs
```

This will load the compiled spl programs and the user programs to disk.

### Note: 

A bash script `rm.sh` is provided to remove all the `xsm` files.

## Running XSM Machine

Run the machine:

```
$ cd ~/myexpos/xsm/
$ ./xsm --timer 20
```

You will get an output of numbers from 1 - 100 in order if the value of timer is small, and out of order as value increases.

## Explanation

1. [Disk and Memory Organization](https://exposnitc.github.io/os_implementation.html)

2. [Page Table](https://exposnitc.github.io/arch_spec-files/paging_hardware.html)

3. [Process Table](https://exposnitc.github.io/os_design-files/process_table.html)

4. [System Status Table](https://exposnitc.github.io/os_design-files/mem_ds.html#ss_table)

5. [Terminal Status Table](https://exposnitc.github.io/os_design-files/mem_ds.html#ts_table)