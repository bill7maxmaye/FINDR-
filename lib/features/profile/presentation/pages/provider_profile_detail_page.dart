import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme.dart';
import '../bloc/provider_profile_bloc.dart';
import '../bloc/provider_profile_event.dart';
import '../bloc/provider_profile_state.dart';
import '../widgets/skeleton_loading.dart';
import '../widgets/date_time_picker_modal.dart';
import '../widgets/task_scheduled_success_dialog.dart';

class ProviderProfileDetailPage extends StatefulWidget {
  final String providerId;
  final String providerName;

  const ProviderProfileDetailPage({
    super.key,
    required this.providerId,
    required this.providerName,
  });

  @override
  State<ProviderProfileDetailPage> createState() => _ProviderProfileDetailPageState();
}

class _ProviderProfileDetailPageState extends State<ProviderProfileDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProviderProfileBloc>().add(
      ProviderProfileLoad(providerId: widget.providerId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.iconColor),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text(
          widget.providerName,
          style: const TextStyle(
            color: AppTheme.iconColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppTheme.iconColor),
            onPressed: () {
              // Handle share
            },
          ),
        ],
      ),
      body: BlocBuilder<ProviderProfileBloc, ProviderProfileState>(
        builder: (context, state) {
          if (state is ProviderProfileLoading) {
            return _buildSkeletonLoading();
          } else if (state is ProviderProfileLoaded) {
            return _buildLoadedContent(state);
          } else if (state is ProviderProfileError) {
            return _buildErrorState(state);
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: BlocBuilder<ProviderProfileBloc, ProviderProfileState>(
        builder: (context, state) {
          if (state is ProviderProfileLoaded) {
            return FloatingActionButton.extended(
              onPressed: () {
                _selectProvider(state.provider);
              },
              backgroundColor: const Color(0xFF2D5A87),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.check),
              label: const Text('Select & Continue'),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SkeletonProfileCard(),
          const SkeletonStatsCard(),
          const SizedBox(height: 16),
          _buildSkeletonSection('Services'),
          const SizedBox(height: 16),
          _buildSkeletonSection('Certifications'),
          const SizedBox(height: 16),
          _buildSkeletonSection('Availability'),
          const SizedBox(height: 16),
          _buildSkeletonSection('Completed Jobs'),
        ],
      ),
    );
  }

  Widget _buildSkeletonSection(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLoading(width: 100, height: 16),
          const SizedBox(height: 12),
          if (title == 'Services' || title == 'Certifications')
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(3, (index) => const SkeletonCertificationChip()),
            )
          else if (title == 'Availability')
            Column(
              children: List.generate(7, (index) => 
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const SkeletonAvailabilityItem(),
                ),
              ),
            )
          else if (title == 'Completed Jobs')
            Column(
              children: List.generate(2, (index) => 
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: const SkeletonReviewCard(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadedContent(ProviderProfileLoaded state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(state.provider),
          _buildStatsSection(state.provider),
          _buildDescriptionSection(state.provider),
          _buildServicesSection(state.provider['services']),
          _buildCertificationsSection(state.certifications),
          _buildAvailabilitySection(state.availability),
          _buildCompletedJobsSection(state.completedJobs),
          const SizedBox(height: 100), // Space for floating button
        ],
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Profile Picture with Verification Badge
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: _getProfileImage(provider),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(width: 16),
          
          // Provider Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider['name'] ?? 'Unknown Provider',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Serving ${provider['location'] ?? 'Unknown Location'}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(Map<String, dynamic> provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.calendar_today,
              title: '${provider['experience'] ?? 0}+ Years Experience',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              icon: Icons.people,
              title: '${provider['taskCount'] ?? 0}+ Completed Jobs',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              icon: Icons.star,
              title: '${provider['rating'] ?? 0.0} Average Rating',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({required IconData icon, required String title}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(Map<String, dynamic> provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              provider['description'] ?? 'No description available.',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection(List<dynamic> services) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Services',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.start,
              children: services.map((service) => _buildServiceChip(service)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceChip(String service) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        service,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCertificationsSection(List<Map<String, dynamic>> certifications) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Certifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.start,
              children: certifications.map((cert) => _buildCertificationChip(cert)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationChip(Map<String, dynamic> certification) {
    final isHighlighted = certification['isHighlighted'] ?? false;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.green[100] : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHighlighted ? Colors.green[300]! : Colors.grey[300]!,
        ),
      ),
      child: Text(
        certification['name'],
        style: TextStyle(
          fontSize: 14,
          color: isHighlighted ? Colors.green[800] : Colors.black87,
          fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildAvailabilitySection(Map<String, dynamic> availability) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Availability',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          ...availability.entries.map((entry) => _buildAvailabilityItem(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildAvailabilityItem(String day, Map<String, dynamic> schedule) {
    final isAvailable = schedule['available'] ?? false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              day.substring(0, 1).toUpperCase() + day.substring(1),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${schedule['start']} - ${schedule['end']}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isAvailable ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCompletedJobsSection(List<Map<String, dynamic>> completedJobs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Completed Jobs',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          ...completedJobs.map((job) => _buildCompletedJobCard(job)),
        ],
      ),
    );
  }

  Widget _buildCompletedJobCard(Map<String, dynamic> job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${job['startDate']} - ${job['endDate']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              // Job Rating
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...List.generate(5, (index) => 
                      Icon(
                        Icons.star,
                        size: 14,
                        color: index < (job['rating'] ?? 0) ? Colors.amber : Colors.grey[300],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${job['rating']}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Job Description
          Text(
            '"${job['description']}"',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          
          // Job Images
          if (job['images'] != null && job['images'].isNotEmpty)
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: job['images'].length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: index < job['images'].length - 1 ? 8 : 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        job['images'][index],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          
          // Client Review Section (Upwork-style)
          if (job['clientReview'] != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Client Info and Rating
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            job['clientReview']['clientName'][0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job['clientReview']['clientName'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                ...List.generate(5, (index) => 
                                  Icon(
                                    Icons.star,
                                    size: 12,
                                    color: index < (job['clientReview']['rating'] ?? 0) ? Colors.amber : Colors.grey[300],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  job['clientReview']['date'],
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Client Review Comment
                  Text(
                    '"${job['clientReview']['comment']}"',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      fontStyle: FontStyle.italic,
                      height: 1.3,
                    ),
                  ),
                  
                  // Project Images from Review
                  if (job['clientReview']['projectImages'] != null && job['clientReview']['projectImages'].isNotEmpty) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: job['clientReview']['projectImages'].length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(right: index < job['clientReview']['projectImages'].length - 1 ? 6 : 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                job['clientReview']['projectImages'][index],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image, color: Colors.grey, size: 16),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(ProviderProfileError state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading profile',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<ProviderProfileBloc>().add(
                  ProviderProfileRefresh(providerId: widget.providerId),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getProfileImage(Map<String, dynamic> provider) {
    // Always use the person.jpg asset image
    return Image.asset(
      'assets/images/person.jpg',
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print('Asset image loading error: $error');
        return _buildInitialsAvatar(provider['name'] ?? '');
      },
    );
  }

  Widget _buildInitialsAvatar(String name) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _getInitials(name),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'P';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  void _selectProvider(Map<String, dynamic> provider) {
    // Show date/time picker modal
    showDialog(
      context: context,
      builder: (context) => DateTimePickerModal(
        providerName: provider['name'] ?? 'Provider',
        providerInitials: _getInitials(provider['name'] ?? 'Provider'),
        onConfirm: (selectedDate, selectedTime) {
          _showSuccessDialog(provider, selectedDate, selectedTime);
        },
      ),
    );
  }


  void _showSuccessDialog(Map<String, dynamic> provider, DateTime selectedDate, String selectedTime) {
    final taskTitle = 'Task with ${provider['name']}';
    final scheduledDate = _formatDate(selectedDate);
    
    TaskScheduledSuccessDialog.show(
      context: context,
      taskTitle: taskTitle,
      scheduledDate: scheduledDate,
      scheduledTime: selectedTime,
      providerName: provider['name'] ?? 'Provider',
      onViewRequest: () {
        // Navigate to bookings page or request details
        context.go('/bookings');
      },
      onClose: () {
        // Navigate back to home or provider selection
        context.go('/home');
      },
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

}

