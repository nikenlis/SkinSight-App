

import 'package:flutter/material.dart';

class AgePickerWheel extends StatefulWidget {
  final void Function(int age) onAgeSelected;

  const AgePickerWheel({super.key, required this.onAgeSelected});

  @override
  State<AgePickerWheel> createState() => _AgePickerWheelState();
}

class _AgePickerWheelState extends State<AgePickerWheel> {
  final List<int> ages = List.generate(100, (index) => index + 1);
  int selectedAge = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180, // Total tinggi untuk 3 item (3 x itemExtent = 150)
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Kotak highlight abu-abu
          Positioned(
            child: Container(
              height: 60,
              width: 140,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          ListWheelScrollView.useDelegate(
            itemExtent: 60, // ✅ Jarak antar item
            diameterRatio: 2.0, // ✅ Semakin besar, semakin jauh efek depth-nya
            perspective: 0.005, // Optional, biar tidak terlalu melengkung
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              setState(() {
                selectedAge = ages[index];
              });
              widget.onAgeSelected(selectedAge);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: ages.length,
              builder: (context, index) {
                final isSelected = ages[index] == selectedAge;
                return Center(
                  child: Text(
                    ages[index].toString(),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

