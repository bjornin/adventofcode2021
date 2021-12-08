-module(main).
-compile(export_all).

main() ->
    main(["input.txt"]).

main([File]) ->
    {ok, Bin} = file:read_file(File),
    P = parse(Bin),
    M = mark(P),
    D = danger(M),
    io:format("part1: ~p~n", [D]),
    M2 = mark2(P),
    io:format("part1: ~p~n", [danger(M2)]).
    % erlang:halt(0).

parse(Bin) when is_binary(Bin) ->
    P = [string:tokens(X, " -> ") || X <- string:tokens(binary_to_list(Bin), "\n")],
    parse_point(P).

parse_point(P) -> lists:reverse(parse_point(P, [])).
parse_point([H|T], Acc) ->
    [P1, P2] = H,
    From = list_to_tuple([list_to_integer(X) || X <- string:tokens(P1, ",")]),
    To = list_to_tuple([list_to_integer(X) || X <- string:tokens(P2, ",")]),
    parse_point(T, [[From, To]|Acc]);
parse_point([], Acc) -> Acc.

mark(P) -> mark(P, #{}).
mark([H|T], Acc) ->
    A = maps:merge_with(fun(_Key, V1, V2) -> V1 + V2 end, mark_line(H), Acc),
    mark(T, A);
mark([], Acc) -> Acc.

mark_line([{X1, Y1}, {X2, Y2}]) ->
    if X1 == X2 -> mark_point_x(X1, {Y1, Y2}, #{});
        Y1 == Y2 -> mark_point_y({X1, X2}, Y1, #{});
        true -> #{}
    end.

mark_point_x(X, {Y, Y}, Acc) ->
    maps:update_with({X, Y}, fun(V) -> V + 1 end, 1, Acc);
mark_point_x(X, {Y1, Y2}, Acc) ->
    A = maps:update_with({X, min(Y1,Y2)}, fun(V) -> V + 1 end, 1, Acc),
    mark_point_x(X, {min(Y1,Y2) + 1, max(Y1,Y2)}, A).

mark_point_y({X, X}, Y, Acc) ->
    maps:update_with({X, Y}, fun(V) -> V + 1 end, 1, Acc);
mark_point_y({X1, X2}, Y, Acc) ->
    A = maps:update_with({min(X1, X2), Y}, fun(V) -> V + 1 end, 1, Acc),
    mark_point_y({min(X1,X2) + 1, max(X1,X2)}, Y, A).

danger(M) ->
    maps:fold(fun(_, V, Acc) when V > 1 -> Acc + 1; (_,_,Acc) -> Acc end, 0, M).

mark2(P) -> mark2(P, #{}).
mark2([], Acc) -> Acc;
mark2([H|T], Acc) ->
    A = maps:merge_with(fun(_Key, V1, V2) -> V1 + V2 end, mark_line2(H), Acc),
    mark2(T, A).

mark_line2([{X1, Y1}, {X2, Y2}]) ->
    if X1 == X2 -> mark_point_x(X1, {Y1, Y2}, #{});
        Y1 == Y2 -> mark_point_y({X1, X2}, Y1, #{});
        true -> mark_point_d(X1, Y1, X2, Y2, #{})
    end.

mark_point_d(X1, Y1, X2, Y2, Acc) ->
    Xs = if X1 < X2 -> lists:seq(X1, X2);
            X1 > X2 -> lists:seq(X1, X2, -1)
        end,
    Ys = if Y1 < Y2 -> lists:seq(Y1, Y2);
            Y1 > Y2 -> lists:seq(Y1, Y2, -1)
        end,
    K = lists:zip(Xs,Ys),
    maps:from_keys(K, 1).

            