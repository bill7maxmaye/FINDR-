import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme.dart';

class ProfileDropdown extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? profileImageUrl;
  final bool isInLeading;

  const ProfileDropdown({
    super.key,
    required this.userName,
    required this.userEmail,
    this.profileImageUrl,
    this.isInLeading = false,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      onSelected: (value) {
        switch (value) {
          case 'my-requests':
            context.go('/my-requests');
            break;
          case 'my-reviews':
            context.go('/my-reviews');
            break;
          case 'manage-account':
            context.go('/manage-account');
            break;
          case 'sign-out':
            _showSignOutDialog(context);
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userEmail,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'my-requests',
          child: _buildMenuItem(
            icon: Icons.assignment_outlined,
            title: 'My Request',
          ),
        ),
        PopupMenuItem<String>(
          value: 'my-reviews',
          child: _buildMenuItem(
            icon: Icons.star_outline,
            title: 'My Review',
          ),
        ),
        PopupMenuItem<String>(
          value: 'manage-account',
          child: _buildMenuItem(
            icon: Icons.settings_outlined,
            title: 'Manage Account',
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'sign-out',
          child: _buildMenuItem(
            icon: Icons.logout,
            title: 'Sign out',
            textColor: AppTheme.errorColor,
          ),
        ),
      ],
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: ClipOval(
          child: profileImageUrl != null
              ? profileImageUrl!.startsWith('http')
                  ? Image.network(
                      profileImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar();
                      },
                    )
                  : Image.asset(
                      profileImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar();
                      },
                    )
              : _buildDefaultAvatar(),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.8),
            AppTheme.primaryColor.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Color? textColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: textColor ?? AppTheme.textPrimaryColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: textColor ?? AppTheme.textPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement sign out logic
              context.go('/login');
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
