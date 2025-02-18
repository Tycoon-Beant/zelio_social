import 'package:json_annotation/json_annotation.dart';
import 'package:zelio_social/config/common.dart';

part 'all_post_model.g.dart';

// class TotalPost {
//   List<PostModel>? posts;
//   num? totalPosts;

//   TotalPost({
//     this.posts,
//     this.totalPosts,
//   });
// }

@JsonSerializable()
class PostModel {
  @JsonKey(name: "_id")
  String? id;
  String? content;
  List<String>? tags;
  List<Images>? images;
  Author? author;
  DateTime? createdAt;
  String? updatedAt;
  num? iV;
  int? comments;
  int? likes;
  bool? isLiked;
  bool? isBookmarked;

  PostModel(
      {this.id,
      this.content,
      this.tags,
      this.images,
      this.author,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.comments,
      this.likes,
      this.isLiked,
      this.isBookmarked});

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  PostModel copyWith({
        String? id,
        String? content,  
        List<String>? tags,
        List<Images>? images,
        Author? author,
        DateTime? createdAt,
        DateTime? updatedAt,
        int? v,
        int? comments,
        int? likes,
        bool? isLiked,
        bool? isBookmarked,
    }) =>
        PostModel(
            id: id ?? this.id,
            content: content ?? this.content,
            tags: tags ?? this.tags,
            images: images ?? this.images,
            author: author ?? this.author,
            createdAt: createdAt ?? this.createdAt,
           
            comments: comments ?? this.comments,
            likes: likes ?? this.likes,
            isLiked: isLiked ?? this.isLiked,
            isBookmarked: isBookmarked ?? this.isBookmarked,
        );

}

@JsonSerializable()
class Images {
  String? url;
  @JsonKey(fromJson: _localPathFromJson)
  String? localPath;
  @JsonKey(name: "_id")
  String? id;

  Images({this.url, this.localPath, this.id});

  static String? _localPathFromJson(String? image) {
    if (image == null) {
      return null;
    }
    return "$imageBaseUrl${image.replaceAll("public/", "")}";
  }

  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);
}

@JsonSerializable()
class Author {
  @JsonKey(name: "_id")
  String? id;
  Images? coverImage;
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

  Author(
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
      this.account});

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);
}

@JsonSerializable()
class Account {
  @JsonKey(name: "_id")
  String? id;
  Images? avatar;
  String? username;
  String? email;

  Account({this.id, this.avatar, this.username, this.email});

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}
