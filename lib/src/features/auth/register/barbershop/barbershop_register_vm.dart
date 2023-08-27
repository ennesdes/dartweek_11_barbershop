import 'package:project_barbershop_dartweek/src/core/fp/either.dart';
import 'package:project_barbershop_dartweek/src/core/providers/application_providers.dart';
import 'package:project_barbershop_dartweek/src/features/auth/register/barbershop/barbershop_register_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'barbershop_register_vm.g.dart';

@riverpod
class BarbershopRegisterVm extends _$BarbershopRegisterVm {
  @override
  BarbershopRegisterState build() => BarbershopRegisterState.initial();

  void addOrRemoveOpenDay(String weekDay) {
    final openingDays = state.openingDays;

    if (openingDays.contains(weekDay)) {
      openingDays.remove(weekDay);
    } else {
      openingDays.add(weekDay);
    }

    state = state.copyWith(openingDays: openingDays);
  }

  void addOrRemoveOpenHours(int hour) {
    final openingHours = state.openingHours;

    if (openingHours.contains(hour)) {
      openingHours.remove(hour);
    } else {
      openingHours.add(hour);
    }

    state = state.copyWith(openingHours: openingHours);
  }

  Future<void> register(String name, String email) async {
    final repository = ref.watch(barbershopRepositoryProvider);
    // usando destructor
    final BarbershopRegisterState(:openingDays, :openingHours) = state;

    final dto = (
      name: name,
      email: email,
      openingDays: openingDays,
      openingHours: openingHours,
    );

    final resultRegister = await repository.save(dto);

    switch (resultRegister) {
      case Success():
        ref.invalidate(getMyBarbershopProvider);
        state = state.copyWith(status: BarbershopRegisterStateStatus.success);
      case Failure():
        state = state.copyWith(status: BarbershopRegisterStateStatus.error);
    }
  }
}
