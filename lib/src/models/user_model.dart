sealed class UserModel {
  final int id;
  final String name;
  final String email;
  final String? avatar;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return switch (map['profile']) {
      'ADM' => UserModelADM.fromMap(map),
      'EMPLOYEE' => UserModelEmployee.fromMap(map),
      _ => throw ArgumentError('User profile not found')
    };
  }
}

class UserModelADM extends UserModel {
  final List<String>? workDays;
  final List<int>? workHours;

  UserModelADM({
    required super.id,
    required super.name,
    required super.email,
    this.workDays,
    this.workHours,
    super.avatar,
  });

  factory UserModelADM.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {
        'id': final int id,
        'name': final String name,
        'email': final String email,
      } =>
        UserModelADM(
          id: id,
          name: name,
          email: email,
          avatar: map['avatar'],
          workDays: map['work_days']?.cast<String>(),
          workHours: map['work_hours']?.cast<int>(),
        ),
      _ => throw ArgumentError('Invalid Map'),
    };
  }
}

class UserModelEmployee extends UserModel {
  final int barbershopId;
  final List<String> workDays;
  final List<int> workHours;

  UserModelEmployee({
    required super.id,
    required super.name,
    required super.email,
    required this.barbershopId,
    required this.workDays,
    required this.workHours,
    super.avatar,
  });

  factory UserModelEmployee.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {
        'id': final int id,
        'name': final String name,
        'email': final String email,
        'barbershop_id': final int barbershopId,
        'work_days': final List workDays,
        'work_hours': final List workHours,
      } =>
        UserModelEmployee(
          id: id,
          name: name,
          email: email,
          avatar: map['avatar'],
          barbershopId: barbershopId,
          workDays: workDays.cast<String>(),
          workHours: workHours.cast<int>(),
        ),
      _ => throw ArgumentError('Invalid Map'),
    };
  }
}
