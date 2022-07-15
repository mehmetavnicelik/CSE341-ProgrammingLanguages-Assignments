:-dynamic(room/3).
:-dynamic(instructor/2).
:-dynamic(courseEquipment/2).
:-dynamic(course/4).
:-dynamic(roomEquipment/2).
:-dynamic(student/3).

addRoom :- 
	write('Enter a room name: '),
	read(RoomName),
	write('Enter the capacity: '),
	read(Capacity),
	write('When is it Occupied: '),
	read(Time),
	write('What course will be there? '),
	read(CourseName),
	assertz(room(RoomName,Capacity,occupied(Time,CourseName))).

addInsructor :-
	write('Enter an instructor name: '),
	read(InstructorName),
	write('Enter a course for instructor:'),
	read(GivenClass),
	assertz(instructor(InstructorName,GivenClass)).

addCourseEquipment :-
	write('Enter an course name: '),
	read(CourseName),
	write('Enter an equipment for the class:'),
	read(Equipment_for_class),
	assertz(courseEquipment(CourseName,Equipment_for_class)).

addCourse :-
	write('Enter a course name: '),
	read(CourseName),
	write('Enter the capacity: '),
	read(Capacity),
	write('When does it start: '),
	read(Time),
	write('What room will be used? '),
	read(RoomName),
	assertz(course(CourseName,Capacity,Time,RoomName)).

addRoomEquipment :-
	write('Enter the room for equipment: '),
	read(Room),
	write('Enter a new room equipment: '),
	read(RoomEquipment),
	assertz(roomEquipment(Room,RoomEquipment)).

addStudent :-
	write('Enter a student ID: '),
	read(StudentID),
	write('Assign the student to a course: '),
	read(Course),
	write('Is he handicapped? (Write handicapped or nonhandicapped): '),
	read(IsHandicapped),
	assertz(student(StudentID,[Course],IsHandicapped)).


room(room1,30,occupied(8,cse1)).
room(room1,30,occupied(8,cse2)).
room(room2,30,occupied(8,cse3)).
room(room2,60,occupied(8,cse4)).
room(room3,60,occupied(8,cse5)).
room(room4,60,occupied(10,cse6)).
room(room5,60,occupied(11,cse6)).
room(room6,60,occupied(12,cse6)).

instructor(yakup,cse1).
instructor(yakup,cse2).
instructor(erdogan,cse3).
instructor(erkan,cse4).
instructor(yusuf,cse5).
instructor(erchan,cse6).

courseEquipment(cse1,projector).
courseEquipment(cse2,projector).
courseEquipment(cse3,smartBoard).
courseEquipment(cse4,smartBoard).
courseEquipment(cse5,handicappedAccess).
courseEquipment(cse6,projector).

course(cse1,30,8,room1).
course(cse2,30,9,room1).
course(cse3,30,8,room2).
course(cse4,60,9,room4).
course(cse5,60,9,room5).
course(cse6,60,9,room6).

roomEquipment(room1,projector).
roomEquipment(room1,nonhandicapped).
roomEquipment(room2,handicapped).
roomEquipment(room2,nonhandicapped).
roomEquipment(room3,smartBoard).
roomEquipment(room3,nonhandicapped).
roomEquipment(room4,smartBoard).
roomEquipment(room4,nonhandicapped).
roomEquipment(room5,handicapped).
roomEquipment(room5,nonhandicapped).
roomEquipment(room6,projector).
roomEquipment(room6,nonhandicapped).

student(student1,[cse1,cse2],handicapped).
student(student2,[cse1,cse2],nonhandicapped).


schedulingConflict :- 
	room(R,_,occupied(T,C)),
	room(R1,_,occupied(T1,C1)),
	R == R1,
	T == T1,
	\+(C=C1),
	write(R).

canBeAssign2Class(Course) :-
	courseEquipment(Course,X),
	roomEquipment(R,Y),
	X==Y,
	write(Course),
	write(' course can be assigned to '),
	write(R).

canBeAssign2Class :-
	roomEquipment(Room,RoomEquipment),
	courseEquipment(Course,CourseEquipment),
	RoomEquipment==CourseEquipment,
	write(Room),
	write(' can have the '),
	write(Course),
	write(' classes.').

studentEnrollingCheck(Student,Course) :-
	student(Student,_,IsHandicapped),
	course(Course,_,_,Room),
	roomEquipment(Room,HandicappedAccess),
	IsHandicapped==HandicappedAccess,
	write(Student),
	write(' can be enrolled to '),
	write(Course).

studentEnrollingCheck(Student) :-
	student(Student,_,IsHandicapped),
	course(Course,_,_,Room),
	roomEquipment(Room,HandicappedAccess),
	IsHandicapped==HandicappedAccess,
	write(Student),
	write(' can be enrolled to '),
	write(Course).
