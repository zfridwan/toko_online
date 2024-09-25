class MockDatabase {
  static Map<String, Map<String, String>> _users = {
    't': {'email': 'test@example.com', 'password': '1'},
  };
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
    print("Attempting sign-in with Username: $username, Password: $password");
    if (_users.containsKey(username) &&
        _users[username]!['password'] == password) {
      print("Sign-in successful for user: $username");
      currentUsername = username;
      return true;
    }
    print("Sign-in failed for user: $username");
    return false;
  }

  static Map<String, String>? getUserDetails(String username) {
    return _users[username];
  }
}
