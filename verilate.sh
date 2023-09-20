#! /bin/bash

modules_to_verilate=(adder.v client.v)
verilator_files_path="verilator_files"

rm -rf ${verilator_files_path}

for module in  ${modules_to_verilate[@]}; do
    verilator --sc --pins-bv 2 -CFLAGS -std=c++11 -Wno-fatal -Wall --Mdir verilator_files ${module}
done