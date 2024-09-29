
/* Ensures that a given list contains every number 1-N */
is1toN(0,List).
is1toN(N,List) :- N>0, member(N,List), G is N-1, is1toN(G,List).

/* Ensures that, for a list of lists, each sublist is of size N, contains elements 1-N*/
listoflistselsare1toNandsizeN([],N).
listoflistselsare1toNandsizeN([H|T],N) :- length(H,N), is1toN(N,H), listoflistselsare1toNandsizeN(T,N).

/* In a list of lists which represents are a grid, this gets the Nth column*/
getnthcolumn(_,[],[]) :- !.
getnthcolumn(N, [R|T], [NewEl|Column]) :- nth(N,R,NewEl),getnthcolumn(N,T,Column).

/*This gets every column a list of lists, in reverse order*/
revrowstocols(_,[],0) :- !.
revrowstocols(Rows,[Newcol|Cols],N) :- N>0, getnthcolumn(N,Rows,Newcol), G is N-1, revrowstocols(Rows,Cols,G).

/*In a list that represents a row of towers, this counts how many towers are visible from the leftmost side/not blocked by a taller tower */
visiblefromlefthelper([], 0):-!.
visiblefromlefthelper([_], 1):-!.
visiblefromlefthelper([H1, H2 | T], Num) :- H1 >= H2, !, visiblefromlefthelper([H1 | T], RestNum), Num is RestNum.
visiblefromlefthelper([H1, H2 | T], Num) :- H1 < H2, visiblefromlefthelper([H2 | T], RestNum), Num is RestNum + 1.
visiblefromleft(L, C1) :- visiblefromlefthelper(L, C2), C1 is C2.

/*Ensures that the visiblefromleft value matches that which is expected in the list of expected counts for every given row*/ 
viewcountmatch(Counts,List,N):-length(Counts,N),viewcountmatchhelp(Counts,List,N).
viewcountmatchhelp(_,_,0):-!.
viewcountmatchhelp(Counts,List,N):- nth(N,List,Sublist), nth(N,Counts,Desiredcount), visiblefromleft(Sublist,M), M = Desiredcount, G is N-1, viewcountmatchhelp(Counts,List,G).

/* Given a list of lists, each sublist has the elemnts reversed, but the greater lists remain in the same order*/
reversesublists([],[]).
reversesublists([H1|T1],[H2|T2]):- reverse(H1,H2),reversesublists(T1,T2).

/*Finite domain version of above helper functions */
fd_1toN([],_).
fd_1toN([H|T],N):- fd_domain(H,1,N), fd_1toN(T,N).

reversedlengthargs(N, L) :- length(L, N).

fd_visiblefromlefthelper([], 0):-!.
fd_visiblefromlefthelper([_], 1):-!.
fd_visiblefromlefthelper([H1, H2 | T], Num) :- H1 #>= H2, !, fd_visiblefromlefthelper([H1 | T], RestNum), Num #= RestNum.
fd_visiblefromlefthelper([H1, H2 | T], Num) :- H1 #< H2, fd_visiblefromlefthelper([H2 | T], RestNum), Num #= RestNum + 1.
fd_visiblefromleft(L, C1) :- fd_visiblefromlefthelper(L, C2), C1 #= C2.

fd_viewcountmatch(Counts,List,N):-length(Counts,N),fd_viewcountmatchhelp(Counts,List,N).
fd_viewcountmatchhelp(_,_,0):-!.
fd_viewcountmatchhelp(Counts,List,N):- nth(N,List,Sublist), nth(N,Counts,Desiredcount), visiblefromleft(Sublist,M), M #= Desiredcount, G #= N-1, fd_viewcountmatchhelp(Counts,List,G).


