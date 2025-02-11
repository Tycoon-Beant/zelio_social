import 'package:dio/dio.dart';
import 'package:zelio_social/services/dio_instance.dart';
import 'package:zelio_social/social/home/model/all_post_model.dart';
import 'package:zelio_social/social/home/all_post_cubit/all_post_list_cubit.dart';
import 'package:zelio_social/social/profile/model/social_profile_model.dart';

import '../../../services/dio_exceptions.dart';

class AllPostService {
  AllPostService();

  Future<List<PostModel>> getAllPost({CancelToken? token}) async {
    final response = await DioSingleton.instance.dio.get(
      "social-media/posts",
      cancelToken: token,
    );
    final body = response.data;
    final List<dynamic> jsonResponse = body["data"]["posts"];
    return jsonResponse.map((e) => PostModel.fromJson(e)).toList();
  }

  Future<ProfileState> getMyPosts({CancelToken? token}) async {
    final response = await DioSingleton.instance.dio
        .get("social-media/posts/get/my", cancelToken: token);
    final body = response.data;
    final List<dynamic> jsonResponse = body["data"]["posts"];

    final postList = jsonResponse.map((e) => PostModel.fromJson(e)).toList();
    final myProfile = await _getSocialProfile();
    return ProfileState(postList, myProfile);
  }

  Future<SocialProfile> _getSocialProfile({CancelToken? token}) async {
    final response = await DioSingleton.instance.dio.get(
      "social-media/profile",
      cancelToken: token,
    );
    final body = response.data;
    final socialProfile = SocialProfile.fromJson(body["data"]);
    return socialProfile;
  }


  Future<ProfileState> getUserPosts({String? username,CancelToken? token}) async {
    final response = await DioSingleton.instance.dio.get("social-media/posts/get/u/${username}", cancelToken: token);
    final body = response.data;
    final List<dynamic> jsonResponse = body["data"]["posts"];
     final posts = jsonResponse.map((e) => PostModel.fromJson(e) ).toList();
    final profile = await _getUsersProfile(username: username);
    return ProfileState(posts, profile);
  }


  Future<SocialProfile> _getUsersProfile({String? username, CancelToken? token}) async{
   try {
      final response = await DioSingleton.instance.dio.get("social-media/profile/u/${username}",cancelToken: token);
      final body = response.data;
      final userProfile = SocialProfile.fromJson(body["data"]);
      return userProfile;
   } on DioException catch (e) {
      print("Error getting user profile: $e");
      throw DioExceptions.fromDioError(e);
    }
  }
}
