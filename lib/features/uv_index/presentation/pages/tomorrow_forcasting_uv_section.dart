import 'package:flutter/material.dart';
import 'package:skinsight/core/theme/app_color.dart';
import 'package:skinsight/features/uv_index/domain/entities/uv_entity.dart';
import 'package:skinsight/features/uv_index/presentation/widgets/tomorrow_uv_item.dart';

class TomorrowForecastingUvSection extends StatefulWidget {
  final List<UviForecastEntity> tomorrowList;
  const TomorrowForecastingUvSection({super.key, required this.tomorrowList});

  @override
  State<TomorrowForecastingUvSection> createState() => _TomorrowForecastingUvSectionState();
}

class _TomorrowForecastingUvSectionState extends State<TomorrowForecastingUvSection> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    List<String> parts = widget.tomorrowList[0].time.split(',');
    int itemCountToShow = _showAll ? widget.tomorrowList.length : 8;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            parts[0],
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 16,
              fontWeight: semiBold,
              color: kMainTextColor,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            itemCount: itemCountToShow,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return TomorrowUvItem(data: widget.tomorrowList[index]);
            },
          ),
          if (widget.tomorrowList.length > 8)
          InkWell(
            onTap: (){
              setState(() {
                  _showAll = !_showAll;
                });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                    _showAll ? "See less" : "Show more",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: mainColor,
                    ),
                  ),
                ),
            ),
          ),
            // TextButton(

            //   onPressed: () {
            //     setState(() {
            //       _showAll = !_showAll;
            //     });
            //   },
            //   child: Center(
            //     child: Text(
            //       _showAll ? "See less" : "Show more",
            //       style: TextStyle(
            //         fontWeight: FontWeight.normal,
            //         color: mainColor,
            //       ),
            //     ),
            //   ),
            // ),
        ],
      ),
    );
  }
}
