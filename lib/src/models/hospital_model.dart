import '../core/constants/hospital_data.dart';

class PanelHospital {
  final int id;
  final String hospitalName;
  final String address;
  final String contact;

  PanelHospital({
    required this.id,
    required this.hospitalName,
    required this.address,
    required this.contact,
  });

  factory PanelHospital.fromMap(Map<String, dynamic> map) {
    return PanelHospital(
      id: map['id'] ?? 0,
      hospitalName: map['hospital'] ?? map['hospital_name'] ?? '',
      address: map['address'] ?? '',
      contact: map['contact'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hospital': hospitalName,
      'address': address,
      'contact': contact,
    };
  }
}

class PanelHospitalRepository {
  static final Map<String, List<Map<String, dynamic>>> cityHospitals = {
    'Karachi': karachiPanelHospital,
    'Lahore': lahorePanelHospital,
    'Islamabad': islamabadPanelHospital,
    'Hyderabad': hyderabadPanelHospital,
    'Shikarpur': shikarpurPanelHosital,
    'Sukkur': sukkurPanelHospital,
    'Burewala': burewalaPanelHospital,
    'Jhelum': jhelumPanelHospital,
    'Gilgit': gilgitPanelHospital,
    'Chitral': chitralPanelHospital,
    'Rawalpindi': rawalpindiPanelHospital,
    'Multan': multanPanelHospital,
    'Faisalabad': faisalabadPanelHospital,
    'Taxila': taxilaPanelHospital,
    'Sargodha': sargodhaPanelHospital,
    'Wah Cantt': wahCantPanelHospital,
    'Mardan': mardanPanelHospital,
    'Gujranwala': gujranwlaPanelHospital,
    'Okara': okaraPanelHospital,
    'Sialkot': sialkotPanelHospital,
    'Sheikhupura': sheikhupuraPanelHospital,
    'Kharian': kharianPanelHospital,
    'Sadiqabad': sadiqabadPanelHospital,
    'Sahiwal': sahiwalPanelHospital,
    'Quetta': quettaPanelHospital,
    'Rahim Yar Khan': rahimYarKhanPanelHospital,
    'Mianwali': mianwaliPanelHospital,
    'Abbottabad': abbotabadPanelHospital,
    'Bahawalpur': bahawalpurPanelHospital,
    'Peshawar': peshawarPanelHospital,
    'Mian Channu': mianChannuPanelHospital,
    'Bhakkar': bhakkarPanelHospital,
    'Jhang': jhangPanelHospital,
  };

  static List<PanelHospital> getHospitalsForCity(String cityName) {
    final hospitals = cityHospitals[cityName] ?? [];
    return hospitals
        .map((hospital) => PanelHospital.fromMap(hospital))
        .toList();
  }

  static List<String> getAllCities() {
    return cityHospitals.keys.toList();
  }
}

