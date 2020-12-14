# eXpOS: Building an OS from Scratch!

This repo follows the roadmap provided [here](https://exposnitc.github.io/Roadmap.html) and aims at building an OS for the provided XSM machine.

## Getting Started

1. You will need to set up the myexpos package at your home directory. Follow stage 1 at the link here: https://exposnitc.github.io/Roadmap.html

Follow the stages till stage 5. This repo has source files and their explanations starting from stage 6. This is a repo that documents what I understand and it might, hopefully, help someone.

2. Download this repo and extract it to your home directory or clone it using the following commands.

```
$ cd ~
$ git clone https://github.com/the-bumblebee/expos-roadmap
```

Make sure you end up with folders `expos-roadmap` and `myexpos` at your home directory before jumping into the stages.

Each stage in this repo has a `README.md` that explains the required background in a minimal way (I hope so) and also has steps you need to follow to complete the stage. Do note that it is assumed that you have `myexpos` package and this repo set up at your home directory as mentioned above. If not, follow the above steps or change the commands of each stage accordingly. Please make sure to go through the source files and the `README.md` file of each stage for a thorough understanding, instead of just copy pasting the commands to your terminal.

## Known Bugs

#### Stage 22
* Running the process "parent.xsm" a couple of times, raises an exception in one its processes. After this, running the process again for a couple more times leads to another exception that exits the processes, before the desired output is displayed. **Note:** This bug could affect the stages following this, but the test programs used didn't show any signs. It was just this process.

## Helpful Links
1. [eXpOS Design](https://exposnitc.github.io/os_design.html)
2. [Experimental Filesystem (eXpFS)](https://exposnitc.github.io/os_spec-files/eXpFS.html)
3. [XFS Interface](https://exposnitc.github.io/support_tools-files/xfs-interface.html)
4. [Disk Data Structures](https://exposnitc.github.io/os_design-files/disk_ds.html) (INODE table, Disk Free List, Root File, User Table)
5. [Machine Organization](https://exposnitc.github.io/arch_spec-files/machine_organisation.html)
6. [Instruction Set](https://exposnitc.github.io/arch_spec-files/instruction_set.html)
7. [Instruction Execution](https://exposnitc.github.io/Tutorials/xsm-instruction-cycle.html)
8. [System Call Interface](https://exposnitc.github.io/os_spec-files/systemcallinterface.html)

#### Useful while writing code:
1. [Disk and Memory Organization](https://exposnitc.github.io/os_implementation.html)
2. [Page Table](https://exposnitc.github.io/arch_spec-files/paging_hardware.html)
3. [Process Table](https://exposnitc.github.io/os_design-files/process_table.html)
4. [System Status Table](https://exposnitc.github.io/os_design-files/mem_ds.html#ss_table)
5. [Terminal Status Table](https://exposnitc.github.io/os_design-files/mem_ds.html#ts_table)

## Questions

#### 1. Why do you need both INODE table and root file?
> The root file is accessible even in user mode but INODE table is accessible only in kernel mode and has additional information like the disk blocks the file is contained in. This information is critical if all the user programs had access to it.

#### 2. What does the ROM code do?
> ROM code is the first thing that runs when the machine boots up. It has only 2 commands: One, to load the bootstrap code from disk block 0 to memory page 1. Two, a jump instruction that transfers execution to OS startup code (or bootstrap code).
> ```
> LOADI 1, 0
> JMP 512
> ```

#### 3. What happens when the machine encounters `ireturn` statement?
> `ireturn` transfer execution from kernel mode to user mode. The SP, PTBR and PTLR registers should be properly set up for this to work. First, the value in the top of the stack is popped and IP is set to this value (assuming that SP is set a logical address within the number of pages as in PTLR). Now this value is checked to if it lies inside the number of pages as per the PTLR register. If not, an exception is encountered (same is the case, if SP lies outside this range).

#### 4. Why does the scheduler has to push just the BP and not any of the other registers?
> The ExpL compiler is designed in such a way that the caller is expected to save all the registers in use and the callee expected to save just the BP. This is purely a decision choice and theres no particular reason behind it. So when the compiler compiles a system call, let's say Read, the user program saves all the registers in use except BP, and expects the system call to save the BP. So once execution changes to kernel mode, the kernel module has to save the BP. If the Read resource was free, saving BP doesn't matter, as after the system call, the execution would be passed back to the user program that invoked it. However, when the resource is busy, the scheduler is called within the Read function and the value in BP is overwritten with that of another user program. Thus, the BP value is pushed in to the stack inside the scheduler. (You will find it hard to find an explanation when you follow Stage 14 (Boot Module). But once you write the Read function, you will come to know the reasons then. This answer sums it up for anyone who is curious after doing Stage 14.)

#### 5. Let's say, you decided to change the number of logical pages to 7, pages 0-1 for library, pages 2-3 for heap, 4th page for code and pages 5-6 for stack. Is this doable? Why/Why not?
> No. If we were writing the code for both the OS and the user programs in assembly, then this is doable. However, we are using compilers to generate the code. These compilers are designed such that they expect the library pages to be at 0 and 1 (a sys call would translate to CALL 0, the first address of page 0), the heap pages to be at 2 and 3 (the library that handles the dynamic memory expects 2-3 pages to be the heap), the code pages to be at 4,5,6 and 7 (the entry point of the compiled code is 2056 which is at logical page 4) and the stack pages to be at 8 and 9 (the compiler assigns memory for global variables from 4096, which is at page 8).

#### 6. When you wrote Acquire Terminal, you wrote a loop which continuously checked the STATUS in the Terminal Status Table. The loop calls the Scheduler if the terminal is busy (STATUS = 1). Why can't the process just wait once for the resource to be free (here terminal) and simply proceed to acquire the resource when it is acheduled? or what is the need of a loop and why not an if statement?

> When the process invokes the Scheduler waiting for a resource, the Scheduler schedules the process again only after the resource becomes free. If there is only one process waiting for the process an If statement would have sufficed here. But when 2 or more programs are waiting for the resource, a simple If statement wouldn't suffice.

> Consider a case where 3 processes need to acquire the terminal. Initially, one of them would be able to acquire the terminal. Now if another process is scheduled, the Resource Manger Module would see the terminal as busy (you might think a simple If check could do this but wait for it) and so changes the STATE of the process to WAIT_TERMINAL and invokes the Scheduler to schedule another process. Similarly, the status of the third process would be changed to WAIT_TERMINAL as well.

> Now, suppose the first process releases the terminal, in which case, the STATUS of the other 2 processes are changed to READY. Now, if the second process is scheduled, it could acquire the terminal (Till now an If would have sufficed). But, when the terminal is still in use by the second process and the third process was scheduled, the third process would go on to acquire the terminal without checking the STATUS of the Terminal Status Table (there should be another check now inside the Resource Manager, in other words, we need a loop). This would be chaotic. And this is why, a loop is used instead of an If statement. Only when the STATUS is 0 (terminal is free) would it break out of the loop and acquire it.

> After the first process, there is a "race condition" and the first process that's scheduled right after the terminal becomes free acquires the terminal. (Such busy loops will be encountered further down the road).

#### 7. Why do you need to save the user context for an interrupt and not for a system call?
> System calls are invoked directly from the user programs and as such, the ExpL compiler pushes all the registers in use except the BP to the stack. That is the user context is backed up within the user process. However, other interrupts are raised independent of the user programs and hence, the registers should be saved within the interrupt routine so as to save the user context. For more info [click here](https://exposnitc.github.io/support_tools-files/spl.html#con) and head over to "SPL Interrupt Handler and Module Programming Conventions".

#### 8. Is it possible that the running process interrupted by the console interrupt be the same process that had acquired the terminal for reading?
> No. As soon as the process acquires the terminal, IN statement is executed (in Resource Manger). Since this is a non blocking code, the XSM machine proceeds to the next instruction which is setting the STATE of the process to WAIT_TERMINAL. The Scheduler is then invoked and when the input is entered, the console interrupt is raised and the STATE of the acquired process is changed back to READY. Only then can the process be scheduled. Hence, it is not possible that the process being interrupted could be the same process.