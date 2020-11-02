# Stage 18: Disk Interrupt Handler

* LOAD instr- page number and block number
* Disk Status Table - Acquire Disk
* exec load instead of loadi
* Disk interrupt handler
* Exec modified with Disk load instead of loadi
* Initialize per-process tablle of idle in boot
* Load disk int handler from disk to memory in boot
* Initialize STATUS field of Disk Status Table to 0


#### Disk Load (Device Manager Module, Function number = 2)
#### Acquire Disk (Resource Manager Module, Function number = 3)

## Files Included

#### spl_progs/module_device_manager.spl

#### spl_progs/module_resource_manager.spl

#### spl_progs/disk_interrupt_handler.spl

#### spl_progs/interrupt_9.spl



#### spl_progs/module_boot.spl

#### Unchanged files:

#### expl_progs/idle.expl

| Region | Memory Pages |
|---|---|
| Stack | 81 |
| UAPage | 82 |

#### expl_progs/exec.expl

| Region | Memory Pages |
|---|---|
| Stack | 76 - 77 |
| Heap | 78 - 79 |
| UAPage | 80 |

#### expl_progs/numbers.expl

#### expl_progs/hello.expl

#### spl_progs/console_interrupt_handler.spl

#### spl_progs/haltprog.spl

#### spl_progs/module_scheduler.spl

#### spl_progs/os_startup.spl

#### spl_progs/sample_timer.spl

#### spl_progs/interrupt_10.spl

#### spl_progs/interrupt_console_output.spl

#### spl_progs/interrupt_console_input.spl

#### spl_progs/module_process_manager.spl

#### spl_progs/module_memory_manager.spl

## Compiling SPL Programs

It is assumed that both the eXpOS package and this repository are set up at home directory. If not, follow the main [README.md](/README.md).

A bash script, `run.sh`, containing commands for compiling the expl programs and spl programs is provided. Another file `batch-xfs` contains commands to be run by the `xfs-interface` tool for loading the programs to appropriate disk blocks.

First, set executable permission for the bash script:

```
$ cd ~/expos-roadmap/stage18
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
$ ./xfs-interface run ~/expos-roadmap/stage18/batch-xfs
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

6. [Disk Status Table](https://exposnitc.github.io/os_design-files/mem_ds.html#ds_table)