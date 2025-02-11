// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import 'package:zelio_social/model/result.dart';
import 'package:zelio_social/social/profile/model/social_profile_model.dart';
import 'package:zelio_social/social/profile/service/profile_service.dart';

class ProfileCubit extends Cubit<Result<SocialProfile>> {
  final Map<String, dynamic> _formData = {};
  final ProfileService _socialProfileService;
  CancelToken? cancelToken;
  ProfileCubit(this._socialProfileService, ) : super(Result(isLoading: true)){
    cancelToken ??= CancelToken();
  }


  Future<void> getProfile({String? username}) async{
    try {
      emit(Result(isLoading: true));
      final profile = await _socialProfileService.getSocialProfile(token: cancelToken);
      emit(Result(data: profile));
    } catch (e) {
      emit(Result(error: e));
    }
  }

   Future<void> patchProfileData() async {
    try {
      emit(Result(isLoading: true));
      final addressDetailPatch = await _socialProfileService.patchProfileDetails(
       data: _formData
      );
      emit(Result(data: addressDetailPatch));
    } catch (e) {
      emit(Result(error: e.toString()));
    }
  }

  void updateForm(String key, dynamic value) {
    _formData[key] = value;
  }

  Future<void> patchCoverImg({required File image,}) async{
    try {
      emit(Result(isLoading: true));
      final patchData = await _socialProfileService.patchCameraImage(coverImage:image);
      emit(Result(data: patchData));
    } catch (e) {
      emit(Result(error:e.toString()));
    }
  }
  

 


  @override
  Future<void> close() {
    cancelToken?.cancel();
    return super.close();
  }
  

}


class MyProfileState {
  final ProfileEvent event;
  final SocialProfile profile;
  MyProfileState({
    required this.event,
    required this.profile,
  });


}

enum ProfileEvent { add, updated}