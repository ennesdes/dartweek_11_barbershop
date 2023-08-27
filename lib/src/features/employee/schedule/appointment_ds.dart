import 'package:project_barbershop_dartweek/src/core/ui/constants.dart';
import 'package:project_barbershop_dartweek/src/models/schedule_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentDs extends CalendarDataSource {
  final List<ScheduleModel> schedules;

  AppointmentDs({
    required this.schedules,
  });

  @override
  List? get appointments => schedules.map((e) {
        final ScheduleModel(
          date: DateTime(:year, :month, :day),
          :hour,
          :clientName,
        ) = e;

        final startTime = DateTime(year, month, day, hour, 0, 0);
        final endTime = DateTime(year, month, day, hour + 1, 0, 0);

        return Appointment(
          color: ColorsConstants.brow,
          startTime: startTime,
          endTime: endTime,
          subject: clientName,
        );
      }).toList();
}
