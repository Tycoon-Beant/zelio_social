// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookmarkedPosts _$BookmarkedPostsFromJson(Map<String, dynamic> json) =>
    BookmarkedPosts(
      id: json['_id'] as String?,
      content: json['content'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => Images.fromJson(e as Map<String, dynamic>))
          .toList(),
      author: json['author'] == null
          ? null
          : Author.fromJson(json['author'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      iV: (json['iV'] as num?)?.toInt(),
      comments: (json['comments'] as num?)?.toInt(),
      likes: (json['likes'] as num?)?.toInt(),
      isLiked: json['isLiked'] as bool?,
      isBookmarked: json['isBookmarked'] as bool?,
    );

Map<String, dynamic> _$BookmarkedPostsToJson(BookmarkedPosts instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'content': instance.content,
      'tags': instance.tags,
      'images': instance.images,
      'author': instance.author,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'iV': instance.iV,
      'comments': instance.comments,
      'likes': instance.likes,
      'isLiked': instance.isLiked,
      'isBookmarked': instance.isBookmarked,
    };

Images _$ImagesFromJson(Map<String, dynamic> json) => Images(
      url: json['url'] as String?,
      localPath: Images._localPathFromJson(json['localPath'] as String?),
      id: json['_id'] as String?,
    );

Map<String, dynamic> _$ImagesToJson(Images instance) => <String, dynamic>{
      'url': instance.url,
      'localPath': instance.localPath,
      '_id': instance.id,
    };

Author _$AuthorFromJson(Map<String, dynamic> json) => Author(
      id: json['_id'] as String?,
      coverImage: json['coverImage'] == null
          ? null
          : Images.fromJson(json['coverImage'] as Map<String, dynamic>),
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
      iV: (json['iV'] as num?)?.toInt(),
      account: json['account'] == null
          ? null
          : Account.fromJson(json['account'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
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
    };

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      id: json['_id'] as String?,
      avatar: json['avatar'] == null
          ? null
          : Images.fromJson(json['avatar'] as Map<String, dynamic>),
      username: json['username'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      '_id': instance.id,
      'avatar': instance.avatar,
      'username': instance.username,
      'email': instance.email,
    };
