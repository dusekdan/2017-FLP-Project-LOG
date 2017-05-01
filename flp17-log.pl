% FLP2017-LOG Maticové operace, xdusek21, Daniel Dušek
:- use_module(library(dcg/basics)).

%% input_to_numbers(+Input, +Numbers)
% 
% Reads stdin and parses it to a list of list of integers and floats which just
% happens to be the way we want to repesent a matrix in prolog.
%

input_to_numbers(Input, Numbers) :- phrase_from_stream(numbers(Numbers), Input).

%% DCG input parsing rules
%
% Uses eos/0, whites/0, number/1, blanks_to_nl/0 from dcg/basics.pl that is 
% accessible in swi-pl installations.
%

numbers([]) --> eos, !.
numbers([H|T]) -->
	nums_line(H), !,
	numbers(T).
nums_line([N|Ns]) -->
	whites,
	number(N), !,
	nums_line(Ns).
nums_line([]) --> blanks_to_nl.


%% main/0 - Application entry point goal
% 
% Takes care of calling proper goals and printing their results to stdout
% 

main :- prompt(_,''),
	input_to_numbers(user_input, Ns),
	constructMatrices(Ns,A,B),
	m_add_print(A,B),
	write('\n'),
	m_mult_print(A,B),
	write('\n'),
	m_inversion_print(A),
	write('\n'),
	m_cholesky_print(A),
	write('\n'),
	m_determinant_print(A),
	write('\n'),
	m_rank_print(A),
	write('\n'),
	halt.


%% constructMatrices(+List, -List A, -List B)
%
% Constructs matrices representation from its first parameter
%
% +List is list of lists of numbers, whereas empty list in place of list of 
%  numbers is considered matrix separator.
% -List A is representation of Matrix A
% -List B is representation of Matrix B
%
% == 
% constructMatrices([[1,2,3], [3,4,5], [5,6,7], [], [8,9,10], [10,11,12], [12,13,14]], A, B).
% A = [[1, 2, 3], [3, 4, 5], [5, 6, 7]],
% B = [[8, 9, 10], [10, 11, 12], [12, 13, 14]]
% == 

constructMatrices([[]|X], [], B) :- constructMatricesHelper(X,B).
constructMatrices([H|T], [H|A], B) :- constructMatrices(T,A,B).
constructMatricesHelper([], []).
constructMatricesHelper([H|T], [H|B]) :- constructMatricesHelper(T,B).


%% Result printing operations
%% m_add_print(+List,+List), m_mult_print(+List,+List)
%
% Ensures calculation is run and its output is print to stdout,
% these could be considered a wrapper functions in imperative languages.
%
% +List A is representation of matrix A
% +List B is representation of matrix B
%

m_add_print(A,B) :- catch(m_add(A,B,C), 
	error(type_error(_,_),_), false)
		->  	printMatrix(C) 
		; 	write('false\n').

m_mult_print(A,B) :- catch(m_multiplication(A,B,C),
	error(type_error(_,_),_), false) 
		-> 	printMatrix(C) 
		; 	write('false\n').


%% printMatrix(+List)
% 
% Prints out matrix in desired final formatting
%
% +List is matrix representation to be printed out
%

printMatrix([]).
printMatrix([H|T]) :- printMatrixLine(H), write('\n'), printMatrix(T).
printMatrixLine([]).
printMatrixLine([H|T]) :- write(H), write(' '), printMatrixLine(T).


%% m_add(+List A, +List B, -List C)
%
% Adds matrix A to matrix B and puts result to matrix C
%
% +List A is representation of matrix A
% +List B is representation of matrix B
% -List C is representation of addition of matrices A nd B
%
% ==
% m_add([[1,2,3], [23,3,2]], [[5,6,8],[5,6,8]], X).
% X = [[6, 8, 11], [28, 9, 10]]
% ==

