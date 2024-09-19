import '../model/cart-item-model.dart';
import '../model/product-model.dart';

class MockDatabase {
  static Map<String, Map<String, String>> _users = {};
  static String? currentUsername;

  static bool signUp(String username, String email, String password) {
    if (_users.containsKey(username)) {
      return false;
    } else {
      _users[username] = {
        'email': email,
        'password': password,
      };
      currentUsername = username;
      return true;
    }
  }

  static bool signIn(String username, String password) {
    if (_users.containsKey(username) &&
        _users[username]!['password'] == password) {
      currentUsername = username;
      return true;
    }
    return false;
  }

  static Map<String, String>? getUserDetails(String username) {
    return _users[username];
  }
}
