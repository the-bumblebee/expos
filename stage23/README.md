# Stage 23: File Creation and Deletion

### Interrupt Routine 4
**Create System Call:** Args - filename, permission

Creates empty file with given filename. Modifies root file and inode table.

**Delete System Call:** Args - filename

Deletes record of file from root file and inode table.

### Resoruce Manager Module
Acquire Inode. Release Inode.

### Interrupt Routine 15
Shutdown.

### Boot Module


## Per Process Table
Resource ID - 1 for Semaphore and 0 for file.

1. [Per Process Table](https://exposnitc.github.io/os_design-files/process_table.html#per_process_table)
2. [Semaphore](https://exposnitc.github.io/os_design-files/mem_ds.html#sem_table)