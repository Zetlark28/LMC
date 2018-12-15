%%nome e matricola di ogni membro

state(Acc, Pc, Mem, In, Out, Flag):-between(0,999, Acc),
                                    between(0,99,Pc),
                                    controllo_el(Mem),
                                    controllo_el(In),
                                    controllo_el(Out),
                                    controllo_flag(Flag).

controllo_el([]).
controllo_el([H|T]):-between(0, 999, H), controllo_el(T).

controllo_flag("flag").
controllo_flag("noflag").

halted_state(Acc, Pc, Mem, In, Out, Flag):-between(0,999, Acc),
                                           between(0,99,Pc),
                                           controllo_el(Mem),
                                           controllo_el(In),
                                           controllo_el(Out),
                                           controllo_flag(Flag).

%%input
one_instruction(State, Newstate):-State=..L,
                                  nth0(0,L,state),
                                  nth0(3, L, Mem),
                                  nth0(2, L, Pc),
                                  nth0(Pc, Mem, 901),
                                  nth0(4,L,In),
                                  testa_coda(In, Primo_el, Resto),
                                  nth0(5,L,Out),
                                  nth0(6,L,Flag),
                                  pc_agg(Pc, New_Pc),
                                  Newstate=..[state, Primo_el, New_Pc, Mem, Resto, Out, Flag].



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


%%sub no flag
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
                                    Cell is Istr-300,
                                    nth0(Cell, Mem, Val),
                                    nth0(1, L, Acc),
                                    Diff is Acc-Val,
                                    Diff < 0,
                                    Ris is Diff+1000,
                                    pc_agg(Pc, New_Pc),
                                    nth0(4, L, In),
                                    nth0(5, L, Out),
                                    NewState=.. [state, Ris, New_Pc, Mem, In, Out, flag].



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
one_instruction(State, X):- State=..L,
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
                            X=..[state, Res, New_pc, Mem, Inp, Out, F].

%%branch if zero
one_instruction(State, X):- State=..L,
                            nth0(0, L, state),
                            nth0(1,L,0),
                            nth0(2, L, Pc),
                            nth0(3, L, Mem),
                            nth0(Pc, Mem, Ind),
                            between(700,799,Ind),!,
                            nth0(6, L, noflag),
                            Val is Ind-700,
                            nth0(4, L, Inp),
                            nth0(5, L, Out),
                            X=..[state, 0, Val, Mem, Inp, Out, noflag].

one_instruction(State,X):-State=..L,
                          nth0(0,L,state),
                          nth0(1,L,Acc),
                          nth0(2,L,Pc),
                          nth0(3,L,Mem),
                          nth0(Pc, Mem, Ind),
                          between(700,799,Ind),!,
                          pc_agg(Pc,New_Pc),
                          nth0(4,L,Inp),
                          nth0(5,L,Out),
                          nth0(6,L,F),
                          X=..[state,Acc,New_Pc, Mem, Inp, Out, F].



 %%branch if positive
 one_instruction(State, X):- State=..L,
                            nth0(0, L, state),
                            nth0(6,L,noflag),
                            nth0(2, L, Pc),
                            nth0(3, L, Mem),
                            nth0(Pc, Mem, Ind),
                            between(800,899,Ind),!,
                            Val is Ind-800,
                            nth0(1, L, Acc),
                            nth0(4, L, Inp),
                            nth0(5, L, Out),
                            X=..[state, Acc, Val, Mem, Inp, Out, noflag].

one_instruction(State,X):- State=..L,
                           nth0(0,L,state),
                           nth0(6,L,flag),
                           nth0(1,L,Acc),
                           nth0(2,L,Pc),
                           nth0(3,L,Mem),
                           nth0(Pc,Mem,Ind),
                           between(800,899,Ind),!,
                           nth0(4,L,Inp),
                           nth0(5,L,Out),
                           pc_agg(Pc,New_Pc),
                           X=..[state,Acc,New_Pc,Mem,Inp,Out,flag].




%%branch
one_instruction(State, Newstate):- State=..L,
                                   nth0(0,L,state),
                                   nth0(3, L, Mem),
                                   nth0(2, L, Pc),
                                   nth0(Pc, Mem, Istr),
                                   between(600, 699, Istr),!,
                                   nth0(4,L,In),
                                   nth0(5,L,Out),
                                   nth0(6,L,Flag),
                                   nth0(1,L,Acc),
                                   New_Pc is Istr-600,
                                   Newstate=..[state, Acc, New_Pc, Mem, In, Out, Flag].




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
                             nth0(Pc, Mem, 902),
                             nth0(1, L, Acc),
                             pc_agg(Pc,New_pc),
                             nth0(4, L, Inp),
                             nth0(5, L, Out),
                             nth0(6, L, F),
                             append(Out, [Acc], Z),
                             X=..[state, Acc, New_pc, Mem, Inp, Z, F].

