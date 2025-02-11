import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/social/profile/model/comment_model.dart';
import 'package:zelio_social/social/profile/model/like_unlike_post_model.dart';
import 'package:zelio_social/social/profile/service/comment_service.dart';
 
class CommentListCubit extends Cubit<Result<List<CommentModel>>> {
  final CommentService _commentService;
  CommentListCubit(this._commentService) : super(Result(isLoading: false));
 
  Future<void> getPostComments({String? id}) async {
    try {
      emit(Result(isLoading: true));
      final postCommentsDetails = await _commentService.getPostComments(id: id);
      emit(Result(data: postCommentsDetails));
    } catch (e) {
      emit(Result(error: e.toString()));
    }
  }

  void updateLikes({LikeCommentModel? likeCommentModel}) {
    emit(Result(data: [
      for(CommentModel c in state.data ?? [])
        if(c.id == likeCommentModel?.commentId) 
          c.copyWith(isLiked: likeCommentModel?.isLiked, likes: likeCommentModel?.likes)
        else 
        c
    ]));
  }
}
 