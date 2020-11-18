# Stage 16 Assignment 1

Write an ExpL program to read N numbers in an array, sort using bubble sort and print the sorted array to the terminal. Load this program as init program and run the machine.

## Compiling SPL Programs

It is assumed that both the eXpOS package and this repository are set up at home directory. If not, follow the main [README.md](/README.md).

A bash script, `run.sh`, containing commands for compiling the expl programs and spl programs is provided. Another file `batch-xfs` contains commands to be run by the `xfs-interface` tool for loading the programs to appropriate disk blocks.

First, set executable permission for the bash script:

```
$ cd ~/expos-roadmap/stage16_assignment1
$ sudo chmod +x run.sh

$ ./run.sh

$ cd ~/myexpos/xfs-interface
$ ./xfs-interface run ~/expos-roadmap/stage16_assignment1/batch-xfs

$ cd ~/myexpos/xsm/
$ ./xsm
```
* Enter N (1-15) followed by N numbers.
* Outputs the sorted array.