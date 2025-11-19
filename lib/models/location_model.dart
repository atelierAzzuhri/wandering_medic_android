class LocationModel {
  final String id;
  final String ownerId;
  final String latitude;
  final String longitude;
  final String province;
  final String city;
  final String street;

  LocationModel({
    required this.id,
    required this.ownerId,
    required this.latitude,
    required this.longitude,
    required this.province,
    required this.city,
    required this.street,
  });

  Map<String, dynamic> toJson() => {
    'id': id.trim(),
    'ownerId': ownerId.trim(),
    'latitude': latitude.trim(),
    'longitude': longitude.trim(),
    'province': province.trim(),
    'city': city.trim(),
    'street': street.trim(),
  };

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    id: json['id'] ?? '',
    ownerId: json['ownerId'] ?? '',
    latitude: json['latitude'] ?? '',
    longitude: json['longitude'] ?? '',
    province: json['province'] ?? '',
    city: json['city'] ?? '',
    street: json['street'] ?? '',
  );

  @override
  String toString() {
    return 'LocationModel(id: $id, ownerId: $ownerId, lat: $latitude, long: $longitude, province: $province, city: $city, street: $street)';
  }
}

class GetLocationRequestModel {
  final String ownerId;

  const GetLocationRequestModel({required this.ownerId});

  Map<String, dynamic> toJson() => {'ownerId': ownerId.trim()};

  GetLocationRequestModel copyWith({String? ownerId}) {
    return GetLocationRequestModel(ownerId: ownerId ?? this.ownerId);
  }

  @override
  String toString() {
    return 'GetLocationRequestModel(ownerId: $ownerId)';
  }
}

class GetLocationResponseModel {
  final String message;
  final int statusCode;
  final LocationModel data;

  GetLocationResponseModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory GetLocationResponseModel.fromJson(Map<String, dynamic> json) {
    return GetLocationResponseModel(
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      data: LocationModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'statusCode': statusCode,
    'data': data.toJson(),
  };

  @override
  String toString() {
    return 'GetLocationResponseModel(message: $message, statusCode: $statusCode, data: $data)';
  }
}

class CreateLocationRequestModel {
  final String ownerId;
  final String latitude;
  final String longitude;
  final String province;
  final String city;
  final String street;

  const CreateLocationRequestModel({
    required this.ownerId,
    required this.latitude,
    required this.longitude,
    required this.province,
    required this.city,
    required this.street,
  });

  Map<String, dynamic> toJson() => {
    'ownerId': ownerId.trim(),
    'latitude': latitude.trim(),
    'longitude': longitude.trim(),
    'province': province.trim(),
    'city': city.trim(),
    'street': street.trim(),
  };

  CreateLocationRequestModel copyWith({
    String? ownerId,
    String? latitude,
    String? longitude,
    String? province,
    String? city,
    String? street,
  }) {
    return CreateLocationRequestModel(
      ownerId: ownerId ?? this.ownerId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      province: province ?? this.province,
      city: city ?? this.city,
      street: street ?? this.street,
    );
  }

  @override
  String toString() {
    return 'CreateLocationRequestModel(ownerId: $ownerId, lat: $latitude, long: $longitude, province: $province, city: $city, street: $street)';
  }
}

class CreateLocationResponseModel {
  final String message;
  final int statusCode;

  CreateLocationResponseModel({
    required this.message,
    required this.statusCode,
  });

  factory CreateLocationResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateLocationResponseModel(
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'statusCode': statusCode,
  };

  @override
  String toString() {
    return 'CreateLocationResponseModel(message: $message, statusCode: $statusCode)';
  }
}

class UpdateLocationRequestModel {
  final String? latitude;
  final String? longitude;
  final String? province;
  final String? city;
  final String? street;

  const UpdateLocationRequestModel({
    this.latitude,
    this.longitude,
    this.province,
    this.city,
    this.street,
  });

  Map<String, dynamic> toJson() => {
    if (latitude != null) 'latitude': latitude!.trim(),
    if (longitude != null) 'longitude': longitude!.trim(),
    if (province != null) 'province': province!.trim(),
    if (city != null) 'city': city!.trim(),
    if (street != null) 'street': street!.trim(),
  };

  UpdateLocationRequestModel copyWith({
    String? latitude,
    String? longitude,
    String? province,
    String? city,
    String? street,
  }) {
    return UpdateLocationRequestModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      province: province ?? this.province,
      city: city ?? this.city,
      street: street ?? this.street,
    );
  }

  @override
  String toString() {
    return 'UpdateLocationRequestModel(lat: $latitude, long: $longitude, province: $province, city: $city, street: $street)';
  }
}

class UpdateLocationResponseModel {
  final String message;
  final int statusCode;

  const UpdateLocationResponseModel({
    required this.message,
    required this.statusCode,
  });

  factory UpdateLocationResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateLocationResponseModel(
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'statusCode': statusCode,
  };

  @override
  String toString() {
    return 'UpdateLocationResponseModel(message: $message, statusCode: $statusCode)';
  }
}
