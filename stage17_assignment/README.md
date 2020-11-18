# Stage 17 Assignment

Use the XSM debugger to print out the contents of the System Status Table and the Memory Free List after Get Free Page and Release Page functions, inside the Memory Manager module. 

## Compiling SPL Programs

```
$ cd ~/expos-roadmap/stage17_assignment
$ sudo chmod +x run.sh

$ ./run.sh

$ cd ~/myexpos/xfs-interface
$ ./xfs-interface run ~/expos-roadmap/stage17_assignment/batch-xfs

$ cd ~/myexpos/xsm/
$ ./xsm --debug
```

* Type `numbers.xsm` and hit Enter.
* The console prints `releasepage` after which the first breakpoint is encountered. Rype `sst` to print the System Status Table and `mf` to print the Memory Free List.
* For each `releasepage`, MEM_FREE_COUNT in System Status Table increments and an entry in Memory Free List is decremented.
* The breakpoint after `getfreepage` is the breakpoint after Get Free Page function call. MEM_FREE_COUNT decrements and an entry in Memory Free List is incremented.