import 'dart:convert';

/// Defines parameters needed to create a new task
///
/// Contains the task details like description and due date that will be sent to create the task
class CreateTaskParam {
  /// The description of the task
  final String? description;

  /// The due date/time for when the task needs to be completed
  final DateTime? dueAt;

  CreateTaskParam({
    this.description,
    this.dueAt,
  });

  CreateTaskParam copyWith({
    String? description,
    DateTime? dueAt,
  }) {
    return CreateTaskParam(
      description: description ?? this.description,
      dueAt: dueAt ?? this.dueAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'title': description,
    };
  }

  String toJson() => json.encode(toMap());
}
