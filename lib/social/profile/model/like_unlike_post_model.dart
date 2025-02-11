import 'package:json_annotation/json_annotation.dart';

part 'like_unlike_post_model.g.dart';

@JsonSerializable()
class LikeModel {
  LikeModel(this.isLiked, this.postId, this.likes);
 
  bool? isLiked;
  String? postId;
  int? likes;

  factory LikeModel.fromJson(Map<String, dynamic> json) => _$LikeModelFromJson(json);
}

@JsonSerializable()
class LikeCommentModel{
  bool? isLiked;
  int? likes;
  String? commentId;

  LikeCommentModel(this.isLiked , this.commentId, this.likes);

  factory LikeCommentModel.fromJson(Map<String, dynamic> json) => _$LikeCommentModelFromJson(json);
}