%% ------------------ Representacion del estado actual --------------------- %%
%%         state(CasillaAndroide, CasillaCaja1, CasillaCaja2)                %%

%% ------------------ Representacion de los movimientos -------------------- %%
%% Se ha decidido crear dos estructuras que representen movimiento con el    %%
%% fin de ganar en expresividad y que conceptualmente quede mas clara la     %%
%% separación de las dos posibles funcionalidades del androide: moverse      %%
%% y empujar. Los dos constructures son usados son:                          %%
%%     - m(CasillaOrigenAndroide, CasillaDestinoAndroide)                    %%
%%     - p(CasillaAndroide, CasillaCaja, CasillaDestino)                     %%

%% Representacion del tablero usado en el problema.
%% Se representan las vecindades en horizontal: hor(casilla1, casilla2)
%% y las vecindades en vertical: ver(casilla1, casilla2).

%% ----------- Representacion de la configuracion del problema ------------- %%
%% hor(casilla1, casilla2): representa que las dos casillas son adyacentes   %%
%% horizontalmente.                                                          %%
%%                                                                           %%
%% ver(casilla1, casilla2): representa que las dos casillas son adyacentes   %%
%% verticalmente.                                                            %%

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

%% Predicado pos(casilla1, casilla2, direccion): permite comprobar si  dos  %%
%% casillas son adyacentes en cuatro posibles direcciones (arriba, abajo,   %%
%% izquierda o derecha).                                                    %%

pos(X, Y, left) :-
    hor(X, Y).
pos(X, Y, right) :-
    hor(Y, X).
pos(X, Y, top) :-
    ver(X, Y).
pos(X, Y, bottom) :-
    ver(Y, X).

%% Predicado ocupada(state(casillaAndroide, casillaCaja1, casillaCaja2)):   %%
%% permite coprobar si una celda esta ocupada por el androide o por una     %%
%% de las dos cajas del problema.                                           %%

ocupada(state(D, _, _), D).
ocupada(state(_, D, _), D).
ocupada(state(_, _, D), D).


%% ----------------- Representacion del estado inicial ----------------------- %%
%% initial_state(problema, state(casillaAndroide, casillaCaja1, casillaCaja2)) %%
%% Segun el problema enunciado:                                                %%
%%  - El androide se encuentra en la casiila l7                                %% 
%%  - Una caja (caja1) se encuentra en la casilla l5                           %%
%%  - Una caja (caja2) se encuentra en la casilla l6                           %%

initial_state(sokoban, state(l7, l5, l6)).

%% ----------------- Representacion del estado final -------------------------  %%
%% final_state(problema, state(casillaAndroide, casillaCaja1, casillaCaja2))    %%
%% El problema terminara cuando (sin importar la casilla del androide):         %%
%%  - Una caja se encuentre en una de las casillas destino (l8 o l9)            %%
%%  - La otra caja se encuentre en la casilla destino que quede libre           %%
%%                                                                              %%
%% Por tanto, hay dos posibles estado finales. En una de ellos una caja termina %%
%% en la casilla l8 y la otra en l9. El otro final posible ocure de forma       %%
%% contraria.                                                                   %%

final_state(sokoban, state(_, l8, l9)).
final_state(sokoban, state(_, l9, l8)).

%% Predicado move(state(casillaAndroide, casillaCaja1, casillaCaja2), m(casillaAndroide, casillaDestino))     %%
%% y move(state(casillaAndroide, casillaCaja1, casillaCaja2), p(casillaAndroide, casillaDestino, direccion))  %%
%%                                                                                                            %%
%% El objetivo de estos predicados es el de representar las acciones del androide: moverse y                  %%
%% empujar una caja. En el primer caso, unicamente es necesario comprobar que la casilla donde esta el        %%
%% androide y la casilla destino a la que quiere moverse son adyacentes y que esta ultima esta vacia.         %%
%% Por otro lado, en el caso de la accion empujar, hay que hacer dos comprobaciones de adyacencia. Se         %%
%% comprueba primero que la casilla donde esta el androide y donde esta la caja sean adyacentes.              %%
%% Posteriormente hay que comprobar que la casilla de la caja y la casilla destino a la que se quiere empujar %%
%% la caja son adyacentes. Finalmente, una vez comprobada la adyacencia se temina comprobando que la  casilla %%
%% destino esta vacia.                                                                                        %%

move(state(A, C1, C2), m(A, D)) :-
    pos(A, D, _),
    not(ocupada(state(A, C1, C2), D)).
move(state(A, C1, C2), p(A, C1, D)) :-
    pos(A, C1, Pos),
    pos(C1, D, Pos),
    not(ocupada(state(A, C1, C2), D)).
move(state(A, C1, C2), p(A, C2, D)) :-
    pos(A, C2, Pos),
    pos(C2, D, Pos),
    not(ocupada(state(A, C1, C2), D)).

%% Predicado update(state(casillaAndroide, casillaCaja1, casillaCaja2), m(casillaAndroide, casillaDestino),      %%
%%                  state(nuevaCasillaAndroide, nuevaCasillaCaja1, nuevCasillaCaja2).                            %%
%% y update(state(casillaAndroide, casillaCaja1, casillaCaja2), p(casillaAndroide, casillaCaja, casillaDestino), %%
%%                  state(nuevaCasillaAndroide, nuevaCasillaCaja1, nuevCasillaCaja2).                            %%
%%                                                                                                               %%
%% El objetivo de este predicado es el de efectuar un cambio en el estado actual mediante la aplicacion          %%
%% de uno de los movimientos especificados en el predicado move.                                                 %%

update(state(A, C1, C2), m(A, D), state(D, C1, C2)).
update(state(A, C1, C2), p(A, C1, D), state(C1, D, C2)).
update(state(A, C1, C2), p(A, C2, D), state(C2, C1, D)).

%% ------------------------- Framework depth-first ------------------------- %%

%% El problema acaba cuando el estado incial es el mismo que el estado final %%

solve_dfs(Problem, State, History, []) :-
	final_state(Problem, State).


solve_dfs(Problem, State, History, [Move|Moves]) :-
	move(State, Move),
	update(State, Move, NewState),
	\+ member(NewState, History),
	solve_dfs(Problem, NewState, [NewState|History], Moves).

%% Preodicado que utiliza el framework indicado anteriormente para solucionar %%
%% el problema.                                                               %%

solve_problem(Problem, Solution) :-
	initial_state(Problem, Initial),
	solve_dfs(Problem, Initial, [Initial], Solution).
