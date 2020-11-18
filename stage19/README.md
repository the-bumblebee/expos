# Stage 19: Exception Handler

* Four events- 1. Illegal memory access(EC = 2), 2. Illegal instruction(EC = 1), 3. Arithmetic exception(EC = 3), 4. Page fault(EC = 0)
* Four special registers- EC, EIP, EPN, EMA
* EC: 1-3 => prints cause of exception
* Allocation on page fault
* Initially load only 2 stack pages and 1 code page (memory utilisation better)
* Get Code Page - Allocates a memory page and loads a code block
* Pre-process disk map table (10 words) - Stores disk block numbers corresponding to memory page numbers used by process.
* Modify the exec system call to initialize the disk map table for the newly created process. The code page entries of the process's Disk Map Table are filled with the disk block numbers of the executable file being loaded from the inode table. Remaining entries are set to invalid (-1).
* Modifications to exec system call.
> Heap pages are not allocated and heap Page Table entries are invalidated. Invoke Get Code Page function only for the first code block and update Page Table entry corresponding to this page. Invalidate rest of the code pages entries in Page Table. Initialise the Disk Map Table of the process, code page entries are set to the disk block numbers from Inode Table of the program. Rest are initilised to -1.
* Get Code function in Memory Manager Module
> Go through all disk map table entries of all processes. If given block number present and corresponds to valid page table entry, return memory page number. Increment memory free list entry of that page.  If code page not in memory, invoke Get Free Page function. Load disk block to newly acquired memory page by invoking Disk Load of Device Manager Module. Return memory page number to which code block has been loaded.
* Modifications to Free Page Table function
> Go through stack and heap entries in the disk map table of the process with given PID. If valid entries found, invoke Release Block function in Memory Manager module. Invalidate all entries of the disk map table.

### Memory Manager

1. Get Code Page (Memory Manager Module, Function number = 5)
2. Release Block (Memory Manager Module, Function number = 4)

### Exec (Interrupt 9)

### Process Manager

### Exception Handler