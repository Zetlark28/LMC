%%nome e matricola di ogni membro

state(Acc, Pc, Mem, In, Out, Flag).

halted_state(Acc, Pc, Mem, In, Out, Flag).

%%add no flag

one_instruction(State, X):- State=..L,
                            nth0(0, L, state),
                            nth0(2, L, Pc),
                            nth0(3, L, Mem),

                            nth0(Pc, Mem, Ind),
                            Ind < 200,
                            Ind > 99,
                            Val is Ind-100,
                            nth0(Val, Mem, Res),
                            nth0(1, L, Acc),
                            Fin is Res + Acc,
                            Fin =< 1000,
                            Pc_agg is Pc+1,
                            nth0(4, L, Inp),
                            nth0(5, L, Out),
                            X=..[state, Fin, Pc_agg, Mem, Inp, Out, noflag].

%%add flag

one_instruction(State, X):- State=..L,
                            nth0(0, L, state),
                            nth0(2, L, Pc),
                            nth0(3, L, Mem),

                            nth0(Pc, Mem, Ind),
                            Ind < 200,
                            Ind > 99,
                            Val is Ind-100,
                            nth0(Val, Mem, Res),
                            nth0(1, L, Acc),
                            Fin is Res + Acc,
                            Fin > 1000,
                            Fin1 is Fin-1000,
                            Pc_agg is Pc+1,
                            nth0(4, L, Inp),
                            nth0(5, L, Out),
                            X=..[state, Fin1, Pc_agg, Mem, Inp, Out, flag].


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
                                    
%%codice per lo store    

%%Sostituisce un elemento dato l'indice
replace_el([H|T], P, El, [El|T]):- P=0.
replace_el([H|T], P, El, [H|Z]):-  Pos is P-1, replace_el(T, Pos, El, Z).

%%store
one_instruction(State, Newstate):- State=..L,
                                       nth0(0,L,state),
                                       nth0(3,L,Mem),
                                       nth0(2,L,Pc),
                                       nth0(Pc,Mem,Istr),
                                       Istr>299,
                                       Istr<400,
                                       Cell is Instr-300,
                                       nth0(1,L,Acc),
                                       replace_el(Mem,Cell,Acc,MemAcc),
                                       Pc_new is Pc+1,
                                       nth0(4,L,In),
                                       nth0(5,L,Out),
                                       nth0(6,L,Flag),
                                       NewState=..[state,Acc,Pc_new,MemAcc,In,Out,Flag].



execution_loop(State, Out).

lmc_load(Filename,Mem).

lmc_run(Filename, Input, Output):- lmc_load(Filename, Mem),

                                   execution_loop(State, Output).

                                 
