import 'package:flutter/services.dart';

class StudentModel {
  StudentModel({
    this.id,
    this.name,
    this.age,
    this.address,
    this.major,
    this.phone,
    this.photo,
  });

  StudentModel.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    age = json['age'];
    address = json['address'];
    major = json['major'];
    phone = json['phone'];
    photo = json['photo'];
  }
  int? id;
  String? name;
  int? age;
  String? address;
  String? major;
  String? phone;
  Uint8List? photo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['age'] = age;
    map['address'] = address;
    map['major'] = major;
    map['phone'] = phone;
    map['photo'] = photo;
    return map;
  }
}
