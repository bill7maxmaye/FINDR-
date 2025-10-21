import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_header.dart';

class EmailVerificationPage extends StatefulWidget {
  final String? email;
  
  const EmailVerificationPage({
    super.key,
    this.email,
  });

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  bool _isResending = false;

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          } else if (state is AuthAuthenticated) {
            // Navigate to home page after successful verification
            context.go('/home');
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              'assets/images/findr_logo.png',
                              height: 72,
                            ),
                            const SizedBox(height: 12),
                            const AuthHeader(
                              title: 'Verify Your Email',
                              subtitle: 'Enter the verification code sent to your email',
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        if (widget.email != null) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  color: AppTheme.primaryColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Code sent to: ${widget.email}',
                                    style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        AuthTextField(
                          controller: _tokenController,
                          labelText: 'Verification Code',
                          hintText: 'Enter 6-digit code',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter verification code';
                            }
                            if (value.length < 4) {
                              return 'Verification code must be at least 4 characters';
                            }
                            return null;
                          },
                          prefixIcon: Icons.verified_user_outlined,
                        ),
                        const SizedBox(height: 16),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return AuthButton(
                              text: 'Verify Email',
                              isLoading: state is AuthLoading,
                              onPressed: _handleVerification,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Didn't receive the code? "),
                            TextButton(
                              onPressed: _isResending ? null : _handleResendCode,
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.primaryColor,
                              ),
                              child: _isResending
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          AppTheme.primaryColor,
                                        ),
                                      ),
                                    )
                                  : const Text('Resend Code'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Wrong email? "),
                            TextButton(
                              onPressed: () {
                                context.go('/register');
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.primaryColor,
                              ),
                              child: const Text('Change Email'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleVerification() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthVerifyEmailRequested(
              token: _tokenController.text.trim(),
            ),
          );
    }
  }

  void _handleResendCode() async {
    setState(() {
      _isResending = true;
    });

    try {
      context.read<AuthBloc>().add(
            AuthResendVerificationRequested(),
          );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification code sent successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to resend code: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      setState(() {
        _isResending = false;
      });
    }
  }
}

