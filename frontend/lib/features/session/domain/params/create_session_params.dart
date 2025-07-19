import 'dart:convert';

/// Defines parameters needed to create a new session
///
/// Contains the session details like title that will be sent to create the session
class CreateSessionParam {
  /// The title of the session
  final bool isPublic;

  CreateSessionParam({
    required this.isPublic,
  });

  Map<String, dynamic> toMap() {
    return {
      'is_public': isPublic,
    };
  }

  String toJson() => json.encode(toMap());
}
