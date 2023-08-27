import 'package:project_barbershop_dartweek/src/core/exceptions/auth_exception.dart';
import 'package:project_barbershop_dartweek/src/core/exceptions/repository_exception.dart';
import 'package:project_barbershop_dartweek/src/core/fp/either.dart';
import 'package:project_barbershop_dartweek/src/core/fp/nil.dart';
import 'package:project_barbershop_dartweek/src/models/user_model.dart';

abstract interface class UserRepository {
  Future<Either<AuthException, String>> login(String email, String password);

  Future<Either<RepositoryException, UserModel>> me();

  Future<Either<RepositoryException, Nil>> registerAdmin(
    ({
      String name,
      String email,
      String password,
    }) userData,
  );

  Future<Either<RepositoryException, List<UserModel>>> getEmployees(
      int barbershopId);

  Future<Either<RepositoryException, Nil>> registerAdmAsEmployee(
    ({
      List<String> workDays,
      List<int> workHours,
    }) userModel,
  );

  Future<Either<RepositoryException, Nil>> registerEmployee(
    ({
      int barbershopId,
      String name,
      String email,
      String password,
      List<String> workDays,
      List<int> workHours,
    }) userModel,
  );
}
