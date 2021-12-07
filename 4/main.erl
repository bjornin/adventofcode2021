-module(main).
-compile(export_all).

main() ->
    main(["input.txt"]).

main([File]) ->
    {ok, Bin} = file:read_file(File),
    {Numbers, Boards} = parse(Bin),
    P1 = catch bingo(Numbers,Boards),
    io:format("part1: ~p~n", [P1]),
    P2 = bingo2(Numbers,Boards),
    io:format("part2: ~p~n", [P2]).
    % erlang:halt(0).

parse(Bin) when is_binary(Bin) ->
    [N|B] = [string:tokens(X, ", ") || X <- string:tokens(binary_to_list(Bin), "\n")],
    Boards = boards(B, maps:new()),
    {N,Boards}.

boards([], Acc) -> Acc;
boards([A,B,C,D,E|T], Acc) ->
    V = zip5(A,B,C,D,E),
    S = lists:sum([list_to_integer(X) || X <- lists:append(V)]),
    boards(T, maps:put(lists:append([A,B,C,D,E], V), S*2, Acc)).

zip5([V | Vs], [W | Ws], [X | Xs], [Y | Ys], [Z | Zs]) -> [[V, W, X, Y, Z] | zip5(Vs, Ws, Xs, Ys, Zs)];
zip5([], [], [], [], []) -> [].

bingo(N, B) -> bingo(N, maps:keys(B), maps:new(), B).
bingo([H|T], B, Acheck, Asum) ->
    try check_board(H, B, Acheck, Asum) of
        {Ncheck, Nsum} -> bingo(T, B, Ncheck, Nsum)
    catch
        Winner -> throw(Winner)
    end.

check_board(_, [], Acheck, Asum) -> {Acheck, Asum};
check_board(N, [H|T], Acheck, Asum) ->
    try check_line(N, H, Acheck, 0) of
        {Ncheck, Nsum} ->
            NS = maps:update_with(H, fun(V) -> V - Nsum end, Asum),
            check_board(N, T, Ncheck, NS)
    catch
        Winner -> throw(list_to_integer(N) * (maps:get(H, Asum) - list_to_integer(N)*2) / 2)
    end.
    
check_line(_,[], Acheck, Sum) -> {Acheck, Sum};
check_line(N, [H|T], Acheck, Sum) ->
    M = lists:member(N, H),
    if M ->
        Ncheck = maps:update_with(H,fun(V) -> V + 1 end, 1, Acheck),
        case maps:get(H,Ncheck) of
            5 -> throw({winner});
            _ -> check_line(N, T, Ncheck, Sum + list_to_integer(N))
        end;
        true -> check_line(N, T, Acheck, Sum)
    end.


bingo2(N, B) -> bingo2(N, maps:keys(B), maps:new(), B, []).
bingo2([], _, _, _, _) -> 0;
bingo2(_, [], _, Asum, [Last]) -> maps:get(Last, Asum) / 2;
bingo2([H|T], B, Acheck, Asum, Last) ->
    {Ncheck, Nsum, W} = check_board2(H, B, Acheck, Asum, []),
    bingo2(T, B -- W, Ncheck, Nsum, W).

check_board2(_, [], Acheck, Asum, W) -> {Acheck, Asum, W};
check_board2(N, [H|T], Acheck, Asum, W) ->
    try check_line2(N, H, Acheck, 0) of
        {Ncheck, Nsum} ->
            NS = maps:update_with(H, fun(V) -> V - Nsum end, Asum),
            check_board2(N, T, Ncheck, NS, W)
    catch
        Winner -> 
            io:format("~p ~n", [N]), % This is ugly. Need to make it return N to bingo
            Nsum = maps:update_with(H, fun(V) -> V - list_to_integer(N)*2 end, Asum),
            check_board2(N, T, Acheck, Nsum, [H|W])
    end.
    
check_line2(_,[], Acheck, Sum) -> {Acheck, Sum};
check_line2(N, [H|T], Acheck, Sum) ->
    M = lists:member(N, H),
    if M ->
        Ncheck = maps:update_with(H,fun(V) -> V + 1 end, 1, Acheck),
        case maps:get(H,Ncheck) of
            5 -> throw({winner});
            _ -> check_line2(N, T, Ncheck, Sum + list_to_integer(N))
        end;
        true -> check_line2(N, T, Acheck, Sum)
    end.
