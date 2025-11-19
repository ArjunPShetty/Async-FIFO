📦 Asynchronous FIFO (Gray Code) – Verilog | Vivado Project

This project implements an Asynchronous FIFO in Verilog for safe data transfer between two different clock domains.
It uses Gray-coded pointers and two-stage synchronizers to avoid metastability.

This repository contains:  
Asynchronous FIFO RTL,
Testbench,
Simulation results

🚀 Project Overview
The FIFO supports:   
Independent write clock and read clock,
8-bit data width (parameterizable),
Configurable depth,
Full and Empty flag logic,
Gray-coded pointer architecture,
Safe Clock Domain Crossing (CDC)

🧠 Why Gray Code?
Gray code ensures only one bit changes per increment, reducing CDC errors.

This FIFO uses:   
Binary pointers,
Binary → Gray conversion,
Gray → Binary conversion,
Two-FF pointer synchronization


