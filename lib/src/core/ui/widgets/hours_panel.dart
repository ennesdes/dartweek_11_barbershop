// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:project_barbershop_dartweek/src/core/ui/constants.dart';

class HoursPanel extends StatefulWidget {
  final int startTime;
  final int endTime;
  final ValueChanged<int> onHourPressed;
  final List<int>? enabledTimes;
  final bool singleSelection;

  const HoursPanel({
    Key? key,
    required this.startTime,
    required this.endTime,
    required this.onHourPressed,
    this.enabledTimes,
  })  : singleSelection = false,
        super(key: key);

  const HoursPanel.singleSelection({
    Key? key,
    required this.startTime,
    required this.endTime,
    required this.onHourPressed,
    this.enabledTimes,
  })  : singleSelection = true,
        super(key: key);

  @override
  State<HoursPanel> createState() => _HoursPanelState();
}

class _HoursPanelState extends State<HoursPanel> {
  int? lastSelection;

  @override
  Widget build(BuildContext context) {
    final HoursPanel(:singleSelection) = widget;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecione os horários de atendimento',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 16,
          children: [
            for (int i = widget.startTime; i <= widget.endTime; i++)
              TimeButton(
                singleSelection: singleSelection,
                timeSelected: lastSelection,
                value: i,
                enabledTimes: widget.enabledTimes,
                label: '${i.toString().padLeft(2, '0')}:00',
                onPressed: (timeSelected) {
                  setState(() {
                    if (singleSelection) {
                      if (lastSelection == timeSelected) {
                        lastSelection = null;
                      } else {
                        lastSelection = timeSelected;
                      }
                    }
                  });

                  widget.onHourPressed(timeSelected);
                },
              ),
          ],
        ),
      ],
    );
  }
}

class TimeButton extends StatefulWidget {
  final bool singleSelection;
  final int value;
  final int? timeSelected;
  final List<int>? enabledTimes;
  final String label;
  final ValueChanged<int> onPressed;

  const TimeButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.singleSelection,
    required this.timeSelected,
    required this.value,
    this.enabledTimes,
  }) : super(key: key);

  @override
  State<TimeButton> createState() => _TimeButtonState();
}

class _TimeButtonState extends State<TimeButton> {
  var selected = false;

  @override
  Widget build(BuildContext context) {
    final TimeButton(
      :value,
      :label,
      :enabledTimes,
      :singleSelection,
      :timeSelected,
    ) = widget;

    if (singleSelection) {
      if (timeSelected != null) {
        if (timeSelected == value) {
          selected = true;
        } else {
          selected = false;
        }
      }
    }

    final textColor = selected ? Colors.white : ColorsConstants.grey;
    var buttonColor = selected ? ColorsConstants.brow : Colors.white;
    final buttonBorderColor =
        selected ? ColorsConstants.brow : ColorsConstants.grey;

    final disableTime = enabledTimes != null && !enabledTimes.contains(value);

    if (disableTime) {
      buttonColor = Colors.grey[400]!;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: disableTime
          ? null
          : () {
              setState(() => selected = !selected);
              widget.onPressed(value);
            },
      child: Container(
        width: 64,
        height: 36,
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
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
