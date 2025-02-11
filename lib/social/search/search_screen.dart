import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:zelio_social/Widgets/async_widget.dart';
import 'package:zelio_social/config/common.dart';
import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/social/home/model/all_post_model.dart';
import 'package:zelio_social/social/home/all_post_cubit/all_post_list_cubit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isSearch = false;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: isSearch
                ? TextFormField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: "Search...",
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.blue,
                      ),
                    ),
                    autofocus: true, // Automatically focus the field
                    onFieldSubmitted: (value) {
                      // Add logic to handle search action
                      print("Search query: $value");
                    },
                  )
                : Text(
                    "Explore",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: context.colorScheme.primary),
                  ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: InkWell(
                onTap: () {
                  setState(() {
                    isSearch = !isSearch;
                    if (!isSearch) searchController.clear(); // Reset search
                  });
                },
                child: Icon(isSearch ? Icons.close : Icons.search),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 16), // Add spacing for better layout
                BlocListener<AllPostListCubit, Result<List<PostModel>>>(
                  listener: (context, state) {
                    context.read<AllPostListCubit>().getAllPosts();
                  },
                  child: AsyncWidget<AllPostListCubit, List<PostModel>>(
                    data: (posts) {
                      return MasonryView(
                        listOfItem: posts!,
                        numberOfColumn: 2,
                        itemBuilder: (images) {
                          final post = images as PostModel;
                          return Container(
                              child: Image.network(
                            post.images?.firstOrNull?.localPath ?? '',
                            fit: BoxFit.contain,
                          ));
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
