// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialProfile _$SocialProfileFromJson(Map<String, dynamic> json) =>
    SocialProfile(
      id: json['_id'] as String?,
      coverImage: json['coverImage'] == null
          ? null
          : CoverImage.fromJson(json['coverImage'] as Map<String, dynamic>),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      bio: json['bio'] as String?,
      dob: json['dob'] == null ? null : DateTime.parse(json['dob'] as String),
      location: json['location'] as String?,
      countryCode: json['countryCode'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      owner: json['owner'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      iV: json['iV'] as num?,
      account: json['account'] == null
          ? null
          : Account.fromJson(json['account'] as Map<String, dynamic>),
      followersCount: json['followersCount'] as num?,
      followingCount: json['followingCount'] as num?,
      isFollowing: json['isFollowing'] as bool?,
    );

Map<String, dynamic> _$SocialProfileToJson(SocialProfile instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'coverImage': instance.coverImage,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'bio': instance.bio,
      'dob': instance.dob?.toIso8601String(),
      'location': instance.location,
      'countryCode': instance.countryCode,
      'phoneNumber': instance.phoneNumber,
      'owner': instance.owner,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'iV': instance.iV,
      'account': instance.account,
      'followersCount': instance.followersCount,
      'followingCount': instance.followingCount,
      'isFollowing': instance.isFollowing,
    };

CoverImage _$CoverImageFromJson(Map<String, dynamic> json) => CoverImage(
      url: json['url'] as String?,
      localPath: CoverImage._localPathFromJson(json['localPath'] as String?),
      id: json['_id'] as String?,
    );

Map<String, dynamic> _$CoverImageToJson(CoverImage instance) =>
    <String, dynamic>{
      'url': instance.url,
      'localPath': instance.localPath,
      '_id': instance.id,
    };

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      id: json['_id'] as String?,
      avatar: json['avatar'] == null
          ? null
          : CoverImage.fromJson(json['avatar'] as Map<String, dynamic>),
      username: json['username'] as String?,
      email: json['email'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool?,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      '_id': instance.id,
      'avatar': instance.avatar,
      'username': instance.username,
      'email': instance.email,
      'isEmailVerified': instance.isEmailVerified,
    };
