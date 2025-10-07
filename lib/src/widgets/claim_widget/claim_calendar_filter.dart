import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

void showCalendarFilter(
  BuildContext context,
  void Function(DateTime?, DateTime?) onDateRangeSelected,
) {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedStartDay;
  DateTime? selectedEndDay;
  CalendarFormat calendarFormat = CalendarFormat.month;

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  title: "Select Date Range",
                  fontSize: 14.sp,
                  weight: FontWeight.bold,
                ),
                TableCalendar(
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  focusedDay: focusedDay,
                  calendarFormat: calendarFormat,
                  selectedDayPredicate: (day) {
                    if (selectedStartDay != null && selectedEndDay != null) {
                      return day.isAtSameMomentAs(selectedStartDay!) ||
                          (day.isAfter(selectedStartDay!) &&
                              day.isBefore(selectedEndDay!)) ||
                          day.isAtSameMomentAs(selectedEndDay!);
                    }
                    return false;
                  },
                  onDaySelected: (selectedDay, newFocusedDay) {
                    setModalState(() {
                      if (selectedStartDay == null ||
                          (selectedStartDay != null && selectedEndDay != null)) {
                        selectedStartDay = selectedDay;
                        selectedEndDay = null;
                      } else if (selectedStartDay != null &&
                          selectedEndDay == null) {
                        if (selectedDay.isAfter(selectedStartDay!)) {
                          selectedEndDay = selectedDay;
                        } else {
                          selectedEndDay = selectedStartDay;
                          selectedStartDay = selectedDay;
                        }
                      }
                      focusedDay = newFocusedDay;
                    });
                  },
                  onFormatChanged: (format) =>
                      setModalState(() => calendarFormat = format),
                  calendarStyle: const CalendarStyle(
                    rangeHighlightColor: AppColors.brightYellowColor,
                    todayDecoration: BoxDecoration(
                      color: AppColors.purpleColor,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppColors.brightYellowColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        onDateRangeSelected(null, null);
                        Navigator.pop(context);
                      },
                      child: const Text("Clear"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purpleColor,
                      ),
                      onPressed: () {
                        onDateRangeSelected(selectedStartDay, selectedEndDay);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Apply",
                        style: TextStyle(color: Colors.amberAccent),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      );
    },
  );
}
