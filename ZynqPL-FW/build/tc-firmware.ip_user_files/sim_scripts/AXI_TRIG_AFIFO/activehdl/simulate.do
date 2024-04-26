onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+AXI_TRIG_AFIFO  -L xpm -L fifo_generator_v13_2_7 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.AXI_TRIG_AFIFO xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure

do {AXI_TRIG_AFIFO.udo}

run

endsim

quit -force
