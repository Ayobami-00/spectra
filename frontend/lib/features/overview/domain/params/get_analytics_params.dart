import 'dart:convert';

class GetAnalyticsParam {
  final String analyticsId;

  GetAnalyticsParam({
    required this.analyticsId,
  });

  Map<String, dynamic> toMap() {
    return {
      "analytics_id": analyticsId,
    };
  }

  String toJson() => json.encode(toMap());

  GetAnalyticsParam copyWith({
    String? analyticsId,
  }) {
    return GetAnalyticsParam(
      analyticsId: analyticsId ?? this.analyticsId,
    );
  }
}
