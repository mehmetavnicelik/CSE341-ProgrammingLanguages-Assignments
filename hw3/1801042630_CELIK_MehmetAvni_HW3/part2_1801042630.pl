%knowledge
flight(canakkale,erzincan,6).
flight(erzincan,antalya,3).
flight(antalya,izmir,2).
flight(antalya,diyarbakir,4).
flight(izmir,ankara,6).
flight(izmir,istanbul,2).
flight(istanbul,rize,4).
flight(istanbul,ankara,1).
flight(rize,ankara,5).
flight(van,ankara,4).
flight(diyarbakir,ankara,8).
flight(van,gaziantep,3).

flight(erzincan,canakkale,6).
flight(antalya,erzincan,3).
flight(izmir,antalya,2).
flight(diyarbakir,antalya,4).
flight(ankara,izmir,6).
flight(istanbul,izmir,2).
flight(rize,istanbul,4).
flight(ankara,istanbul,1).
flight(ankara,rize,5).
flight(ankara,van,4).
flight(ankara,diyarbakir,8).
flight(gaziantep,van,3).
%rules


route(Start,End,C):-
	flight(Start,End,C).

route(Start,End,C):-
	flight(Start,Temp,C1),
	route(Temp,End,C2),
	C is C1+C2.
