%% Representacion del estado actual                 %%
%% cs(CasillaAndroide, CasillaCaja1, CasillaCaja2)  %%

%% Representacion de los movimientos %%
%% m(CasillaOrigen, CasillaDestino)  %%
%% p(CasillaOrigen, CasillaDestino)  %%

%% Representacion del tablero usado en el problema.
%% Se representan las vecindades en horizontal: hor(casilla1, casilla2)
%% y las vecindades en vertical: ver(casilla1, casilla2). 

hor(l1, l2).
hor(l2, l3).
hor(l4, l5).
hor(l5, l6).
hor(l7, l8).
hor(l8, l9).
ver(l1, l4).
ver(l2, l5).
ver(l3, l6).
ver(l4, l7).
ver(l5, l8).
ver(l6, l9).

%% %% %% %% TODO actualizar
%% Predicado que permite comprobar si dos casillas con adyacentes
%% segun su posicion en el tablero.

pos(X, Y, left) :-
    hor(X, Y).
pos(X, Y, right) :-
    hor(Y, X).
pos(X, Y, top) :-
    ver(X, Y).
pos(X, Y, bottom) :-
    ver(Y, X).
%% adyacente(X, Y) :-
%%     hor(X, Y).
%% adyacente(X, Y) :-
%%     hor(Y, X).
%% adyacente(X, Y) :-
%%     ver(X, Y).
%% adyacente(X, Y) :-
%%     ver(Y, X).

%% Predicado que representa si una casilla esta ocupada: ocupada(Casilla) %%

ocupada(cs(D, _, _), D).
ocupada(cs(_, D, _), D).
ocupada(cs(_, _, D), D).


%% Representacion del estado inicial
%% initial_state(problema, cs(CasillaAndroide, CasillaCaja1, CasillaCaja2))
%% Segun el problema enunciado:
%%  - El androide se encuentra en la casiila l7
%%  - Una caja (caja1) se encuentra en la casilla l5
%%  - Una caja (caja2) se encuentra en la casilla l6

initial_state(sokoban, cs(l7, l5, l6)).

%% Representacion del estado final
%% final_state(problema, cs(CasillaAndroide, CasillaCaja1, CasillaCaja2))
%% El problema terminara cuando (sin importar la casilla del androide):
%%  - Una caja se encuentre en una de las casillas destino (l8 o l9)
%%  - La otra caja se encuentre en la casilla destino que quede libre

final_state(sokoban, cs(_, l8, l9)).
final_state(sokoban, cs(_, l9, l8)).

%% Predicado de movimiento del androide                 %%
%% El androide se puede mover si la casilla de destino  %%
%% esta vacia y ademas es adyacente                     %%
%% move(EstadoActual, MovimientoDeseado)                %%

move(cs(A, C1, C2), m(A, D)) :-
    pos(A, D, _),
    not(ocupada(cs(A, C1, C2), D)).
move(cs(A, C1, C2), p(A, C1, D)) :-
    pos(A, C1, Pos),
    pos(C1, D, Pos),
    not(ocupada(cs(A, C1, C2), D)).
move(cs(A, C1, C2), p(A, C2, D)) :-
    pos(A, C2, Pos),
    pos(C2, D, Pos),
    not(ocupada(cs(A, C1, C2), D)).


/******************************************************************/
/* TODO   */
/******************************************************************/
update(cs(A, C1, C2), m(A, D), cs(D, C1, C2)).
update(cs(A, C1, C2), p(A, C1, D), cs(C1, D, C2)).
update(cs(A, C1, C2), p(A, C2, D), cs(C2, C1, D)).


/******************************************************************/
/* Checks whether a state is legal according to the constraints   */
/* imposed by the problem\'s statement.                            */
/******************************************************************/
legal(cs(_, _, _)) :- 
	!.

/******************************************************/
/* A reusable depth-first problem solving framework.  */
/******************************************************/

/* The problem is solved is the current state is the final state. */
solve_dfs(Problem, State, History, []) :-
	final_state(Problem, State).


solve_dfs(Problem, State, History, [Move|Moves]) :-
	move(State, Move),
	update(State, Move, NewState),
	legal(NewState),
	\+ member(NewState, History),
	solve_dfs(Problem, NewState, [NewState|History], Moves).

/*************************/
/* Solving the problem.  */
/*************************/

solve_problem(Problem, Solution) :-
	initial_state(Problem, Initial),
	solve_dfs(Problem, Initial, [Initial], Solution).
