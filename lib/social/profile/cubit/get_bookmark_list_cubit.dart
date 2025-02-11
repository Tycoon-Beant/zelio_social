import 'package:bloc/bloc.dart';
import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/social/profile/model/bookmark_model.dart';
import 'package:zelio_social/social/profile/service/bookmark_service.dart';

class GetBookmarkListCubit extends Cubit<Result<List<BookmarkedPosts>>> {
  final BookmarkService _bookmarkedService;
  GetBookmarkListCubit(this._bookmarkedService) : super(Result(isLoading: true)){
    getBookmarklist();
  }

  Future<void> getBookmarklist() async {
    try {
      emit(Result(isLoading: true));
      final bookmarkList = await _bookmarkedService.getBookmark();
      emit(Result(data: bookmarkList));
    } catch (e) {
      emit(Result(error: e.toString()));
      rethrow;
    }
  }
}
