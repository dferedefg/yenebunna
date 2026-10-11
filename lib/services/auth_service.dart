import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../core/config/parse_config.dart';
import 'parse_service.dart';

enum AuthProviderType { email, google, facebook }

class AuthUser {
  final String objectId;
  final String fullName;
  final String email;
  final String sessionToken;
  final AuthProviderType provider;
  final String amharicName;

  const AuthUser({
    required this.objectId,
    required this.fullName,
    required this.email,
    required this.sessionToken,
    required this.provider,
    this.amharicName = 'የቡና ደንበኛ',
  });
}

class AuthService extends ChangeNotifier {
  AuthUser? _currentUser = const AuthUser(
    objectId: 'usr-dawit-904',
    fullName: 'Dawit Gebremedhin',
    email: 'dawit.g@yenebunna.et',
    sessionToken: 'r:parse-session-token-demo',
    provider: AuthProviderType.email,
    amharicName: 'ዳዊት ገብረመድኅን',
  );

  bool _isLoading = false;
  String? _errorMessage;
  String? _resetConfirmationMessage;

  AuthUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get resetConfirmationMessage => _resetConfirmationMessage;

  void clearError() {
    _errorMessage = null;
    _resetConfirmationMessage = null;
    notifyListeners();
  }

  Future<bool> loginWithEmail({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _resetConfirmationMessage = null;
    notifyListeners();

    try {
      if (email.trim().isEmpty || password.isEmpty) {
        throw Exception('Please enter both email and password.');
      }

      if (!kIsWeb && ParseConfig.hasCredentials) {
        final uri = Uri.parse(
          '${ParseConfig.serverUrl}/login?username=${Uri.encodeQueryComponent(email.trim())}&password=${Uri.encodeQueryComponent(password)}',
        );
        final client = HttpClient();
        client.connectionTimeout = const Duration(seconds: 5);
        final request = await client.getUrl(uri);
        request.headers.set('X-Parse-Application-Id', ParseConfig.applicationId);
        request.headers.set('X-Parse-Client-Key', ParseConfig.clientKey);
        final response = await request.close();
        if (response.statusCode == 200) {
          final body = await response.transform(utf8.decoder).join();
          final data = jsonDecode(body) as Map<String, dynamic>;
          _currentUser = AuthUser(
            objectId: (data['objectId'] as String?) ?? 'usr-parse',
            fullName: (data['fullName'] as String?) ??
                email.split('@').first.toUpperCase(),
            email: email.trim(),
            sessionToken: (data['sessionToken'] as String?) ?? 'r:session',
            provider: AuthProviderType.email,
          );
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }

      await Future.delayed(const Duration(milliseconds: 350));
      final nameFromEmail = email.trim().split('@').first;
      _currentUser = AuthUser(
        objectId: 'usr-${DateTime.now().millisecondsSinceEpoch}',
        fullName: nameFromEmail[0].toUpperCase() + nameFromEmail.substring(1),
        email: email.trim(),
        sessionToken: 'r:session-${DateTime.now().millisecondsSinceEpoch}',
        provider: AuthProviderType.email,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> registerWithEmail({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _resetConfirmationMessage = null;
    notifyListeners();

    try {
      if (fullName.trim().isEmpty ||
          email.trim().isEmpty ||
          password.length < 6) {
        throw Exception(
          'Provide your full name, valid email, and a 6+ character password.',
        );
      }

      await Future.delayed(const Duration(milliseconds: 400));
      _currentUser = AuthUser(
        objectId: 'usr-${DateTime.now().millisecondsSinceEpoch}',
        fullName: fullName.trim(),
        email: email.trim(),
        sessionToken: 'r:session-${DateTime.now().millisecondsSinceEpoch}',
        provider: AuthProviderType.email,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Idempotent Password Reset Request (`POST /requestPasswordReset`)
  Future<bool> requestPasswordReset({required String email}) async {
    _isLoading = true;
    _errorMessage = null;
    _resetConfirmationMessage = null;
    notifyListeners();

    try {
      final cleanEmail = email.trim().toLowerCase();
      if (cleanEmail.isEmpty || !cleanEmail.contains('@')) {
        throw Exception('Please enter a valid email address.');
      }

      final idempKey = ParseService.computeIdempotencyKey('PWRESET', cleanEmail);

      if (!kIsWeb && ParseConfig.hasCredentials) {
        try {
          final uri = Uri.parse('${ParseConfig.serverUrl}/requestPasswordReset');
          final client = HttpClient();
          client.connectionTimeout = const Duration(seconds: 5);
          final req = await client.postUrl(uri);
          req.headers.set('X-Parse-Application-Id', ParseConfig.applicationId);
          req.headers.set('X-Parse-Client-Key', ParseConfig.clientKey);
          req.headers.set('Content-Type', 'application/json');
          req.add(utf8.encode(jsonEncode({'email': cleanEmail})));
          await req.close();
        } catch (_) {
          // Offline fallback
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 300));
      }

      _resetConfirmationMessage =
          'Password recovery link dispatched to $cleanEmail ($idempKey).';
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithSocial(AuthProviderType provider) async {
    _isLoading = true;
    _errorMessage = null;
    _resetConfirmationMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 350));
    final isGoogle = provider == AuthProviderType.google;
    _currentUser = AuthUser(
      objectId: 'usr-${provider.name}-${DateTime.now().millisecondsSinceEpoch}',
      fullName: isGoogle ? 'Nardos Berhe (Google)' : 'Nardos Berhe (Facebook)',
      email: isGoogle ? 'nardosberhe7@gmail.com' : 'nardos.berhe@facebook.com',
      sessionToken:
          'r:oauth-${provider.name}-${DateTime.now().millisecondsSinceEpoch}',
      provider: provider,
      amharicName: 'ናርዶስ በርሄ',
    );
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void signOut() {
    _currentUser = null;
    notifyListeners();
  }
}
