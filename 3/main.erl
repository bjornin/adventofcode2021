-module(main).
-export([main/0, main/1]).

main() ->
    main(["input.txt"]).

main([File]) ->
    {ok, Bin} = file:read_file(File),
    Val = parse(Bin),
    io:format("part1: ~p~n", [engine_stats(Val)]),
    io:format("part2: ~p~n", [air_stats(Val)]),
    erlang:halt(0).

parse(Bin) when is_binary(Bin) ->
    [X || X <- string:tokens(binary_to_list(Bin), "\n")].

engine_stats(L) ->
    S = sum_bits(L),
    G = lists:map(fun transform/1, S),
    E = invert_bin(G),
    list_to_integer(lists:concat(G), 2) * list_to_integer(lists:concat(E), 2).

transform(Num) when is_integer(Num) ->
    case Num > 500 of
        true -> 1;
        false -> 0
    end.

invert_bin(L) -> lists:reverse(invert_bin(L, [])).
invert_bin([], Acc) -> Acc;
invert_bin([H|T], Acc) ->
    invert_bin(T, [(H + 1) rem 2|Acc]).
    
sum_bits(L) -> sum_bits(L, [0,0,0,0,0,0,0,0,0,0,0,0]).
sum_bits([], Acc) -> Acc;
sum_bits([H|T], Acc) ->
    sum_bits(T, lists:zipwith(fun(X, Y) -> list_to_integer([X]) + Y end, H, Acc)).

air_stats([]) -> 0;
air_stats(L) ->
    O = sum_air(oxygen, L),
    C = sum_air(co2, L),
    list_to_integer(O, 2) * list_to_integer(C, 2).

sum_air(M, L) -> sum_air(M, 1, L).
sum_air(_, _, [H]) -> H;
sum_air(M, Pos, L) -> sum_air(M, Pos, L, [], []).

sum_air(M, Pos, [], Zeros, Ones) ->
    if length(Ones) >= length(Zeros) andalso M =:= oxygen -> sum_air(M, Pos + 1, Ones);
        length(Ones) < length(Zeros) andalso M =:= oxygen -> sum_air(M, Pos + 1, Zeros);
        length(Ones) >= length(Zeros) andalso M =:= co2 -> sum_air(M, Pos + 1, Zeros);
        length(Ones) < length(Zeros) andalso M =:= co2 -> sum_air(M, Pos + 1, Ones)
    end;
sum_air(M, Pos, [H|T], Zeros, Ones) ->
    case lists:nth(Pos, H) of
        $0 -> sum_air(M, Pos, T, [H|Zeros], Ones);
        $1 -> sum_air(M, Pos, T, Zeros, [H|Ones])
    end.
