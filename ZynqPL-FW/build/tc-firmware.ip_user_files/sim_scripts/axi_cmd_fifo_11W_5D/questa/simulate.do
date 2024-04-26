onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib axi_cmd_fifo_11W_5D_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {axi_cmd_fifo_11W_5D.udo}

run 1000ns

quit -force
