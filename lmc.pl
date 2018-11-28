%%nome e matricola di ogni membro

state(Acc, Pc, Mem, In, Out, Flag).

halted_state(Acc, Pc, Mem, In, Out, Flag).

%%sub no flag
one_instruction(State, NewState):-  State=..L,
                                    nth0(0, L, state),
                                    nth0(3, L, Mem),
                                    nth0(2, L, Pc),
                                    nth0(Pc, Mem, Istr),
                                    Istr>199,
                                    Istr<300,
                                    Cell is Istr-200,
                                    nth0(Cell, Mem, Val),
                                    nth0(1, L, Acc),
                                    Ris is Acc-Val,
                                    Ris >0,
                                    Pc_agg is Pc+1,
                                    nth0(4, L, In),
                                    nth0(5, L, Out),
                                    NewState=.. [state, Ris, Pc_agg, Mem, In, Out, noflag].


execution_loop(State, Out).

lmc_load(Filename,Mem).

lmc_run(Filename, Input, Output):- lmc_load(Filename, Mem),

                                   execution_loop(State, Output).
