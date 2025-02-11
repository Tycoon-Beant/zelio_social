import 'package:dio/dio.dart';
import 'package:zelio_social/services/dio_instance.dart';
import 'package:zelio_social/social/profile/model/bookmark_model.dart';

class BookmarkService {

  BookmarkService(){
    getBookmark();
  }

  Future<List<BookmarkedPosts>> getBookmark() async {
    try {
      final response = await DioSingleton.instance.dio.get("social-media/bookmarks");
      final body = response.data;
     List<dynamic> jsonResponse = body["data"]["bookmarkedPosts"];
     return jsonResponse.map((e) => BookmarkedPosts.fromJson(e) ).toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<AddBookMarkModel> addBookmark({String? postId}) async {
    try {
     final response =  await DioSingleton.instance.dio.post(
          "social-media/bookmarks/${postId}",);
    final body = response.data;
    return AddBookMarkModel(isBookmarked: body["data"]["isBookmarked"], postId: postId);
    } on DioException catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
}