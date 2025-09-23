abstract class ProviderProfileEvent {}

class ProviderProfileLoad extends ProviderProfileEvent {
  final String providerId;

  ProviderProfileLoad({required this.providerId});
}

class ProviderProfileRefresh extends ProviderProfileEvent {
  final String providerId;

  ProviderProfileRefresh({required this.providerId});
}
