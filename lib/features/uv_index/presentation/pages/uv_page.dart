import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skinsight/features/uv_index/domain/entities/uv_entity.dart';
import 'package:skinsight/features/uv_index/presentation/pages/tomorrow_forcasting_uv_section.dart';

import '../../../../core/theme/app_color.dart';
import '../../../product/presentation/widgets/product_item.dart';
import '../widgets/index_uv_bar.dart';
import '../widgets/today_uv_item.dart';

class UvPage extends StatefulWidget {
  final UviDataEntity data;
  const UvPage({super.key, required this.data});

  @override
  State<UvPage> createState() => _UvPageState();
}

class _UvPageState extends State<UvPage> {
  final ScrollController _scrollController = ScrollController();
  late List<UviForecastEntity> todayList;
  late List<UviForecastEntity> tomorrowList;

  List<UviForecastEntity> getForecastForDate(
      List<UviForecastEntity> forecastList, DateTime targetDate) {
    final dateFormat = RegExp(r'^([A-Za-z]+), ([A-Za-z]+ \d{1,2}, \d{4})');
    final targetString =
        '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}';

    return forecastList.where((item) {
      final match = dateFormat.firstMatch(item.time);
      if (match != null) {
        final dateStr = match.group(2); // e.g. "July 24, 2025"
        try {
          final parsedDate = DateFormat('MMMM d, y').parse(dateStr!);
          final checkString =
              '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
          return checkString == targetString;
        } catch (e) {
          print('Date parsing error: $e');
          return false;
        }
      }
      return false;
    }).toList();
  }

  List<UviForecastEntity> getTodayForecast(List<UviForecastEntity> forecasts) {
    return getForecastForDate(forecasts, DateTime.now());
  }

  List<UviForecastEntity> getTomorrowForecast(
      List<UviForecastEntity> forecasts) {
    return getForecastForDate(forecasts, DateTime.now().add(Duration(days: 1)));
  }

  @override
  void initState() {
    super.initState();
    todayList = getTodayForecast(widget.data.forecast);
    tomorrowList = getTomorrowForecast(widget.data.forecast);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UV Index'),
      ),
      body: ListView(
        children: [
          uvTodaySection(context),
          recommendationSunscreenProductSection(context),
          todayForcastingUvSection(context),
          tomorrowForcastingUvSection(context),
        ],
      ),
    );
  }

  uvTodaySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
          ),
          Text(
            "Today's UV risk",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: kMainTextColor, fontSize: 18, fontWeight: semiBold),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            width: double.infinity,
            decoration: BoxDecoration(
                color: whiteColor, borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'UV Index',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 14,
                          fontWeight: semiBold,
                          color: kMainTextColor),
                    ),
                    Spacer(),
                    Icon(
                      Icons.location_on,
                      color: mainColor,
                      size: 16,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      widget.data.now.locality,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 14, fontWeight: semiBold, color: mainColor),
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                UvIndexBarType2(value: widget.data.now.uvi),
                SizedBox(
                  height: 4,
                ),
                Text(
                  widget.data.now.recommendation,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 12,
                      fontWeight: regular,
                      color: kSecondaryTextColor),
                  maxLines: 3,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  recommendationSunscreenProductSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 24, bottom: 16, left: 20, right: 20),
          color: lightBackgroundColor,
          child: Text(
            'Sunscreens Recommendation',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: kMainTextColor, fontSize: 18, fontWeight: semiBold),
          ),
        ),
        SizedBox(
          height: 238,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.data.recommendationProducts.length,
            itemBuilder: (context, index) {
              return Container(
                  margin: EdgeInsets.only(
                    left: index == 0 ? 20 : 0,
                    right:
                        index == widget.data.recommendationProducts.length - 1
                            ? 20
                            : 12,
                  ),
                  width: 150,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  child: ProductItem(
                      data: widget.data.recommendationProducts[index]));
            },
            separatorBuilder: (_, __) => const SizedBox(width: 2),
          ),
        )
      ],
    );
  }

  todayForcastingUvSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 24, bottom: 16, left: 20, right: 20),
          color: lightBackgroundColor,
          child: Text(
            'Today',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: kMainTextColor, fontSize: 18, fontWeight: semiBold),
          ),
        ),
        SizedBox(
          height: 130,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: todayList.length,
            itemBuilder: (context, index) {
              return Container(
                  margin: EdgeInsets.only(
                    left: index == 0 ? 20 : 0,
                    right: index == todayList.length - 1 ? 20 : 12,
                  ),
                  width: 100,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  child: TodayUvItem(
                    data: todayList[index],
                  ));
            },
            separatorBuilder: (_, __) => const SizedBox(width: 2),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  tomorrowForcastingUvSection(BuildContext context) {
    List<String> parts = tomorrowList[0].time.split(',');

    // return Container(
    //   width: double.infinity,
    //   margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
    //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    //   decoration: BoxDecoration(
    //       color: whiteColor, borderRadius: BorderRadius.circular(8)),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Text(
    //         parts[0],
    //         style: Theme.of(context).textTheme.titleMedium?.copyWith(
    //               fontSize: 16,
    //               fontWeight: semiBold,
    //               color: kMainTextColor)
    //       ),
    //       SizedBox(height: 8,),
    //       ListView.builder(
    //           itemCount: tomorrowList.length,
    //           shrinkWrap: true,
    //           physics: NeverScrollableScrollPhysics(),
    //           itemBuilder: (context, index) {
    //             return TomorrowUvItem(
    //               data: tomorrowList[index],
    //             );
    //           }),
    //     ],
    //   ),
    // );

    return TomorrowForecastingUvSection(tomorrowList: tomorrowList,);
  }


}
