class UserProfile {

  // uid, Name, Email, Password, Selfie
  int? _id;
  String? _uid;
  String? _userDisplayName;
  String? _userEmail;
  String? _userPassword;
  String? _date;
  String? _selfieString;

//  int _id;
//  String _title;
//  String _description;
//  String _date;
//  int _priority;

  UserProfile(this._uid, this._userDisplayName, this._userEmail, this._userPassword, this._date, [this._selfieString]);

  UserProfile.withId(this._id, this._uid, this._userDisplayName, this._userEmail, this._userPassword, this._date, [this._selfieString]);

  //Note(this._title, this._date, this._priority, [this._description]);

  //Note.withId(this._id, this._title, this._date, this._priority,[this._description]);

//
//  int get id => _id;
//
//  String get title => _title;
//
//  String get description => _description;
//
//  int get priority => _priority;
//
//  String get date => _date;

  int? get id => _id;
  String? get uid => _uid;
  String get userDisplayName => _userDisplayName!;
  String get userEmail => _userEmail!;
  String get userPassword => _userPassword!;
  String get selfieString => _selfieString!;
  String get date => _date!;

  set uid (String? newUid) {
    //if (uid.length>0){
      this._uid=newUid;
    //}
  }

  set userDisplayName (String newUserDisplayName) {
    if (newUserDisplayName.length>0){
      if (newUserDisplayName.length>50) {
        this._userDisplayName = newUserDisplayName.substring(0,50);
      } else {
        this._userDisplayName=newUserDisplayName;
      }
    }
  }

  set userEmail (String newUserEmail) {
    if (newUserEmail.length>0){
      this._userEmail=newUserEmail;
    }
  }

  set userPassword (String newUserPassword) {
    if (newUserPassword.length>0) {
      this._userPassword = newUserPassword;
    }
  }

  set date (String newDate) {
    if (newDate.length>0){
      this._date=newDate;
    }
  }

  set selfieString (String newSelfieString) {
    if (newSelfieString.length>0) {
      this._selfieString=newSelfieString;
    }
  }

//  set title(String newTitle) {
//    if (newTitle.length <= 255) {
//      this._title = newTitle;
//    }
//  }
//
//  set description(String newDescription) {
//    if (newDescription.length <= 255) {
//      this._description = newDescription;
//    }
//  }
//
//  set priority (int newPriority) {
//    if (newPriority>=1 && newPriority<=2) {
//      this._priority = newPriority;
//    }
//  }
//
//  set date (String newDate) {
//    this._date = newDate;
//  }

  // Convert a Note object into a Map object
  // bisa Map<String, String> atau <String, int>, etc
  // dynamic itu bisa tipe apapun
//  Map<String, dynamic> toMap() {
//    var map = Map<String, dynamic>();
//
//    if (id !=null) {
//      map['id'] = _id;
//    }
//    map['title']=_title;
//    map['description']=_description;
//    map['priority']=_priority;
//    map['date']=_date;
//
//    return map;
//  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id!=null) {
      map['id']=_id;
    }

    if (uid!=null && _userEmail!=null && _userPassword!=null) {
      map['uid'] = _uid;
      map['userEmail'] = _userEmail;
      map['userPassword']=_userPassword;
    }
    if (userDisplayName!=null) {
      map['userDisplayName']=_userDisplayName;
    } else {
      map['userDisplayName']='';
    }

    map['date'] = _date;

    map['selfieString'] = _selfieString;

    return map;
  }

// Extract a Note object from a Map object
//  Note.fromMapObject(Map<String, dynamic> map){
//    this._id=map['id'];
//    this._title=map['title'];
//    this._description=map['description'];
//    this._priority=map['priority'];
//    this._date=map['date'];
//  }

  UserProfile.fromMapObject (Map<String, dynamic> map) {
    this._id = map['id'];
    this._uid=map['uid'];
    this._userDisplayName=map['userDisplayName'];
    this._userEmail=map['userEmail'];
    this._userPassword=map['userPassword'];
    this._date=map['date'];
    this._selfieString=map['selfieString'];
  }
}