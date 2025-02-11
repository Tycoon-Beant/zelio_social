import 'package:json_annotation/json_annotation.dart';
import 'package:zelio_social/config/common.dart';
 
part 'follower_following_model.g.dart';
 
@JsonSerializable()
class FollowersFollowingModel {
  @JsonKey(name: "_id")
  String? id;
  Avatar? avatar;
  String? username;
  String? email;
  Profile? profile;
  bool? isFollowing;
 
  FollowersFollowingModel(
      {this.id,
      this.avatar,
      this.username,
      this.email,
      this.profile,
      this.isFollowing});
 
   factory FollowersFollowingModel.fromJson(Map<String, dynamic> json) =>
      _$FollowersFollowingModelFromJson(json);
 
 
}
 
@JsonSerializable()
class Avatar {
  String? url;
  @JsonKey(fromJson: _localPathFromJson)
  String? localPath;
  @JsonKey(name: "_id")
  String? id;
 
   static String? _localPathFromJson(String? image) {
    if (image == null) {
      return null;
    }
    return "$imageBaseUrl${image.replaceAll("public", "")}";
  }


  Avatar({this.url, this.localPath, this.id});
 
   factory Avatar.fromJson(Map<String, dynamic> json) =>
      _$AvatarFromJson(json);
}
 
@JsonSerializable()
class Profile {
  @JsonKey(name: "_id")
  String? id;
  Avatar? coverImage;
  String? firstName;
  String? lastName;
  String? bio;
  String? dob;
  String? location;
  String? countryCode;
  String? phoneNumber;
  String? owner;
  String? createdAt;
  String? updatedAt;
  int? iV;
 
  Profile(
      {this.id,
      this.coverImage,
      this.firstName,
      this.lastName,
      this.bio,
      this.dob,
      this.location,
      this.countryCode,
      this.phoneNumber,
      this.owner,
      this.createdAt,
      this.updatedAt,
      this.iV});
   factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
 
}