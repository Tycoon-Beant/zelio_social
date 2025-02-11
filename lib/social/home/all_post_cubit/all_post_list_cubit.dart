import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/social/home/model/all_post_model.dart';
import 'package:zelio_social/social/profile/cubit/add_comment_cubit.dart';
import 'package:zelio_social/social/profile/model/like_unlike_post_model.dart';
import 'package:zelio_social/social/profile/service/all_post_service.dart';
import 'package:zelio_social/social/profile/model/social_profile_model.dart';

class AllPostListCubit extends Cubit<Result<List<PostModel>>> {
  final AllPostService _allPostService;
  CancelToken? cancelToken;
  AllPostListCubit(this._allPostService) : super(Result(isLoading: true)) {
    cancelToken ??= CancelToken();
    getAllPosts();
  }

  Future<void> getAllPosts() async {
    try {
      emit(Result(isLoading: true));
      final allPost = await _allPostService.getAllPost(token: cancelToken);
      emit(Result(data: allPost));
    } catch (e) {
      emit(Result(error: e.toString()));
    }
  }

  void updatePosts(List<PostModel> posts) {
    emit(Result(data: posts));
  }

  void update(LikeModel data) {
    emit(Result(data: [
      for (PostModel i in state.data ?? [])
        if (i.id == data.postId)
          i.copyWith(
            isLiked: data.isLiked,
            likes: data.isLiked == true ? i.likes! + 1 : i.likes! - 1,
          )
        else
          i
    ]));
  }

void updateCommentcount({required String postId,required CommentEvent event}){
  emit(Result(data: [
    for(PostModel i in state.data ?? [])
    if(i.id == postId)
    i.copyWith(
      comments: event == CommentEvent.add ? i.comments! + 1 : i.comments! - 1,
    ) 
    else 
    i
  ]));
}

void updateBookmark({required String postId , required bool isBookmarked}){
  emit(Result(data: [
    for(PostModel i in state.data ?? [])
    if(i.id == postId)
    i.copyWith(
      isBookmarked: isBookmarked,
    )
    else
    i
  ]));
}


  @override
  Future<void> close() {
    cancelToken?.cancel();
    return super.close();
  }
}

class ProfileState {
  List<PostModel>? myPostList;
  SocialProfile? myProfile;

  ProfileState(this.myPostList, this.myProfile);
}
