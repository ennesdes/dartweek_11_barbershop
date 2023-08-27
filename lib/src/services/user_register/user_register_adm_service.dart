import 'package:project_barbershop_dartweek/src/core/exceptions/service_exception.dart';
import 'package:project_barbershop_dartweek/src/core/fp/either.dart';
import 'package:project_barbershop_dartweek/src/core/fp/nil.dart';

abstract interface class UserRegisterAdmService {
  Future<Either<ServiceException, Nil>> execute(
    ({String name, String email, String password}) userData,
  );
}
