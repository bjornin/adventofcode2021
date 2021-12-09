-module(main).
-compile(export_all).

main() ->
    main(["input.txt"]).

main([File]) ->
    {ok, Bin} = file:read_file(File),
    P = parse(Bin),
    F = fish(P, 80),
    io:format("part1: ~p~n", [F]),
    F2 = fish(P, 256),
    io:format("part1: ~p~n", [F2]).
    % io:format("part1: ~p~n", [danger(M2)]).
    % erlang:halt(0).

parse(Bin) when is_binary(Bin) ->
    [list_to_integer(X) || X <- string:tokens(binary_to_list(Bin), ",")].

fish(P, D) when D == 0 -> length(P);
fish(P, D) ->
    New = [8 || X <- P, X =:= 0],
    T = lists:map(fun tick/1, P),
    fish(lists:append(T, New), D-1).

tick(V) ->
    if V =:= 0 -> 6;
        V > 0 -> V - 1
    end.
