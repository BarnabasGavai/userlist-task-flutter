import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// {"id":6129712,"name":"Chakravartee Chaturvedi","email":"chakravartee_chaturvedi@keeling.test","gender":"male","status":"inactive"}

class User {
  int id;
  String name;
  String email;
  String gender;
  String status;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'gender': gender,
      'status': status,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      gender: map['gender'] as String,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
