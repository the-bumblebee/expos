# Stage 17: Program Loader

* New process from a user process "Exec" sys call
* New process same PID as calling process
* Mem Free List for all pages of all user processes set
* MEM_FREE_COUNT set


Here, we will be implementing the "Exec" system call.

#### Exec System Call (Interupt 9)

 It has only one argument, which is the file name. The system call checks for the file in the disk and also checks if it is a valid eXpOS executable. If so, the "Exec" call destroys the invoking process, loads the executable from disk.

 Exec first deallocates all the pages used by invoking process. These include the 2 heap pages, 2 stack pages, the code pages occupied by the process and the user area page. It also invalidates the page table entries. This is done by calling the Exit Process function from the Process Manager Module. Since Exec system call runs in kernel mode and needs a kernel stack for its own execution, Exec reclaims the same user area page after coming back from the Exit Process function.

#### Free User Area Page (Process Manager Module, Function number = 2)
#### Exit Process (Process Manager Module, Function number = 3)
#### Exit Process (Process Manager Module, Function number = 4)
#### Get Free Page (Memory Manager Module, Function number = 1)
#### Release Page (Memory Manager Module, Function number = 2)

## Files Included

### spl_progs/interrupt_9.spl

### spl_progs/module_process_manager.spl

### spl_progs/console_memory_manager.spl

### expl_progs/exec.expl

This is loaded as the init program. The program takes in a string and executes the file corresponding to the string given, using the "Exec" system call. If the file is not present in the disk, it will exit by displaying a message.

| Region | Memory Pages |
|---|---|
| Stack | 76 - 77 |
| Heap | 78 - 79 |
| UAPage | 80 |

### expl_progs/numbers.expl

### expl_progs/hello.expl

### spl_progs/module_boot.spl

### Unchanged files:

### expl_progs/idle.expl

| Region | Memory Pages |
|---|---|
| Stack | 81 |
| UAPage | 82 |

### spl_progs/module_device_manager.spl

### spl_progs/console_interrupt_handler.spl

### spl_progs/haltprog.spl

### spl_progs/module_scheduler.spl

### spl_progs/os_startup.spl

### spl_progs/sample_timer.spl

### spl_progs/interrupt_10.spl

### spl_progs/interrupt_console_output.spl

### spl_progs/module_resource_manager.spl

### spl_progs/interrupt_console_input.spl

## Compiling SPL Programs

It is assumed that both the eXpOS package and this repository are set up at home directory. If not, follow the main [README.md](/README.md).

A bash script, `run.sh`, containing commands for compiling the expl programs and spl programs is provided. Another file `batch-xfs` contains commands to be run by the `xfs-interface` tool for loading the programs to appropriate disk blocks.

First, set executable permission for the bash script:

```
$ cd ~/expos-roadmap/stage17
$ sudo chmod +x run.sh
```

Then run the bash script:

```
$ ./run.sh
```

This will generate corresponding xsm files: `exec.xsm`(init program), `numbers.xsm`, `hello.xsm`, `idle.xsm` in the `expl_progs` directory and `module_boot.xsm`, `module_scheduler.xsm`, `module_device_manager.xsm`, `module_resource_manager.xsm`, `module_memory_manager.xsm`, `module_process_manager.xsm`, `interrupt_10.xsm`,`interrupt_9.xsm`, `haltprog.xsm`, `os_startup.xsm`, `sample_timer.xsm`, `interrupt_console_output.xsm`, `interrupt_console_input.xsm`, `console_interrupt_handler.xsm` in the `spl_progs` directory.

Then run:

```
$ cd ~/myexpos/xfs-interface
$ ./xfs-interface run ~/expos-roadmap/stage17/batch-xfs
```

This will load the compiled spl programs and the user programs to disk.

### Note: 

A bash script `rm.sh` is provided to remove all the `xsm` files.

## Running XSM Machine

Run the machine:

```
$ cd ~/myexpos/xsm/
$ ./xsm
```

Then enter either `hello.xsm` or `numbers.xsm` to run the corresponding process.

`hello.xsm` prints "Hello World" to the terminal.

`numbers.xsm` prints numbers from 1 to 50 to the terminal.

## Explanation

1. [Disk and Memory Organization](https://exposnitc.github.io/os_implementation.html)

2. [Page Table](https://exposnitc.github.io/arch_spec-files/paging_hardware.html)

3. [Process Table](https://exposnitc.github.io/os_design-files/process_table.html)

4. [System Status Table](https://exposnitc.github.io/os_design-files/mem_ds.html#ss_table)

5. [Terminal Status Table](https://exposnitc.github.io/os_design-files/mem_ds.html#ts_table)