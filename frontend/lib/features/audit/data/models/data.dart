import 'dart:convert';

import 'log.dart';

class Data {
	List<Log>? logs;
	int? total;

	Data({this.logs, this.total});

	@override
	String toString() => 'Data(logs: $logs, total: $total)';

	factory Data.fromMap(Map<String, dynamic> data) => Data(
				logs: (data['logs'] as List<dynamic>?)
						?.map((e) => Log.fromMap(e as Map<String, dynamic>))
						.toList(),
				total: data['total'] as int?,
			);

	Map<String, dynamic> toMap() => {
				'logs': logs?.map((e) => e.toMap()).toList(),
				'total': total,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
	factory Data.fromJson(String data) {
		return Data.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
	String toJson() => json.encode(toMap());

	Data copyWith({
		List<Log>? logs,
		int? total,
	}) {
		return Data(
			logs: logs ?? this.logs,
			total: total ?? this.total,
		);
	}
}
