import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/services/local_storage_service.dart';
import 'package:zelio_social/social/profile/model/follower_following_model.dart';
import 'package:zelio_social/social/profile/service/profile_service.dart';

class FollowerListCubit extends Cubit<Result<List<FollowersFollowingModel>>> {
  ProfileService _profileService;
  final LocalStorageService _localStorageService;
  FollowerListCubit(this._profileService, this._localStorageService) : super(Result(isLoading: false));

   Future<void> getFollowerList({String? username}) async{
    try {
      emit(Result(isLoading: true));
      final currentUser = _localStorageService.getUser()?.username;
      final followerList = await _profileService.getFollowersList(username: username ?? currentUser);
      emit(Result(data:  followerList));
    } on DioException catch (e) {
      print("Error getting followerList: $e");
      rethrow;
    }
  }

   
}

// class FollowListState{
//  final FollowListEvent event;
//  final List<SocialProfile> profile;

//  FollowListState({required this.event,required this.profile});
// }

// enum FollowListEvent { follower, following}