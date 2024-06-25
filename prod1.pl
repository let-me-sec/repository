:- dynamic xpositive/2, xnegative/2.

/* Система пользовательского интерфейса */
do_expert_job:-
      do_consulting,
      halt.

do_consulting:-
      os_is(X),!,
      format("Рекомендуемая Операционная Система : ~a.~n",[X]),
      clear.

do_consulting:-
      write("Информация об интересующей Вас Операционной Системе отсутствует в БЗ."),nl,
      clear.

ask(X,Y):-
      format("Вопрос : ~a ~a?~n",[X,Y]),
      write("1 - да,"),nl,
      write("2 - нет"),nl,
      readloop(Reply),
      remember(X,Y,Reply).

/* Проверка корректности ввода */
readloop(Response):-
      %read(Response),
      read_string(user_input, "\n", "\r",_,Str),
      atom_number(Str, Response),
      legal_response(Response),!.

      legal_response(Response):-Response=1.
      legal_response(Response):-Response=2.

/* Механизм вывода экспертного заключения */
positive(X,Y):-
      xpositive(X,Y),!.

positive(X,Y):-
      not(getnegative(X,Y)),!,ask(X,Y).

getpositive(X,Y):-
       xpositive(X,Y),!.

getnegative(X,Y):-
      xnegative(X,Y),!.

negative(X,Y):-
      xnegative(X,Y),!.
negative(X,Y):-
       not(getpositive(X,Y)),!,not(ask(X,Y)).

remember(X,Y,1):-!,
      assertz(xpositive(X,Y)).

remember(X,Y,2):-!,
      assertz(xnegative(X,Y)),fail.

/* Продукционные правила */
os_is("Windows"):-
      it_is("Десктопная"),
      positive("Имеет", "закрытый исходный код"),
      positive("Устанавливается на","любые устройства"),
      positive("Относится к семейству", "Windows NT систем"),!.

os_is("Linux"):-
      it_is("Десктопная"),
      positive("Имеет", "открытый исходный код"),
      positive("Устанавливается на", "любые устройства"),
      positive("Относится к семейству", "UNIX систем"),!.

os_is("React OS"):-
      it_is("Десктопная"),
      positive("Имеет", "открытый исходный код"),
      positive("Устанавливается на", "любые устройства"),
      positive("Относится к семейству", "Windows NT систем"),!.

os_is("macOS"):-
      it_is("Десктопная"),
      positive("Имеет", "закрытый исходный код"),
      positive("Устанавливается на", "только фирменные устройства"),
      positive("Относится к семейству", "UNIX систем"),!.

os_is("Solaris OS"):-
      it_is("Десктопная"),
      positive("Имеет", "закрытый исходный код"),
      positive("Устанавливается на", "любые устройства"),
      positive("Относится к семейству", "UNIX систем"),!.

os_is("MS-DOS"):-
      it_is("Десктопная"),
      positive("Имеет", "закрытый исходный код"),
      positive("Устанавливается на", "любые устройства"),
      positive("Относится к семейству", "DOS систем"),!.

os_is("freeDOS"):-
      it_is("Десктопная"),
      positive("Имеет", "открытый исходный код"),
      positive("Устанавливается на", "любые устройства"),
      positive("Относится к семейству", "DOS систем"),!.

os_is("OS/2"):-
      it_is("Десктопная"),
      positive("Имеет", "закрытый исходный код"),
      positive("Устанавливается на", "только фирменные устройства"),
      positive("Относится к семейству", "OS/2 систем"),!.

os_is("osFree"):-
      it_is("Десктопная"),
      positive("Имеет", "открытый исходный код"),
      positive("Устанавливается на", "любые устройства"),
      positive("Относится к семейству", "OS/2 систем"),!.

os_is("iOS"):-
      it_is("Мобильная"),
      positive("Имеет", "закрытый исходный код"),
      positive("Устанавливается на", "только фирменные устройства"),!.

os_is("Android"):-
      it_is("Мобильная"),
      positive("Имеет", "открытый исходный код"),!.

os_is("Windows Phone"):-
      it_is("Мобильная"),
      positive("Имеет", "закрытый исходный код"),
      positive("Относится к семейству", "Windows NT систем"),!.

it_is("Десктопная"):-
      positive("Используется на", "десктопных устройствах"),!.

it_is("Мобильная"):-
      positive("Используется на", "мобильных устройствах"),!.

/* Уничтожение в базе данных всех ответов yes (да) и no (нет) */
   clear:-retract(xpositive(_,_)),retract(xnegative(_,_)),fail,!.
   clear.

:- do_expert_job.
