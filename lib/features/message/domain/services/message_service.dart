import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/logger_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../data/models/message_model.dart';
import '../../data/models/conversation_model.dart';

class MessageService {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;
  final _logger = LoggerHelper('MessageService');

  MessageService({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  }) : _apiService = apiService,
       _connectivityService = connectivityService;

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.checkConnectivity()) {
      throw NoInternetException();
    }
  }

  Future<List<ConversationModel>> getConversations(String eventId) async {
    await _checkConnectivity();
    _logger.i('Fetching conversations for event: $eventId');

    final response = await _apiService.get(
      '${ApiConstants.getConversations}/$eventId',
    );

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if ((data['success'] as bool? ?? false) && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => ConversationModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }

  Future<List<MessageModel>> getMessages(
    String conversationId,
    String eventId,
  ) async {
    await _checkConnectivity();
    _logger.i(
      'Fetching messages for conversation: $conversationId, event: $eventId',
    );

    final response = await _apiService.get(
      '${ApiConstants.getMessages}/$conversationId/$eventId',
    );

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if ((data['success'] as bool? ?? false) && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }

  Future<Map<String, dynamic>> sendMessage(
    String eventId, {
    required String receiverId,
    required String content,
    File? attachmentFile,
  }) async {
    await _checkConnectivity();
    _logger.i('Sending message to: $receiverId for event: $eventId');

    String? attachmentUrl;

    // Optional: Pre-upload the attachment if the API expects an uploaded URL
    // Or attach it directly into FormData if the sendMessage endpoint accepts FormData.
    // Based on priority 38: uploadChatAttachment = '/upload/chat-attachment'
    if (attachmentFile != null) {
      attachmentUrl = await uploadChatAttachment(attachmentFile);
    }

    final response = await _apiService.post(
      '${ApiConstants.sendMessage}/$eventId',
      data: {
        'receiverId': receiverId,
        'content': content,
        if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
      },
    );

    return response.data as Map<String, dynamic>;
  }

  Future<String?> uploadChatAttachment(File file) async {
    await _checkConnectivity();
    _logger.i('Uploading chat attachment: ${file.path}');

    final formData = FormData.fromMap({
      'attachment': await MultipartFile.fromFile(file.path),
    });

    final response = await _apiService.post(
      ApiConstants.uploadChatAttachment,
      data: formData,
    );

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true && data['data'] != null) {
        return data['data']['url']?.toString();
      }
    }
    return null;
  }

  Future<Map<String, dynamic>> markMessageSeen(
    String msgId,
    String eventId,
  ) async {
    await _checkConnectivity();
    _logger.i('Marking message seen: $msgId');

    final response = await _apiService.patch(
      '${ApiConstants.markMessageSeen}/$msgId/$eventId',
    );
    return response.data as Map<String, dynamic>;
  }
}
