class Court {
  int id;
  String name;

  Court({
    required this.id,
    required this.name,
  });

  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
      id: json['id'],
      name: json['name'],
    );
  }
}
