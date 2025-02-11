// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_unlike_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikeModel _$LikeModelFromJson(Map<String, dynamic> json) => LikeModel(
      json['isLiked'] as bool?,
      json['postId'] as String?,
      (json['likes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LikeModelToJson(LikeModel instance) => <String, dynamic>{
      'isLiked': instance.isLiked,
      'postId': instance.postId,
      'likes': instance.likes,
    };

LikeCommentModel _$LikeCommentModelFromJson(Map<String, dynamic> json) =>
    LikeCommentModel(
      json['isLiked'] as bool?,
      json['commentId'] as String?,
      (json['likes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LikeCommentModelToJson(LikeCommentModel instance) =>
    <String, dynamic>{
      'isLiked': instance.isLiked,
      'likes': instance.likes,
      'commentId': instance.commentId,
    };
