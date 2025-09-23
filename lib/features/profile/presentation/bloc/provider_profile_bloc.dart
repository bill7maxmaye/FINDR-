import 'package:flutter_bloc/flutter_bloc.dart';
import 'provider_profile_event.dart';
import 'provider_profile_state.dart';

class ProviderProfileBloc extends Bloc<ProviderProfileEvent, ProviderProfileState> {
  ProviderProfileBloc() : super(ProviderProfileInitial()) {
    on<ProviderProfileLoad>(_onLoadProviderProfile);
    on<ProviderProfileRefresh>(_onRefreshProviderProfile);
  }

  Future<void> _onLoadProviderProfile(
    ProviderProfileLoad event,
    Emitter<ProviderProfileState> emit,
  ) async {
    emit(ProviderProfileLoading());
    
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data - in real app, this would come from API
      final provider = _getMockProviderData(event.providerId);
      final reviews = _getMockReviews();
      final certifications = _getMockCertifications();
      final completedJobs = _getMockCompletedJobs();
      final availability = _getMockAvailability();
      
      emit(ProviderProfileLoaded(
        provider: provider,
        reviews: reviews,
        certifications: certifications,
        completedJobs: completedJobs,
        availability: availability,
      ));
    } catch (e) {
      emit(ProviderProfileError(message: e.toString()));
    }
  }

  Future<void> _onRefreshProviderProfile(
    ProviderProfileRefresh event,
    Emitter<ProviderProfileState> emit,
  ) async {
    add(ProviderProfileLoad(providerId: event.providerId));
  }

  Map<String, dynamic> _getMockProviderData(String providerId) {
    return {
      'id': providerId,
      'name': 'BILL M.',
      'rating': 4.9,
      'reviewCount': 127,
      'taskCount': 127,
      'price': 129,
      'distance': 2.5,
      'experience': 15,
      'location': 'Austin, TX',
      'profileImage': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      'description': 'Full Stack Developer | React | Next.js | Nest.js | LangChain | AI. I specialize in crafting dynamic, high-performing web applications that bring ideas to life faster, smarter, and with unwavering dedication to quality. My focus is on creating intuitive user interfaces and delivering efficient, reliable, and tailored solutions.',
      'services': ['Electrical Services', 'Plumbing Repairs', 'Interior Painting'],
    };
  }

  List<Map<String, dynamic>> _getMockReviews() {
    return [
      {
        'id': '1',
        'clientName': 'Sarah M.',
        'rating': 5.0,
        'comment': 'Abel did an outstanding job on this project as well. He quickly understood the requirements, provided effective solutions, and delivered everything on time. His skills and reliability make him a top choice for any development project.',
        'date': '2024-01-15',
        'projectImages': [
          'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=300&h=300&fit=crop',
          'https://images.unsplash.com/photo-1551650975-87deedd944c3?w=300&h=300&fit=crop',
          'https://images.unsplash.com/photo-1551434678-e076c223a692?w=300&h=300&fit=crop',
          'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=300&h=300&fit=crop',
        ],
      },
      {
        'id': '2',
        'clientName': 'Michael R.',
        'rating': 5.0,
        'comment': 'Abel did an outstanding job on this project as well. He quickly understood the requirements, provided effective solutions, and delivered everything on time. His skills and reliability make him a top choice for any development project.',
        'date': '2024-01-10',
        'projectImages': [
          'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=300&h=300&fit=crop',
          'https://images.unsplash.com/photo-1551650975-87deedd944c3?w=300&h=300&fit=crop',
          'https://images.unsplash.com/photo-1551434678-e076c223a692?w=300&h=300&fit=crop',
          'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=300&h=300&fit=crop',
        ],
      },
    ];
  }

  List<Map<String, dynamic>> _getMockCertifications() {
    return [
      {
        'id': '1',
        'name': 'Master Electrician',
        'isHighlighted': false,
      },
      {
        'id': '2',
        'name': 'OSHA Certified',
        'isHighlighted': true,
      },
      {
        'id': '3',
        'name': 'Residential Specialist',
        'isHighlighted': false,
      },
    ];
  }

  List<Map<String, dynamic>> _getMockCompletedJobs() {
    return [
      {
        'id': '1',
        'title': 'Front End Redevelopment',
        'startDate': '2024-12-31',
        'endDate': '2025-07-14',
        'rating': 5.0,
        'clientName': 'Sarah M.',
        'description': 'Complete frontend redesign and development using React and Next.js',
        'images': [
          'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=300&h=300&fit=crop',
          'https://images.unsplash.com/photo-1551650975-87deedd944c3?w=300&h=300&fit=crop',
          'https://images.unsplash.com/photo-1551434678-e076c223a692?w=300&h=300&fit=crop',
          'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=300&h=300&fit=crop',
        ],
      },
    ];
  }

  Map<String, dynamic> _getMockAvailability() {
    return {
      'monday': {'start': '8AM', 'end': '6PM', 'available': true},
      'tuesday': {'start': '8AM', 'end': '6PM', 'available': true},
      'wednesday': {'start': '8AM', 'end': '6PM', 'available': true},
      'thursday': {'start': '8AM', 'end': '6PM', 'available': true},
      'friday': {'start': '8AM', 'end': '6PM', 'available': true},
      'saturday': {'start': '9AM', 'end': '4PM', 'available': true},
      'sunday': {'start': '10AM', 'end': '2PM', 'available': false},
    };
  }
}
