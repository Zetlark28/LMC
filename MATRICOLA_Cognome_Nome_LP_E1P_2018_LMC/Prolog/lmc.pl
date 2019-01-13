%%Ezpeleta Clark 837002, Sad Rafik 816920, nome e matricola di ogni membro
%%Per funzione dei metodi guardare il file readme

state(Acc, Pc, Mem, In, Out, Flag):-between(0, 999, Acc),
                                    between(0, 99, Pc),
                                    control_el(Mem),
                                    control_el(In),
                                    control_el(Out),
                                    control_flag(Flag).

control_el([]).
control_el([H|T]):-between(0, 999, H),
                   control_el(T).

control_flag("flag").
control_flag("noflag").

halted_state(Acc, Pc, Mem, In, Out, Flag):-between(0, 999, Acc),
                                           between(0, 99, Pc),
                                           control_el(Mem),
                                           control_el(In),
                                           control_el(Out),
                                           control_flag(Flag).

%%input
one_instruction(State, Newstate):-State=..L,
                                  nth0(0, L, state),
                                  nth0(3, L, Mem),
                                  nth0(2, L, Pc),
                                  nth0(Pc, Mem, 901),
                                  nth0(4, L, In),
                                  head_tail(In, Primo_el, Resto),
                                  nth0(5, L, Out),
                                  nth0(6, L, Flag),
                                  update_pc(Pc, New_Pc),
                                  Newstate=..[state, Primo_el, New_Pc, Mem, Resto, Out, Flag].
%%output
one_instruction(State, X):- State=..L,
                             nth0(0, L, state),
                             nth0(2, L, Pc),
                             nth0(3, L, Mem),
                             nth0(Pc, Mem, 902),
                             nth0(1, L, Acc),
                             update_pc(Pc, New_pc),
                             nth0(4, L, Inp),
                             nth0(5, L, Out),
                             nth0(6, L, F),
                             append(Out, [Acc], Z),
                             X=..[state, Acc, New_pc, Mem, Inp, Z, F].


%%store
one_instruction(State, Newstate):- State=..L,
                                   nth0(0, L, state),
                                   nth0(3, L, Mem),
                                   nth0(2, L, Pc),
                                   nth0(Pc, Mem, Istr),
                                   between(300, 399, Istr),
                                   Cell is Istr-300,
                                   nth0(1, L, Acc),
                                   replace_el(Mem, Cell, Acc, MemAcc),
                                   update_pc(Pc, New_Pc),
                                   nth0(4, L, In),
                                   nth0(5, L, Out),
                                   nth0(6, L, Flag),
                                   Newstate=..[state, Acc, New_Pc, MemAcc, In, Out, Flag].
%%load
one_instruction(State, X):- State=..L,
                            nth0(0, L, state),
                            nth0(2, L, Pc),
                            nth0(3, L, Mem),
                            nth0(Pc, Mem, Ind),
                            between(500, 599, Ind),
                            Val is Ind-500,
                            nth0(Val, Mem, Res),
                            update_pc(Pc, New_pc),
                            nth0(4, L, Inp),
                            nth0(5, L, Out),
                            nth0(6, L, F),
                            X=..[state, Res, New_pc, Mem, Inp, Out, F].




%%add no flag

one_instruction(State, X):- State=..L,
                            nth0(0, L, state),
                            nth0(2, L, Pc),
                            nth0(3, L, Mem),
                            nth0(Pc, Mem, Ind),
                            between(100, 199, Ind),
                            Val is Ind-100,
                            nth0(Val, Mem, Res),
                            nth0(1, L, Acc),
                            Fin is Res + Acc,
                            Fin < 1000,!,
                            update_pc(Pc, New_Pc),
                            nth0(4, L, Inp),
                            nth0(5, L, Out),
                            X=..[state, Fin, New_Pc, Mem, Inp, Out, noflag].

%%add flag

one_instruction(State, X):- State=..L,
                            nth0(0, L, state),
                            nth0(2, L, Pc),
                            nth0(3, L, Mem),
                            nth0(Pc, Mem, Ind),
                            between(100, 199, Ind),
                            Val is Ind-100,
                            nth0(Val, Mem, Res),
                            nth0(1, L, Acc),
                            Fin is Res + Acc,
                            Fin >=1000,!,
                            Fin1 is Fin-1000,
                            update_pc(Pc, New_Pc),
                            nth0(4, L, Inp),
                            nth0(5, L, Out),
                            X=..[state, Fin1, New_Pc, Mem, Inp, Out, flag].


