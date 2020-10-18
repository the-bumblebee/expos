#!/bin/bash


cd ~/myexpos/spl/
./spl ~/expos-roadmap/stage15/spl_progs/module_boot.spl
./spl ~/expos-roadmap/stage15/spl_progs/module_scheduler.spl
./spl ~/expos-roadmap/stage15/spl_progs/module_device_manager.spl
./spl ~/expos-roadmap/stage15/spl_progs/module_resource_manager.spl
./spl ~/expos-roadmap/stage15/spl_progs/console_output.spl
./spl ~/expos-roadmap/stage15/spl_progs/haltprog.spl
./spl ~/expos-roadmap/stage15/spl_progs/interrupt_10.spl
./spl ~/expos-roadmap/stage15/spl_progs/os_startup.spl
./spl ~/expos-roadmap/stage15/spl_progs/sample_timer.spl
cd ../expl/
./expl ~/expos-roadmap/stage15/expl_progs/oddNum.expl
./expl ~/expos-roadmap/stage15/expl_progs/evenNum.expl
./expl ~/expos-roadmap/stage15/expl_progs/idle.expl