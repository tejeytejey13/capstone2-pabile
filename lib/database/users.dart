class Users {
  final String? id;
  final String phoneNo;
  final String name;
  final String email;
  final String password;
  final String role;
  final String? status;

  Users({
    this.id,
    required this.phoneNo,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'phoneNo': phoneNo,
        'fullname': name,
        'email': email,
        'password': password,
        'role': role,
        'status': status,
      };

  static Users fromJson(Map<String, dynamic> json) => Users(
        id: json['id'],
        phoneNo: json['phoneNo'],
        name: json['fullname'],
        email: json['email'],
        password: json['password'],
        role: json['role'],
        status: json['status'],
      );
}
