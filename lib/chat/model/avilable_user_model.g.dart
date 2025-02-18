// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avilable_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvilableUserModel _$AvilableUserModelFromJson(Map<String, dynamic> json) =>
    AvilableUserModel(
      id: json['_id'] as String?,
      avatar: json['avatar'] == null
          ? null
          : Avatar.fromJson(json['avatar'] as Map<String, dynamic>),
      username: json['username'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$AvilableUserModelToJson(AvilableUserModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'avatar': instance.avatar,
      'username': instance.username,
      'email': instance.email,
    };

Avatar _$AvatarFromJson(Map<String, dynamic> json) => Avatar(
      url: json['url'] as String?,
      localPath: Avatar._localPathFromJson(json['localPath'] as String?),
      id: json['_id'] as String?,
    );

Map<String, dynamic> _$AvatarToJson(Avatar instance) => <String, dynamic>{
      'url': instance.url,
      'localPath': instance.localPath,
      '_id': instance.id,
    };
