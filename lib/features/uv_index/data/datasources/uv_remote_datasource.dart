import 'package:skinsight/features/uv_index/data/models/uv_model.dart';

import '../../../../core/api/api_client.dart';

abstract class UvRemoteDatasource {
  Future<UviDataModel> getDataUv({required double latitude, required double longitude});
}

class UvRemoteDatasourceImpl implements UvRemoteDatasource{
  @override
  Future<UviDataModel> getDataUv({required double latitude, required double longitude}) async {
    return await ApiClient.get<UviDataModel>(
      endpoint: "/current-uv-index?latitude=$latitude&longitude=$longitude",
      headers: await ApiClient.getHeaders(),
      parser: (json) {
        print('🔥  => ${UviDataModel.fromJson(json['data'])}');
        return UviDataModel.fromJson(json['data']);
      },
    );
  }

}