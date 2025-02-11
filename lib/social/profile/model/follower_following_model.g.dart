// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follower_following_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FollowersFollowingModel _$FollowersFollowingModelFromJson(
        Map<String, dynamic> json) =>
    FollowersFollowingModel(
      id: json['_id'] as String?,
      avatar: json['avatar'] == null
          ? null
          : Avatar.fromJson(json['avatar'] as Map<String, dynamic>),
      username: json['username'] as String?,
      email: json['email'] as String?,
      profile: json['profile'] == null
          ? null
          : Profile.fromJson(json['profile'] as Map<String, dynamic>),
      isFollowing: json['isFollowing'] as bool?,
    );

Map<String, dynamic> _$FollowersFollowingModelToJson(
        FollowersFollowingModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'avatar': instance.avatar,
      'username': instance.username,
      'email': instance.email,
      'profile': instance.profile,
      'isFollowing': instance.isFollowing,
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

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      id: json['_id'] as String?,
      coverImage: json['coverImage'] == null
          ? null
          : Avatar.fromJson(json['coverImage'] as Map<String, dynamic>),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      bio: json['bio'] as String?,
      dob: json['dob'] as String?,
      location: json['location'] as String?,
      countryCode: json['countryCode'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      owner: json['owner'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      iV: (json['iV'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      '_id': instance.id,
      'coverImage': instance.coverImage,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'bio': instance.bio,
      'dob': instance.dob,
      'location': instance.location,
      'countryCode': instance.countryCode,
      'phoneNumber': instance.phoneNumber,
      'owner': instance.owner,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'iV': instance.iV,
    };
