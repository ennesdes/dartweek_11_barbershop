import 'package:project_barbershop_dartweek/src/core/providers/application_providers.dart';
import 'package:project_barbershop_dartweek/src/services/user_register/user_register_adm_service.dart';
import 'package:project_barbershop_dartweek/src/services/user_register/user_register_adm_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_register_providers.g.dart';

@riverpod
UserRegisterAdmService userRegisterAdmService(UserRegisterAdmServiceRef ref) =>
    UserRegisterAdmServiceImpl(
      userRepository: ref.watch(userRepositoryProvider),
      userLoginService: ref.watch(userLoginServiceProvider),
    );
