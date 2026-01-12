import 'package:daily_money/Controllers/home_controller.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeLine extends StatelessWidget {
  const TimeLine({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: EasyDateTimeLine(
        initialDate: DateTime.now(),
        onDateChange: (selectedDate) => controller.onDateSelected(selectedDate),
        headerProps: const EasyHeaderProps(
          monthPickerType: MonthPickerType.switcher,
          dateFormatter: DateFormatter.fullDateDMY(),
        ),
        dayProps: EasyDayProps(
          dayStructure: DayStructure.dayStrDayNum,
          height: 56,
          width: 56,
          borderColor: Colors.transparent,
          inactiveDayStyle: DayStyle(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[100],
            ),
            dayNumStyle: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            dayStrStyle:
                GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
          ),
          activeDayStyle: DayStyle(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ],
            ),
            dayNumStyle: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            dayStrStyle:
                GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
          ),
        ),
      ),
    );
  }
}

