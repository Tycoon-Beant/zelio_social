import 'package:bloc/bloc.dart';
import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/social/profile/model/bookmark_model.dart';
import 'package:zelio_social/social/profile/service/bookmark_service.dart';

class AddBookmarkCubit extends Cubit<Result<AddBookMarkModel>> {
  final BookmarkService _bookmarkService;
  AddBookmarkCubit(this._bookmarkService) : super(Result(isLoading: false));

  Future<void> addBookmarkByPostId({String? postId}) async {
    try {
      emit(Result(isLoading: true));
      final addbookmark = await _bookmarkService.addBookmark(postId: postId);
      emit(Result(data: addbookmark));
    } catch (e) {
      emit(Result(error: e.toString()));
    }
  }
}
