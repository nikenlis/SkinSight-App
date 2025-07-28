
import 'package:equatable/equatable.dart';

import '../../../product/domain/entities/product_entity.dart';

class UviNowEntity extends Equatable {
  final String time;
  final double uvi;
  final String level;
  final String recommendation;
  final String city;
  final String country;
  final String countryCode;
  final String locality;

  const UviNowEntity({required this.time, required this.uvi, required this.level, required this.recommendation, required this.city, required this.country, required this.countryCode, required this.locality});


  @override
  List<Object> get props {
    return [
      time,
      uvi,
      level,
      recommendation,
      city,
      country,
      countryCode,
      locality,
    ];
  }
}

class UviForecastEntity extends Equatable {
  final String time;
  final double uvi;
  final String level;

  const UviForecastEntity({
    required this.time,
    required this.uvi,
    required this.level,
  });

  @override
  List<Object> get props => [time, uvi, level];
}



class UviDataEntity extends Equatable {
  final UviNowEntity now;
  final List<ProductEntity> recommendationProducts;
  final List<UviForecastEntity> forecast;

  const UviDataEntity({
    required this.now,
    required this.recommendationProducts,
    required this.forecast,
  });

  @override
  List<Object> get props => [now, recommendationProducts, forecast];
}
