#!/bin/bash


cd ~/myexpos/spl/
./spl ~/expos-roadmap/stage13/spl_progs/boot_module.spl
./spl ~/expos-roadmap/stage13/spl_progs/console_output.spl
./spl ~/expos-roadmap/stage13/spl_progs/haltprog.spl
./spl ~/expos-roadmap/stage13/spl_progs/os_startup.spl
./spl ~/expos-roadmap/stage13/spl_progs/sample_timer.spl
cd ../expl/
./expl ~/expos-roadmap/stage13/expl_progs/numbers.expl
./expl ~/expos-roadmap/stage13/expl_progs/idle.expl