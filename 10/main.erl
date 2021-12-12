-module(main).
-compile(export_all).

main() ->
    main(["input.txt"]).

main([File]) ->
    {ok, Bin} = file:read_file(File),
    P = parse(Bin),
    C = check(P),
    io:format("part1: ~p~n", [C]).

parse(Bin) when is_binary(Bin) ->
    [parse_line(X) || X <- string:tokens(binary_to_list(Bin), "\n\r")].

parse_line(B) ->
    [list_to_binary([X]) || X <- B].

check(P) -> check(P, 0).
check([], Acc) -> Acc;
check([H|T], Acc) ->
    try check_line(H) of
        _ -> check(T, Acc)
    catch
        A ->
            check(T, Acc + A)
    end.

check_line(P) -> check_line(P, []).
check_line([], _) -> 0;
check_line([H|T], [Sh|St]) ->
    if H == <<")">>, Sh =/= <<"(">> -> throw(3);
        H == <<")">> -> check_line(T, St);
        H == <<"]">>, Sh =/= <<"[">> -> throw(57);
        H == <<"]">> -> check_line(T, St);
        H == <<"}">>, Sh =/= <<"{">> -> throw(1197);
        H == <<"}">> -> check_line(T, St);
        H == <<">">>, Sh =/= <<"<">> -> throw(25137);
        H == <<">">> -> check_line(T, St);
        true -> check_line(T,[H|[Sh|St]])
    end;
check_line([H|T], S) ->
    check_line(T, [H|S]).