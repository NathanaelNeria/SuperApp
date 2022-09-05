import 'package:firebase_database/firebase_database.dart';

class Todo {
  String? key;
  String? subject;
  bool? completed;
  String? userId;

  Todo(this.subject, this.userId, this.completed);

  Todo.fromSnapshot(DataSnapshot snapshot) :
    key = snapshot.key,
    userId = (snapshot.value as Map)['userId'].toString(),
    subject = (snapshot.value as Map)['subject'].toString(),
    completed = (snapshot.value as Map)['completed'];

  toJson() {
    return {
      "userId": userId,
      "subject": subject,
      "completed": completed,
    };
  }
}