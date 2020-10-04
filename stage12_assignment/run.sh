#!/bin/bash


cd ~/myexpos/spl/
./spl ~/expos-roadmap/stage12_assignment/spl_progs/console_output.spl
./spl ~/expos-roadmap/stage12_assignment/spl_progs/haltprog.spl
./spl ~/expos-roadmap/stage12_assignment/spl_progs/os_startup.spl
./spl ~/expos-roadmap/stage12_assignment/spl_progs/sample_timer.spl
cd ../expl/
./expl ~/expos-roadmap/stage12_assignment/expl_progs/numbers.expl
./expl ~/expos-roadmap/stage12_assignment/expl_progs/idle.expl