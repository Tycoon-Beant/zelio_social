import 'package:dio/dio.dart';
import 'package:zelio_social/services/dio_instance.dart';
import 'package:zelio_social/social/profile/model/comment_model.dart';
import 'package:zelio_social/social/profile/model/like_unlike_post_model.dart';

class CommentService {
  CommentService();

  Future<List<CommentModel>> getPostComments({String? id}) async {
    try {
      final response =
          await DioSingleton.instance.dio.get("social-media/comments/post/$id");
      final body = response.data;
      List<dynamic> jsonResponse = body['data']['comments'];
      return jsonResponse.map((e) => CommentModel.fromJson(e)).toList();
    } on DioException catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<void> addPostComment({String? postId, String? content}) async {
    try {
      await DioSingleton.instance.dio.post(
          "social-media/comments/post/${postId}",
          data: {"content": content ?? ''});
    } on DioException catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<CommentModel> deleteComment({String? commentId}) async {
    try {
      final response = await DioSingleton.instance.dio
          .delete("social-media/comments/${commentId}");
      final body = response.data;
      return CommentModel.fromJson(body["data"]);
    } on DioException catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<LikeCommentModel> likeUnlikeComment(String? commentId) async {
    try {
      final response = await DioSingleton.instance.dio
          .post("social-media/like/comment/${commentId}");
      final Map<String, dynamic> body = response.data["data"];
      body.addAll({"commentId": commentId});
      return LikeCommentModel.fromJson(body);
    } on DioException catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
}
