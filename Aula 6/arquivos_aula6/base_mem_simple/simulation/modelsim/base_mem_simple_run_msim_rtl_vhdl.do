transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/Aluno/Documents/Uehara/Aula 6/arquivos_aula8/base_mem_simple/mem_2port.vhd}
vcom -93 -work work {C:/Users/Aluno/Documents/Uehara/Aula 6/arquivos_aula8/base_mem_simple/reg.vhd}
vcom -93 -work work {C:/Users/Aluno/Documents/Uehara/Aula 6/arquivos_aula8/base_mem_simple/base_mem_simple.vhd}
vcom -93 -work work {C:/Users/Aluno/Documents/Uehara/Aula 6/arquivos_aula8/base_mem_simple/reg_bank.vhd}
vcom -93 -work work {C:/Users/Aluno/Documents/Uehara/Aula 6/arquivos_aula8/base_mem_simple/code_gen.vhd}

vcom -93 -work work {C:/Users/Aluno/Documents/Uehara/Aula 6/arquivos_aula8/base_mem_simple/clock_generator.vhd}
vcom -93 -work work {C:/Users/Aluno/Documents/Uehara/Aula 6/arquivos_aula8/base_mem_simple/mem_2port.vhd}
vcom -93 -work work {C:/Users/Aluno/Documents/Uehara/Aula 6/arquivos_aula8/base_mem_simple/reg.vhd}
vcom -93 -work work {C:/Users/Aluno/Documents/Uehara/Aula 6/arquivos_aula8/base_mem_simple/code_gen.vhd}
vcom -93 -work work {C:/Users/Aluno/Documents/Uehara/Aula 6/arquivos_aula8/base_mem_simple/reg_bank.vhd}
vcom -93 -work work {C:/Users/Aluno/Documents/Uehara/Aula 6/arquivos_aula8/base_mem_simple/base_mem_simple.vhd}
vcom -93 -work work {C:/Users/Aluno/Documents/Uehara/Aula 6/arquivos_aula8/base_mem_simple/stimuli_base_mem.vhd}
vcom -93 -work work {C:/Users/Aluno/Documents/Uehara/Aula 6/arquivos_aula8/base_mem_simple/testbench_base_mem.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -voptargs="+acc"  tb_base_mem

add wave *
view structure
view signals
run 1000 ns
