onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+dig_sto_fifo_9W_16D  -L xpm -L fifo_generator_v13_2_7 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.dig_sto_fifo_9W_16D xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure

do {dig_sto_fifo_9W_16D.udo}

run 1000ns

endsim

quit -force
