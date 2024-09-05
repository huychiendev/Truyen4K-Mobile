class AuthService {
  Future<bool> login(String email, String password) async {
    // Simulate API login response
    await Future.delayed(Duration(seconds: 2));
    return email == 'test@example.com' && password == '123456';
  }
}