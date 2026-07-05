import 'package:geo_attend/models/user_model.dart';

class UserService {
  // get current user
  Future<UserModel> getCurrentUser() async {
    await Future.delayed(Duration(seconds: 1));

    return UserModel(userId: "124214", userName: "John Doe");
  }
}
