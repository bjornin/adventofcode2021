-module(main).
-compile(export_all).

main() ->
    main(["input.txt"]).

main([File]) ->
    {ok, Bin} = file:read_file(File),
    Val = parse(Bin),
    io:format("part1: ~p~n", [engine_stats(Val)]).
% io:format("part2: ~p~n",[travel_aim(Val)]),
% erlang:halt(0).

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
