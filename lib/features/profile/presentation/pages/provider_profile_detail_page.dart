import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme.dart';
import '../bloc/provider_profile_bloc.dart';
import '../bloc/provider_profile_event.dart';
import '../bloc/provider_profile_state.dart';
import '../widgets/skeleton_loading.dart';

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
          _buildSkeletonSection('Reviews'),
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
          else if (title == 'Reviews')
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
          _buildReviewsSection(state.reviews),
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
          Text(
            provider['description'] ?? 'No description available.',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
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
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: services.map((service) => _buildServiceChip(service)).toList(),
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
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: certifications.map((cert) => _buildCertificationChip(cert)).toList(),
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

  Widget _buildReviewsSection(List<Map<String, dynamic>> reviews) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (reviews.isNotEmpty)
                GestureDetector(
                  onTap: () => _openReviewsPage(reviews),
                  child: Row(
                    children: [
                      Text(
                        'View All (${reviews.length})',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: AppTheme.primaryColor,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ...reviews.take(2).map((review) => _buildReviewCard(review)),
          if (reviews.length > 2)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Center(
                child: GestureDetector(
                  onTap: () => _openReviewsPage(reviews),
                  child: Text(
                    'View ${reviews.length - 2} more reviews',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"${review['comment']}"',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(4, (index) => 
              Container(
                margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    review['projectImages'][index],
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
              ),
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
          Text(
            job['title'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '${job['startDate']} - ${job['endDate']}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 16),
              Row(
                children: List.generate(5, (index) => 
                  Icon(
                    Icons.star,
                    size: 16,
                    color: index < (job['rating'] ?? 0) ? Colors.amber : Colors.grey[300],
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${job['rating']}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '"${job['description']}"',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(4, (index) => 
              Container(
                margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
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
              ),
            ),
          ),
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
    // Handle provider selection - navigate back to provider selection or next step
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected ${provider['name']}'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
    // TODO: Navigate to booking confirmation page or back to provider selection
    Navigator.of(context).pop();
  }

  void _openReviewsPage(List<Map<String, dynamic>> reviews) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildReviewsBottomSheet(reviews),
    );
  }

  Widget _buildReviewsBottomSheet(List<Map<String, dynamic>> reviews) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'All Reviews',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          // Reviews list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return _buildDetailedReviewCard(review);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Review header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    review['clientName'][0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['clientName'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        ...List.generate(5, (index) => 
                          Icon(
                            Icons.star,
                            size: 16,
                            color: index < (review['rating'] ?? 0) ? Colors.amber : Colors.grey[300],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          review['date'],
                          style: const TextStyle(
                            fontSize: 12,
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
          const SizedBox(height: 12),
          // Review text
          Text(
            '"${review['comment']}"',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          // Project images
          if (review['projectImages'] != null && review['projectImages'].isNotEmpty)
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review['projectImages'].length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: index < review['projectImages'].length - 1 ? 8 : 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        review['projectImages'][index],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
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
        ],
      ),
    );
  }
}
