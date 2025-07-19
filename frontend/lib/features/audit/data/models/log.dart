import 'dart:convert';

class Log {
	String? actorName;
	int? createdAt;
	String? actorId;
	String? id;
	String? action;

	Log({this.actorName, this.createdAt, this.actorId, this.id, this.action});

	@override
	String toString() {
		return 'Log(actorName: $actorName, createdAt: $createdAt, actorId: $actorId, id: $id, action: $action)';
	}

	factory Log.fromMap(Map<String, dynamic> data) => Log(
				actorName: data['actor_name'] as String?,
				createdAt: data['created_at'] as int?,
				actorId: data['actor_id'] as String?,
				id: data['id'] as String?,
				action: data['action'] as String?,
			);

	Map<String, dynamic> toMap() => {
				'actor_name': actorName,
				'created_at': createdAt,
				'actor_id': actorId,
				'id': id,
				'action': action,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Log].
	factory Log.fromJson(String data) {
		return Log.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Log] to a JSON string.
	String toJson() => json.encode(toMap());

	Log copyWith({
		String? actorName,
		int? createdAt,
		String? actorId,
		String? id,
		String? action,
	}) {
		return Log(
			actorName: actorName ?? this.actorName,
			createdAt: createdAt ?? this.createdAt,
			actorId: actorId ?? this.actorId,
			id: id ?? this.id,
			action: action ?? this.action,
		);
	}
}
