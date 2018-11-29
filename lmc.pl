%%nome e matricola di ogni membro

state(Acc, Pc, Mem, In, Out, Flag).

halted_state(Acc, Pc, Mem, In, Out, Flag).

%%add no flag

one_instruction(State, X):- State=..L,
                            nth0(0, L, state),
                            nth0(2, L, Pc),
                            nth0(3, L, Mem),
                            nth0(Pc, Mem, Ind),
                            between(100,199,Ind),
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
                            between(100,199,Ind),
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
                                    between(200,299,Istr),
                                    Cell is Istr-200,
                                    nth0(Cell, Mem, Val),
                                    nth0(1, L, Acc),
                                    Ris is Acc-Val,
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
                                    between(300,399,Istr),
                                    Cell is Istr-200,
                                    nth0(Cell, Mem, Val),
                                    nth0(1, L, Acc),
                                    Diff is Acc-Val,
                                    Diff < 0,
                                    Ris is Diff+1000,
                                    pc_agg(Pc, New_Pc),
                                    nth0(4, L, In),
                                    nth0(5, L, Out),
                                    NewState=.. [state, Ris, New_Pc, Mem, In, Out, flag].


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
                                   between(300,399,Istr),
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
                            between(500,599,Ind),
                            Val is Ind-500,
                            nth0(Val, Mem, Res),
                            pc_agg(Pc, New_pc),
                            nth0(4, L, Inp),
                            nth0(5, L, Out),
                            nth0(6, L, F),
                            X=..[state, Res, New_Pc, Mem, Inp, Out, F].
  
  %%branch if zero
  
one_instruction(State, X):- State=..L,
                            nth0(0, L, state),
                            nth0(2, L, Pc),
                            nth0(3, L, Mem),
                            nth0(Pc, Mem, Ind),
                            between(700,799,Ind),
                            nth0(6, L, noflag),
                            Val is Ind-700,
                            nth0(1, L, 0),
                            nth0(4, L, Inp),
                            nth0(5, L, Out),
                            X=..[state, Acc, Val, Mem, Inp, Out, noflag].
                            
 %%branch if positive
 
 one_instruction(State, X):- State=..L,
                            nth0(0, L, state),
                            nth0(2, L, Pc),
                            nth0(3, L, Mem),

                            nth0(Pc, Mem, Ind),
                            between(800,899,Ind),
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
                                   nth0(4,L,In),
                                   nth0(5,L,Out),
                                   nth0(6,L,Flag),
                                   nth0(1,L,Acc),
                                   New_Pc is Pc-600,
                                   Newstate=..[state, Acc, New_Pc, Mem, In, Out, Flag].
                                   
%%input
one_instruction(State, Newstate):-State=..L,
                                  nth0(0,L,state),
                                  nth0(3, L, Mem),
                                  nth0(2, L, Pc),
                                  nth0(Pc, Mem, Istr),
                                  Istr == 901,
                                  nth0(4,L,In),
                                  testa_coda(In, Primo_el, Resto),
                                  nth0(5,L,Out),
                                  nth0(6,L,Flag),
                                  pc_agg(Pc, New_Pc),
                                  Newstate=..[state, Primo_el, New_Pc, Mem, Resto, Out, Flag].
                               
        
testa_coda([H|T],H,T).

%%halt
one_instruction(State, Newstate):-State=..L,
                                  nth0(0,L,state),
                                  nth0(3, L, Mem),
                                  nth0(2, L, Pc),
                                  nth0(Pc, Mem, Istr),
                                  Istr<100,
                                  nth0(1, L, Acc),
                                  nth0(4, L, In),
                                  nth0(5, L, Out),
                                  nth0(6, L, Flag),
                                  pc_agg(Pc, New_Pc),
                                  Newstate=..[halted_state, Acc, New_Pc, Mem, In, Out, Flag].
                                  
 %%Output
 
 one_instruction(State, X):- State=..L,
                            nth0(0, L, state),
                            nth0(2, L, Pc),
                            nth0(3, L, Mem),
                            nth0(Pc, Mem, Ind),
                            Ind == 902,
                            nth0(1, L, Acc),
                            pc_agg(Pc,New_pc),
                            nth0(4, L, Inp),
                            nth0(5, L, Out),
                            nth0(6, L, F),
                            agg_out(Out, Acc, Z),
                            X=..[state, Acc, New_pc, Mem, Inp, Z, F].


agg_out([], X, [X]).
agg_out([H|T], Y, [H|X]):-agg_out(T, Y, X).

                                 
                                 
 execution_loop(State, Out):- one_instruction(State, NewState),
                             NewState=..L,
                             nth0(0, L, halted_state),!,
                             nth0(5, L, Out).
execution_loop(State,Out):-one_instruction(State, NewState),
                          NewState=..L,
                          nth0(0, L, state),
                          execution_loop(NewState,Out).

lmc_load(Filename,Mem).
lmc_run(Input, Output):- randseq(99, 99, Mem), 
                         execution_loop(state(0, 0, Mem, Input, [], noflag),Output).



pc_agg(99,0).
pc_agg(Pc, New_Pc):- between(0, 100, Pc), New_Pc is Pc+1.
