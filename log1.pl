:- dynamic yes/1, no/1.
/* База знаний. */

/* Размещение в резидентной БД информации из утверждений БЗ ЭС */
     assert_database:-
           rule(Rule_number,Category,Type_of_breed,Conditions),
           assertz(d_rule(Rule_number,Category,Type_of_breed,Conditions)),fail.

     assert_database:-
           cond(Cond_number,Condition),
           assertz(d_cond(Cond_number,Condition)),fail.

     assert_database:-!.

/* Условия-характеристики различных ОС.*/
      cond(1,"десктопная ОС").
      cond(2,"мобильная ОС").
      cond(3,"закрытый исходный код").
      cond(4,"открытый исходный код").
      cond(5,"любые устройства").
      cond(6,"фирменные устройства").
      cond(7, "UNIX семейство").
      cond(8, "Windows NT семейство").
      cond(9, "DOS семейство").
      cond(10, "OS/2 семейство").

/* Данные о типах ОС */
   topic("десктопная").
   topic("мобильная").
   
/* Данные о конкретных ОС */
      rule(1,"ОС","десктопная",[1]).
      rule(2,"ОС","мобильная",[2]).
      rule(3,"десктопная","Windows",[3,5,8]).
      rule(4,"десктопная","Linux",[4,5,7]).
      rule(5,"десктопная","macOS",[3,6,7]).
      rule(6,"десктопная","SolarisOS",[3,5,7]).
      rule(7,"десктопная","ReactOS",[4,5,8]).
      rule(8,"десктопная","MS-DOS",[3,5,9]).
      rule(9,"десктопная","freeDOS",[4,5,9]).
      rule(10,"десктопная","OS/2",[3,6,10]).
      rule(11,"десктопная","osFree",[4,5,10]).
      rule(12,"мобильная","iOS",[3,6]).
      rule(13,"мобильная","Android",[4]).
      rule(14,"мобильная","WindowsPhone",[3,8]).
   
/* Система пользовательского интерфейса */
main:-
   assert_database,
   do_expert_job.

do_expert_job:-
    do_consulting,
    halt.

do_consulting:-
   go([],"ОС"),!.

do_consulting:-
   write("Информация об интересующей вас Операционной Системе отсутствует в БЗ."), nl,
   clear.

/* Выдача подсказки */
info:-
   write("База знаний содержит информацию о категориях Операционных Систем:"), nl,
   topic(X), format('\t~w~n',[X]).

/* Запрос и получение ответов yes и no от пользователя */
ask_question(Breed_cond,Text):-
   format("Вопрос : ~a?~n",[Text]),
   write("1 - да,"),nl,
   write("2 - нет"),nl,
   readloop(Response),
   do_answer(Breed_cond,Response).

/* Проверка корректности ввода */
readloop(Response):-
   %read(Response),
   read_string(user_input, "\n", "\r",_,Str),
   atom_number(Str, Response),
   legal_response(Response),!.

legal_response(Response):-Response=1.
legal_response(Response):-Response=2.

/* Предикаты ЕЯ-интерфейса */
/* Принадлежность элемента списку */
member(Head,[Head|_]):-!.
member(Elem,[_|T]):-
     member(Elem,T).

/* Механизм вывода */

/* Начальное правило механизма вывода */
go(_,Mygoal):-
   not(rule(_,Mygoal,_,_)),!,
   format("Рекомендуемая Операционная Система: ~a.~n",[Mygoal]).

go(History,Mygoal):-
   rule(Rule_number,Mygoal,Type_of_breed,Conditions),
   check(Rule_number,History,Conditions),
   go([Rule_number|History],Type_of_breed).

/* Сопоставление входных данных пользователя со списками атрибутов
отдельных языков программирования */
check(Rule_number,History,[Breed_cond|Rest_breed_cond_list]):-
   yes(Breed_cond),!,
   check(Rule_number,History,Rest_breed_cond_list).

check(_,_,[Breed_cond|_]):-
   no(Breed_cond),!,fail.

check(Rule_number,History,[Breed_cond|Rest_breed_cond_list]):-
   cond(Breed_cond,Text),
   ask_question(Breed_cond,Text),
   check(Rule_number,History,Rest_breed_cond_list).

check(_,_,[]).

do_answer(Cond_number,1):-!,
   assertz(yes(Cond_number)).

do_answer(Cond_number,2):-!,
   assertz(no(Cond_number)),fail.
   
/* Исключение данных из базы знаний после завершения цикла "Распознавание-действие" */
erase:-retract(_),fail.
erase.

/* Уничтожение в базе данных всех ответов yes (да) и no (нет) */
clear:-retract(yes(_)),retract(no(_)),retract(goes(_,_)),fail,!.
clear.

:- main.