%%sub no flag
one_instruction(State, NewState):-  State=..L,
                                    nth0(0, L, state),
                                    nth0(3, L, Mem),
                                    nth0(2, L, Pc),
                                    nth0(Pc, Mem, Istr),
                                    between(200, 299, Istr),
                                    Cell is Istr-200,
                                    nth0(Cell, Mem, Val),
                                    nth0(1, L, Acc),
                                    Ris is Acc-Val,
                                    Ris>=0,
                                    update_pc(Pc, New_Pc),
                                    nth0(4, L, In),
                                    nth0(5, L, Out),
                                    NewState=.. [state, Ris, New_Pc, Mem, In, Out, noflag].

%%sub con flag
one_instruction(State, NewState):-  State=..L,
                                    nth0(0, L, state),
                                    nth0(3, L, Mem),
                                    nth0(2, L, Pc),
                                    nth0(Pc, Mem, Istr),
                                    between(200, 299, Istr),
                                    Cell is Istr-200,
                                    nth0(Cell, Mem, Val),
                                    nth0(1, L, Acc),
                                    Diff is Acc-Val,
                                    Diff < 0,
                                    Ris is Diff+1000,
                                    update_pc(Pc, New_Pc),
                                    nth0(4, L, In),
                                    nth0(5, L, Out),
                                    NewState=.. [state, Ris, New_Pc, Mem, In, Out, flag].




%%branch if zero
one_instruction(State, X):- State=..L,
                            nth0(0, L, state),
                            nth0(1, L, 0),
                            nth0(2, L, Pc),
                            nth0(3, L, Mem),
                            nth0(Pc, Mem, Ind),
                            between(700, 799, Ind),
                            nth0(6, L, noflag),!,
                            Val is Ind-700,
                            nth0(4, L, Inp),
                            nth0(5, L, Out),
                            X=..[state, 0, Val, Mem, Inp, Out, noflag].

%%branch if zero quando non rispetta i requisiti
one_instruction(State, X):-State=..L,
                           nth0(0, L, state),
                           nth0(1, L, Acc),
                           nth0(2, L, Pc),
                           nth0(3, L, Mem),
                           nth0(Pc, Mem, Ind),
                           between(700, 799, Ind),!,
                           update_pc(Pc, New_Pc),
                           nth0(4, L, Inp),
                           nth0(5, L, Out),
                           nth0(6, L, F),
                           X=..[state, Acc, New_Pc, Mem, Inp, Out, F].


%%branch if positive
one_instruction(State, X):- State=..L,
                            nth0(0, L, state),
                            nth0(6, L, noflag),
                            nth0(2, L, Pc),
                            nth0(3, L, Mem),
                            nth0(Pc, Mem, Ind),
                            between(800, 899, Ind),!,
                            Val is Ind-800,
                            nth0(1, L, Acc),
                            nth0(4, L, Inp),
                            nth0(5, L, Out),
                            X=..[state, Acc, Val, Mem, Inp, Out, noflag].

%%branch if positive quando non rispetta i requisiti
one_instruction(State, X):- State=..L,
                            nth0(0, L, state),
                            nth0(6, L, flag),
                            nth0(1, L, Acc),
                            nth0(2, L, Pc),
                            nth0(3, L, Mem),
                            nth0(Pc, Mem, Ind),
                            between(800, 899, Ind),!,
                            nth0(4, L, Inp),
                            nth0(5, L, Out),
                            update_pc(Pc, New_Pc),
                            X=..[state, Acc, New_Pc, Mem, Inp, Out, flag].




%%branch
one_instruction(State, Newstate):- State=..L,
                                   nth0(0, L, state),
                                   nth0(3, L, Mem),
                                   nth0(2, L, Pc),
                                   nth0(Pc, Mem, Istr),
                                   between(600, 699, Istr),!,
                                   nth0(4, L, In),
                                   nth0(5, L, Out),
                                   nth0(6, L, Flag),
                                   nth0(1, L, Acc),
                                   New_Pc is Istr-600,
                                   Newstate=..[state, Acc, New_Pc, Mem, In, Out, Flag].




%%halt
one_instruction(State, Newstate):-State=..L,
                                  nth0(0, L, state),
                                  nth0(3, L, Mem),
                                  nth0(2, L, Pc),
                                  nth0(Pc, Mem, Istr),
                                  Istr<100,
                                  nth0(1, L, Acc),
                                  nth0(4, L, In),
                                  nth0(5, L, Out),
                                  nth0(6, L, Flag),
                                  update_pc(Pc, New_Pc),
                                  Newstate=..[halted_state, Acc, New_Pc, Mem, In, Out, Flag].

%%aggiornamento del PC
update_pc(99, 0).
update_pc(Pc, New_Pc):- between(0, 100, Pc),
                        New_Pc is Pc+1.


