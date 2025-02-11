import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/social/home/all_post_cubit/all_post_list_cubit.dart';
import 'package:zelio_social/social/profile/service/all_post_service.dart';

import '../repository/follow_unfollow_repository.dart';

class ProfilePostListCubit extends Cubit<Result<ProfileState>> {
  final AllPostService _allPostService;
  final FollowUnfollowRepository _repository;
  

  CancelToken? cancelToken;
  ProfilePostListCubit(this._allPostService, this._repository)
      : super(Result(isLoading: true)) {
    cancelToken ??= CancelToken();
  }

  Future<void> getProfileData(
      {String? userName, bool showLoader = true}) async {
    try {
      if (showLoader) emit(Result(isLoading: true));
      ProfileState profile;
      if (userName != null) {
        profile = await _allPostService.getUserPosts(
            username: userName, token: cancelToken);
      } else {
        profile = await _allPostService.getMyPosts(token: cancelToken);
      }
      emit(Result(data: profile));
    } catch (e) {
      emit(Result(error: e.toString()));
    }
  }

  Future<void> postFollow({String? userId, String? username}) async {
    try {
      emit(Result(isRefreshing: true, data: state.data));
      final response =
          await _repository.followUnfollow(id: userId, username: username);
      emit(Result(data: response));
    } catch (e) {
      emit(Result(error: e.toString()));
    }
  }

 

  @override
  Future<void> close() {
    cancelToken?.cancel();
    return super.close();
  }
}
