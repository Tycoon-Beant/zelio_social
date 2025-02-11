import 'package:json_annotation/json_annotation.dart';
 
part 'comment_model.g.dart';
 
 
@JsonSerializable()
class CommentModel {
  @JsonKey(name: "_id")
  String? id;
  String? content;
  String? postId;
  Author? author;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? likes;
  bool? isLiked;
 
  CommentModel(
      {this.id,
      this.content,
      this.postId,
      this.author,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.likes,
      this.isLiked});
 
 
 
  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
 
CommentModel copyWith({
         String? id,
  String? content,
  String? postId,
  Author? author,
  String? createdAt,
  String? updatedAt,
  int? iV,
  int? likes,
  bool? isLiked,
    }) =>
        CommentModel(
            id: id ?? this.id,
            content: content ?? this.content,
            author: author ?? this.author,
            createdAt: createdAt ?? this.createdAt,
            likes: likes ?? this.likes,
            isLiked: isLiked ?? this.isLiked,
        );

}
 
 
@JsonSerializable()
class Author {
  @JsonKey(name: "_id")
  String? id;
  String? firstName;
  String? lastName;
  Account? account;
 
  Author({this.id, this.firstName, this.lastName, this.account});
 
  factory Author.fromJson(Map<String, dynamic> json) =>
      _$AuthorFromJson(json);
 
}
 
 
@JsonSerializable()
class Account {
 
  @JsonKey(name: "_id")
  String? id;
  Avatar? avatar;
  String? username;
  String? email;
 
  Account({this.id, this.avatar, this.username, this.email});
 
   factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}
 
 
@JsonSerializable()
class Avatar {
  String? url;
  String? localPath;
  @JsonKey(name: "_id")
  String? id;
 
  Avatar({this.url, this.localPath, this.id});
 
  factory Avatar.fromJson(Map<String, dynamic> json) =>
      _$AvatarFromJson(json);
}