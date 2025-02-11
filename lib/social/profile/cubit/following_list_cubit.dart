
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/services/local_storage_service.dart';
import 'package:zelio_social/social/profile/model/follower_following_model.dart';
import 'package:zelio_social/social/profile/service/profile_service.dart';

class FollowingListCubit extends Cubit<Result<List<FollowersFollowingModel>>> {
  ProfileService _profileService;
  final LocalStorageService _localStorageService;
  FollowingListCubit(this._profileService, this._localStorageService) : super(Result(isLoading: false));

   Future<void> getFollowingsList({String? username}) async{
    try {
      emit(Result(isLoading: true));
      final currentUser = _localStorageService.getUser()?.username;
      final followingList = await _profileService.getFollowingList(username: username ?? currentUser);
      emit(Result(data: followingList));
    } on DioException catch (e) {
      print("Error getting followingList: $e");
      rethrow;
    }
  }

   
}



