import 'package:project_barbershop_dartweek/src/core/exceptions/repository_exception.dart';
import 'package:project_barbershop_dartweek/src/core/fp/either.dart';
import 'package:project_barbershop_dartweek/src/core/fp/nil.dart';
import 'package:project_barbershop_dartweek/src/models/barbershop_model.dart';
import 'package:project_barbershop_dartweek/src/models/user_model.dart';

abstract interface class BarbershopRepository {
  Future<Either<RepositoryException, Nil>> save(
    ({
      String name,
      String email,
      List<String> openingDays,
      List<int> openingHours,
    }) data,
  );

  Future<Either<RepositoryException, BarbershopModel>> getMyBarbershop(
    UserModel userModel,
  );
}
