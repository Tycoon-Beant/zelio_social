import 'package:json_annotation/json_annotation.dart';
import 'package:zelio_social/config/common.dart';

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

  ChatModel(
      {this.id,
      this.name,
      this.isGroupChat,
      this.participants,
      this.admin,
      this.createdAt,
      this.updatedAt,
      this.iV});

  String chatTitle(String? userId){
    if (isGroupChat ?? false) {
      return name ?? "N/A";
    }
    return participants?.where((e) => e.id != userId).singleOrNull?.username ?? "N/A";
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);
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
    if (image == null) {
      return null;
    }
    return "$imageBaseUrl${image.replaceAll("public", "")}";
  }

  factory Avatar.fromJson(Map<String, dynamic> json) => _$AvatarFromJson(json);
}
