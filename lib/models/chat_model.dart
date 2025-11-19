// ROOMS
class SessionModel {
  final String id; // formerly room.id
  final String roomId;
  final Map<String, dynamic> medic;
  final Map<String, dynamic> patient;
  final DateTime startedAt;
  final bool isActive;

  SessionModel({
    required this.id,
    required this.roomId,
    required this.medic,
    required this.patient,
    required this.startedAt,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'roomId': roomId,
    'medic': medic,
    'patient': patient,
    'startedAt': startedAt.toIso8601String(),
    'isActive': isActive,
  };

  factory SessionModel.fromJson(Map<String, dynamic> json) => SessionModel(
    id: json['id'] ?? '',
    roomId: json['roomId'] ?? '',
    medic: Map<String, dynamic>.from(json['medic'] ?? {}),
    patient: Map<String, dynamic>.from(json['patient'] ?? {}),
    startedAt: DateTime.tryParse(json['startedAt'] ?? '') ?? DateTime.now(),
    isActive: json['isActive'] ?? false,
  );

  SessionModel copyWith({
    String? id,
    String? roomId,
    Map<String, dynamic>? medic,
    Map<String, dynamic>? patient,
    DateTime? startedAt,
    bool? isActive,
  }) {
    return SessionModel(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      medic: medic ?? this.medic,
      patient: patient ?? this.patient,
      startedAt: startedAt ?? this.startedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

class RequestSessionModel {
  final String patientId;
  final String medicId;

  RequestSessionModel({
    required this.patientId,
    required this.medicId,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'medicId': medicId,
    };
  }
}

class RequestSessionResponseModel {
  final String message;
  final int statusCode;
  final SessionModel data;

  RequestSessionResponseModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory RequestSessionResponseModel.fromJson(Map<String, dynamic> json) {
    return RequestSessionResponseModel(
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      data: SessionModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'statusCode': statusCode,
      'data': data.toJson(),
    };
  }
}

// MESSAGES
class MessageModel {
  final String id;
  final String roomId;
  final String senderId;
  final String content;

  MessageModel({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'roomId': roomId,
    'senderId': senderId,
    'content': content,
  };

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json['id'] ?? '',
    roomId: json['roomId'] ?? '',
    senderId: json['senderId'] ?? '',
    content: json['content'] ?? '',
  );

}

class MessageRequestModel {
  final String roomId;
  final String senderId;
  final String content;

  MessageRequestModel({
    required this.roomId,
    required this.senderId,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
    'roomId': roomId,
    'senderId': senderId,
    'content': content,
  };
}

class MessageResponseModel {
  final String message;
  final int statusCode;
  final MessageModel data;

  MessageResponseModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory MessageResponseModel.fromJson(Map<String, dynamic> json) {
    return MessageResponseModel(
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      data: MessageModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'statusCode': statusCode,
      'data': data.toJson(),
    };
  }
}
