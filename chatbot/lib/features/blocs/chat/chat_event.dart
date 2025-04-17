abstract class ChatEvent {}

class LoadChatHistory extends ChatEvent {
  final String userId;
  LoadChatHistory(this.userId);
}

class SendChatMessage extends ChatEvent {
  final String userId;
  final String message;

  SendChatMessage({required this.userId, required this.message});
}

class SendVoiceMessage extends ChatEvent {
  final String userId;
  final String voiceMessage;

  SendVoiceMessage({required this.userId, required this.voiceMessage});
}