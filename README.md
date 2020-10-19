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

## Helpful Links
1. [eXpOS Design](https://exposnitc.github.io/os_design.html)
2. [Experimental Filesystem (eXpFS)](https://exposnitc.github.io/os_spec-files/eXpFS.html)
3. [XFS Interface](https://exposnitc.github.io/support_tools-files/xfs-interface.html)
4. [Disk Data Structures](https://exposnitc.github.io/os_design-files/disk_ds.html) (INODE table, Disk Free List, Root File, User Table)
5. [eXpOS Implementation](https://exposnitc.github.io/os_implementation.html)
6. [Machine Organization](https://exposnitc.github.io/arch_spec-files/machine_organisation.html)
7. [Instruction Set](https://exposnitc.github.io/arch_spec-files/instruction_set.html)
8. [Instruction Execution](https://exposnitc.github.io/Tutorials/xsm-instruction-cycle.html)

## Questions

1. Why do you need both INODE table and root file?
> The root file is accessible even in user mode but INODE table is accessible only in kernel mode and has additional information like the disk blocks the file is contained in. This information is critical if all the user programs had access to it.

2. What does the ROM code do?
> ROM code is the first thing that runs when the machine boots up. It has only 2 commands: One, to load the bootstrap code from disk block 0 to memory page 1. Two, a jump instruction that transfers execution to OS startup code (or bootstrap code).
> ```
> LOADI 1, 0
> JMP 512
> ```

3. What happens when the machine encounters `ireturn` statement?
> `ireturn` transfer execution from kernel mode to user mode. The SP, PTBR and PTLR registers should be properly set up for this to work. First, the value in the top of the stack is popped and IP is set to this value (assuming that SP is set a logical address within the number of pages as in PTLR). Now this value is checked to if it lies inside the number of pages as per the PTLR register. If not, an exception is encountered (same is the case, if SP lies outside this range).

4. Why does the scheduler has to push just the BP and not any of the other registers?
> The ExpL compiler is designed in such a way that the caller is expected to save all the registers in use and the callee expected to save just the BP. This is purely a decision choice and thers no particula reason behind it. So when the compiler compiler a system call, let's say Read, the user program saves all the registers in use except BP, and expects the system call to save the BP. So once execution changes to kernel mode, the kernel module has to save the BP. If the Read resource was free, saving BP doesn't matter, as after the system call, the execution passed back to the user program that invoked it. However, when the resource is busy, the scheduler is called within the Read function and the value in BP is overwritten with that of another user program. Thus, the BP value is pushed in to the stack inside the scheduler. (You will find it hard to find an explanation when you follow Stage 14 (Boot Module). But once you write the Read function, you will come to know the reasons then. This answers sums it up for anyone who is curious after doing Stage 14.)

5. Let's say, you decided to change the number of logical pages to 7, pages 0-1 for library, pages 2-3 for heap, 4th page for code and pages 5-6 for stack. Is this doable? Why/Why not?
> No. If we were writing the code for both the OS and the user programs in assembly, then this is doable. However, we are using compilers to generate the code. These compilers are designed such that they expect the library pages to be at 0 and 1 (a sys call would translate to CALL 0, the first address of page 0), the heap pages to be at 2 and 3 (the library that handles the dynamic memory expects 2-3 pages to be the heap), the code pages to be at 4,5,6 and 7 (the entry point of the compiled code is 2056 which is at logical page 4) and the stack pages to be at 8 and 9 (the compiler assigns memory for global variables from 4096, which is at page 8).

## Doubt

> There is one important conceptual point to be explained here relating to resource acquisition. The Acquire Terminal function described above waits in a loop, in which it repeatedly invokes the scheduler if the terminal is not free. This kind of a waiting loop is called a busy loop or busy wait. Why can't the process wait just once for a resource and simply proceed to acquire the resource when it is scheduled? In other words, what is the need for a wait in a loop? Pause to think before you read the explanation below. You will encounter such busy loops several times in this project, inside various module functions described in later stages.