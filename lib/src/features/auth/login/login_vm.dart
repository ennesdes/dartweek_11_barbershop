import 'package:asyncstate/asyncstate.dart';
import 'package:project_barbershop_dartweek/src/core/exceptions/service_exception.dart';
import 'package:project_barbershop_dartweek/src/core/fp/either.dart';
import 'package:project_barbershop_dartweek/src/core/providers/application_providers.dart';
import 'package:project_barbershop_dartweek/src/features/auth/login/login_state.dart';
import 'package:project_barbershop_dartweek/src/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_vm.g.dart';

@riverpod
class LoginVm extends _$LoginVm {
  @override
  LoginState build() => LoginState.initial();

  Future<void> login(String email, String password) async {
    final loaderHandle = AsyncLoaderHandler()..start();
    final loginService = ref.watch(userLoginServiceProvider);
    final result = await loginService.execute(email, password);

    switch (result) {
      case Success():
        // limpando cache, para evitar login errado
        ref.invalidate(getMeProvider);
        ref.invalidate(getMyBarbershopProvider);

        final userModel = await ref.read(getMeProvider.future);

        switch (userModel) {
          case UserModelADM():
            state = state.copyWith(status: LoginStateStatus.admLogin);
          case UserModelEmployee():
            state = state.copyWith(status: LoginStateStatus.employeeLogin);
        }
        break;
      case Failure(exception: ServiceException(:final message)):
        state = state.copyWith(
          status: LoginStateStatus.error,
          errorMessage: () => message,
        );
    }

    loaderHandle.close();
  }
}
