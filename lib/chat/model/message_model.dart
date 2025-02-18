import 'package:json_annotation/json_annotation.dart';
import 'package:zelio_social/chat/model/chat_model.dart';
import 'package:zelio_social/social/home/model/all_post_model.dart';

part 'message_model.g.dart';

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

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}
