import 'package:bloc/bloc.dart';
import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/social/profile/model/like_unlike_post_model.dart';
import 'package:zelio_social/social/profile/service/comment_service.dart';

class LikeUnlikeCommentCubit extends Cubit<Result<LikeCommentModel>> {
  CommentService _commentService;
  LikeUnlikeCommentCubit(this._commentService) : super(Result(isLoading: false));

  Future<void> likeUnlikeComments({String? commentId}) async {
    try {
      emit(Result(isLoading: true));
      final isLikeComment = await _commentService.likeUnlikeComment(commentId);
      emit(Result(data: isLikeComment));
    } catch (e) {
      emit(Result(error: e.toString()));
    }
  }
}
