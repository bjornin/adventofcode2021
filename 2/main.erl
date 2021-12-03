-module(main).
-compile(export_all).

main() ->
    main(["input.txt"]).
main([File]) ->
    {ok, Bin} = file:read_file(File),
    Val = parse(Bin),
    io:format("part1: ~p~n",[travel(Val)]),
    io:format("part2: ~p~n",[travel_aim(Val)]).

parse(Bin) when is_binary(Bin) ->
    Val = [X || X <- string:tokens(binary_to_list(Bin), "\n")],
    group_vals(Val, []).

group_vals([], Acc) ->
    lists:reverse(Acc);
group_vals([H|T], Acc) ->
    {Dir, Len} = list_to_tuple(string:split(H, " ")),
    group_vals(T, [{list_to_atom(Dir), list_to_integer(Len)}|Acc]).

travel(Instructions) ->
    {X, Y} = lists:foldl(fun move/2, {0, 0}, Instructions),
    X * Y.

move(Instruction, {Horizontal, Depth}) ->
    case Instruction of
        {forward, N} -> {Horizontal + N, Depth};
        {down, N} -> {Horizontal, Depth + N};
        {up, N} -> {Horizontal, Depth - N};
        _ -> {Horizontal, Depth}
    end.

travel_aim(Instructions) ->
    {X, Y, _} = lists:foldl(fun move_aim/2, {0, 0, 0}, Instructions),
    X * Y.

move_aim(Instruction, {Horizontal, Depth, Aim}) ->
    case Instruction of
        {forward, N} -> {Horizontal + N, Depth + Aim * N, Aim};
        {down, N} -> {Horizontal, Depth, Aim + N};
        {up, N} -> {Horizontal, Depth, Aim - N};
        _ -> {Horizontal, Depth, Aim}
    end.
