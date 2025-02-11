// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) => ChatModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      isGroupChat: json['isGroupChat'] as bool?,
      participants: (json['participants'] as List<dynamic>?)
          ?.map((e) => Participants.fromJson(e as Map<String, dynamic>))
          .toList(),
      admin: json['admin'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      iV: (json['iV'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'isGroupChat': instance.isGroupChat,
      'participants': instance.participants,
      'admin': instance.admin,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'iV': instance.iV,
    };

Participants _$ParticipantsFromJson(Map<String, dynamic> json) => Participants(
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

Map<String, dynamic> _$ParticipantsToJson(Participants instance) =>
    <String, dynamic>{
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
      localPath: Avatar._localPathFromJson(json['localPath'] as String?),
      id: json['_id'] as String?,
    );

Map<String, dynamic> _$AvatarToJson(Avatar instance) => <String, dynamic>{
      'url': instance.url,
      'localPath': instance.localPath,
      '_id': instance.id,
    };
