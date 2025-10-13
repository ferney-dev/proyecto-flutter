import 'dart:convert';

class Empresa {
  final int? id;
  final String? name;
  final String? taxId;
  final String? legalName;
  final String? address;
  final String? phone;
  final String? website;
  final int? employeeCount;
  final String? economicSector;
  final String? description;
  final int? existenceYears;
  final String? legalDocument;
  final String? legalFirstName;
  final String? legalLastName;
  final String? legalRepresentativeName;
  final String? legalRepresentativeRole;
  final String? legalRepresentativePhone;
  final String? legalRepresentativeEmail;
  final String? landline;
  final String? legalMobile;
  final String? email;
  final String? legalPosition;
  final int? cityId;
  final City? city;

  Empresa({
    this.id,
    this.name,
    this.taxId,
    this.legalName,
    this.address,
    this.phone,
    this.website,
    this.employeeCount,
    this.economicSector,
    this.description,
    this.existenceYears,
    this.legalDocument,
    this.legalFirstName,
    this.legalLastName,
    this.legalRepresentativeName,
    this.legalRepresentativeRole,
    this.legalRepresentativePhone,
    this.legalRepresentativeEmail,
    this.landline,
    this.legalMobile,
    this.email,
    this.legalPosition,
    this.cityId,
    this.city,
  });

  factory Empresa.fromJson(Map<String, dynamic> json) => Empresa(
        id: json["id"],
        name: json["name"],
        taxId: json["taxId"],
        legalName: json["legalName"],
        address: json["address"],
        phone: json["phone"],
        website: json["website"],
        employeeCount: json["employeeCount"],
        economicSector: json["economicSector"],
        description: json["description"],
        existenceYears: json["existenceYears"],
        legalDocument: json["legalDocument"],
        legalFirstName: json["legalFirstName"],
        legalLastName: json["legalLastName"],
        legalRepresentativeName: json["legalRepresentativeName"],
        legalRepresentativeRole: json["legalRepresentativeRole"],
        legalRepresentativePhone: json["legalRepresentativePhone"],
        legalRepresentativeEmail: json["legalRepresentativeEmail"],
        landline: json["landline"],
        legalMobile: json["legalMobile"],
        email: json["email"],
        legalPosition: json["legalPosition"],
        cityId: json["cityId"],
        city: json["city"] != null ? City.fromJson(json["city"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "taxId": taxId,
        "legalName": legalName,
        "address": address,
        "phone": phone,
        "website": website,
        "employeeCount": employeeCount,
        "economicSector": economicSector,
        "description": description,
        "existenceYears": existenceYears,
        "legalDocument": legalDocument,
        "legalFirstName": legalFirstName,
        "legalLastName": legalLastName,
        "legalRepresentativeName": legalRepresentativeName,
        "legalRepresentativeRole": legalRepresentativeRole,
        "legalRepresentativePhone": legalRepresentativePhone,
        "legalRepresentativeEmail": legalRepresentativeEmail,
        "landline": landline,
        "legalMobile": legalMobile,
        "email": email,
        "legalPosition": legalPosition,
        "cityId": cityId,
        "city": city?.toJson(),
      };
}

// 🔹 Modelo interno para City
class City {
  final int? id;
  final String? name;
  final int? departmentId;

  City({
    this.id,
    this.name,
    this.departmentId,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
        departmentId: json["departmentId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "departmentId": departmentId,
      };
}

// ✅ Funciones auxiliares
List<Empresa> empresasFromJson(String str) =>
    List<Empresa>.from(json.decode(str)["data"].map((x) => Empresa.fromJson(x)));
