abstract class ProviderProfileState {}

class ProviderProfileInitial extends ProviderProfileState {}

class ProviderProfileLoading extends ProviderProfileState {}

class ProviderProfileLoaded extends ProviderProfileState {
  final Map<String, dynamic> provider;
  final List<Map<String, dynamic>> reviews;
  final List<Map<String, dynamic>> certifications;
  final List<Map<String, dynamic>> completedJobs;
  final Map<String, dynamic> availability;

  ProviderProfileLoaded({
    required this.provider,
    required this.reviews,
    required this.certifications,
    required this.completedJobs,
    required this.availability,
  });
}

class ProviderProfileError extends ProviderProfileState {
  final String message;

  ProviderProfileError({required this.message});
}
