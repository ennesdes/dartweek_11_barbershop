import 'package:asyncstate/asyncstate.dart';
import 'package:project_barbershop_dartweek/src/core/fp/either.dart';
import 'package:project_barbershop_dartweek/src/core/providers/application_providers.dart';
import 'package:project_barbershop_dartweek/src/features/schedules/schedule_state.dart';
import 'package:project_barbershop_dartweek/src/models/barbershop_model.dart';
import 'package:project_barbershop_dartweek/src/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'schedule_vm.g.dart';

@riverpod
class ScheduleVm extends _$ScheduleVm {
  @override
  ScheduleState build() => ScheduleState.initial();

  void hourSelect(int hour) {
    if (hour == state.scheduleHour) {
      state = state.copyWith(
        scheduleHour: () => null,
      );
    } else {
      state = state.copyWith(
        scheduleHour: () => hour,
      );
    }
  }

  void dateSelect(DateTime date) {
    state = state.copyWith(scheduleDate: () => date);
  }

  Future<void> register({
    required UserModel userModel,
    required String clientName,
  }) async {
    final asyncLoaderHandler = AsyncLoaderHandler()..start();

    final ScheduleState(:scheduleDate, :scheduleHour) = state;
    final scheduleRepository = ref.read(scheduleRepositoryProvider);
    final BarbershopModel(id: barbershopId) = await ref.watch(
      getMyBarbershopProvider.future,
    );

    final dto = (
      barbershopId: barbershopId,
      clientName: clientName,
      date: scheduleDate!,
      time: scheduleHour!,
      userId: userModel.id,
    );

    final scheduleResult = await scheduleRepository.scheduleClient(dto);

    switch (scheduleResult) {
      case Success():
        state = state.copyWith(status: ScheduleStateStatus.success);
      case Failure():
        state = state.copyWith(status: ScheduleStateStatus.error);
    }

    asyncLoaderHandler.close();
  }
}
