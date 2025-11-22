// lib/features/jobs/models/job_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  final String id;
  final String title;
  final String enterprise;
  final double enterpriseRating;
  final int priority;
  final double pay;
  final double distanceFromUser;
  final int verifiedStatus;
  final String phoneNumber;
  final String description;
  final GeoPoint location;
  final String duration;
  final String shift;
  final List<String> skillsRequired;
  final String availableStatus;
  final Map<String, dynamic> jobRequesters;
  final String? jobAssignedTo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String jobType;

  JobModel({
    required this.id,
    required this.title,
    required this.enterprise,
    this.enterpriseRating = 0.0,
    this.priority = 1,
    this.pay = 0.0,
    this.distanceFromUser = 0.0,
    this.verifiedStatus = 3,
    this.phoneNumber = '',
    this.description = '',
    GeoPoint? location,
    this.duration = '',
    this.shift = '',
    this.skillsRequired = const [],
    this.availableStatus = 'open',
    this.jobRequesters = const {},
    this.jobAssignedTo,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.jobType = '',
  })  : location = location ?? const GeoPoint(0, 0),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // -------------------------
  // FROM JSON
  // -------------------------
  factory JobModel.fromJson(Map<String, dynamic> json, String id) {
    GeoPoint parsedLocation = const GeoPoint(0, 0);

    final locationData = json['location'];

    if (locationData is GeoPoint) {
      parsedLocation = locationData;
    } else if (locationData is Map) {
      parsedLocation = GeoPoint(
        (locationData['latitude'] as num?)?.toDouble() ?? 0.0,
        (locationData['longitude'] as num?)?.toDouble() ?? 0.0,
      );
    }

    return JobModel(
      id: id,
      title: json['title'] as String? ?? '',
      enterprise: json['enterprise'] as String? ?? '',
      enterpriseRating:
          (json['enterprise_rating'] as num?)?.toDouble() ?? 0.0,
      priority: (json['priority'] as num?)?.toInt() ?? 1,
      pay: (json['pay'] as num?)?.toDouble() ?? 0.0,
      distanceFromUser:
          (json['distance_from_user'] as num?)?.toDouble() ?? 0.0,
      verifiedStatus: (json['verified_status'] as num?)?.toInt() ?? 3,
      phoneNumber: json['phone_number'] as String? ?? '',
      description: json['description'] as String? ?? '',
      location: parsedLocation,
      duration: json['duration'] as String? ?? '',
      shift: json['shift'] as String? ?? '',
      skillsRequired:
          (json['skills_required'] as List?)?.cast<String>() ?? const [],
      availableStatus: json['available_status'] as String? ?? 'open',
      jobRequesters:
          (json['job_requesters'] as Map?)?.cast<String, dynamic>() ?? const {},
      jobAssignedTo: json['job_assigned_to'] as String?,
      createdAt:
          (json['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt:
          (json['updated_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      jobType: json['job_type'] as String? ?? '',
    );
  }

  // -------------------------
  // TO JSON
  // -------------------------
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'enterprise': enterprise,
      'enterprise_rating': enterpriseRating,
      'priority': priority,
      'pay': pay,
      'distance_from_user': distanceFromUser,
      'verified_status': verifiedStatus,
      'phone_number': phoneNumber,
      'description': description,
      'location': location,
      'duration': duration,
      'shift': shift,
      'skills_required': skillsRequired,
      'available_status': availableStatus,
      'job_requesters': jobRequesters,
      'job_assigned_to': jobAssignedTo,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
      'job_type': jobType,
    };
  }

  // -------------------------
  // COPY WITH
  // -------------------------
  JobModel copyWith({
    String? id,
    String? title,
    String? enterprise,
    double? enterpriseRating,
    int? priority,
    double? pay,
    double? distanceFromUser,
    int? verifiedStatus,
    String? phoneNumber,
    String? description,
    GeoPoint? location,
    String? duration,
    String? shift,
    List<String>? skillsRequired,
    String? availableStatus,
    Map<String, dynamic>? jobRequesters,
    String? jobAssignedTo,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? jobType,
  }) {
    return JobModel(
      id: id ?? this.id,
      title: title ?? this.title,
      enterprise: enterprise ?? this.enterprise,
      enterpriseRating: enterpriseRating ?? this.enterpriseRating,
      priority: priority ?? this.priority,
      pay: pay ?? this.pay,
      distanceFromUser: distanceFromUser ?? this.distanceFromUser,
      verifiedStatus: verifiedStatus ?? this.verifiedStatus,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      description: description ?? this.description,
      location: location ?? this.location,
      duration: duration ?? this.duration,
      shift: shift ?? this.shift,
      skillsRequired: skillsRequired ?? this.skillsRequired,
      availableStatus: availableStatus ?? this.availableStatus,
      jobRequesters: jobRequesters ?? this.jobRequesters,
      jobAssignedTo: jobAssignedTo ?? this.jobAssignedTo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      jobType: jobType ?? this.jobType,
    );
  }
}
