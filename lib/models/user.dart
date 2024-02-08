import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// {"id":6129712,"name":"Chakravartee Chaturvedi","email":"chakravartee_chaturvedi@keeling.test","gender":"male","status":"inactive"}

class User {
  String? id;
  String name;
  String email;
  String gender;
  String? status;
  String? phone;
  String? state;
  String? city;
  String? address;
  String? latitude;
  String? longitude;

  User(
      {this.id,
      required this.name,
      required this.email,
      required this.gender,
      this.status,
      this.address,
      this.city,
      this.latitude,
      this.longitude,
      this.phone,
      this.state});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'gender': gender,
      'status': status,
      'phone': phone,
      'state': state,
      'city': city,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      email: map['email'] as String,
      gender: map['gender'] as String,
      status: map['status'] as String,
      phone: map['phone'] != null ? map['phone'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      latitude: map['latitude'] != null ? map['latitude'] as String : null,
      longitude: map['longitude'] != null ? map['longitude'] as String : null,
    );
  }
}
