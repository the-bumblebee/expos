# Stage 15: Resource Manager Module (Module 0)

The Resource Manager Module manage resources like terminal, disk, inode, etc. among different processes.


// Acquire term-8 release -9
// argument r1, r2  r3, r1 func number, r2 pid
// not directly invoked from writ sys call
// invokes rerminal wrote func in device manafer module, r1 func number 3, r2 pid, r3 word
// invoker must save registers in use before invoke
// return value r0 0
// invoker extract return val, pop back reg, resume 

There is one important conceptual point to be explained here relating to resource acquisition. The Acquire Terminal function described above waits in a loop, in which it repeatedly invokes the scheduler if the terminal is not free. This kind of a waiting loop is called a busy loop or busy wait. Why can't the process wait just once for a resource and simply proceed to acquire the resource when it is scheduled? In other words, what is the need for a wait in a loop? Pause to think before you read the explanation below. You will encounter such busy loops several times in this project, inside various module functions described in later stages.

## Files Included

### 1. spl_progs/console_output.spl

### 2. spl_progs/module_boot.spl

### 3. spl_progs/module_device_manager.spl

### 4. spl_progs/module_resource_manager.spl

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
$ cd ~/expos-roadmap/stage14
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
$ ./xfs-interface run ~/expos-roadmap/stage14/batch-xfs
```

This will load the compiled spl programs and the user programs to disk.

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