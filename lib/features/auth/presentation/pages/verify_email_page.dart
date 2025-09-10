import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme.dart';
import '../../presentation/bloc/auth_bloc.dart';
import '../../presentation/bloc/auth_event.dart';
import '../../presentation/bloc/auth_state.dart';

class VerifyEmailPage extends StatefulWidget {
  final String? token;
  const VerifyEmailPage({super.key, this.token});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.token != null) {
      _controller.text = widget.token!;
      _verify();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppTheme.errorColor),
            );
          } else if (state is AuthEmailVerified) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Email verified')),
            );
          }
        },
        builder: (context, state) {
          final loading = state is AuthLoading;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(labelText: 'Token'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: loading ? null : _verify,
                  child: loading ? const CircularProgressIndicator() : const Text('Verify'),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _verify() {
    final token = _controller.text.trim();
    if (token.isNotEmpty) {
      context.read<AuthBloc>().add(AuthVerifyEmailRequested(token: token));
    }
  }
}


