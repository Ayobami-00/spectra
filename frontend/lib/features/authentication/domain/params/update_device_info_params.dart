import 'dart:convert';

class UpdateDeviceInfoParam {
  /// The user's mobile device type.
  final String? mobileDeviceType;

  /// The user's one signal id.
  final String? oneSignalId;

  /// The user's mobile version
  final String? mobileVersion;

  UpdateDeviceInfoParam({
    this.mobileDeviceType,
    this.mobileVersion,
    this.oneSignalId,
  });

  Map<String, dynamic> toMap() {
    return {
      "device_type": mobileDeviceType,
      "version": mobileVersion,
      "one_signal_id": oneSignalId
    };
  }

  String toJson() => json.encode(toMap());

  UpdateDeviceInfoParam copyWith({
    String? mobileDeviceType,
    String? mobileVersion,
    String? oneSignalId,
  }) {
    return UpdateDeviceInfoParam(
      mobileDeviceType: mobileDeviceType ?? this.mobileDeviceType,
      mobileVersion: mobileVersion ?? this.mobileVersion,
      oneSignalId: oneSignalId ?? this.oneSignalId,
    );
  }
}
