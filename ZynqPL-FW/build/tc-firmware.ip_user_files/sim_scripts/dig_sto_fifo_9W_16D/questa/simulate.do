onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib dig_sto_fifo_9W_16D_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {dig_sto_fifo_9W_16D.udo}

run 1000ns

quit -force
