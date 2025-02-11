// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:zelio_social/config/common.dart';
import 'package:zelio_social/social/home/model/all_post_model.dart';

part 'add_message_model.g.dart';

@JsonSerializable()
class MessageModel {
  @JsonKey(name: "_id")
  String? id;
  Sender? sender;
  String? content;
  List<Images>? attachments;
  String? chat;
  String? createdAt;
  String? updatedAt;
  int? iV;

  MessageModel(
      {this.id,
      this.sender,
      this.content,
      this.attachments,
      this.chat,
      this.createdAt,
      this.updatedAt,
      this.iV});

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);
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
