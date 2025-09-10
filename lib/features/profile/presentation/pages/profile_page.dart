import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_action_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(ProfileLoadUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
          onPressed: () {
            // Navigate to edit profile page
            context.go('/edit-profile');
          },
          ),
        ],
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          } else if (state is ProfilePasswordChanged) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password changed successfully'),
                backgroundColor: AppTheme.successColor,
              ),
            );
          } else if (state is ProfileAccountDeleted) {
            // Navigate to login page
            context.go('/login');
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ProfileLoaded || state is ProfileUpdated) {
              final user = state is ProfileLoaded ? state.user : (state as ProfileUpdated).user;
              
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Profile Image Section
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                            backgroundImage: user.profileImageUrl != null
                                ? NetworkImage(user.profileImageUrl!)
                                : null,
                            child: user.profileImageUrl == null
                                ? Icon(
                                    Icons.person,
                                    size: 60,
                                    color: AppTheme.primaryColor,
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {
                                  // Handle image upload
                                  context.read<ProfileBloc>().add(
                                        ProfileUploadImage(imagePath: 'placeholder'),
                                      );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // User Info
                    Text(
                      user.fullName,
                      style: AppTextStyles.heading2,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.email,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Profile Information Cards
                    ProfileInfoCard(
                      title: 'Personal Information',
                      children: [
                        _buildInfoRow('First Name', user.firstName),
                        _buildInfoRow('Last Name', user.lastName),
                        if (user.phoneNumber != null)
                          _buildInfoRow('Phone Number', user.phoneNumber!),
                        _buildInfoRow('Email Verified', user.isEmailVerified ? 'Yes' : 'No'),
                        _buildInfoRow('Account Status', user.isActive ? 'Active' : 'Inactive'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    ProfileInfoCard(
                      title: 'Account Information',
                      children: [
                        _buildInfoRow('Member Since', '${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}'),
                        _buildInfoRow('Last Updated', '${user.updatedAt.day}/${user.updatedAt.month}/${user.updatedAt.year}'),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // Action Buttons
                    ProfileActionButton(
                      icon: Icons.edit,
                      title: 'Edit Profile',
                      onTap: () {
                        context.go('/edit-profile');
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    ProfileActionButton(
                      icon: Icons.lock,
                      title: 'Change Password',
                      onTap: () {
                        context.go('/change-password');
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    ProfileActionButton(
                      icon: Icons.calendar_today,
                      title: 'My Bookings',
                      onTap: () {
                        context.go('/bookings');
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    ProfileActionButton(
                      icon: Icons.logout,
                      title: 'Logout',
                      onTap: () {
                        // Handle logout
                        context.go('/login');
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    ProfileActionButton(
                      icon: Icons.delete_forever,
                      title: 'Delete Account',
                      textColor: AppTheme.errorColor,
                      onTap: () {
                        _showDeleteAccountDialog();
                      },
                    ),
                  ],
                ),
              );
            } else if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.message}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppTheme.errorColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(ProfileLoadUser());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return const Center(
              child: Text('Welcome to Profile'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<ProfileBloc>().add(ProfileDeleteAccount());
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
