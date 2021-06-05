class UserProfile {
  final String id;
  final UserDetails user;
  final String occupation;
  final String moreInfo;
  final String address;
  final String city;
  final String state;
  final String country;
  final String pinCode;
  final String socialMedia;
  final String status;

  UserProfile({
    this.id,
    this.user,
    this.occupation,
    this.moreInfo,
    this.address,
    this.city,
    this.state,
    this.country,
    this.pinCode,
    this.socialMedia,
    this.status,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw FormatException("Null JSON provided to Individual");
    }
    return UserProfile(
      id: json['id'],
      user: UserDetails.fromJson(json['user']),
      occupation: json['occupation'],
      moreInfo: json['moreInfo'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      pinCode: json['pinCode'],
      socialMedia: json['socialMedia'],
      status: json['status'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["user"] = user;
    map["occupation"] = occupation;
    map["moreInfo"] = moreInfo;
    map["address"] = address;
    map["city"] = city;
    map["state"] = state;
    map["country"] = country;
    map["pinCode"] = pinCode;
    map["socialMedia"] = socialMedia;
    map["status"] = status;

    return map;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "occupation": occupation,
        "moreInfo": moreInfo,
        "address": address,
        "city": city,
        "state": state,
        "country": country,
        "pinCode": pinCode,
        "socialMedia": socialMedia,
        "status": status,
      };
}

class UserDetails {
  final String email;
  UserDetails({this.email});
  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(email: json['email']);
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["email"] = email;
    return map;
  }

  Map<String, dynamic> toJson() => {
        "email": email,
      };
}
