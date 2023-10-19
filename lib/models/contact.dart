class SmartContact {
  String name;
  String email;

  SmartContact({required this.name, required this.email});

  factory SmartContact.fromJson(Map<String, dynamic> json) {
    return SmartContact(
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }
}