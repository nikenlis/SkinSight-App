import 'package:skinsight/features/uv_index/domain/entities/uv_entity.dart';

import '../../../product/data/models/product_model.dart';

class UviNowModel extends UviNowEntity {
  const UviNowModel({
    required super.time,
    required super.uvi,
    required super.level,
    required super.recommendation, required super.city, required super.country, required super.countryCode, required super.locality,
  });

  factory UviNowModel.fromJson(Map<String, dynamic> json) {
    return UviNowModel(
      time: json['time'],
      uvi: (json['uvi'] as num).toDouble(),
      level: json['level'],
      recommendation: json['recommendation'],
      city: json['location']['city'],
      country: json['location']['country'],
      countryCode: json['location']['countryCode'],
      locality: json['location']['locality'],
    );
  }

  UviNowEntity toEntity() => UviNowEntity(time: time, uvi: uvi, level: level, recommendation: recommendation, city: city, country: country, countryCode: countryCode, locality: locality);
}

class UviForecastModel extends UviForecastEntity {
  const UviForecastModel({
    required super.time,
    required super.uvi,
    required super.level,
  });

  factory UviForecastModel.fromJson(Map<String, dynamic> json) {
    return UviForecastModel(
      time: json['time'],
      uvi: (json['uvi'] as num).toDouble(),
      level: json['level'],
    );
  }

  UviForecastEntity toEntity() => UviForecastEntity(
        time: time,
        uvi: uvi,
        level: level,
      );
}


class UviDataModel extends UviDataEntity {
  const UviDataModel({
    required super.now,
    required super.recommendationProducts,
    required super.forecast,
  });

  factory UviDataModel.fromJson(Map<String, dynamic> json) {
    return UviDataModel(
      now: UviNowModel.fromJson(json['now']),
      recommendationProducts: (json['recommendationProducts'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList(),
      forecast: (json['forecast'] as List)
          .map((e) => UviForecastModel.fromJson(e))
          .toList(),
    );
  }

  UviDataEntity toEntity() => UviDataEntity(
        now: (now as UviNowModel).toEntity(),
        recommendationProducts: recommendationProducts
            .map((e) => (e as ProductModel).toEntity())
            .toList(),
        forecast:
            forecast.map((e) => (e as UviForecastModel).toEntity()).toList(),
      );
}
