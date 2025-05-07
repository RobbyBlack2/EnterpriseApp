class Session {
  //Session Model used for storing the users session data when filling out the screens

  String? lang;
  String? fname;
  String? lname;
  String? email;
  String? phone;
  String? dob;
  String? qtext1;
  String? atext1;
  String? qtext2;
  String? atext2;
  String? qyn1;
  String? ayn1;
  String? qyn2;
  String? ayn2;
  String? reason;
  String? subreason;

  Session({
    this.lang,
    this.fname,
    this.lname,
    this.email,
    this.phone,
    this.dob,
    this.qtext1,
    this.atext1,
    this.qtext2,
    this.atext2,
    this.qyn1,
    this.ayn1,
    this.qyn2,
    this.ayn2,
    this.reason,
    this.subreason,
  });
  void clear() {
    lang = null;
    fname = null;
    lname = null;
    email = null;
    phone = null;
    dob = null;
    qtext1 = null;
    atext1 = null;
    qtext2 = null;
    atext2 = null;
    qyn1 = null;
    ayn1 = null;
    qyn2 = null;
    ayn2 = null;
    reason = null;
    subreason = null;
  }

  //tojson
  Map<String, dynamic> toJson() {
    return {
      'lang': lang,
      'fname': fname,
      'lname': lname,
      'email': email,
      'phone': phone,
      'dob': dob,
      'qtext1': qtext1,
      'atext1': atext1,
      'qtext2': qtext2,
      'atext2': atext2,
      'qyn1': qyn1,
      'ayn1': ayn1,
      'qyn2': qyn2,
      'ayn2': ayn2,
      'reason': reason,
      'subreason': subreason,
    };
  }
}
