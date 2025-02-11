// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      id: json['_id'] as String?,
      content: json['content'] as String?,
      postId: json['postId'] as String?,
      author: json['author'] == null
          ? null
          : Author.fromJson(json['author'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      iV: (json['iV'] as num?)?.toInt(),
      likes: (json['likes'] as num?)?.toInt(),
      isLiked: json['isLiked'] as bool?,
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'content': instance.content,
      'postId': instance.postId,
      'author': instance.author,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'iV': instance.iV,
      'likes': instance.likes,
      'isLiked': instance.isLiked,
    };

Author _$AuthorFromJson(Map<String, dynamic> json) => Author(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      account: json['account'] == null
          ? null
          : Account.fromJson(json['account'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'account': instance.account,
    };

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      id: json['_id'] as String?,
      avatar: json['avatar'] == null
          ? null
          : Avatar.fromJson(json['avatar'] as Map<String, dynamic>),
      username: json['username'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      '_id': instance.id,
      'avatar': instance.avatar,
      'username': instance.username,
      'email': instance.email,
    };

Avatar _$AvatarFromJson(Map<String, dynamic> json) => Avatar(
      url: json['url'] as String?,
      localPath: json['localPath'] as String?,
      id: json['_id'] as String?,
    );

Map<String, dynamic> _$AvatarToJson(Avatar instance) => <String, dynamic>{
      'url': instance.url,
      'localPath': instance.localPath,
      '_id': instance.id,
    };