m_add([],[],[]).
m_add([H1|T1], [H2|T2], [H3|T3]) :- v_add(H1, H2, H3), m_add(T1, T2, T3).
% This code is commented out - I researched that for my
% printing approach it is better to just catch the error. 
%m_add([], [_|_], _) :- write('m1fail'), fail.
%m_add([_|_], [], _) :- write('m2fail'), fail.


%% v_add(+List A, +List B, -List C)
%
% Adds vector to another vector
%
% +List A is a list of numbers representing vector
% +List B is a list of numbers representing vector
% +List C is a list of numbers representing result of vector A and B addition
%

v_add([],[],[]).
v_add([H1|T1], [H2|T2], [H3|T3]) :- H3 is H1 + H2, v_add(T1, T2, T3).
% This code is commented out - I researched that for my
% printing approach it is better to just catch the error.
%v_add([], [_|_], _) :- write('v1'), fail.
%v_add([_|_], [], _) :- write('v2'), fail.
 


%% m_mult()+List A, +List B, -List C)
%
% Multiplies matrix A with matrix B and puts result to matrix C
%
% +List A is representation of matrix A
% +List B is representation of matrix B
% -List C is representation of multiplication of matrices A nd B
%

v_multiplication([], [_|_], _) :- fail.
v_multiplication([_|_], [], _) :- fail.
v_multiplication([], [], _) :- fail.	% u fkin sure daniel?
v_multiplication(List1, List2, Result) :- v_multiplication(List1, List2, 0, Result).
v_multiplication([], [], Acc, Acc).
v_multiplication([X|Xs], [Y|Ys], Acc, Result) :- NewAcc is X*Y+Acc, v_multiplication(Xs, Ys, NewAcc, Result).

m_multiplication(X,Y,Z) :- m_transpose(Y,Y2), maplist(m_multiplication2(Y2), X, Z).
m_multiplication2(Y, X, Z) :- maplist(v_multiplication(X), Y, Z).


%% m_transpose(+List A, -List B)
%
% Transpose matrix represented by list A, serves as helper for m_mult/3 goal 
%
% +List A representation of matrix to be transposed
% -List B representation of transposed matrix
%
% == 
% m_transpose([[1,2,3], [-23,3,2]], X).
% X = [[1, -23], [2, 3], [3, 2]]
% ==

m_transpose([], []).
m_transpose([F|Fs], Ts) :- m_transpose(F, [F|Fs], Ts).
m_transpose([], _, []).
m_transpose([_|Rs], Ms, [Ts|Tss]) :- l_split_firsts(Ms, Ts, Ms1), m_transpose(Rs, Ms1, Tss).

%% l_split_firsts
%
% Splits first elements of lists, from the rest and returns both , serves as
% a helper for m_transpose/2 goal
%

l_split_firsts([], [], []).
l_split_firsts([[F|Os]|Rest], [F|Fs], [Os|Oss]) :- l_split_firsts(Rest, Fs, Oss).



%% PROTOTYPES
%% DISABLE WARNINGS
:-style_check(-singleton).
%%
m_inversion_print([]) 		:- write('false\n').
m_inversion_print([H|T]) 	:- write('false\n').
m_cholesky_print([]) 		:- write('false\n').
m_cholesky_print([H|T]) 	:- write('false\n').
m_determinant_print([]) 	:- write('false\n').
m_determinant_print([H|T]) 	:- write('false\n').
m_rank_print([]) 			:- write('false\n').
m_rank_print([H|T]) 		:- write('false\n').



%% All predicate & goals writen under this line are unfinished concepts I have
%% created whilst working on this project. They are most likely unused, but
%% were definitively intended to be used.
checkAddDimensions([H1|T1],[H2|T2]) :- checkAddDimensions2(H1,H2), checkAddDimensions(T1,T2).
checkAddDimensions2([], [_|_]) :- !, fail.
checkAddDimensions2([_|_], []) :- !, fail.  
checkAddDimensions2([], []).