import 'package:bloc/bloc.dart';
import 'package:zelio_social/chat/model/avilable_user_model.dart';
import 'package:zelio_social/chat/service/get_avilable_user_service.dart';
import 'package:zelio_social/model/result.dart';

class AvilableUserCubit extends Cubit<Result<List<AvilableUserModel>>> {
  final GetAvilableUserService _avilableUserService;
  AvilableUserCubit(this._avilableUserService) : super(Result(isLoading: true)){
    getAvilableUser();
  }

  Future<void> getAvilableUser() async{
    try {
      emit(Result(isLoading: true));
      final users = await _avilableUserService.GetAvilableUser();
      emit(Result(data: users));
    } catch (e) {
      emit(Result(error: e.toString()));
      rethrow;
    }
  }
}
