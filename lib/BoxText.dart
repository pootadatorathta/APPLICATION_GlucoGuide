class UserEntity {
  final String name;
  final double age;
  final double insulinSensitivity;
  final double carbPerUnit;

  UserEntity(
    this.name,
    this.age,
    this.insulinSensitivity,
    this.carbPerUnit,
  );

  UserEntity.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        age = json['age'].toDouble(),
        insulinSensitivity = json['insulinSensitivity'].toDouble(),
        carbPerUnit = json['carbPerUnit'].toDouble();

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'insulinSensitivity': insulinSensitivity,
        'carbPerUnit': carbPerUnit,
      };

  @override
  String toString() {
    return '$name,$age,$insulinSensitivity,$carbPerUnit';
  }

  static UserEntity fromString(String s) {
    final parts = s.split(',');
    return UserEntity(
      parts[0],
      double.parse(parts[1]),
      double.parse(parts[2]),
      double.parse(parts[3]),
    );
  }
}
