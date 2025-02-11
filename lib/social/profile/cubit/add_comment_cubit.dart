import 'package:bloc/bloc.dart';
import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/social/profile/service/comment_service.dart';
class AddCommentCubit extends Cubit<Result<CommentState>> {
  final CommentService _commentService;
  AddCommentCubit(this._commentService) : super(Result(isLoading: false));

  Future<void> addPostComments({String? postId, String? content}) async {
    try {
      emit(Result(isLoading: true));
      await _commentService.addPostComment(postId: postId,content: content);
      emit(Result(data:CommentState(event: CommentEvent.add, postId: postId)));
    } catch (e) {
      emit(Result(error: e.toString()));
    }
  }
  
  Future<void> deleteCommentbyId({String? commentId, String? postId}) async{
    try {
      emit(Result(isLoading: true));
      await _commentService.deleteComment(commentId: commentId);
      emit(Result(data: CommentState(event: CommentEvent.delete, postId: postId)));
    } catch (e) {
      emit(Result(error: e.toString()));
    }
  }
}

class CommentState{
  String? postId;
  final CommentEvent event;
  CommentState({required this.event, this.postId});
}



enum CommentEvent{add, delete , update}