import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zelio_social/Widgets/async_widget.dart';
import 'package:zelio_social/config/common.dart';
import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/social/addpost/add_post_screen.dart';
import 'package:zelio_social/social/profile/cubit/profile_cubit.dart';
import 'package:zelio_social/social/profile/model/social_profile_model.dart';
import 'package:zelio_social/social/profile/service/profile_service.dart';
import 'package:zelio_social/social/profile/pickup_form_field.dart';

class UpdateProfileDetailScreen extends StatefulWidget {
  const UpdateProfileDetailScreen({super.key});

  @override
  State<UpdateProfileDetailScreen> createState() =>
      _UpdateProfileDetailScreenState();
}

class _UpdateProfileDetailScreenState extends State<UpdateProfileDetailScreen> {
  final profileKey = GlobalKey<FormState>();
  final image = GlobalKey<_ProfileImageStackState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileCubit(context.read<ProfileService>())..getProfile(),
      child: Builder(builder: (context) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.blue),
              title: Text(
                "Profile Details",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Colors.blue),
              ),
            ),
            body: SingleChildScrollView(
              child: BlocListener<ProfileCubit, Result<SocialProfile>>(
                listener: (context, state) {
                  if (state.data != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Successfully updated profile"),
                      ),
                    );
                  }
                  if (state.error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.error.toString(),
                        ),
                      ),
                    );
                  }
                },
                child: AsyncWidget<ProfileCubit, SocialProfile>(
                  data: (SocialProfile? profile) {
                    final profileImg = profile?.coverImage?.url;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: profileKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Center(
                              child: ProfileImageStack(
                                profileImg: profileImg!,
                                key: image,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: Text(
                                'Upload Image',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            BuildTExtField(
                              context: context,
                              label: "First Name",
                              initialValue: profile!.firstName,
                              onSaved: (value) => context
                                  .read<ProfileCubit>()
                                  .updateForm("firstName", value),
                            ),
                            const SizedBox(height: 10),
                            BuildTExtField(
                              context: context,
                              label: "Last Name",
                              initialValue: profile.lastName,
                              onSaved: (value) => context
                                  .read<ProfileCubit>()
                                  .updateForm("lastName", value),
                            ),
                            const SizedBox(height: 10),
                            BuildTExtField(
                              context: context,
                              label: "Phone Number",
                              initialValue: profile.phoneNumber,
                              prefix: CountryCodePicker(
                                padding: EdgeInsets.zero,
                                textStyle: context.theme.titleMedium!
                                    .copyWith(fontFamily: FontFamily.w400),
                                showFlag: false,
                                onChanged: (element) =>
                                    debugPrint(element.dialCode.toString()),
                                initialSelection: profile.countryCode,
                                showCountryOnly: false,
                                favorite: const ['+39', 'FR'],
                              ),
                              onSaved: (value) => context
                                  .read<ProfileCubit>()
                                  .updateForm("phoneNumber", value),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Date of Birth",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.black),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: const [
                                    BoxShadow(
                                        offset: Offset(1, 1),
                                        color:
                                            Color.fromARGB(255, 218, 217, 217),
                                        spreadRadius: 2,
                                        blurRadius: 2)
                                  ]),
                              child: PickerFormField<DateTime>(
                                initialValue:
                                    profile.dob == null ? null : profile.dob!,
                                onSelect: (d) {
                                  return showDatePicker(
                                    context: context,
                                    initialDate: d,
                                    firstDate: DateTime(1947),
                                    lastDate: DateTime.now(),
                                  );
                                },
                                context: context,
                                hint: "Enter your dob",
                              ),
                            ),
                            const SizedBox(height: 10),
                            BuildTExtField(
                              context: context,
                              label: "Location",
                              initialValue: profile.location,
                              onSaved: (value) => context
                                  .read<ProfileCubit>()
                                  .updateForm("location", value),
                            ),
                            const SizedBox(height: 10),
                            BuildTExtField(
                              context: context,
                              label: "Bio",
                              initialValue: profile.bio,
                              onSaved: (value) => context
                                  .read<ProfileCubit>()
                                  .updateForm("bio", value),
                            ),
                            const SizedBox(height: 40),
                            BlocBuilder<ProfileCubit, Result<SocialProfile>>(
                              builder: (context, state) {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width, 50),
                                  ),
                                  onPressed: state.isLoading
                                      ? null
                                      : () {
                                          if (profileKey.currentState!
                                              .validate()) {
                                            profileKey.currentState!.save();
                                            context
                                                .read<ProfileCubit>()
                                                .patchProfileData();
                                            final coverImage = image
                                                .currentState!.selectedImage;
                                            context
                                                .read<ProfileCubit>()
                                                .patchCoverImg(
                                                    image: coverImage!);
                                          }
                                        },
                                  child: state.isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(
                                          "Update Profile",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(color: Colors.white),
                                        ),
                                );
                              },
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class ProfileImageStack extends StatefulWidget {
  const ProfileImageStack({
    super.key,
    required this.profileImg,
  });

  final String profileImg;

  @override
  State<ProfileImageStack> createState() => _ProfileImageStackState();
}

class _ProfileImageStackState extends State<ProfileImageStack> {
  File? selectedImage;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, Result<SocialProfile>>(
      builder: (context, state) {
        return Stack(
          children: [
            if (selectedImage != null)
              Container(
                height: 80,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
                child: CircleAvatar(
                  radius: 10,
                  backgroundImage: FileImage(
                    selectedImage!,
                  ),
                ),
              )
            else if (state.data?.coverImage?.url != null)
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  state.data?.coverImage!.url ?? "",
                ),
              )
            else
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(
                      "assets/social_media/3x/user.png",
                    ),
                  )),
            Positioned(
              top: 50,
              left: 52,
              child: GestureDetector(
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
                  child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: context.colorScheme.onPrimary)),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ))),
            ),
          ],
        );
      },
    );
  }
}

class BuildTExtField extends StatelessWidget {
  const BuildTExtField(
      {super.key,
      required this.context,
      required this.label,
      required this.initialValue,
      required this.onSaved,
      this.prefix});

  final BuildContext context;
  final String label;
  final String? initialValue;
  final Widget? prefix;
  final FormFieldSetter<String>? onSaved;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.black),
        ),
        Container(
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                    offset: Offset(1, 1),
                    color: Color.fromARGB(255, 218, 217, 217),
                    spreadRadius: 2,
                    blurRadius: 2)
              ]),
          child: TextFormField(
            initialValue: initialValue,
            onSaved: onSaved,
            decoration: InputDecoration(
              hintText: 'Enter $label',
              prefixIcon: prefix,
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              hintStyle:
                  const TextStyle(color: Color.fromARGB(255, 191, 189, 189)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
