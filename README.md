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
