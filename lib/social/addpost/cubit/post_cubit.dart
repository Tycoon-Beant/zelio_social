import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/social/home/model/all_post_model.dart';
import 'package:zelio_social/social/addpost/post_service/add_post_service.dart';

class PostCubit extends Cubit<Result<PostsState>> {
  final AddPostService _addPostService;
  PostCubit(this._addPostService) : super(Result(isLoading: false));

  Future<void> addpostData(String content, List<File> images, List<String> tags) async {
    try {
      emit(Result(isLoading:  true));
      final postData = await _addPostService.addPost(content, images, tags);
      emit(Result(data: PostsState(event: PostEvent.add, post: postData)));
    } catch (e) {
      emit(Result(error: e.toString()));
    }
  }

  Future<void> patchpostData({required String postId,
      required String content,
      required List<File> images,
      required List<String> tags}) async {
    try {
      emit(Result(isLoading:  true));
      final patchData = await _addPostService.patchPost(content:content, images:images, tags:tags, postId: postId);
      emit(Result(data: PostsState(event: PostEvent.update, post: patchData)));
    } catch (e) {
      emit(Result(error: e.toString()));
    }
  }
  
  Future<void> deletePost({required String postId}) async{
    try {
      emit(Result(isLoading: true));
      final delete = await _addPostService.deletePost(postId: postId);
      emit(Result(data: PostsState(event: PostEvent.delete, post: delete)));
    } catch (e) {
      emit(Result(error: e.toString()));
    }
  }
}

class PostsState {
  final PostEvent event;
  final PostModel post;

  PostsState({required this.event, required this.post});
}

enum PostEvent { add, delete, update, clear }
