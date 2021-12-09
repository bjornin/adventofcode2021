-module(main).
-compile(export_all).

main() ->
    main(["input.txt"]).

main([File]) ->
    {ok, Bin} = file:read_file(File),
    P = parse(Bin),
    F = fish(P, 80),
    S = lists:sum(maps:values(F)),
    io:format("part1: ~p~n", [S]),
    F2 = fish(P, 256),
    S2 = lists:sum(maps:values(F2)),
    io:format("part1: ~p~n", [S2]).
    % io:format("part1: ~p~n", [danger(M2)]).
    % erlang:halt(0).

parse(Bin) when is_binary(Bin) ->
    parse_num([list_to_integer(X) || X <- string:tokens(binary_to_list(Bin), ",")]).

parse_num(N) -> parse_num(N, #{}).
parse_num([], Acc) -> Acc;
parse_num([H|T], Acc) ->
    Nacc = maps:update_with(H, fun(V) -> V + 1 end, 1, Acc),
    parse_num(T, Nacc).

fish(P, D) when is_map(P) -> fish(P, maps:keys(P), D).
fish(P, _, D) when D == 0 -> P;
fish(P, K, D) ->
    fish(fish_tick(P, K), D-1).

fish_tick(P, K) -> fish_tick(P, K, #{}).
fish_tick(_, [], Acc) -> Acc;
fish_tick(P, [H|T], Acc) ->
    Z = maps:get(H, P),
    if H == 0 ->
            Acc8 = maps:put(8, Z, Acc),
            Acc6 = maps:update_with(6, fun(V) -> V + Z end, Z, Acc),
            A = maps:merge(Acc6, Acc8),
            fish_tick(P, T, maps:merge(Acc, A));
        H == 7 ->
            A = maps:update_with(6, fun(V) -> V + Z end, Z, Acc),
            fish_tick(P, T, maps:merge(Acc, A));
        true ->
            A = maps:put(H - 1, Z, Acc),
            fish_tick(P, T, maps:merge(Acc, A))
        end.
