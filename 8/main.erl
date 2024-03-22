-module(main).
-compile(export_all).

main() ->
    main(["input.txt"]).

main([File]) ->
    {ok, Bin} = file:read_file(File),
    P = parse(Bin),
    M = min_dist(fun main:min_dist_1/3, P),
    io:format("part1: ~p~n", [M]),

parse(Bin) when is_binary(Bin) ->
    [list_to_integer(X) || X <- string:tokens(binary_to_list(Bin), ",")].
