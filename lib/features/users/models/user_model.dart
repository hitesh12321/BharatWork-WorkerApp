import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String name;

  final String gender;
  final DateTime? dob;
  final String pincode;
  final String city;
  final String state;
  final String occupation;

  final String lastWork; // 100 chars
  final double experienceYears;

  final String aadharNumber;
  final String panNumber;

  final List<String> photos;
  final String profilePhoto;

  final DateTime? createdAt;

  final int jobsCompleted;
  final double expectedWages;

  final GeoPoint? location;
  final double totalEarnings;

  final List<String> skills;

  final double averageRating;
  final int reviewsCount;

  final String availabilityStatus;

  final String phone;
  final String email;

  final DateTime? lastActiveAt;

  final bool verified;
  final bool isBlocked;

  final Map<String, dynamic> metadata;

  AppUser({
    required this.id,
    required this.name,

    this.gender = "",
    this.dob,
    this.pincode = "",
    this.city = "",
    this.state = "",
    this.occupation = "",
    this.lastWork = "",
    this.experienceYears = 0.0,
    this.aadharNumber = "",
    this.panNumber = "",
    this.photos = const [],
    this.profilePhoto = "",
    this.createdAt,
    this.jobsCompleted = 0,
    this.expectedWages = 0,
    this.location,
    this.totalEarnings = 0.0,
    this.skills = const [],
    this.averageRating = 0.0,
    this.reviewsCount = 0,
    this.availabilityStatus = "available",
    this.phone = "",
    this.email = "",
    this.lastActiveAt,
    this.verified = false,
    this.isBlocked = false,
    this.metadata = const {},
  });

  // -------------------------
  // FROM JSON
  // -------------------------
  factory AppUser.fromJson(Map<String, dynamic> json, String id) {
    GeoPoint? geo;

    // Handle geoPoint
    if (json['location'] is GeoPoint) {
      geo = json['location'] as GeoPoint;
    } else if (json['location'] is Map) {
      final map = json['location'] as Map<String, dynamic>;
      if (map.containsKey('latitude') && map.containsKey('longitude')) {
        geo = GeoPoint(
          (map['latitude'] as num).toDouble(),
          (map['longitude'] as num).toDouble(),
        );
      }
    }

    return AppUser(
      id: id,
      name: json['name'] ?? '',

      gender: json['gender'] ?? "",
      dob: (json['dob'] as Timestamp?)?.toDate(),
      pincode: json['pincode'] ?? "",
      city: json['city'] ?? "",
      state: json['state'] ?? "",
      occupation: json['occupation'] ?? "",
      lastWork: json['last_work'] ?? "",
      experienceYears: (json['experience_years'] as num?)?.toDouble() ?? 0,

      aadharNumber: json['aadhar_number'] ?? "",
      panNumber: json['pan_number'] ?? "",

      photos: (json['photos'] as List?)?.cast<String>() ?? const [],
      profilePhoto: json['profile_photo'] ?? "",

      createdAt: (json['created_at'] as Timestamp?)?.toDate(),
      jobsCompleted: (json['jobs_completed'] as num?)?.toInt() ?? 0,
      expectedWages: (json['expected_wages'] as num?)?.toDouble() ?? 0,

      location: geo,
      totalEarnings: (json['total_earnings'] as num?)?.toDouble() ?? 0,

      skills: (json['skills'] as List?)?.cast<String>() ?? const [],
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0,
      reviewsCount: (json['reviews_count'] as num?)?.toInt() ?? 0,

      availabilityStatus: json['availability_status'] ?? "available",

      phone: json['phone'] ?? "",
      email: json['email'] ?? "",

      lastActiveAt: (json['last_active_at'] as Timestamp?)?.toDate(),
      verified: json['verified'] ?? false,
      isBlocked: json['is_blocked'] ?? false,

      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  // -------------------------
  // TO JSON
  // -------------------------
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender,
      if (dob != null) 'dob': Timestamp.fromDate(dob!),
      'pincode': pincode,
      'city': city,
      'state': state,
      'occupation': occupation,
      'last_work': lastWork,
      'experience_years': experienceYears,
      'aadhar_number': aadharNumber,
      'pan_number': panNumber,
      'photos': photos,
      'profile_photo': profilePhoto,
      if (createdAt != null) 'created_at': Timestamp.fromDate(createdAt!),
      'jobs_completed': jobsCompleted,
      'expected_wages': expectedWages,
      if (location != null) 'location': location,
      'total_earnings': totalEarnings,
      'skills': skills,
      'average_rating': averageRating,
      'reviews_count': reviewsCount,
      'availability_status': availabilityStatus,
      'phone': phone,
      'email': email,
      if (lastActiveAt != null)
        'last_active_at': Timestamp.fromDate(lastActiveAt!),
      'verified': verified,
      'is_blocked': isBlocked,
      'metadata': metadata,
    };
  }
}
