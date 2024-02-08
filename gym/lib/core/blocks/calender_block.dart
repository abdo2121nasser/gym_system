import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/cubits/book_cubit/booking_cubit.dart';
import 'package:gym/core/cubits/book_cubit/booking_cubit.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';


class CalenderBlock extends StatelessWidget {
  const CalenderBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var bCubit=BookingCubit.get(context);
        return TableCalendar(
         currentDay: bCubit.selectedDay,
          onDaySelected: (selectedDay, focusedDay) {
            bCubit.changeSelectedDay(selectedDay,context);
          },
          selectedDayPredicate: (day) {
            // Use this to determine if a day is selected
            return isSameDay(bCubit.selectedDay, day);
          },
          headerStyle: HeaderStyle(

            formatButtonVisible: false,
            titleCentered: true,
            leftChevronIcon: const Icon(Icons.chevron_left),
            rightChevronIcon: const Icon(Icons.chevron_right),
            titleTextStyle: const TextStyle(fontSize: 18),
            headerPadding: const EdgeInsets.all(0),
            headerMargin: const EdgeInsets.all(0),
            titleTextFormatter: (date, locale) =>
                DateFormat.MMMM().format(date),
          ),
          calendarFormat: CalendarFormat.week,
          firstDay: DateTime.now().subtract(const Duration(days: 21)),
          lastDay: DateTime.now().add(const Duration(days: 25)),
          focusedDay:bCubit.selectedDay,


        );
      },
    );
  }
}
