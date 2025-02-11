// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Loginuser _$LoginuserFromJson(Map<String, dynamic> json) => Loginuser(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );

Map<String, dynamic> _$LoginuserToJson(Loginuser instance) => <String, dynamic>{
      'user': instance.user,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['_id'] as String?,
      avatar: json['avatar'] == null
          ? null
          : Avatar.fromJson(json['avatar'] as Map<String, dynamic>),
      username: json['username'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      loginType: json['loginType'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      iV: (json['iV'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.id,
      'avatar': instance.avatar,
      'username': instance.username,
      'email': instance.email,
      'role': instance.role,
      'loginType': instance.loginType,
      'isEmailVerified': instance.isEmailVerified,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'iV': instance.iV,
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
