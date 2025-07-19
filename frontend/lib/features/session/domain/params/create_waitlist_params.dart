class CreateWaitlistParams {
  final String email;
  final String planType;

  CreateWaitlistParams({
    required this.email,
    required this.planType,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'plan_type': planType,
    };
  }
}
