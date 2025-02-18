

import 'package:json_annotation/json_annotation.dart';
import 'package:zelio_social/config/common.dart';

part 'avilable_user_model.g.dart';

@JsonSerializable()
class AvilableUserModel {
  @JsonKey(name: "_id")
  String? id;
  Avatar? avatar;
  String? username;
  String? email;

  AvilableUserModel({this.id, this.avatar, this.username, this.email});

  factory AvilableUserModel.fromJson(Map<String, dynamic> json) => _$AvilableUserModelFromJson(json);
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
    return "$imageBaseUrl${image.replaceAll("public/", "")}";
  }

  factory Avatar.fromJson(Map<String, dynamic> json) => _$AvatarFromJson(json);
}
