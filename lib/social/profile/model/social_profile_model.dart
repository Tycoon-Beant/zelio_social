
import 'package:json_annotation/json_annotation.dart';
import 'package:zelio_social/config/common.dart';

part 'social_profile_model.g.dart';


@JsonSerializable()
class SocialProfile {
@JsonKey(name: "_id")
  String? id;
  CoverImage? coverImage;
  String? firstName;
  String? lastName;
  String? bio;
  DateTime? dob;
  String? location;
  String? countryCode;
  String? phoneNumber;
  String? owner;
  String? createdAt;
  String? updatedAt;
  num? iV;
  Account? account;
  num? followersCount;
  num? followingCount;
  bool? isFollowing;

  SocialProfile(
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
      this.iV,
      this.account,
      this.followersCount,
      this.followingCount,
      this.isFollowing});

  factory SocialProfile.fromJson(Map<String, dynamic> json ) => _$SocialProfileFromJson(json);
}

@JsonSerializable()
class CoverImage {
  String? url;
  @JsonKey(fromJson: _localPathFromJson)
  String? localPath;
  @JsonKey(name: "_id")
  String? id;

  static String? _localPathFromJson(String? image) {
    if (image == null) {
      return null;
    }
    return "$imageBaseUrl${image.replaceAll("public/", "")}";
  }


  CoverImage({this.url, this.localPath, this.id});

 factory CoverImage.fromJson(Map<String, dynamic> json) => _$CoverImageFromJson(json);
}

@JsonSerializable()
class Account {
  @JsonKey(name: "_id")
  String? id;
  CoverImage? avatar;
  String? username;
  String? email;
  bool? isEmailVerified;

  Account(
      {this.id, this.avatar, this.username, this.email, this.isEmailVerified});

  factory Account.fromJson(Map<String,dynamic> json) => _$AccountFromJson(json);
}

