-module(main).
-compile(export_all).

main() ->
    main(["input.txt"]).

main([File]) ->
    {ok, Bin} = file:read_file(File),
    P = parse(Bin),
    M = min_dist(P),
    io:format("part1: ~p~n", [M]).

parse(Bin) when is_binary(Bin) ->
    [list_to_integer(X) || X <- string:tokens(binary_to_list(Bin), ",")].

min_dist(P) -> min_dist(P, lists:seq(lists:min(P), lists:max(P)), 1000000).
min_dist(_, [], Fuel) -> Fuel;
min_dist(P, [H|T], Fuel) ->
    F = min_dist_p(P, H, 0),
    min_dist(P, T, min(F, Fuel)).
min_dist_p([], _, Acc) -> Acc;
min_dist_p([H|T], M, Acc) ->
    A = math:sqrt((H - M) * (H - M)),
    min_dist_p(T, M, Acc + A).