execution_loop(State, Out):- State=..L,
                             nth0(0, L, halted_state),!,
                             nth0(5, L, Out).

execution_loop(State,Out):-State=..L,
                           nth0(0,L,state),!,
                           one_instruction(State, NewState),
                           execution_loop(NewState,Out).

lmc_load(Filename,Mem):- open(Filename, read, Stream),
                         parser(Stream, Ris),
                         controllo_mem(Ris,Mem),
                         close(Stream),!.


controllo_mem(Ris, Mem):- length(Ris, 100),
                          Mem is Ris .
controllo_mem(Ris, Y):- append(Ris,[0],T),
                        controllo_mem(T, Y).

parser(Stream,Mem):-read_string(Stream,_, Stringa),
                    split_string(Stringa,"\r\n" ,"\s\r\n", Stringhe),
                    togli_righe_commenti(Stringhe, Senza_linea_commenti),
                    elimina_commenti(Senza_linea_commenti, Stringhe_da_analizzare),
                    analizza_stringa(Stringhe_da_analizzare,Stringhe_da_analizzare, Mem).

togli_righe_commenti([],[]).

togli_righe_commenti([H|T],Z):- split_string(H,"\s","\s", Stringa),
                                nth0(0,Stringa,"//"),
                                togli_righe_commenti(T,Z).

togli_righe_commenti([H|T],[H|Z]):-togli_righe_commenti(T,Z).

elimina_commenti([],[]).

elimina_commenti([H|T],[Z|Y]):-split_string(H, "\s", "\s", Stringa),
                               no_commenti(Stringa,Z),
                               elimina_commenti(T,Y).

no_commenti([],[]).
no_commenti([H|_],Y):-H == "//",
                    no_commenti([],Y).
no_commenti([H|T], [H|Y]):- no_commenti(T,Y).

analizza_stringa(_,[],_).

%%una solo istruzione senza etichette o valori
analizza_stringa(Stringhe,[H|T],[Z|Y]):- length(H,1),!,
                                         nth0(0,H,H1),
                                         nth0(Pos,Stringhe,H),
                                         istr_one(Pos,H1,Z),
                                         analizza_stringa(Stringhe,T,Y).

%%istruzione + valore
analizza_stringa(Stringhe,[H|T],[Z|Y]):- length(H,2),
                                         nth0(1, H, X),
                                         nth0(0, H, Istr),
                                         atomic_list_concat([X],'',Num),
                                         atom_number(Num, N),!,
                                         operazione(Istr,N, Z),
                                         analizza_stringa(Stringhe,T,Y).

%%istruzione+ etichetta
analizza_stringa(Stringhe, [H|T],[Z|Y]):- length(H,2),
                                          nth0(0, H, Istr),
                                          nth0(1, H, X),
                                          string_chars(Istr,Lung),
                                          length(Lung,3),
                                          string(X),
                                          trova_valore_et(Stringhe,Stringhe,X, Val),!,
                                          operazione(Istr,Val,Z),
                                          analizza_stringa(Stringhe, T, Y).


%%etichetta+istruzione
analizza_stringa(Stringhe, [H|T], [Z|Y]):- length(H,2),
                                           nth0(0,H,X),
                                           nth0(1,H, Istr),
                                           string(X),
                                           string_chars(Istr,Lung),
                                           length(Lung,3),!,
                                           nth0(W,Stringhe, H),
                                           istr_one(W, Istr, Z),
                                           analizza_stringa(Stringhe, T, Y).
%%etichetta+istruzione+numero
analizza_stringa(Stringhe, [H|T],[Z|Y]):- length(H, 3),
                                          nth0(2, H, X),
                                          nth0(1, H, Istr),
                                          atomic_list_concat([X],'',Num),
                                          atom_number(Num,N),
                                          operazione(Istr, N, Z),
                                          analizza_stringa(Stringhe, T, Y).



%%etichetta+istruzione+ etichetta
analizza_stringa(Stringhe,[H|T],[Z|Y]):- length(H,3),
                                         nth0(2, H, Et),
                                         nth0(1,H, Istr),
                                         string_chars(Istr,Lung),
                                         length(Lung, 3),
                                         string(Et),!,
                                         trova_valore_et(Stringhe,Stringhe,Et,Val),
                                         operazione(Istr, Val, Z),
                                         analizza_stringa(Stringhe, T, Y).

