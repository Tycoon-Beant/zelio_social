import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:zelio_social/config/common.dart';
import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/social/home/all_post_cubit/all_post_list_cubit.dart';
import 'package:zelio_social/social/home/model/all_post_model.dart';
import 'package:zelio_social/social/addpost/cubit/post_cubit.dart';
import 'package:zelio_social/social/top_notch_bottom_nav/top_notch_bottom_nav.dart';

class AddPostScreen extends StatefulWidget {
  final PostModel? post;

  const AddPostScreen({Key? key, this.post}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  String? caption;
  String? tags;
  File? selectedImage;

  final _postKey = GlobalKey<FormState>();

  TextEditingController captionController = TextEditingController();
  TextEditingController tagsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<PostCubit>().state.isLoading;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => TopNotchBottomNav()));
          },
          child: Icon(Icons.arrow_back),
        ),
        title: Text(
          widget.post != null ? "Update Post" : "Upload Post",
          style: context.theme.headlineSmall
              ?.copyWith(fontFamily: FontFamily.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocConsumer<PostCubit, Result<PostsState>>(
            listener: (context, state) {
              if (state.data != null ||
                  state.data?.event == PostEvent.add ||
                  state.data?.event == PostEvent.update) {
                final message = widget.post != null
                    ? "Post Updated Successfully!"
                    : "Post Added Successfully!";
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
                captionController.clear();
                tagsController.clear();
                setState(() {
                  selectedImage = null;
                });
                context.read<AllPostListCubit>().getAllPosts();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TopNotchBottomNav()));
              } else if (state.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error.toString())),
                );
              }
            },
            builder: (context, state) {
              return Form(
                key: _postKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ImageSelection(
                              onImageSelected: (compressedImage) {
                                setState(() {
                                  selectedImage = compressedImage;
                                });
                              },
                            );
                          },
                        );
                      },
                      child: selectedImage == null &&
                              widget.post?.images == null
                          ? DottedBorder(
                              color: Colors.black,
                              strokeWidth: 2,
                              dashPattern: [8, 3],
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              child: Container(
                                width: double.infinity,
                                height: 200,
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      size: 40,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Add Image",
                                      style: context.theme.titleMedium
                                          ?.copyWith(
                                              fontFamily: FontFamily.w700),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: selectedImage != null
                                      ? FileImage(selectedImage!)
                                      : NetworkImage(
                                              widget.post!.images!.first.url!)
                                          as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "Caption:",
                      style: context.theme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: captionController,
                      initialValue: widget.post?.content,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: "Enter caption...",
                        hintStyle: context.theme.bodySmall
                            ?.copyWith(color: Colors.grey),
                      ),
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter a caption'
                          : null,
                      onSaved: (value) => caption = value,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Tags:",
                      style: context.theme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: tagsController,
                      initialValue: widget.post?.tags?.join(","),
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: "Enter tags...",
                        hintStyle: context.theme.bodySmall
                            ?.copyWith(color: Colors.grey),
                      ),
                      onFieldSubmitted: (value) {
                        if (_postKey.currentState!.validate()) {
                          _postKey.currentState?.save();
                          if (widget.post != null) {
                            context.read<PostCubit>().patchpostData(
                                  postId: widget.post!.id!,
                                  content: caption!,
                                  images: selectedImage != null
                                      ? [selectedImage!]
                                      : [],
                                  tags: tags?.split(",") ?? [],
                                );
                          } else {
                            context.read<PostCubit>().addpostData(
                                  caption!,
                                  selectedImage != null ? [selectedImage!] : [],
                                  tags?.split(",") ?? [],
                                );
                          }
                        }
                      },
                      onSaved: (value) => tags = value,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width, 50),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_postKey.currentState!.validate()) {
                                _postKey.currentState?.save();
                                if (widget.post != null) {
                                  context.read<PostCubit>().patchpostData(
                                        postId: widget.post!.id!,
                                        content: caption!,
                                        images: selectedImage != null
                                            ? [selectedImage!]
                                            : [],
                                        tags: tags?.split(",") ?? [],
                                      );
                                } else {
                                  context.read<PostCubit>().addpostData(
                                        caption!,
                                        selectedImage != null
                                            ? [selectedImage!]
                                            : [],
                                        tags?.split(",") ?? [],
                                      );
                                }
                              }
                            },
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              widget.post != null ? 'Update' : 'Upload',
                              style: context.theme.titleMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ImageSelection extends StatelessWidget {
  final Function(File) onImageSelected;

  const ImageSelection({required this.onImageSelected, Key? key})
      : super(key: key);

  Future<File> compressImageWithFlutter(File imageFile) async {
    final compressedBytes = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
      quality: 85,
    );

    final tempDir = Directory.systemTemp;
    final compressedFile = File('${tempDir.path}/compressed_image.jpg');
    return await compressedFile.writeAsBytes(compressedBytes!);
  }

  Future<void> _pickAndCompressImage(
      BuildContext context, ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        final selectedFile = File(pickedFile.path);
        final compressedFile = await compressImageWithFlutter(selectedFile);
        Navigator.of(context).pop();
        onImageSelected(compressedFile);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => _pickAndCompressImage(context, ImageSource.camera),
            icon: const Icon(Icons.camera_alt_outlined),
            color: Colors.black,
            iconSize: 30,
          ),
          IconButton(
            onPressed: () =>
                _pickAndCompressImage(context, ImageSource.gallery),
            icon: const Icon(Icons.file_present_outlined),
            color: Colors.black,
            iconSize: 30,
          ),
        ],
      ),
    );
  }
}
