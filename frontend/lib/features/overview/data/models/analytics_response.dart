class AnalyticsResponse {
  final String? status;

  final String? message;

  final bool hasError;

  final AnalyticsData? data;

  const AnalyticsResponse({
    required this.status,
    required this.message,
    this.data,
    this.hasError = false,
  });

  factory AnalyticsResponse.fromJson(Map<String, dynamic> json) {
    return AnalyticsResponse(
      status: json["status"] as String?,
      message: json["message"] as String?,
      data: json["data"] != null
          ? AnalyticsData.fromJson(
              json["data"]["analytics"],
            )
          : null,
    );
  }

  factory AnalyticsResponse.hasError(String errorMessage) => AnalyticsResponse(
        status: "failed",
        message: errorMessage,
        hasError: true,
      );
}

class AnalyticsData {
  final int total;
  final Map<String, int> byDay;
  final Map<String, int> byWeek;
  final Map<String, int> byYear;
  final Map<String, int> byMonth;

  AnalyticsData({
    required this.total,
    required this.byDay,
    required this.byWeek,
    required this.byYear,
    required this.byMonth,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return AnalyticsData(
      total: json['total'],
      byDay: Map<String, int>.from(json['by_day']),
      byWeek: Map<String, int>.from(json['by_week']),
      byYear: Map<String, int>.from(json['by_year']),
      byMonth: Map<String, int>.from(json['by_month']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'by_day': byDay,
      'by_week': byWeek,
      'by_year': byYear,
      'by_month': byMonth,
    };
  }
}
