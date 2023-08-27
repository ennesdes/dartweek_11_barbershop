import 'package:project_barbershop_dartweek/src/core/exceptions/service_exception.dart';
import 'package:project_barbershop_dartweek/src/core/fp/either.dart';
import 'package:project_barbershop_dartweek/src/core/fp/nil.dart';

abstract interface class UserLoginService {
  Future<Either<ServiceException, Nil>> execute(
    String email,
    String password,
  );
}
