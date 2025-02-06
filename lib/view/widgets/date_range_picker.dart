import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangePicker  extends StatelessWidget {
    const DateRangePicker ({super.key,
    required this.fromDate,
    required this.toDate,
    required this.selectDate,
  });

  final DateTime fromDate;
  final DateTime toDate;
  final Future<void> Function(bool) selectDate;

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () => selectDate(true),
          icon: const Icon(Icons.calendar_today, size: 20),
          label: Text('From: ${dateFormat.format(fromDate)}'),
        ),
        TextButton.icon(
          onPressed: () => selectDate(false),
          icon: const Icon(Icons.calendar_today, size: 20),
          label: Text('To: ${dateFormat.format(toDate)}'),
        ),
      ],
    );
  }
}