%%Sostituisce un elemento dato l'indice
replace_el([_|T], P, El, [El|T]):- P=0.
replace_el([H|T], P, El, [H|Z]):-  Pos is P-1, replace_el(T, Pos, El, Z).

%codice gestione lista di Output
head_tail([H|T], H, T).


execution_loop(State, Out):- State=..L,
                             nth0(0, L, halted_state),!,
                             nth0(5, L, Out).

execution_loop(State, Out):-State=..L,
                           nth0(0, L, state),!,
                           one_instruction(State, NewState),
                           execution_loop(NewState, Out).

lmc_run(Filename, Input, Output):-lmc_load(Filename, Mem),
                                  execution_loop(state(0, 0, Mem, Input, [], noflag), Output),!.



lmc_load(Filename, Mem):- open(Filename, read, Stream),
                          read_string(Stream, _, Stringa),
                          split_string(Stringa, "\r\n", "\s\t\r\n", Stringhe),
                          length(Stringhe, Lung),
                          parser(Lung, Stringhe, Ris),
                          append(Ris, [], Ris2),
                          length(Ris2, Lung1),
                          memory_control(Lung1, Ris, Mem),
                          close(Stream),!.


memory_control(100, Ris, Ris):-!.


memory_control(X, Ris, Mem):- append(Ris, [0], Y),
                             Z is X+1,
                             memory_control(Z, Y, Mem).

parser(1, [""], [0]):-!.

parser(_, Stringhe, Mem):-delete_comment_line(Stringhe, Senza_linea_commenti),
                         delete_comment(Senza_linea_commenti, Stringhe_da_analizzare),
                         analize_string(Stringhe_da_analizzare, Stringhe_da_analizzare, Mem).

%%per eliminare le righe di solo commento
delete_comment_line([], []).

delete_comment_line([H|T], Z):- split_string(H, "\s\t", "\s\t", Stringa),
                                nth0(0, Stringa, El),
                                string_chars(El, Car),
                                nth0(0, Car, '/'),
                                nth0(1, Car, '/'),
                                delete_comment_line(T, Z).

delete_comment_line([H|T], [H|Z]):-delete_comment_line(T, Z).

%%per eliminare i commenti tra le istruzioni
delete_comment([], []).

delete_comment([H|T], [Z|Y]):- split_string(H, "\s", "\s", Stringa),
                               delete(Stringa, Z),
                               delete_comment(T, Y).

delete([], []).
delete([H|_], Y):- string_chars(H, Car),
                   nth0(0, Car, '/'),
                   nth0(1, Car, '/'),
                   delete([], Y).

delete([H|T], [H|Y]):- delete(T, Y).

analize_string(_, [], []).

%%una solo istruzione senza etichette o valori
analize_string(Stringhe, [H|T], [Z|Y]):- length(H, 1),!,
                                         nth0(0, H, H1),
                                         nth0(Pos, Stringhe, H),
                                         type_instr_one(Pos, H1, Z),
                                         analize_string(Stringhe, T, Y).

%%istruzione + valore
analize_string(Stringhe, [H|T], [Z|Y]):- length(H, 2),
                                         nth0(1, H, X),
                                         nth0(0, H, Istr),
                                         atomic_list_concat([X], '', Num),
                                         atom_number(Num, N),!,
                                         type_instruction(Istr, N, Z),
                                         analize_string(Stringhe, T, Y).

%%istruzione+ etichetta
analize_string(Stringhe, [H|T], [Z|Y]):- length(H, 2),
                                         nth0(0, H, Istr),
                                         nth0(1, H, X),
                                         string_chars(Istr, Lung),
                                         length(Lung, 3),
                                         string(X),
                                         search_value(Stringhe, Stringhe, X, Val),!,
                                         type_instruction(Istr, Val, Z),
                                         analize_string(Stringhe, T, Y).


%%etichetta+istruzione
analize_string(Stringhe, [H|T], [Z|Y]):- length(H, 2),
                                         nth0(0, H, X),
                                         nth0(1, H, Istr),
                                         string(X),
                                         string_chars(Istr, Lung),
                                         length(Lung, 3),!,
                                         nth0(W, Stringhe, H),
                                         type_instr_one(W, Istr, Z),
                                         analize_string(Stringhe, T, Y).
%%etichetta+istruzione+numero
analize_string(Stringhe, [H|T], [Z|Y]):- length(H, 3),
                                        nth0(2, H, X),
                                        nth0(1, H, Istr),
                                        atomic_list_concat([X], '', Num),
                                        atom_number(Num, N),
                                        type_instruction(Istr, N, Z),
                                        analize_string(Stringhe, T, Y).



