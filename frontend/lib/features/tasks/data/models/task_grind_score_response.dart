class TaskGrindScoreResponse {
  final int? grindScore;
  final int? totalTasks;
  final String? message;
  final bool hasError;

  const TaskGrindScoreResponse({
    this.grindScore,
    this.totalTasks,
    this.message,
    this.hasError = false,
  });

  factory TaskGrindScoreResponse.fromJson(Map<String, dynamic> json) {
    return TaskGrindScoreResponse(
      grindScore: json["grind_score"] as int?,
      totalTasks: json["total_tasks"] as int?,
    );
  }

  factory TaskGrindScoreResponse.hasError(String errorMessage) =>
      TaskGrindScoreResponse(
        message: errorMessage,
        hasError: true,
      );
}
