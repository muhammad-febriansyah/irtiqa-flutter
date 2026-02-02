import 'package:dio/dio.dart';
import '../../core/api_client.dart';

class AboutUsProvider {
  Future<Response> getAboutUs() async {
    return await ApiClient.get('/about-us');
  }
}
