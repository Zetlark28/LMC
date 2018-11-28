%%nome e matricola di ogni membro

state(Acc, Pc, Mem, In, Out, Flag).

halted_state(Acc, Pc, Mem, In, Out, Flag).

one_instruction(State, NewState).

execution_loop(State, Out).

lmc_load(Filename,Mem).

lmc_run(Filename, Input, Output):- lmc_load(Filename, Mem),

                                   execution_loop(State, Output).
