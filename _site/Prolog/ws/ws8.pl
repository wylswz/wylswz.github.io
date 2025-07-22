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