
import 'package:zelio_social/chat/model/avilable_user_model.dart';
import 'package:zelio_social/services/dio_instance.dart';

class GetAvilableUserService {
  GetAvilableUserService();

  Future<List<AvilableUserModel>> GetAvilableUser() async{
    try {
      final response = await DioSingleton.instance.dio.get("chat-app/chats/users");
      final body = response.data;
     final  List<dynamic> jsonResponse = body["data"];
      return jsonResponse.map((e) => AvilableUserModel.fromJson(e)).toList();
    } catch (e) {
      print("Error in getting users: ${e.toString()}");
      rethrow;
    }
  }
}