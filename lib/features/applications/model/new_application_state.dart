import 'package:flutter/foundation.dart';

@immutable
class NewApplicationState {
  final int currentStep;
  final ApplicantDetails applicantDetails;
  final LandDetails landDetails;
  final List<TreeDetail> trees;
  final Map<String, String?> documents;
  final bool isSubmitting;
  final String? error;

  const NewApplicationState({
    this.currentStep = 0,
    this.applicantDetails = const ApplicantDetails(),
    this.landDetails = const LandDetails(),
    this.trees = const [TreeDetail()],
    this.documents = const {
      'land_proof': null,
      'project_approval': null,
      'site_photos': null,
      'noc_revenue': null,
    },
    this.isSubmitting = false,
    this.error,
  });

  NewApplicationState copyWith({
    int? currentStep,
    ApplicantDetails? applicantDetails,
    LandDetails? landDetails,
    List<TreeDetail>? trees,
    Map<String, String?>? documents,
    bool? isSubmitting,
    String? error,
  }) {
    return NewApplicationState(
      currentStep: currentStep ?? this.currentStep,
      applicantDetails: applicantDetails ?? this.applicantDetails,
      landDetails: landDetails ?? this.landDetails,
      trees: trees ?? this.trees,
      documents: documents ?? this.documents,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }
}

@immutable
class ApplicantDetails {
  final String type;
  final String fullName;
  final String aadhaar;
  final String mobile;
  final String email;
  final String purpose;

  const ApplicantDetails({
    this.type = 'Individual / Citizen',
    this.fullName = '',
    this.aadhaar = '',
    this.mobile = '',
    this.email = '',
    this.purpose = 'Road/Highway Construction',
  });

  ApplicantDetails copyWith({
    String? type,
    String? fullName,
    String? aadhaar,
    String? mobile,
    String? email,
    String? purpose,
  }) {
    return ApplicantDetails(
      type: type ?? this.type,
      fullName: fullName ?? this.fullName,
      aadhaar: aadhaar ?? this.aadhaar,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      purpose: purpose ?? this.purpose,
    );
  }
}

@immutable
class LandDetails {
  final String district;
  final String block;
  final String village;
  final String khasra;
  final String landType;
  final double area;
  final double? latitude;
  final double? longitude;

  const LandDetails({
    this.district = 'Dehradun',
    this.block = '',
    this.village = '',
    this.khasra = '',
    this.landType = 'Private Land',
    this.area = 0.0,
    this.latitude,
    this.longitude,
  });

  LandDetails copyWith({
    String? district,
    String? block,
    String? village,
    String? khasra,
    String? landType,
    double? area,
    double? latitude,
    double? longitude,
  }) {
    return LandDetails(
      district: district ?? this.district,
      block: block ?? this.block,
      village: village ?? this.village,
      khasra: khasra ?? this.khasra,
      landType: landType ?? this.landType,
      area: area ?? this.area,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

@immutable
class TreeDetail {
  final String species;
  final double gbh;
  final double height;
  final int? age;
  final String condition;
  final String? photoPath;

  const TreeDetail({
    this.species = 'Teak (Tectona grandis)',
    this.gbh = 0.0,
    this.height = 0.0,
    this.age,
    this.condition = 'Healthy',
    this.photoPath,
  });

  TreeDetail copyWith({
    String? species,
    double? gbh,
    double? height,
    int? age,
    String? condition,
    String? photoPath,
  }) {
    return TreeDetail(
      species: species ?? this.species,
      gbh: gbh ?? this.gbh,
      height: height ?? this.height,
      age: age ?? this.age,
      condition: condition ?? this.condition,
      photoPath: photoPath ?? this.photoPath,
    );
  }
}
