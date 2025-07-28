import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skinsight/core/theme/app_color.dart';
class GenderSelector extends StatefulWidget {
  final void Function(String selectedGender) onSelected;

  const GenderSelector({super.key, required this.onSelected});

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  String? selected;

  @override
  Widget build(BuildContext context) {
    final genderOptions = ['female', 'male'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: genderOptions.map((gender) {
        final isSelected = selected == gender;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selected = gender;
              });
              widget.onSelected(gender);
            },
            child: Container(
              width: 102,
              height: 102,
              decoration: BoxDecoration(
                color: isSelected ? mainColor : secondGreyColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    gender == 'female'
                        ? 'assets/icon_female.svg'
                        : 'assets/icon_male.svg',
                    width: 54,
                    height: 54,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    gender == 'female' ? 'Female' : 'Male',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

