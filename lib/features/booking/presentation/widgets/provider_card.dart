import 'package:flutter/material.dart';
import '../../../../core/theme.dart';

class ProviderCard extends StatelessWidget {
  final Map<String, dynamic> provider;
  final VoidCallback onSelectProvider;
  final VoidCallback onViewProfile;

  const ProviderCard({
    super.key,
    required this.provider,
    required this.onSelectProvider,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // Header Section - Provider Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Profile Picture with Verification Badge
                Stack(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
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
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.purple,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(width: 12),
                
                // Provider Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider['name'] ?? 'Unknown Provider',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${provider['rating'] ?? 0.0} (${_getReviewCount(provider)} reviews)',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_getTaskCount(provider)} tasks overall',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Price
                Text(
                  '${_getProviderPrice(provider)} Birr',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          
          // Service Description Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How I can help:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    provider['description'] ?? 'Why Choose me? • Price include TWO TASKERS 👥👥 of my team (Labor only) • never last minute cancellation • Last-minute availability • 2h minimum • your belongings are moved safely with caution! satisfaction guaranteed!! Let\'s Make Your Move a Smooth One! Book us today and see why...',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Read More',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF2D5A87),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Customer Review Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reviewer Avatar
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'AJ',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Anneka J. on Tue, Sep 9',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '"Karmel\'s guys (Solo & Jawan) were great. They worked really fast and were super careful with my things. They were also really nice, personable and friendly. Would highly recommend for any move."',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            height: 1.3,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Action Buttons Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Select & Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onSelectProvider,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D5A87),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Select & Continue',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // View Profile Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onViewProfile,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: const BorderSide(color: Colors.grey),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'View Profile & Reviews',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Description Text
                Text(
                  'You can chat with your provider, adjust task details, or change task time after request.',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _getProfileImage(Map<String, dynamic> provider) {
    // Check if profile image exists at top level
    if (provider['profileImage'] != null && provider['profileImage'].isNotEmpty) {
      return Image.network(
        provider['profileImage'],
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildAssetImageAvatar();
        },
      );
    }
    
    // Check if profile image exists in services (old structure)
    if (provider['services'] != null && provider['services'] is List) {
      final services = provider['services'] as List;
      if (services.isNotEmpty && services[0] is Map) {
        final firstService = services[0] as Map<String, dynamic>;
        if (firstService['profileImage'] != null && firstService['profileImage'].isNotEmpty) {
          return Image.network(
            firstService['profileImage'],
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildAssetImageAvatar();
            },
          );
        }
      }
    }
    
    // Fallback to asset image or initials avatar
    return _buildAssetImageAvatar();
  }

  Widget _buildAssetImageAvatar() {
    return Image.asset(
      'assets/images/person.jpg',
      width: 60,
      height: 60,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildInitialsAvatar('P');
      },
    );
  }

  Widget _buildInitialsAvatar(String name) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _getInitials(name),
          style: const TextStyle(
            fontSize: 20,
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

  String _getProviderPrice(Map<String, dynamic> provider) {
    // Check if price is at top level (new structure)
    if (provider['price'] != null) {
      return provider['price'].toString();
    }
    
    // Check if price is in services array (old structure)
    if (provider['services'] != null && provider['services'] is List) {
      final services = provider['services'] as List;
      if (services.isNotEmpty && services[0] is Map) {
        final firstService = services[0] as Map<String, dynamic>;
        if (firstService['price'] != null) {
          return firstService['price'].toString();
        }
      }
    }
    
    return 'N/A';
  }

  String _getReviewCount(Map<String, dynamic> provider) {
    // Check if reviewCount is at top level (new structure)
    if (provider['reviewCount'] != null) {
      return provider['reviewCount'].toString();
    }
    
    // For old structure, generate a realistic review count based on rating
    final rating = provider['rating'] ?? 0.0;
    final served = provider['served'] ?? 0;
    
    // Generate review count based on rating and served count
    if (rating >= 4.5) {
      return (served * 0.8).round().toString(); // 80% of served tasks left reviews
    } else if (rating >= 4.0) {
      return (served * 0.6).round().toString(); // 60% of served tasks left reviews
    } else if (rating >= 3.0) {
      return (served * 0.4).round().toString(); // 40% of served tasks left reviews
    } else {
      return (served * 0.2).round().toString(); // 20% of served tasks left reviews
    }
  }

  String _getTaskCount(Map<String, dynamic> provider) {
    // Check if taskCount is at top level (new structure)
    if (provider['taskCount'] != null) {
      return provider['taskCount'].toString();
    }
    
    // Check if served is available (old structure)
    if (provider['served'] != null) {
      return provider['served'].toString();
    }
    
    return '0';
  }
}
