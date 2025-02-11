import 'dart:io';

import 'package:dio/dio.dart';
import 'package:zelio_social/services/dio_exceptions.dart';
import 'package:zelio_social/services/dio_instance.dart';
import 'package:zelio_social/social/home/model/all_post_model.dart';


class AddPostService {

  AddPostService();

  Future<PostModel> addPost(
      String content, List<File> images, List<String> tags) async {
    Map<String, dynamic> data = {};
    data.addEntries(List.generate(
        tags.length, (index) => MapEntry("tags[$index]", tags[index])));

    final image = await Future.wait(
        images.map((e) => MultipartFile.fromFile(e.path)).toList());

    data["images"] = image;
    data["content"] = content;
    try {
      final response = await DioSingleton.instance.dio.post("social-media/posts",
          data: FormData.fromMap(data));
      final body = response.data;
      return PostModel.fromJson(body["data"]);
    } on DioException catch (e) {
      print("Error while adding post : $e");
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<PostModel> deletePost({required String postId}) async {
    try {
      final response = await DioSingleton.instance.dio.delete(
            "social-media/posts/$postId",
          );
      final body = response.data;
      return PostModel.fromJson(body["data"]);
    } on DioException catch (e) {
      print("Error deleting item to cart: $e");
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<PostModel> patchPost(
      {required String postId,
      required String content,
      required List<File> images,
      required List<String> tags}) async {
    Map<String, dynamic> data = {};
    data.addEntries(List.generate(
        tags.length, (index) => MapEntry("tags[$index]", tags[index])));

    final image = await Future.wait(
        images.map((e) => MultipartFile.fromFile(e.path)).toList());

    data["images"] = image;
    data["content"] = content;
    try {
      final response =
          await DioSingleton.instance.dio.patch("social-media/posts/$postId",
              data: FormData.fromMap(data));
      final body = response.data;
      return PostModel.fromJson(body["data"]);
    } on DioException catch (e) {
      print("Error updating item to cart: $e");
      throw DioExceptions.fromDioError(e);
    }
  }
}
