# Stage 12 Assigment

1. Rewrite init program to print numbers from 1 to 100. Also, rewrite idle program to print numbers from 101 to 200.

2. Set two breakpoints in the timer interrupt routine, the first one immediately upon entering the timer routine and the second one just before return from the timer routine. Dump the process table entry and page table entries of current process.

## Compiling SPL Programs

```
$ cd ~/expos-roadmap/stage12_assignment
$ sudo chmod +x run.sh
$ ./run.sh
$ cd ~/myexpos/xfs-interface
$ ./xfs-interface run ~/expos-roadmap/stage12_assignment/batch-xfs
```

This will load the compiled spl programs and also the init and idle programs to the disk.

## Running XSM Machine

Run the machine:

```
$ cd ~/myexpos/xsm/
$ ./xsm --timer 20 --debug
```

Use `pcb` to print Process Table entry and `pt` to print Page Table entry.