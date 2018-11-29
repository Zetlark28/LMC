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
                            pc_agg(Pc, New_Pc),
                            nth0(4, L, Inp),
                            nth0(5, L, Out),
                            X=..[state, Fin, New_Pc, Mem, Inp, Out, noflag].

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
                            pc_agg(Pc, New_Pc),
                            nth0(4, L, Inp),
                            nth0(5, L, Out),
                            X=..[state, Fin1, New_Pc, Mem, Inp, Out, flag].


%%Sub no flag
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
                                    sottrazione(Acc, Val, Ris),
                                    Ris>0,
                                    pc_agg(Pc, New_Pc),
                                    nth0(4, L, In),
                                    nth0(5, L, Out),
                                    NewState=.. [state, Ris, New_Pc, Mem, In, Out, noflag].

%%sub con flag
one_instruction(State, NewState):- State=..L,
                                    nth0(0, L, state),
                                    nth0(3, L, Mem),
                                    nth0(2, L, Pc),
                                    nth0(Pc, Mem, Istr),
                                    Istr>199,
                                    Istr<300,
                                    Cell is Istr-200,
                                    nth0(Cell, Mem, Val),
                                    nth0(1, L, Acc),
                                    sottrazione(Acc, Val, Ris),
                                    Ris<0,
                                    pc_agg(Pc, New_Pc),
                                    nth0(4, L, In),
                                    nth0(5, L, Out),
                                    NewState=.. [state, Ris, New_Pc, Mem, In, Out, flag].

sottrazione(N1, N2, Ris):- Diff is N1-N2,
                           Diff<(-1000),
                           Ris is Diff+1000.

sottrazione(N1, N2, Diff):- Diff is N1-N2,
                            between(-1000, 1000, Diff).

%%Codice per lo store

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
                                   Cell is Istr-300,
                                   nth0(1,L,Acc),
                                   replace_el(Mem,Cell,Acc,MemAcc),
                                   pc_agg(Pc, New_Pc),
                                   nth0(4,L,In),
                                   nth0(5,L,Out),
                                   nth0(6,L,Flag),
                                   Newstate=..[state, Acc, New_Pc, MemAcc, In, Out, Flag].
                                                                
                    
%%load
one_Instruction(State, X):- State=..L,
                            nth0(0, L, state),
                            nth0(2, L, Pc),
                            nth0(3, L, Mem),

                            nth0(Pc, Mem, Ind),
                            Ind < 600,
                            Ind > 499,
                            Val is Ind-500,
                            nth0(Val, Mem, Res),
                            Pc_agg is Pc+1,
                            nth0(4, L, Inp),
                            nth0(5, L, Out),
                            nth0(6, L, F),
                            X=..[state, Res, Pc_agg, Mem, Inp, Out, F].
                            
 %%branch if positive
 
 one_instruction(State, X):- State=..L,
                            nth0(0, L, state),
                            nth0(2, L, Pc),
                            nth0(3, L, Mem),

                            nth0(Pc, Mem, Ind),
                            Ind < 900,
                            Ind > 799,
                            nth0(6, L, noflag),
                            Val is Ind-800,
                            nth0(1, L, Acc),
                            nth0(4, L, Inp),
                            nth0(5, L, Out),
                            X=..[state, Acc, Val, Mem, Inp, Out, noflag].

%%branch
one_instruction(State, Newstate):- State=..L,
                                   nth0(0,L,state),
                                   nth0(3, L, Mem),
                                   nth0(2, L, Pc),
                                   nth0(Pc, Mem, Istr),
                                   between(600, 699, Istr),
                                   Cell is Istr-600,
                                   nth0(Cell, Mem, Val),
                                   pc_branch(Val, New_Pc),
                                   nth0(4,L,In),
                                   nth0(5,L,Out),
                                   nth0(6,L,Flag),
                                   nth0(1,L,Acc),
                                   Newstate=..[state, Acc, New_Pc, Mem, In, Out, Flag].
                                   

pc_branch(Pc,0):- Pc>99.
pc_branch(Pc, New_Pc):- between(0, 99, Pc), New_Pc is Pc.

execution_loop(State, Out).

lmc_load(Filename,Mem).

lmc_run(Filename, Input, Output):- lmc_load(Filename, Mem),

                                   execution_loop(State, Output).


pc_agg(99,0).
pc_agg(Pc, New_Pc):- between(0, 100, Pc), New_Pc is Pc+1.
