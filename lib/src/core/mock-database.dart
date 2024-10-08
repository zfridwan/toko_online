class MockDatabase {
  static Map<String, Map<String, String>> _userData = {
    "validUser": {"email": "user@example.com"},
    // Add more users as needed
  };

  static Map<String, String>? getUserDetails(String username) {
    return _userData[username]; // Returns null if username doesn't exist
  }

  static String? currentUsername;

  static bool signUp(String username, String email, String password) {
    if (_userData.containsKey(username)) {
      return false;
    } else {
      _userData[username] = {
        'email': email,
        'password': password,
      };
      currentUsername = username;
      return true;
    }
  }

  static bool signIn(String username, String password) {
    print("Attempting sign-in with Username: $username, Password: $password");
    if (_userData.containsKey(username) &&
        _userData[username]!['password'] == password) {
      print("Sign-in successful for user: $username");
      currentUsername = username;
      return true;
    }
    print("Sign-in failed for user: $username");
    return false;
  }
}
