import 'package:flutter/material.dart';

import '../../../../core/theme/app_color.dart';
import '../../domain/entities/uv_entity.dart';

class TodayUvItem extends StatelessWidget {
  final UviForecastEntity data;
  TodayUvItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    String original = data.time;

    List<String> parts = original.split(' at ');

    String datePart = parts[0]; // 'Thursday, July 24, 2025'
    String timePart = parts[1]; // '01:00 WIB'

    List<String> dateParts = datePart.split(', ');

    String day = dateParts[0]; // 'Thursday'
    String date = dateParts[1]; // 'July 24, 2025'
    String time = timePart;

    Color getUvColor(double uv) {
      if (uv <= 2) return Colors.green;
      if (uv <= 5) return Colors.yellow;
      if (uv <= 7) return Colors.orange;
      if (uv <= 10) return Colors.red;
      return Colors.purple;
    }

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(8),
        bottomRight: Radius.circular(8),
      ),
      child: Container(
        padding: EdgeInsets.only(top: 12, bottom: 12),
        width: 80,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: kMainTextColor.withValues(alpha: 0.1),
                blurRadius: 4,
                spreadRadius: 1,
                offset: const Offset(0, 4))
          ],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 249, 250, 245),
              Colors.white.withOpacity(0.8),
            ],
            stops: [0.0, 0.8],
          ),
          border: Border.all(color: mainColor),
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromARGB(255, 249, 250, 245),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.wb_sunny_outlined,
              color: getUvColor(data.uvi),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              data.uvi.toString(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 16, fontWeight: semiBold, color: kMainTextColor),
            ),
            Text(
              data.level,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: kSecondaryTextColor),
            ),
            Spacer(),
            Text(
              time,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: kMainTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
