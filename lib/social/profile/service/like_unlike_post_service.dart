import 'package:dio/dio.dart';
import 'package:zelio_social/services/dio_instance.dart';
import 'package:zelio_social/social/profile/model/like_unlike_post_model.dart';

class LikeUnlikePostService {

  LikeUnlikePostService();

  Future<LikeModel> likeUnlikePost(String? id) async {
    try {
      final response =
          await DioSingleton.instance.dio.post("social-media/like/post/$id");
      final body = response.data;
      return LikeModel.fromJson(body["data"]);
    } on DioException catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
}