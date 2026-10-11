import 'package:flutter/material.dart';
import '../core/config/parse_config.dart';
import '../core/theme/app_theme.dart';
import '../services/auth_service.dart';

enum AuthFormMode { signIn, signUp, forgotPassword }

class AuthScreen extends StatefulWidget {
  final AuthService authService;
  final VoidCallback? onAuthSuccess;
  final VoidCallback? onSkipToHome;
  final VoidCallback? onBackToOnboarding;

  const AuthScreen({
    super.key,
    required this.authService,
    this.onAuthSuccess,
    this.onSkipToHome,
    this.onBackToOnboarding,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthFormMode _mode = AuthFormMode.signIn;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController =
      TextEditingController(text: 'dawit.g@yenebunna.et');
  final TextEditingController _passwordController =
      TextEditingController(text: 'bunna2026');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_mode == AuthFormMode.forgotPassword) {
      await widget.authService.requestPasswordReset(
        email: _emailController.text,
      );
      return;
    }

    bool ok;
    if (_mode == AuthFormMode.signIn) {
      ok = await widget.authService.loginWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } else {
      ok = await widget.authService.registerWithEmail(
        fullName: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
    if (ok && mounted) {
      widget.onAuthSuccess?.call();
    }
  }

  Future<void> _handleSocial(AuthProviderType provider) async {
    final ok = await widget.authService.signInWithSocial(provider);
    if (ok && mounted) {
      widget.onAuthSuccess?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.authService,
      builder: (context, _) {
        final error = widget.authService.errorMessage;
        final resetMsg = widget.authService.resetConfirmationMessage;
        final loading = widget.authService.isLoading;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.onBackToOnboarding != null ||
                  widget.onSkipToHome != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.onBackToOnboarding != null)
                      TextButton.icon(
                        onPressed: widget.onBackToOnboarding,
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 15,
                          color: AppTheme.accentGoldLight,
                        ),
                        label: const Text(
                          'Onboarding (3)',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                    if (widget.onSkipToHome != null)
                      TextButton(
                        onPressed: widget.onSkipToHome,
                        child: const Text(
                          'Continue to Home →',
                          style: TextStyle(
                            color: AppTheme.accentGoldLight,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _mode == AuthFormMode.signIn
                          ? 'Sign In to Yene Bunna'
                          : _mode == AuthFormMode.signUp
                              ? 'Create Marketplace Account'
                              : 'Forgot Password Recovery',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    ParseConfig.hasCredentials ? 'Back4App Ready' : 'Local Auth',
                    style: const TextStyle(
                      color: AppTheme.accentGoldLight,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Sync your Ethiopian coffee subscriptions, favorites, and Addis delivery addresses',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 16),

              // 3-Mode Switcher: Sign In | Sign Up | Forgot Password
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _mode == AuthFormMode.signIn
                            ? AppTheme.accentGold
                            : Colors.transparent,
                        side: BorderSide(
                          color: _mode == AuthFormMode.signIn
                              ? AppTheme.accentGold
                              : AppTheme.borderSubtle,
                        ),
                      ),
                      onPressed: () {
                        widget.authService.clearError();
                        setState(() => _mode = AuthFormMode.signIn);
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: _mode == AuthFormMode.signIn
                              ? Colors.black
                              : AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _mode == AuthFormMode.signUp
                            ? AppTheme.accentGold
                            : Colors.transparent,
                        side: BorderSide(
                          color: _mode == AuthFormMode.signUp
                              ? AppTheme.accentGold
                              : AppTheme.borderSubtle,
                        ),
                      ),
                      onPressed: () {
                        widget.authService.clearError();
                        setState(() => _mode = AuthFormMode.signUp);
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: _mode == AuthFormMode.signUp
                              ? Colors.black
                              : AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _mode == AuthFormMode.forgotPassword
                            ? AppTheme.accentGold
                            : Colors.transparent,
                        side: BorderSide(
                          color: _mode == AuthFormMode.forgotPassword
                              ? AppTheme.accentGold
                              : AppTheme.borderSubtle,
                        ),
                      ),
                      onPressed: () {
                        widget.authService.clearError();
                        setState(() => _mode = AuthFormMode.forgotPassword);
                      },
                      child: Text(
                        'Forgot PW',
                        style: TextStyle(
                          color: _mode == AuthFormMode.forgotPassword
                              ? Colors.black
                              : AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              if (_mode == AuthFormMode.signUp) ...[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name (ሙሉ ስም)',
                    prefixIcon: Icon(Icons.person_outline, size: 18),
                  ),
                ),
                const SizedBox(height: 10),
              ],

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.alternate_email, size: 18),
                ),
              ),

              if (_mode != AuthFormMode.forgotPassword) ...[
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline, size: 18),
                  ),
                ),
                if (_mode == AuthFormMode.signIn)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        widget.authService.clearError();
                        setState(() => _mode = AuthFormMode.forgotPassword);
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: AppTheme.accentGoldLight,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],

              if (error != null) ...[
                const SizedBox(height: 10),
                Text(
                  error,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ],

              if (resetMsg != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.highlandGreen),
                  ),
                  child: Text(
                    resetMsg,
                    style: const TextStyle(
                      color: AppTheme.highlandGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentGold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  onPressed: loading ? null : _submitForm,
                  child: Text(
                    loading
                        ? 'Processing...'
                        : _mode == AuthFormMode.signIn
                            ? 'Sign In with Email'
                            : _mode == AuthFormMode.signUp
                                ? 'Create Account'
                                : 'Send Password Reset Link',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),

              if (_mode != AuthFormMode.forgotPassword) ...[
                const SizedBox(height: 14),
                const Center(
                  child: Text(
                    'OR CONTINUE WITH SOCIAL LOGIN',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.borderSubtle),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                        ),
                        onPressed: loading
                            ? null
                            : () => _handleSocial(AuthProviderType.google),
                        icon: const Icon(
                          Icons.g_mobiledata,
                          color: AppTheme.accentGoldLight,
                          size: 22,
                        ),
                        label: const Text(
                          'Google',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.borderSubtle),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                        ),
                        onPressed: loading
                            ? null
                            : () => _handleSocial(AuthProviderType.facebook),
                        icon: const Icon(
                          Icons.facebook,
                          color: Color(0xFF38BDF8),
                          size: 18,
                        ),
                        label: const Text(
                          'Facebook',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
