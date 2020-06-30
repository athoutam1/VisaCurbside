import 'dart:convert';

class Message {
  final String message;
  final String messenger;
  
  Message({
    this.message,
    this.messenger,
  });

  

  Message copyWith({
    String message,
    String messenger,
  }) {
    return Message(
      message: message ?? this.message,
      messenger: messenger ?? this.messenger,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'messenger': messenger,
    };
  }

  static Message fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Message(
      message: map['message'],
      messenger: map['messenger'],
    );
  }

  String toJson() => json.encode(toMap());

  static Message fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Message(message: $message, messenger: $messenger)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Message &&
      o.message == message &&
      o.messenger == messenger;
  }

  @override
  int get hashCode => message.hashCode ^ messenger.hashCode;
}
