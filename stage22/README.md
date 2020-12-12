# Stage 22: Semaphores

### Interrupt Routine 13
Semget. Semrelease

### Resoruce Manger Module
Acquire Semaphore. Release Semaphore.

### Interrupt Routine 14
SemLock. SemUnlock.

### Boot Module


**Note:** There's a bug in Exec (interrupt 9) system call (which I had narrowed down to anyway) that causes an exception in the parent-child process of stage 22. The exception isn't caused straight away on execution. The program might be needed to run a couple of times (4 in my case) to show the exception. Another execution after this, causes the program to produce 2 exceptions after which the program won't run as expected. In interrupt 9, commenting out the portion where code blocks are set to the disk map table, somehow weirdly, fixes this bug.


## Per Process Table
Resource ID - 1 for Semaphore and 0 for file.

1. [Per Process Table](https://exposnitc.github.io/os_design-files/process_table.html#per_process_table)
2. [Semaphore](https://exposnitc.github.io/os_design-files/mem_ds.html#sem_table)