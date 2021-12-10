-module(main).
-compile(export_all).

main() ->
    main(["input.txt"]).

main([File]) ->
    {ok, Bin} = file:read_file(File),
    P = parse(Bin),
    M = min_dist(fun main:min_dist_1/3, P),
    io:format("part1: ~p~n", [M]),
    M2 = min_dist(fun main:min_dist_2/3, P),
    io:format("part1: ~p~n", [M2]).

parse(Bin) when is_binary(Bin) ->
    [list_to_integer(X) || X <- string:tokens(binary_to_list(Bin), ",")].

min_dist(F, P) -> min_dist(F, P, lists:seq(lists:min(P), lists:max(P)), 100000000000).
min_dist(_, _, [], Fuel) -> Fuel;
min_dist(F, P, [H|T], Fuel) ->
    M = F(P, H, 0),
    min_dist(F, P, T, min(M, Fuel)).
min_dist_1([], _, Acc) -> Acc;
min_dist_1([H|T], M, Acc) ->
    A = math:sqrt((H - M) * (H - M)),
    min_dist_1(T, M, Acc + A).

min_dist_2([], _, Acc) -> Acc;
min_dist_2([H|T], M, Acc) ->
    A = math:sqrt((H - M) * (H - M)),
    F = lists:sum(lists:seq(0,trunc(A))),
    min_dist_2(T, M, Acc + F).
