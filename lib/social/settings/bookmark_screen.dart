import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zelio_social/Widgets/async_widget.dart';
import 'package:zelio_social/social/profile/cubit/get_bookmark_list_cubit.dart';
import 'package:zelio_social/social/profile/model/bookmark_model.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetBookmarkListCubit(context.read()),
      child: Builder(builder: (context) {
        return Scaffold(
          body: Container(
            child: AsyncWidget<GetBookmarkListCubit, List<BookmarkedPosts>>(
                data: (bookmark) {
              final bookmarksList = bookmark;
              return Expanded(
                child: ListView.builder(
                  itemCount: bookmarksList?.length,
                  itemBuilder: (BuildContext context, int index) {
                    final bookmark = bookmarksList?[index];
                    return Text(bookmark!.author!.firstName!);
                  },
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}
