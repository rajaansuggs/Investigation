puzzle(Table):-
Table = [
['May', Dip1, Dur1, Cap1],
['June', Dip2, Dur2, Cap2],
['July', Dip3, Dur3, Cap3],
['August', Dip4, Dur4, Cap4],
['September', Dip5, Dur5, Cap5]
],

permutation([Dip1, Dip2, Dip3, Dip4, Dip5], ['Fitzgerald', 'Howell', 'Nguyen', 'Owens', 'Vasquez']),
permutation([Dur1, Dur2, Dur3, Dur4, Dur5], ['10', '2', '3', '6', '9']),
rule11(Table),
rule2(Table),
   permutation([Cap1, Cap2, Cap3, Cap4, Cap5], ['Athens', 'Brussels', 'Helsinki', 'Kiev', 'Paris']),
rule1(Table),
rule3(Table),
rule4(Table),
rule5(Table),
rule6(Table),
rule8(Table),
rule7(Table),
rule9(Table),
rule10(Table).

print_puzzle(X):- puzzle(X), 
    foreach(member(Row, X), writeln(Row)).
%In rule one, of the ambassador with the 2 day visit and the person going to Kiev, one is Mr. Fitzgerald and the other will leave in June..
rule1(Table):-foreach(member([M,DI,DU,C], Table), r1helper( M, DI, DU, C )).
	r1helper('June', DI, '2', C ):- DI\='Fitzgerald', C\='Kiev'.
	r1helper('June', DI, DU, 'Kiev' ):- DI\='Fitzgerald', DU\='2'.
	r1helper(M, 'Fitzgerald', DU, 'Kiev' ):- DU\='2', M\='June'.
	r1helper(M, 'Fitzgerald', '2',  C):- M\= 'June', C\='Kiev'.
	r1helper(M, DI, DU,  C):- M\= 'June', C\='Kiev', DI\='Fitzgerald', DU\='2'.

%In rule two, The person leaving in July will leave for the 2 day visit..
rule2(Table):-foreach(member([M,_,DU,_], Table), r2helper(M,DU)).
	r2helper(M,DU):- DU='2', M='July' ; DU\='2', M\='July'.

pair([H| T], Row1, Row2) :- Row1 = H, member(Row2, T).
pair([_| T], Row1, Row2) :- pair(T, Row1, Row2).

%In rule three, The ambassador with the 3 day visit will leave 1 month after the ambassador with the 9 day visit..
rule3(Table) :- 
    foreach(pair(Table, [D1, _, C1, _], [D2, _, C2, _]), 
            (rule3helper(D1, D2, C1, C2))). 
	rule3helper(_, _, '9', '3').
	rule3helper(_, _, '3', C2) :- C2 \= '9'. 
	rule3helper(_, _, C1, '9') :- C1 \= '3'. 
	rule3helper(_, _, C1, C2) :- C1 \= '3', C2 \= '9'.

%In rule four, The diplomat going to Helsinki will leave for the 10 day visit..
rule4(Table):-foreach(member([_,_,DU,C], Table), r4helper(DU,C)).
	r4helper( DU, C):- DU='10', C='Helsinki' ; DU\='10', C\='Helsinki'.

%In rule five, The ambassador with the 2 day visit will leave sometime after the ambassador with the 3 day visit..
rule5(Table) :- 
    foreach(pair(Table, [D1, _, C1, _], [D2, _, C2, _]), 
            (rule5helper(D1, D2, C1, C2))).
	rule5helper(_, _, '3', '2').
	rule5helper(_, _, '2', C2) :- C2 \= '3'. 
	rule5helper(_, _, C1, '3') :- C1 \= '2'. 
	rule5helper(_, _, C1, C2) :- C1 \= '2', C2 \= '3'.

%In rule six, The person leaving in September wont go to Helsinki..
rule6(Table):-foreach(member([M,_,_,C], Table), r6helper(M,C)).
	r6helper(M,'Helsinki'):- M\='September'.
	r6helper('September',C):- C\='Helsinki'.
	r6helper(M,C):- M\='September', C\='Helsinki'. 

%In rule seven, Howell is either the person leaving in August or the person leaving in September..
rule7(Table):-foreach(member([M,DI,_,_], Table), r7helper( M, DI )).
	r7helper(M,DI):- DI='Howell', M\='May', M\='June', M\='July';DI\='Howell'.

%In rule eight, The person leaving in May, Nguyen, Fitzgerald and the person going to Brussels are all different diplomats..
rule8(Table):-foreach(member([M, DI, _, C], Table), r8helper(M,DI,C)).
	r8helper('May',DI,C):- DI\='Nguyen', DI\='Fitzgerald', C\='Brussels'.
	r8helper(M,'Fitzgerald',C):- M\='May', C\='Brussels'.
	r8helper(M,'Nguyen',C):- M\='May', C\='Brussels'.
	r8helper(M,DI,'Brussels'):- DI\='Nguyen', DI\='Fitzgerald', M\='May'.
	r8helper(M,DI,C):-DI\='Nguyen', DI\='Fitzgerald', C\='Brussels',M\='May'.

%In rule nine, Owens wont go to Athens..
rule9(Table):-foreach(member([_,DI,_,C], Table), r9helper(DI,C)).
	r9helper('Owens', C):- C\='Athens'.
	r9helper(DI, 'Athens'):- DI\='Owens'.
	r9helper(DI,C):- DI\='Owens', C\='Athens'.

%In rule ten, The person going to Kiev will leave 1 month before the person going to Paris..
rule10(Table) :- 
    foreach(pair(Table, [D1, _, _, Cap1], [D2, _, _,Cap2]), 
            (rule10helper(D1, D2, Cap1, Cap2))).
	rule10helper(_, _, 'Kiev', 'Paris').
	rule10helper(_, _, 'Paris', Cap2) :- Cap2 \= 'Kiev'. 
	rule10helper(_, _, Cap1, 'Kiev') :- Cap1 \= 'Paris'. 
	rule10helper(_, _, Cap1, Cap2) :- Cap1 \= 'Paris', Cap2 \= 'Kiev'.

%In rule eleven, Nguyen wont leave for the 3 day visit..
rule11(Table):-foreach(member([_,DI,DU,_], Table), r11helper(DI,DU)).
	r11helper('Nguyen',DU):- DU\='3'.
	r11helper(DI,'3'):- DI\= 'Nguyen'.
	r11helper(DI,DU):- DU\='3',DI\= 'Nguyen'.
%
%							Table
%	|May				|Vasquez			|9					|Athens
%	|June				|Owens				|3					|Kiev
%	|July				|Fitzgerald			|2					|Paris
%	|August				|Nguyen				|10					|Helsinki
%	|Sepetmeber			|Howell				|6					|Brussels
%
%
