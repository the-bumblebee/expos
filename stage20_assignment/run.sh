#!/bin/bash

cd ~/myexpos/spl/
./spl ~/expos-roadmap/stage20_assignment/spl_progs/module_boot.spl
./spl ~/expos-roadmap/stage20_assignment/spl_progs/module_scheduler.spl
./spl ~/expos-roadmap/stage20_assignment/spl_progs/module_device_manager.spl
./spl ~/expos-roadmap/stage20_assignment/spl_progs/module_resource_manager.spl
./spl ~/expos-roadmap/stage20_assignment/spl_progs/module_process_manager.spl
./spl ~/expos-roadmap/stage20_assignment/spl_progs/module_memory_manager.spl
./spl ~/expos-roadmap/stage20_assignment/spl_progs/interrupt_console_output.spl
./spl ~/expos-roadmap/stage20_assignment/spl_progs/interrupt_console_input.spl
./spl ~/expos-roadmap/stage20_assignment/spl_progs/console_interrupt_handler.spl
./spl ~/expos-roadmap/stage20_assignment/spl_progs/disk_interrupt_handler.spl
./spl ~/expos-roadmap/stage20_assignment/spl_progs/exception_handler.spl
./spl ~/expos-roadmap/stage20_assignment/spl_progs/interrupt_10.spl
./spl ~/expos-roadmap/stage20_assignment/spl_progs/interrupt_9.spl
./spl ~/expos-roadmap/stage20_assignment/spl_progs/interrupt_8.spl
./spl ~/expos-roadmap/stage20_assignment/spl_progs/os_startup.spl
./spl ~/expos-roadmap/stage20_assignment/spl_progs/sample_timer.spl
cd ../expl/
./expl ~/expos-roadmap/stage20_assignment/expl_progs/idle.expl
./expl ~/expos-roadmap/stage20_assignment/expl_progs/init.expl
cd ../xfs-interface/
./xfs-interface run ~/expos-roadmap/stage20_assignment/batch-xfs