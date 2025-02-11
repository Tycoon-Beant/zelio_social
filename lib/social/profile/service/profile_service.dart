import 'dart:io';
import 'package:dio/dio.dart';
import 'package:zelio_social/services/dio_exceptions.dart';
import 'package:zelio_social/services/dio_instance.dart';
import 'package:zelio_social/social/profile/model/follower_following_model.dart';
import 'package:zelio_social/social/profile/model/social_profile_model.dart';

class ProfileService {
  ProfileService();

  Future<SocialProfile> getSocialProfile({CancelToken? token}) async {
    final response = await DioSingleton.instance.dio.get(
      "social-media/profile",
      cancelToken: token,
    );
    final body = response.data;
    final socialProfile = SocialProfile.fromJson(body["data"]);
    return socialProfile;
  }

  Future<SocialProfile> patchProfileDetails(
      {Map<String, dynamic>? data}) async {
    try {
      final response = await DioSingleton.instance.dio.patch(
        'social-media/profile',
        data: data,
      );
      final body = response.data;
      return SocialProfile.fromJson(body["data"]);
    } on DioException catch (e) {
      print("Error patching profile: $e");
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<SocialProfile> patchCameraImage({required File coverImage}) async {
    Map<String, dynamic> data = {};

    try {
      final image = await MultipartFile.fromFile(
        coverImage.path,
        filename: coverImage.path.split('/').last,
      );

      data["coverImage"] = image;

      final response = await DioSingleton.instance.dio.patch(
        "social-media/profile/cover-image",
        data: FormData.fromMap(data),
      );

      final body = response.data;
      return SocialProfile.fromJson(body["data"]);
    } on DioException catch (e) {
      print("Error updating post: $e");
      throw DioExceptions.fromDioError(e);
    }
  }


  Future<SocialProfile> postisFollowed({String? userId}) async {
    try {
      final response =  await DioSingleton.instance.dio.post("social-media/follow/$userId");
      final body =  response.data;
      return SocialProfile.fromJson(body['data']);
    } on DioException catch (e) {
      print("Error during follow : $e");
      throw DioExceptions.fromDioError(e);
    }
  }
  
  Future<List<FollowersFollowingModel>> getFollowersList({String? username, CancelToken? token}) async{
   try {
      final response = await DioSingleton.instance.dio.get("social-media/follow/list/followers/${username}",cancelToken: token);
      final body = response.data;
      final List<dynamic> jsonResponse = body["data"]["followers"];
      final follower = jsonResponse.map((e) => FollowersFollowingModel.fromJson(e)).toList();
      return follower ;
   } on DioException catch (e) {
      print("Error getting user profile: $e");
      throw DioExceptions.fromDioError(e);
    }
  }
  Future<List<FollowersFollowingModel>> getFollowingList({String? username, CancelToken? token}) async{
   try {
      final response = await DioSingleton.instance.dio.get("social-media/follow/list/following/${username}",cancelToken: token);
      final body = response.data;
      final List<dynamic> jsonResponse = body["data"]["following"];
      final following = jsonResponse.map((e) => FollowersFollowingModel.fromJson(e)).toList();
      return following;
   } on DioException catch (e) {
      print("Error getting user profile: $e");
      throw DioExceptions.fromDioError(e);
    }
  }


}
