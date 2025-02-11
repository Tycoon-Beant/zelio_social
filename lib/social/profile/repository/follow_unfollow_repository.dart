import 'package:zelio_social/social/home/all_post_cubit/all_post_list_cubit.dart';
import 'package:zelio_social/social/profile/service/all_post_service.dart';
import 'package:zelio_social/social/profile/service/profile_service.dart';

class FollowUnfollowRepository {
  final ProfileService _profileService;
  final AllPostService _allPostService;

  FollowUnfollowRepository(
      {required ProfileService profileService,
      required AllPostService allPostService})
      : _profileService = profileService,
        _allPostService = allPostService;

  Future<ProfileState> followUnfollow({String? id, String? username})  async{
    try {
      await _profileService.postisFollowed(userId: id);
      final profile = _allPostService.getUserPosts(username: username);
      return profile;
    } catch (e) {
      rethrow;
    }
  }
}
