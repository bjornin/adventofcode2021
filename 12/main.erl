-module(main).
-compile(export_all).

main() ->
    main(["test.txt"]).

main([File]) ->
    {ok, Bin} = file:read_file(File),
    P = parse(Bin),
    io:format("part1: ~p~n", [P]).
    
parse(Bin) when is_binary(Bin) ->
    [X || X <- string:tokens(binary_to_list(Bin), "\n\r")].

