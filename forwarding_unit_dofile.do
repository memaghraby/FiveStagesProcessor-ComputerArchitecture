vsim -gui work.processor
add wave -position insertpoint  \
sim:/processor/n \
sim:/processor/Clk \
sim:/processor/Rst \
sim:/processor/Int \
sim:/processor/InPort \
sim:/processor/OutPort \
sim:/processor/PCAdderCOut \
sim:/processor/IDFinish \
sim:/processor/enable1 \
sim:/processor/IntDecode \
sim:/processor/IntExecute \
sim:/processor/IDFinishExecute \
sim:/processor/enable2 \
sim:/processor/CarryOutALU \
sim:/processor/IntMemory \
sim:/processor/enable3 \
sim:/processor/IntWriteBack \
sim:/processor/enable4 \
sim:/processor/CFExecute \
sim:/processor/ZFExecute \
sim:/processor/NFExecute \
sim:/processor/jmpExecute \
sim:/processor/IntWriteBack2 \
sim:/processor/IDSel \
sim:/processor/SelALUMux1 \
sim:/processor/SelALUMux2 \
sim:/processor/WriteAddr1Execute \
sim:/processor/WriteAddr2Execute \
sim:/processor/WriteAddr1Decode \
sim:/processor/WriteAddr2Decode \
sim:/processor/WriteAddr1Memory \
sim:/processor/WriteAddr2Memory \
sim:/processor/WriteAddr1WriteBack \
sim:/processor/WriteAddr2WriteBack \
sim:/processor/FlagsRestore \
sim:/processor/ReadAddr2Execute \
sim:/processor/FinishOut \
sim:/processor/ShiftAmountExecute \
sim:/processor/temp_shift \
sim:/processor/FetchedInstruction \
sim:/processor/FetchedInstructionDecode \
sim:/processor/SPOut \
sim:/processor/DataMemAddr \
sim:/processor/ControlUnitOut \
sim:/processor/ControlUnitExecute \
sim:/processor/ControlUnitMemory \
sim:/processor/ControlUnitWriteBack \
sim:/processor/SignExtendDecode \
sim:/processor/SignExtendExecute \
sim:/processor/ALUIn1 \
sim:/processor/ALUIn2 \
sim:/processor/InPortMemory \
sim:/processor/ALUOutMemory \
sim:/processor/SignExtendMemory \
sim:/processor/PCMemory \
sim:/processor/MemReadData \
sim:/processor/MemWriteData \
sim:/processor/InPortWriteBack \
sim:/processor/MemReadDataWriteBack \
sim:/processor/ALUOutWriteBack \
sim:/processor/SignExtendWriteBack \
sim:/processor/ReadData2WriteBack \
sim:/processor/ReadData2Memory \
sim:/processor/WriteBackMux \
sim:/processor/PCMux \
sim:/processor/Flags \
sim:/processor/PCOut \
sim:/processor/PCAdderOut \
sim:/processor/Instruction \
sim:/processor/ReadD1 \
sim:/processor/ReadD2 \
sim:/processor/InPortDecode \
sim:/processor/PCDecode \
sim:/processor/InPortExecute \
sim:/processor/ReadData1Execute \
sim:/processor/ReadData2Execute \
sim:/processor/PCExecute \
sim:/processor/ALUOutput
force -freeze sim:/processor/Clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/Rst 1 0
run
force -freeze sim:/processor/Rst 0 0
add wave -position insertpoint  \
sim:/processor/RF/R0/q
add wave -position insertpoint  \
sim:/processor/RF/R1/q
add wave -position insertpoint  \
sim:/processor/RF/R2/q
add wave -position insertpoint  \
sim:/processor/RF/R3/q
add wave -position insertpoint  \
sim:/processor/RF/R4/q
add wave -position insertpoint  \
sim:/processor/RF/R5/q
add wave -position insertpoint  \
sim:/processor/RF/R6/q
add wave -position insertpoint  \
sim:/processor/RF/R7/q
add wave -position insertpoint  \
sim:/processor/CCRx/CF \
sim:/processor/CCRx/ZF \
sim:/processor/CCRx/NF
mem load -filltype value -filldata 0011100000000000 -fillradix symbolic /processor/IM/memory(0)
mem load -filltype value -filldata {0011100100000000 } -fillradix symbolic /processor/IM/memory(1)
mem load -filltype value -filldata {0011101000000000  } -fillradix symbolic /processor/IM/memory(2)
mem load -filltype value -filldata {0011101100000000 } -fillradix symbolic /processor/IM/memory(3)
mem load -skip 0 -filltype value -filldata 0001000000000000 -fillradix symbolic -startaddress 4 -endaddress 1023 /processor/IM/memory
mem load -filltype value -filldata 0100100000110100 -fillradix symbolic /processor/IM/memory(8)
mem load -filltype value -filldata 0100110100011100 -fillradix symbolic /processor/IM/memory(9)
mem load -filltype value -filldata {0100100010111000 } -fillradix symbolic /processor/IM/memory(10)
mem load -filltype value -filldata 0100000000100000 -fillradix symbolic /processor/IM/memory(16)
mem load -filltype value -filldata {0100000000100000 } -fillradix symbolic /processor/IM/memory(17)
force -freeze sim:/processor/InPort 00000000000000000000000000000001 0
run
force -freeze sim:/processor/InPort 00000000000000000000000000000010 0
run
force -freeze sim:/processor/InPort 00000000000000000000000000000011 0
run
force -freeze sim:/processor/InPort 00000000000000000000000000000100 0
run
run
run
run
run
run
run
run
run
run
run
run