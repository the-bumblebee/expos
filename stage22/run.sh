#!/bin/bash

cd ~/myexpos/spl/
./spl ~/expos-roadmap/stage22/spl_progs/module_boot.spl
./spl ~/expos-roadmap/stage22/spl_progs/module_scheduler.spl
./spl ~/expos-roadmap/stage22/spl_progs/module_device_manager.spl
./spl ~/expos-roadmap/stage22/spl_progs/module_resource_manager.spl
./spl ~/expos-roadmap/stage22/spl_progs/module_process_manager.spl
./spl ~/expos-roadmap/stage22/spl_progs/module_memory_manager.spl
./spl ~/expos-roadmap/stage22/spl_progs/interrupt_console_output.spl
./spl ~/expos-roadmap/stage22/spl_progs/interrupt_console_input.spl
./spl ~/expos-roadmap/stage22/spl_progs/console_interrupt_handler.spl
./spl ~/expos-roadmap/stage22/spl_progs/disk_interrupt_handler.spl
./spl ~/expos-roadmap/stage22/spl_progs/exception_handler.spl
./spl ~/expos-roadmap/stage22/spl_progs/interrupt_15.spl
./spl ~/expos-roadmap/stage22/spl_progs/interrupt_14.spl
./spl ~/expos-roadmap/stage22/spl_progs/interrupt_13.spl
./spl ~/expos-roadmap/stage22/spl_progs/interrupt_11.spl
./spl ~/expos-roadmap/stage22/spl_progs/interrupt_10.spl
./spl ~/expos-roadmap/stage22/spl_progs/interrupt_9.spl
./spl ~/expos-roadmap/stage22/spl_progs/interrupt_8.spl
./spl ~/expos-roadmap/stage22/spl_progs/os_startup.spl
./spl ~/expos-roadmap/stage22/spl_progs/sample_timer.spl
cd ../expl/
./expl ~/expos-roadmap/stage22/expl_progs/shell.expl
./expl ~/expos-roadmap/stage22/expl_progs/idle.expl
./expl ~/expos-roadmap/stage22/expl_progs/odd.expl
./expl ~/expos-roadmap/stage22/expl_progs/even.expl
./expl ~/expos-roadmap/stage22/expl_progs/pid.expl
./expl ~/expos-roadmap/stage22/expl_progs/exec.expl
./expl ~/expos-roadmap/stage22/expl_progs/rw.expl
./expl ~/expos-roadmap/stage22/expl_progs/parent.expl
./expl ~/expos-roadmap/stage22/expl_progs/child.expl
cd ../xfs-interface/
./xfs-interface run ~/expos-roadmap/stage22/batch-xfs