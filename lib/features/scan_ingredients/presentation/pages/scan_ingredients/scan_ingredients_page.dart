import 'package:flutter/material.dart';
import 'package:skinsight/features/authentication/presentation/widgets/form_items.dart';
import '../../../../../core/common/app_route.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/ui/custom_button.dart';

class ScanIngredientsPage extends StatefulWidget {
  const ScanIngredientsPage({super.key});

  @override
  State<ScanIngredientsPage> createState() => _ScanIngredientsPageState();
}

class _ScanIngredientsPageState extends State<ScanIngredientsPage> {
  bool _isFormValid = false;
  late TextEditingController nameProductController;

  @override
  void initState() {
    super.initState();
    nameProductController = TextEditingController();
    nameProductController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isFormValid = nameProductController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    nameProductController.removeListener(_validateForm);
    nameProductController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: [
        SizedBox(
          height: 61,
        ),
        Text(
          "Let's Scan Your Skincare \n One scan away from knowing what's inside",
          style: blackRobotoTextStyle.copyWith(
              color: Colors.black, fontSize: 20, fontWeight: regular),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 33,
        ),
        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 29, bottom: 49, left: 43, right: 43),
            child: Column(
              children: [
                Text(
                  'Before You Scan',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 18, fontWeight: medium, color: blackColor),
                ),
                SizedBox(
                  height: 35,
                ),
                Row(
                  children: [
                    Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 17,
                        )),
                    SizedBox(
                      width: 12,
                    ),
                    Text('Use bright lighting'),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(
                          Icons.text_format,
                          color: Colors.white,
                          size: 17,
                        )),
                    SizedBox(
                      width: 12,
                    ),
                    Text('Keep text sharp and clear'),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(
                          Icons.light_outlined,
                          color: Colors.white,
                          size: 17,
                        )),
                    SizedBox(
                      width: 12,
                    ),
                    Text('Avoid shadows'),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        FormItems(
            controller: nameProductController,
            title: 'Product Name',
            hintTitle: 'Enter product name',
            isShowHint: true,
            isShowTitle: true,
            textInputFormatter: [],
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.name),
        SizedBox(
          height: 40,
        ),
        FilledButtonItems(
          title: 'Scan Ingredient',
          onPressed: _isFormValid
              ? () async {
                  Navigator.pushNamed(
                      context, AppRoute.cameraScanIngredientPage,
                      arguments: nameProductController.text);
                  nameProductController.clear();
                }
              : null,
        )
      ],
    ));
  }
}
