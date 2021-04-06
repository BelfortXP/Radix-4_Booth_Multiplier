RTL  := ./src/*.v
TB   += ./test/*.v
SEED ?= $(shell data +%s)

# -------- run the simualtion throught the common methods --------
run: compile simulate

compile:
	vcs -sverilog -debug_all $(RTL) $(TB) -l com_$(SEED).log

simulate:
	./simv +plusargs_save +seed=$(SEED) -l sim_$(SEED).log

run_dve:
	dve -vpd ./vcdplus.vpd &

# -------- coverage driven strategy-------------------------------
run_cov: compile_coverage simulate_coverage

compile_coverage:
	vcs -debug_all -cm line+cond+fsm+tgl+branch -lca $(RTL) $(TB) -l com_$(SEED).log

simulate_coverage:
	./simv +plusargs_save +seed=$(SEED) -cm line+cond+fsm+tgl+branch -lca -cm_log \
		cm_$(SEED).log -l sim_$(SEED).log

report_cov:
	urg -dir simv.vdb -format both -report coverage

dve_cov:
	dve -cov -covdir simv.vdb -lca

clean:
	@-rm -rf *.log csrc simv* *.key *.vpd *.vdb *.bak *.help DVEfiles coverage