trova_valore_et(Stringhe,[H|_], X, Val):- nth0(0,H,X),
                                          nth0(Val,Stringhe,H).

trova_valore_et(Stringhe,[_|T], X, Val):- trova_valore_et(Stringhe, T, X, Val).

%%Load
operazione(Istr, Num, Val):- string_chars(Istr,Car),
                             nth0(0, Car,'L'),
                             Val is 500+ Num.

operazione(Istr, Num, Val):- string_chars(Istr, Car),
                             nth0(0, Car, 'l'),
                             Val is 500+Num.

%%Dat
operazione(Istr,Num, Num):- string_chars(Istr,Car),
                            nth0(0, Car,'D'),!.
operazione(Istr,Num,Num):- string_chars(Istr, Car),
                           nth0(0,Car, 'd'),!.

%%Add
operazione(Istr,Num,Val):- string_chars(Istr,Car),
                           nth0(0, Car, 'A'),!,
                           Val is 100+Num.

operazione(Istr,Num,Val):- string_chars(Istr, Car),
                           nth0(0, Car, 'a'),!,
                           Val is 100+Num.
%%sta
operazione(Istr,Num,Val):- string_chars(Istr,Car),
                           nth0(1, Car, 'T'),!,
                           Val is 300+Num.

operazione(Istr,Num,Val):- string_chars(Istr,Car),
                           nth0(1, Car, 't'),!,
                           Val is 300+ Num.
%%Sub
operazione(Istr, Num, Val):- string_chars(Istr, Car),
                             nth0(2, Car, 'B'),!,
                             Val is 200+Num.

operazione(Istr, Num, Val):- string_chars(Istr, Car),
                             nth0(2, Car, 'b'),!,
                             Val is 200+Num.


%%bra
operazione(Istr, Num, Val):- string_chars(Istr, Car),
                             nth0(2, Car, 'A'),!,
                             Val is 600+Num.

operazione(Istr, Num, Val):- string_chars(Istr, Car),
                             nth0(2, Car, 'a'),!,
                             Val is 600+Num.

%%brz
operazione(Istr, Num, Val):- string_chars(Istr, Car),
                             nth0(2, Car, 'z'),!,
                             Val is 700+Num.

operazione(Istr,Num, Val):- string_chars(Istr, Car),
                           nth0(2, Car, 'Z'), !,
                           Val is 700+Num.
%%brp
operazione(Istr, Num, Val):- string_chars(Istr, Car),
                             nth0(2, Car, 'P'),!,
                             Val is 800+Num.

operazione(Istr, Num, Val):- string_chars(Istr, Car),
                             nth0(2, Car, 'p'),!,
                             Val is 800+Num.


%%input

istr_one(_,Istr, Val):- string_chars(Istr, Car),
                       nth0(0,Car, 'I'),!,
                      Val is 901.

istr_one(_,Istr,Val):- string_chars(Istr, Car),
                     nth0(0, Car, 'i'),!,
                     Val is 901.
%%Out
istr_one(_,Istr, Val):- string_chars(Istr, Car),
                      nth0(0,Car, 'O'),!,
                      Val is 902.
istr_one(_,Istr,Val):- string_chars(Istr, Car),
                     nth0(0, Car, 'o'),!,
                     Val is 902.
%%Halt
istr_one(Pos,Istr,Val):- string_chars(Istr, Car),
                         nth0(0, Car,'H'),!,
                         Val is Pos.

istr_one(Pos,Istr,Val):- string_chars(Istr,Car),
                         nth0(0, Car, 'h'),!,
                         Val is Pos.
%%Dat
istr_one(_,Istr,Val):-string_chars(Istr, Car),
                      nth0(0, Car, 'D'),!,
                      Val is 0.
istr_one(_, Istr, Val):- string_chars(Istr, Car),
                         nth0(0, Car, 'd'),!,
                         Val is 0.



lmc_run(Filename,Input, Output):-lmc_load(Filename, Mem),
                                 execution_loop(state(0, 0, Mem, Input, [], noflag),Output),!.



pc_agg(99,0).
pc_agg(Pc, New_Pc):- between(0, 100, Pc), New_Pc is Pc+1.


%%Sostituisce un elemento dato l'indice
replace_el([_|T], P, El, [El|T]):- P=0.
replace_el([H|T], P, El, [H|Z]):-  Pos is P-1, replace_el(T, Pos, El, Z).

%%codice gestione lista di Output
testa_coda([H|T],H,T).


