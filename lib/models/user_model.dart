class UserModel {
  final String name;
  final String registrationNumber;
  final String password;

  UserModel({
    required this.name,
    required this.registrationNumber,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'registrationNumber': registrationNumber,
      'password': password,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      registrationNumber: map['registrationNumber'],
      password: map['password'],
    );
  }
}
