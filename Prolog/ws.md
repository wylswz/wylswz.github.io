# Prolog workshops

Workshop 1 - 5 are Haskell topics.

The code in workshop is guaranteed to be error-free.

## Workshop 6
Some files required:

- [borders](./ws/borders.pl)
- [cities](./ws/cities.pl)
- [countries](./ws/countries)
- [rivers](./ws/rivers.pl)

Please put them in same dir as workshop 6 source code

```prolog
:- ensure_loaded(borders).
:- ensure_loaded(cities).
:- ensure_loaded(countries).
:- ensure_loaded(rivers).

/*
    Q1 borders(X,australia).
    Q2 borders(B, france), borders(B, spain).
    Q3 borders(B, france), borders(B, spain), country(B,_,_,_,_,_,_,_).
    
*/

/* Q4
    country/1 
    country(C) is True if C is a country 
*/
country(A) :- 
    country(A,_,_,_,_,_,_,_).

/* Q5
    larger/2 
    larger(C1, C2) holds when C1 is larger

    country(Country,Region,Latitude,Longitude,
        Area (sqmiles),
        Population,
        Capital,Currency)
*/
larger(C1, C2) :- 
    country(C1,_,_,_,A1,_,_,_),
    country(C2,_,_,_,A2,_,_,_),
    A1 > A2.

/*
    river_country/2 
    river_country(River, Country) holds if:
    - River is a river
    - Country is a country
    - River flows into or outof Country

    country_region/2
    country_region(Country, Region) holds if:
    - Country is a country in Region
*/
river_country(River, Country) :- 
    river(River, L),
    country(Country),
    member(Country, L).

country_region(Country, Region) :- 
    country(Country, Region, _,_,_,_,_,_).

```

## Workshop 7
```prolog
/* Q1
    list_of/2
    list_of(Elt, List) holds if:
    - every element if List equals to Elt

    Works in any mode
*/

list_of(_,[]).
list_of(E, [E|T]) :- 
    list_of(E,T).

/* Q2
    all_same/1
    all_same(List) holds if:
    - All elements are same
*/
all_same([]).
all_same([_]).
all_same([E|[E|T]]) :- 
    all_same([E|T]).

/* Q3
    adjacent/3
    adjacent(E1, E2, List) holds if:
    E1 appear immediately before E2 in List

*/

adjacent(E1, E2, List) :- 
    append(_, [E1, E2|_], List).

/* Q4
    same predicate as Q3, but implement it recursively
*/

adjacent_r(E1, E2, [E1,E2|_]).
adjacent_r(E1, E2, [_|T]) :-
    adjacent_r(E1, E2, T).

/* Q5
    before/3
    before(E1,E2,List) holds if: 
    - E1 occurs before E2 in List

    Solve this recursively.
    If List starts with E1, then we need to make sure 
    E2 is in tail. If not, apply this to tail.
*/
before(E1, E2, [E1|T]) :- 
    member(E2,T).
before(E1, E2, [_|T]) :- 
    before(E1, E2, T).

/* Q6
    tree/3
    tree(L, N, R) represents a tree with label N and left
    sub-tree L and right sub-tree R. Atom empty is Leaf.

    intset_member/2
    intset_member(N, Set) holds if:
    - N is a member of Set
    *Avoid unnecessary recursion by comparing N with label of Set

    intset_insert/3
    intset_insert(N, Set0, Set) where
    Set has N as a member. There should be no duplicated elements
*/
intset_member(N, tree(_,N,_)).
intset_member(N, tree(L,N0,_)) :- 
    N < N0,
    intset_member(N, L).
intset_member(N, tree(_, N0, R)) :- 
    N >= N0,
    intset_member(N,R).

intset_insert(N, empty, tree(empty, N, empty)).
intset_insert(N, tree(L,N,R), tree(L,N,R)).
intset_insert(N, tree(L1,N1,R1), tree(L2,N1,R1)) :-
    N < N1,
    intset_insert(N, L1, L2).
intset_insert(N, tree(L1,N1,R1), tree(L1,N1,R2)) :- 
    N >= N1,
    intset_insert(N, R1, R2).

```


## Workshop 8 

```prolog

/* Q1
    Convert the code to tail recursive version
    sumList([], 0).
    sumList([N|Ns], Sum) :- 
        sumList(Ns, Sum0),
        Sum is Sum0 + N.

    Solve this by introducing an accumulator A
    When the list is empty, the sum is A
    Otherwise, Add head to A and recursively call
    predicate.
*/

sumListA([],A,A).
sumListA([N|Ns], Sum, A) :-
    Sum0 is A + N,
    sumListA(Ns, Sum, Sum0).

sumList(L, Sum) :- 
    sumListA(L, Sum, 0).

/* Q2
    a binary tree defined as:
    tree(empty).
    tree(node(Left, _, Right)) :- 
        tree(Left),
        tree(Right).
    
    tree_list/2
    tree_list(Tree, List) holds if:
    - List is list of all elem of tree
    - Left to Right order

*/


tree_list(empty, []).
tree_list(node(Left,Elt,Right), List) :-
	tree_list(Left, List1),
	tree_list(Right, List2),
	append(List1, [Elt|List2], List).

/* Q3 
    Same as last question, but not use append
    Make sure the cost is proportional to number of 
    nodes in tree.

    Refer to tail recursion optimization

    It can be solved like this:
    We are basically adding the tree to accumulator to get
    the result.

    Left hand side:
        adding left tree to accumulator A where A is calculated from
        right hand side and the node of current tree

    Right hand side:
        The accumulator is current accumulator passed as argument 
*/

tree_list_a(empty, A, A).
tree_list_a(node(Left, V, Right), List, A) :- 
    tree_list_a(Left, List, List1),
    List1 = [V|List2],
    tree_list_a(Right, List2, A).


/* Q4
    list_tree_b/2
    list_tree_b(List, Tree) holds if:
    - List is a list of elements in Tree
    - Tree is balanced
    
    Work in the mode where List is proper list
*/

/*
    The below solution is not efficient because
    it tries to find the appropriate list combination
    one by one
list_tree_b([],empty).
list_tree_b(List, node(Left, V, Right)) :- 
    append(List_L, List_R_V, List),
    List_R_V = [V| List_R],
    length(List_L, Len_L),
    length(List_R, Len_R),
    Len_L - Len_R =< 1,
    list_tree_b(List_L, Left),
    list_tree_b(List_R, Right).

    A better solution is to specify the length at 
    the beginning

*/

list_tree_b_([], empty).
list_tree_b_([E|List], node(Left,Elt,Right)) :-
	length(List, Len),
	Len2 is Len // 2,
	length(Front, Len2),
	append(Front, [Elt|Back], [E|List]),
	list_tree_b_(Front, Left),
	list_tree_b_(Back, Right).
```