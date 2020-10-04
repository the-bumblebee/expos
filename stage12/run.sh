#!/bin/bash


cd ~/myexpos/spl/
./spl ~/expos-roadmap/stage12/spl_progs/console_output.spl
./spl ~/expos-roadmap/stage12/spl_progs/haltprog.spl
./spl ~/expos-roadmap/stage12/spl_progs/os_startup.spl
./spl ~/expos-roadmap/stage12/spl_progs/sample_timer.spl
cd ../expl/
./expl ~/expos-roadmap/stage12/expl_progs/numbers.expl
./expl ~/expos-roadmap/stage12/expl_progs/idle.expl