%%etichetta+istruzione+ etichetta
analize_string(Stringhe, [H|T], [Z|Y]):- length(H, 3),
                                         nth0(2, H, Et),
                                         nth0(1, H, Istr),
                                         string_chars(Istr, Lung),
                                         length(Lung, 3),
                                         string(Et),!,
                                         search_value(Stringhe, Stringhe, Et, Val),
                                         type_instruction(Istr, Val, Z),
                                         analize_string(Stringhe, T, Y).

search_value(Stringhe, [H|_], X, Val):- nth0(0, H, X),
                                        nth0(Val, Stringhe, H).

search_value(Stringhe, [_|T], X, Val):- search_value(Stringhe, T, X, Val).

%%Load
type_instruction(Istr, Num, Val):- string_chars(Istr, Car),
                                   nth0(0, Car, 'L'),!,
                                   Val is 500+ Num.

type_instruction(Istr, Num, Val):- string_chars(Istr, Car),
                                   nth0(0, Car, 'l'),!,
                                   Val is 500+Num.

%%Dat
type_instruction(Istr, Num, Num):- string_chars(Istr, Car),
                                   nth0(0, Car, 'D'),!.
type_instruction(Istr, Num, Num):- string_chars(Istr, Car),
                                   nth0(0, Car, 'd'),!.

%%Add
type_instruction(Istr, Num, Val):- string_chars(Istr, Car),
                                   nth0(0, Car, 'A'),!,
                                   Val is 100+Num.

type_instruction(Istr, Num, Val):- string_chars(Istr, Car),
                                   nth0(0, Car, 'a'),!,
                                   Val is 100+Num.
%%sta
type_instruction(Istr, Num, Val):- string_chars(Istr, Car),
                                   nth0(1, Car, 'T'),!,
                                   Val is 300+Num.

type_instruction(Istr, Num, Val):- string_chars(Istr, Car),
                                   nth0(1, Car, 't'),!,
                                   Val is 300+ Num.
%%Sub
type_instruction(Istr, Num, Val):- string_chars(Istr, Car),
                                   nth0(2, Car, 'B'),!,
                                   Val is 200+Num.

type_instruction(Istr, Num, Val):- string_chars(Istr, Car),
                                   nth0(2, Car, 'b'),!,
                                   Val is 200+Num.


%%bra
type_instruction(Istr, Num, Val):- string_chars(Istr, Car),
                                   nth0(2, Car, 'A'),!,
                                   Val is 600+Num.

type_instruction(Istr, Num, Val):- string_chars(Istr, Car),
                                   nth0(2, Car, 'a'),!,
                                   Val is 600+Num.

%%brz
type_instruction(Istr, Num, Val):- string_chars(Istr, Car),
                                   nth0(2, Car, 'z'),!,
                                   Val is 700+Num.

type_instruction(Istr, Num, Val):- string_chars(Istr, Car),
                                   nth0(2, Car, 'Z'), !,
                                   Val is 700+Num.
%%brp
type_instruction(Istr, Num, Val):- string_chars(Istr, Car),
                                   nth0(2, Car, 'P'),!,
                                   Val is 800+Num.

type_instruction(Istr, Num, Val):- string_chars(Istr, Car),
                                   nth0(2, Car, 'p'),!,
                                   Val is 800+Num.


%%input

type_instr_one(_, Istr, Val):- string_chars(Istr, Car),
                               nth0(0, Car, 'I'),!,
                               Val is 901.

type_instr_one(_, Istr, Val):- string_chars(Istr, Car),
                               nth0(0, Car, 'i'),!,
                               Val is 901.
%%Out
type_instr_one(_, Istr, Val):- string_chars(Istr, Car),
                               nth0(0, Car, 'O'),!,
                               Val is 902.
type_instr_one(_, Istr, Val):- string_chars(Istr, Car),
                               nth0(0, Car, 'o'),!,
                               Val is 902.
%%Halt
type_instr_one(Pos, Istr, Val):- string_chars(Istr, Car),
                                 nth0(0, Car, 'H'),!,
                                 Val is Pos.

type_instr_one(Pos, Istr, Val):- string_chars(Istr, Car),
                                 nth0(0, Car, 'h'),!,
                                 Val is Pos.
%%Dat
type_instr_one(_, Istr, Val):- string_chars(Istr, Car),
                               nth0(0, Car, 'D'),!,
                               Val is 0.
type_instr_one(_, Istr, Val):- string_chars(Istr, Car),
                               nth0(0, Car, 'd'),!,
                               Val is 0.










