onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc "  -L xpm -L fifo_generator_v13_2_7 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.axi_cmd_fifo_11W_5D xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {axi_cmd_fifo_11W_5D.udo}

run 1000ns

quit -force
