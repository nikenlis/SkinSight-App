import 'package:flutter/material.dart';

class SkinTypeSelector extends StatefulWidget {
  final void Function(String selectedSkinType) onSelected;

  const SkinTypeSelector({super.key, required this.onSelected});

  @override
  State<SkinTypeSelector> createState() => _SkinTypeSelectorState();
}

class _SkinTypeSelectorState extends State<SkinTypeSelector> {
  String? selectedSkinType;

  final List<Map<String, String>> skinTypes = [
    {"label": "Dry", "asset": "assets/img_kulit_dry.png"},
    {"label": "Oily", "asset": "assets/img_kulit_oily.png"},
    {"label": "Normal", "asset": "assets/img_kulit_normal.png"},
    {"label": "Acne", "asset": "assets/img_kulit_acne.png"},
    {"label": "Sensitive", "asset": "assets/img_kulit_sensitive.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: skinTypes.map((skin) {
        final isSelected = selectedSkinType == skin['label'];
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedSkinType = skin['label'];
            });
            widget.onSelected(selectedSkinType!);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(skin['asset']!),
                    fit: BoxFit.cover,
                  ),
                  border: isSelected
                      ? Border.all(color: Colors.white, width: 4)
                      : null,
                ),
              ),
              Text(
                skin['label']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      color: Colors.black38,
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
