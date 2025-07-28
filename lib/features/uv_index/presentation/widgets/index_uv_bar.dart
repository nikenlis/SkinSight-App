import 'package:flutter/material.dart';
import 'package:skinsight/core/theme/app_color.dart';

class UvIndexBar extends StatelessWidget {
  final double value; // nilai UV index dari 0.0–11.0

  const UvIndexBar({super.key, required this.value});

  Color getUvColor(double uv) {
    if (uv <= 2) return Colors.green;
    if (uv <= 5) return Colors.yellow;
    if (uv <= 7) return Colors.orange;
    if (uv <= 10) return Colors.red;
    return Colors.purple;
  }

  String getUvLevel(double uv) {
    if (uv <= 2) return 'Low';
    if (uv <= 5) return 'Moderate';
    if (uv <= 7) return 'High';
    if (uv <= 10) return 'Very High';
    return 'Extreme';
  }

  @override
  Widget build(BuildContext context) {
    final barWidth =
        MediaQuery.of(context).size.width ; // sisa space setelah label
    final normalized = (value.clamp(0, 11) / 11); // 0.0 to 1.0

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${value.toStringAsFixed(0)} ${getUvLevel(value)}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: kMainTextColor,
                fontSize: 12,
              ),
        ),

        SizedBox(width: 16,),
        Expanded(
          child: SizedBox(
            height: 24,
            child: Stack(
              children: [
                Container(
                  width: barWidth,
                  height: 6,
                  margin: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Colors.green,
                      Colors.yellow,
                      Colors.orange,
                      Colors.red,
                      Colors.purple
                    ]),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Positioned(
                  // left: normalized * barWidth - 5,
                  left: ((normalized * barWidth) - 5).clamp(0.0, barWidth - 10),
                  top: 7,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class UvIndexBarType2 extends StatelessWidget {
  final double value;

  const UvIndexBarType2({super.key, required this.value});

  Color getUvColor(double uv) {
    if (uv <= 2) return Colors.green;
    if (uv <= 5) return Colors.yellow;
    if (uv <= 7) return Colors.orange;
    if (uv <= 10) return Colors.red;
    return Colors.purple;
  }

  String getUvLevel(double uv) {
    if (uv <= 2) return 'Low';
    if (uv <= 5) return 'Moderate';
    if (uv <= 7) return 'High';
    if (uv <= 10) return 'Very High';
    return 'Extreme';
  }

  @override
  Widget build(BuildContext context) {
    final barWidth =
        MediaQuery.of(context).size.width - 64; // padding 32 left-right
    final normalized = (value.clamp(0, 11) / 11); // 0.0 to 1.0

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${value.toStringAsFixed(0)} ${getUvLevel(value)}',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontSize: 16),
            ),
            SizedBox(
              width: 4,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkResponse(
                  onTap: () {
                    showUvIndexOverview(context);
                  },
                  borderRadius: BorderRadius.circular(28), 
                  splashColor: mainColor.withOpacity(0.2), 
                  highlightColor: mainColor.withOpacity(0.1), 
                  radius: 20,
                  child: Icon(
                    Icons.info_outline,
                    color: mainColor,
                    size: 20,
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 2),
        Stack(
          children: [
            Container(
              width: barWidth,
              height: 6,
              margin: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [
                  Colors.green,
                  Colors.yellow,
                  Colors.orange,
                  Colors.red,
                  Colors.purple
                ]),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Positioned(
              left: ((normalized * barWidth) - 5).clamp(0.0, barWidth - 10),
              top: 7,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}


void showUvIndexOverview(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: whiteColor,
    context: context,
    isScrollControlled: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'UV index overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _uvLevelRow('1–2 Low', Colors.green, 'SPF 15–30'),
            _uvLevelRow('3–5 Moderate', Colors.orange, 'SPF 30'),
            _uvLevelRow('6–7 High', Colors.deepOrange, 'SPF 50'),
            _uvLevelRow('8–10 Very high', Colors.red, 'SPF 50'),
            _uvLevelRow('11+ Extreme', Colors.purple, 'SPF 50+'),
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}

Widget _uvLevelRow(String label, Color dotColor, String spf) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Icon(Icons.circle, color: dotColor, size: 10),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        Text(
          spf,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    ),
  );
}

