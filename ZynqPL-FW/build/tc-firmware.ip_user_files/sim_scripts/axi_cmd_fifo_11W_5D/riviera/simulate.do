onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+axi_cmd_fifo_11W_5D  -L xpm -L fifo_generator_v13_2_7 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.axi_cmd_fifo_11W_5D xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure

do {axi_cmd_fifo_11W_5D.udo}

run 1000ns

endsim

quit -force
