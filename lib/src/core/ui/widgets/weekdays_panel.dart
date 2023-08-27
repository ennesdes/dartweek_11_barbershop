// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:project_barbershop_dartweek/src/core/ui/constants.dart';

class WeekdaysPanel extends StatelessWidget {
  final ValueChanged<String> onDayPressed;
  final List<String>? enabledDays;

  const WeekdaysPanel({
    Key? key,
    required this.onDayPressed,
    this.enabledDays,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecione os dias da semana',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonDay(
                  label: 'Seg',
                  onDaySelected: onDayPressed,
                  enabledDays: enabledDays,
                ),
                ButtonDay(
                  label: 'Ter',
                  onDaySelected: onDayPressed,
                  enabledDays: enabledDays,
                ),
                ButtonDay(
                  label: 'Qua',
                  onDaySelected: onDayPressed,
                  enabledDays: enabledDays,
                ),
                ButtonDay(
                  label: 'Qui',
                  onDaySelected: onDayPressed,
                  enabledDays: enabledDays,
                ),
                ButtonDay(
                  label: 'Sex',
                  onDaySelected: onDayPressed,
                  enabledDays: enabledDays,
                ),
                ButtonDay(
                  label: 'Sab',
                  onDaySelected: onDayPressed,
                  enabledDays: enabledDays,
                ),
                ButtonDay(
                  label: 'Dom',
                  onDaySelected: onDayPressed,
                  enabledDays: enabledDays,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonDay extends StatefulWidget {
  final String label;
  final ValueChanged<String> onDaySelected;
  final List<String>? enabledDays;

  const ButtonDay({
    Key? key,
    required this.label,
    required this.onDaySelected,
    this.enabledDays,
  }) : super(key: key);

  @override
  State<ButtonDay> createState() => _ButtonDayState();
}

class _ButtonDayState extends State<ButtonDay> {
  var selected = false;

  @override
  Widget build(BuildContext context) {
    final textColor = selected ? Colors.white : ColorsConstants.grey;
    var buttonColor = selected ? ColorsConstants.brow : Colors.white;
    final buttonBorderColor =
        selected ? ColorsConstants.brow : ColorsConstants.grey;

    final ButtonDay(:enabledDays, :label) = widget;
    final disableDay = enabledDays != null && !enabledDays.contains(label);

    if (disableDay) {
      buttonColor = Colors.grey[400]!;
    }

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: disableDay
            ? null
            : () {
                setState(() => selected = !selected);
                widget.onDaySelected(label);
              },
        child: Container(
          width: 40,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: buttonColor,
            border: Border.all(
              color: buttonBorderColor,
            ),
          ),
          child: Center(
              child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          )),
        ),
      ),
    );
  }
}
