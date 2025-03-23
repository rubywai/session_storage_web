class StudentModel {
  StudentModel({
    this.id,
    this.name,
    this.age,
    this.address,
    this.major,
    this.phone,
  });

  StudentModel.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    age = json['age'];
    address = json['address'];
    major = json['major'];
    phone = json['phone'];
  }
  int? id;
  String? name;
  int? age;
  String? address;
  String? major;
  String? phone;
  StudentModel copyWith({
    int? id,
    String? name,
    int? age,
    String? address,
    String? major,
    String? phone,
  }) =>
      StudentModel(
        id: id ?? this.id,
        name: name ?? this.name,
        age: age ?? this.age,
        address: address ?? this.address,
        major: major ?? this.major,
        phone: phone ?? this.phone,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['age'] = age;
    map['address'] = address;
    map['major'] = major;
    map['phone'] = phone;
    return map;
  }
}