ntower(N, T, counts(Firstel,Secondel,Thirdel,Fourthel)) :-
/*
My psuedocode:
- In counts function symbol, C[0],C[1],C[2],C[3] all have size N, there is no C[4+]
    - C[0]/Top: How many towers are visible (in increasing order) from the top-most part, going downwards
    - C[1]/Bottom: How many towers are visible (in increasing order) from the bottom-most part, going upwards
    - C[2]/Left: How many towers are visible (in increasing order) from the left-most part, going rightwards
    - C[3]/Right: How many towers are visible (in increasing order) from the right-most part, going leftwards
- T has index of lists 0-(N-1)
    - Each element of T is list with ints 1-N (unique)
    - Each column of T has ints 1-N (unique)
*/

    /*  In counts function symbol, C[0],C[1],C[2],C[3] all have size N, there is no C[4+]  */
    length(Firstel,N),
    length(Secondel,N),
    length(Thirdel,N),
    length(Fourthel,N),

    /* T and C have index of lists 0-(N-1), each list is size N and permutation of 1 to N*/
    length(T,N),
    maplist(reversedlengthargs(N),T),
    fd_1toN(T,N),
    maplist(fd_all_different,T),

    revrowstocols(T,Cl,N),
    reverse(C,Cl),
    maplist(reversedlengthargs(N),C),
    fd_1toN(C,N),
    maplist(fd_all_different,C),

    listoflistselsare1toNandsizeN(C,N),

    /*  - C[0]/Top: How many towers are visible (in increasing order) from the top-most part, going downwards
        In list of columns, viewable(C[N]) = Firstel[N]
     */
     fd_viewcountmatch(Firstel,C,N),

    /*  C[1]/Bottom: How many towers are visible (in increasing order) from the bottom-most part, going upwards 
        In list of reversedlist of columns, viewable(revC[N]) = Secondel[N]    */
    reversesublists(C,RevC),
    fd_viewcountmatch(Secondel,RevC,N),

    /*  - C[2]/Left: How many towers are visible (in increasing order) from the left-most part, going rightwards 
    In list of rows, viewable(R[N]) = Firstel[N]
    */ 
    fd_viewcountmatch(Thirdel,T,N),

    /*  - C[3]/Right: How many towers are visible (in increasing order) from the right-most part, going leftwards */
    reversesublists(T,RevT),
    fd_viewcountmatch(Fourthel,RevT,N).


plain_ntower(N, T, counts(Firstel,Secondel,Thirdel,Fourthel)) :-
/*
My psuedocode:
- In counts function symbol, C[0],C[1],C[2],C[3] all have size N, there is no C[4+]
    - C[0]/Top: How many towers are visible (in increasing order) from the top-most part, going downwards
    - C[1]/Bottom: How many towers are visible (in increasing order) from the bottom-most part, going upwards
    - C[2]/Left: How many towers are visible (in increasing order) from the left-most part, going rightwards
    - C[3]/Right: How many towers are visible (in increasing order) from the right-most part, going leftwards
- T has index of lists 0-(N-1)
    - Each element of T is list with ints 1-N (unique)
    - Each column of T has ints 1-N (unique)
*/

    /*  In counts function symbol, C[0],C[1],C[2],C[3] all have size N, there is no C[4+]  */
    length(Firstel,N),
    length(Secondel,N),
    length(Thirdel,N),
    length(Fourthel,N),

    /* T has index of lists 0-(N-1) */
    length(T,N),

    /*Each element of T is list with ints 1-N (unique)
    Logically this holds if list is of size N and contains every int leading up to and including N
    */
    listoflistselsare1toNandsizeN(T,N),

    /* Each column of T has ints 1-N (unique) (size restrictions already satisfied by previous code)
     */
     revrowstocols(T,Cl,N),
     reverse(C,Cl),
     listoflistselsare1toNandsizeN(C,N),

    /*  - C[0]/Top: How many towers are visible (in increasing order) from the top-most part, going downwards
        In list of columns, viewable(C[N]) = Firstel[N]
     */
     viewcountmatch(Firstel,C,N),

    /*  C[1]/Bottom: How many towers are visible (in increasing order) from the bottom-most part, going upwards 
        In list of reversedlist of columns, viewable(revC[N]) = Secondel[N]    */
    reversesublists(C,RevC),
    viewcountmatch(Secondel,RevC,N),

    /*  - C[2]/Left: How many towers are visible (in increasing order) from the left-most part, going rightwards 
    In list of rows, viewable(R[N]) = Firstel[N]
    */ 
    viewcountmatch(Thirdel,T,N),

    /*  - C[3]/Right: How many towers are visible (in increasing order) from the right-most part, going leftwards */
    reversesublists(T,RevT),
    viewcountmatch(Fourthel,RevT,N).

/* Return time test case took (total CPU time) for plain divided by ntower. Test case has no valid solution, so tests how long it takes to search problem space. */
ntowertime(Time):- statistics(cpu_time, [Start|_]), \+ ntower(4,T,counts([1,2,3,4],[3,2,4,1],[1,1,3,4],[4,2,3,1])), statistics(cpu_time, [End|_]), Time is (End - Start).
plainntowertime(Time):- statistics(cpu_time, [Start|_]), \+ plain_ntower(4,T,counts([1,2,3,4],[3,2,4,1],[1,1,3,4],[4,2,3,1])), statistics(cpu_time, [End|_]), Time is (End - Start).

speedup(Returned) :- ntowertime(Ntow),plainntowertime(Plain),Returned is Plain / Ntow.

ambiguous(N, C, T1, T2):- ntower(N,T1,C), ntower(N,T2,C), T1 \== T2. 