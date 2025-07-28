import 'package:flutter/material.dart';

import '../../../../core/theme/app_color.dart';
import '../../domain/entities/uv_entity.dart';

class TomorrowUvItem extends StatelessWidget {
  final UviForecastEntity data;
  const TomorrowUvItem({super.key, required this.data});

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

    return Padding(
  padding: const EdgeInsets.symmetric(vertical: 16),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // KIRI
      Expanded(
        flex: 1,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            time,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: kMainTextColor),
          ),
        ),
      ),

      // TENGAH (ICON DI TENGAH BENAR)
      Expanded(
        flex: 1,
        child: Center(
          child: Icon(
            Icons.wb_sunny_outlined,
            color: getUvColor(data.uvi),
            size: 20, // Sesuaikan jika perlu
          ),
        ),
      ),

      // KANAN
      Expanded(
        flex: 1,
        child: Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data.level,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: kSecondaryTextColor),
              ),
              SizedBox(width: 12),
              Text(
                data.uvi.toString(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: kMainTextColor),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
);


  }
}
