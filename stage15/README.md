# Stage 15: Resource Manager Module (Module 0)

The Resource Manager module manages resources like terminal, disk, inode, etc. among different processes. Before using a resource, a process has to acquire the required resource by invoking the resource manager. A process can acquire a resource if the resource is not already acquired by some other process. If the resource requested by a process is not available, then that process has to be blocked until the resource becomes free. In the meanwhile, other processes may be scheduled.

We will also implement the Device Manager module (module 4) with Terminal Write function.

## Files Included

### 1. spl_progs/console_output.spl

The interrupt 7 routine is modified to invoke the Terminal Write function present in the Device Manager module. We will only be replacing the `print` statement with a couple lines of code.

* Push all the registers in use within the interrupt routine till now.
* Store the function number of Terminal Write (3) in R1, PID of the current process in R2 and word to be printed in R3.
* Call Device Manager module (module 4).
* Ignore value present in R0 as Terminal Write doesn't have any return value.
* Pop the registers back.

### 2. spl_progs/module_device_manager.spl

* If the function number provided in R1 is 3 then continue below steps else return.
* We will now be calling Acquire Terminal. Save all the registers in use. Store 8 (function number of Acquire Terminal) in R1 and current PID in R2.
* Call Resource Manager module (module 0). If the terminal is busy, the Resorce Manager moduler calls the scheduler and only when the terminal is available and the process acquires it, does it return back to Device Manager. The actual writing to terminal happens within the Resource Manager module.
* Ignore value present in R0 as Acquire Terminal does not have any return value.
* Restore the registers.
* Now, we will call Release Terminal. Save the registers in use. Store 9 (function number of Release Terminal) in R1 and current PID in R2.
* Call Resource Manager module (module 0).
* Return value will be in R0. Store this value in another register.
* Restore the registers.
* Return using the `return` statement.

### 3. spl_progs/module_resource_manager.spl

* For Acquire Terminal function, check if function number in R1 is 8. 

The current process should wait in a loop until the terminal is free. That is, if the STATUS field of Terminal Status Table is 1, change STATE of the process to WAIT_TERMINAL. Save the registers in use. Call scheduler to schedule other process as this process is waiting. The code following this, will only be executed after the scheduler schedules the process again. Pop the registers pushed before.

Change STATUS to 1 and PID to current PID in Terminal Status Table.

Return using the `return` statement.

* For Release Terminal function, function number is 9. Also, the current PID given in R2 and PID field should be same. If not store -1 as return value in R0 and return.

Change the STATUS field in Terminal Status Table to 0, indicating the terminal is free.

Update the STATE of the process to READY for all processes which have STATE as WAIT_TERMINAL.

Save 0 in R0 indicating success.

Return to the caller.

### 4. spl_progs/module_boot.spl

* Load Module 0 from disk blocks 53, 54 to memory pages 40, 41.

* Load Module 4 from disk blocks 61, 62 to memory pages 48, 49.

* Initialize the STATUS field in the Terminal Status Table to 0 indicating the terminal is free.

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

## Compiling SPL Programs

It is assumed that both the eXpOS package and this repository are set up at home directory. If not, follow the main [README.md](/README.md).

A bash script, `run.sh`, containing commands for compiling the expl programs and spl programs is provided. Another file `batch-xfs` contains commands to be run by the `xfs-interface` tool for loading the programs to appropriate disk blocks.

First, set executable permission for the bash script:

```
$ cd ~/expos-roadmap/stage15
$ sudo chmod +x run.sh
```

Then run the bash script:

```
$ ./run.sh
```

This will generate corresponding xsm files: `oddNum.xsm`(init program), `evenNum.xsm`, `idle.xsm` in the `expl_progs` directory and `module_boot.xsm`, `module_scheduler.xsm`, `module_device_manager.xsm`, `module_resource_manager.xsm`, `interrupt_10.xsm`, `haltprog.xsm`, `os_startup.xsm`, `sample_timer.xsm`, `console_output.xsm` in the `spl_progs` directory.

Then run:

```
$ cd ~/myexpos/xfs-interface
$ ./xfs-interface run ~/expos-roadmap/stage15/batch-xfs
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