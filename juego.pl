:- ensure_loaded('tablero.pl').
:- ensure_loaded('func_aux.pl').
:- ensure_loaded('jugador.pl').
:- ensure_loaded('jugador_virtual.pl').

% Juego principal
jugar :-
    write('Selecciona el modo de juego:'), nl,
    write('1. Multijugador'), nl,
    write('2. Contra jugador virtual'), nl,
    read(Opcion),
    (   Opcion == 1 -> jugar_multijugador
    ;   Opcion == 2 -> jugar_con_virtual
    ;   write('Opción inválida. Intenta de nuevo.'), nl, jugar
    ).
% Modo multijugador
jugar_multijugador :-
    inicializar_tablero(Tablero),
    imprimir_tablero(Tablero),
    write('Comienza el juego. Jugador black empieza.'), nl,
    turno_juego(Tablero, black).

% Modo jugador virtual
jugar_con_virtual :-
    inicializar_tablero(Tablero),
    imprimir_tablero(Tablero),
    write('Comienza el juego contra el jugador virtual. Jugador black empieza.'), nl,
    turno_juego_virtual(Tablero, black).
% Manejo de turnos
turno_juego(Tablero, Jugador) :-
    (   
        write('Turno de: '), write(Jugador), nl,
        solicitar_movimiento(Tablero, X, Y),
        actualiza_tablero(Tablero, Jugador, X, Y, NuevoTablero),
        imprimir_tablero(NuevoTablero),

        oponente(Jugador, OtroJugador),
        quedan_movimientos(NuevoTablero),
        turno_juego(NuevoTablero, OtroJugador)
    ;   
        write('No quedan movimientos disponibles.'), nl,
        fin_juego(Tablero)
    ).

% Manejo de turnos contra jugador virtual
turno_juego_virtual(Tablero, Jugador) :-
    (   write('Turno de: '), write(Jugador), nl,
        (   Jugador == black ->
            solicitar_movimiento(Tablero, X, Y)
        ;   jugador_virtual(Tablero, Jugador, (X, Y)),
            write('El jugador virtual elige: ('), write(X), write(', '), write(Y), write(')'), nl
        ),
        actualiza_tablero(Tablero, Jugador, X, Y, NuevoTablero),
        imprimir_tablero(NuevoTablero),
        oponente(Jugador, OtroJugador),
        quedan_movimientos(NuevoTablero),
        turno_juego_virtual(NuevoTablero, OtroJugador)
    ;   write('No quedan movimientos disponibles.'), nl,
        fin_juego(Tablero)
    ).

solicitar_movimiento(Tablero, X, Y) :-
    repeat,
    write('Introduce las coordenadas (X e Y como números entre 0 y 7): '), nl,
    read_line_to_string(user_input, InputX),
    number_string(X, InputX),
    read_line_to_string(user_input, InputY),
    number_string(Y, InputY),
    (   
        movimiento_valido(Tablero, X, Y) ->  % Valida si (X, Y) es un movimiento válido
            !
        ;   
            write(''), nl,
            fail
    ;   
        write('Movimiento inválido. Intenta de nuevo.'), nl,
        fail
    ).

quedan_movimientos(Tablero) :-
    member(Fila, Tablero),       
    member(empty, Fila).       
    
fin_juego(Tablero):-
    write('Fin del juego. Calculando puntuación...'), nl,

    contar_piezas(Tablero, black, PuntuacionBlack),
    contar_piezas(Tablero, white, PuntuacionWhite),
    write('Puntuación final:'), nl,
    write('Black: '), write(PuntuacionBlack), nl,
    write('White: '), write(PuntuacionWhite), nl,
    (   
        PuntuacionBlack > PuntuacionWhite ->
        write('¡Black gana!')
    ;   
        PuntuacionWhite > PuntuacionBlack ->
        write('¡White gana!')
    ;   
        write('¡Es un empate!')
    ).



