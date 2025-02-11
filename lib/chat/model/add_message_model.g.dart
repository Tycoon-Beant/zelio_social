// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      id: json['_id'] as String?,
      sender: json['sender'] == null
          ? null
          : Sender.fromJson(json['sender'] as Map<String, dynamic>),
      content: json['content'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Images.fromJson(e as Map<String, dynamic>))
          .toList(),
      chat: json['chat'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      iV: (json['iV'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'sender': instance.sender,
      'content': instance.content,
      'attachments': instance.attachments,
      'chat': instance.chat,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'iV': instance.iV,
    };

Sender _$SenderFromJson(Map<String, dynamic> json) => Sender(
      id: json['_id'] as String?,
      avatar: json['avatar'] == null
          ? null
          : Avatar.fromJson(json['avatar'] as Map<String, dynamic>),
      username: json['username'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$SenderToJson(Sender instance) => <String, dynamic>{
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
