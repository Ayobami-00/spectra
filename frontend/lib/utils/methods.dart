import 'package:flutter/widgets.dart';
import 'package:frontend/utils/constants.dart';

void changeFocuNode({
  FocusNode? from,
  FocusNode? to,
  required BuildContext context,
}) {
  from!.unfocus();
  FocusScope.of(context).requestFocus(to);
}

String generateWhatsappLink(String taskId) {
  const baseUrl = "https://api.whatsapp.com/send/";
  const phoneNumber = AppConstants.whatsAppBotNumber; // WhatsApp bot number
  final message =
      "Hello, I'm new to Spectra! I just created my first task with task ID : $taskId.";

  final params = {
    "phone": phoneNumber,
    "text": message,
  };

  final queryString = Uri(queryParameters: params).query;
  return "$baseUrl?$queryString";
}
