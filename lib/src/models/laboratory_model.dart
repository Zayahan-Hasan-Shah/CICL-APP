import '../core/constants/lab_discount_data.dart';

class Laboratory {
  final int id;
  final String laboratoryName;
  final String city;
  final String address;
  final String serviceAgiantItsLocation;
  final String contact;

  Laboratory({
    required this.id,
    required this.laboratoryName,
    required this.city,
    required this.address,
    required this.serviceAgiantItsLocation,
    required this.contact,
  });

  factory Laboratory.fromMap(Map<String, dynamic> map) {
    return Laboratory(
      id: map['id'] ?? 0,
      laboratoryName: map['laboratory'] ?? '',
      city: map['city'] ?? '',
      address: map['address'] ?? '',
      serviceAgiantItsLocation: map['serviceAgiantItsLocation'] ?? '',
      contact: map['contact'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'laboratory': laboratoryName,
      'city': city,
      'address': address,
      'serviceAgiantItsLocation': serviceAgiantItsLocation,
      'contact': contact,
    };
  }
}

class LaboratoryRepository {
  static final Map<String, List<Map<String, dynamic>>> laboratoryData = {
    'Dr. Essa Laboratory': drEssaLaboratory,
    'Chugtai Laboratory': chughtaiLaboratory,
    'JP CT Centre': jpCtCentre,
    'Islamabad Diagnostic Laboratory': islamabadDiagnosticlaboratory,
  };

  static List<Laboratory> getLaboratoriesForProvider(String providerName) {
    final laboratories = laboratoryData[providerName] ?? [];
    return laboratories.map((lab) => Laboratory.fromMap(lab)).toList();
  }

  static List<String> getAllLaboratoryProviders() {
    return laboratoryData.keys.toList();
  }
}


