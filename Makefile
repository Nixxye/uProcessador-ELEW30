FILES = bitShifter halfAdder halfSubtractor mux16
TESTBENCH = tb
MAIN = ULA
WORKDIR = work

GHDL_CMD = ghdl
GHDL_FLAGS = --workdir=$(WORKDIR)
WAVEFORM_VIEWER = gtkwave

all: clean make view

make:
	@mkdir -p work
	@$(GHDL_CMD) -a $(GHDL_FLAGS) $(addprefix source/, $(FILES:=.vhd)) $(MAIN:=.vhd) $(addprefix testbench/, $(TESTBENCH:=.vhd))
	@$(GHDL_CMD) -e $(GHDL_FLAGS) $(TESTBENCH)
	@$(GHDL_CMD) -r $(GHDL_FLAGS) $(TESTBENCH) --wave=$(TESTBENCH).ghw
	@mv $(TESTBENCH).ghw $(WORKDIR)/
view: 
	@$(WAVEFORM_VIEWER) $(addprefix $(WORKDIR)/, $(TESTBENCH:=.ghw))

clean:
	@rm -rf work