import 'package:json_annotation/json_annotation.dart';
import 'package:zelio_social/config/common.dart';
import 'package:zelio_social/social/home/model/all_post_model.dart';

part 'chat_model.g.dart';

@JsonSerializable()
class ChatModel {
  @JsonKey(name: "_id")
  String? id;
  String? name;
  bool? isGroupChat;
  List<Participants>? participants;
  String? admin;
  String? createdAt;
  String? updatedAt;
  int? iV;
  LastMessage? lastMessage;

  ChatModel(
      {this.id,
      this.name,
      this.isGroupChat,
      this.participants,
      this.admin,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.lastMessage});

  String chatTitle(String? userId) {
    if (isGroupChat ?? false) {
      return name ?? "N/A";
    }
    return participants?.where((e) => e.id != userId).singleOrNull?.username ??
        "N/A";
  }

  String? chatAvatar(String userId) {
    return participants
        ?.where((e) => e.id != userId)
        .singleOrNull
        ?.avatar
        ?.localPath;
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);
}

@JsonSerializable()
class LastMessage {
  @JsonKey(name: "_id")
  String? id;
  Sender? sender;
  String? content;
  List<Images>? attachments;
  String? chat;
  String? createdAt;
  String? updatedAt;
  int? iV;

  LastMessage(
      {this.id,
      this.sender,
      this.content,
      this.attachments,
      this.chat,
      this.createdAt,
      this.updatedAt,
      this.iV});

  factory LastMessage.fromJson(Map<String, dynamic> json) =>
      _$LastMessageFromJson(json);
}

@JsonSerializable()
class Sender {
  @JsonKey(name: "_id")
  String? id;
  Avatar? avatar;
  String? username;
  String? email;

  Sender({this.id, this.avatar, this.username, this.email});

  factory Sender.fromJson(Map<String, dynamic> json) => _$SenderFromJson(json);
}

@JsonSerializable()
class Participants {
  @JsonKey(name: "_id")
  String? id;
  Avatar? avatar;
  String? username;
  String? email;
  String? role;
  String? loginType;
  bool? isEmailVerified;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Participants(
      {this.id,
      this.avatar,
      this.username,
      this.email,
      this.role,
      this.loginType,
      this.isEmailVerified,
      this.createdAt,
      this.updatedAt,
      this.iV});

  factory Participants.fromJson(Map<String, dynamic> json) =>
      _$ParticipantsFromJson(json);
}

@JsonSerializable()
class Avatar {
  String? url;
  @JsonKey(fromJson: _localPathFromJson)
  String? localPath;
  @JsonKey(name: "_id")
  String? id;

  Avatar({this.url, this.localPath, this.id});

  static String? _localPathFromJson(String? image) {
    if (image == null || image.isEmpty) {
      return null;
    }
    return "$imageBaseUrl${image.replaceAll("public/", "")}";
  }

  factory Avatar.fromJson(Map<String, dynamic> json) => _$AvatarFromJson(json);
}
