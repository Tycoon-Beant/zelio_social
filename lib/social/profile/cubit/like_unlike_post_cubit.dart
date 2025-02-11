import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/social/profile/model/like_unlike_post_model.dart';
import 'package:zelio_social/social/profile/service/like_unlike_post_service.dart';
 
class LikeUnlikePostCubit extends Cubit<Result<LikeModel>> {
  final LikeUnlikePostService _likeUnlikeService;
  LikeUnlikePostCubit(this._likeUnlikeService) : super(Result(isLoading: false));
 
  Future<void> likeUnlikePost(String? id) async {
    try {
      emit(Result(isLoading: true));
      final likeUnlikePostDetail = await _likeUnlikeService.likeUnlikePost(id);
      emit(Result(data: likeUnlikePostDetail));
    } catch (e) {
      emit(Result(error: e.toString()));
    }
  }
}