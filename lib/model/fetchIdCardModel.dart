class FetchIdCardModel{

  String? _nik;
  String? _nama;
  String? _tempatLahir;
  String? _tglLahir;
  String? _jenisKelamin;
  String? _alamat;
  String? _rtrw;
  String? _kelurahan;
  String? _kecamatan;
  String? _agama;
  String? _status;
  String? _pekerjaan;


  FetchIdCardModel();

  String? get nik => _nik;

  set nik(String? value) {
    _nik = value;
  }

  String? get nama => _nama;

  String? get pekerjaan => _pekerjaan;

  set pekerjaan(String? value) {
    _pekerjaan = value;
  }

  String? get status => _status;

  set status(String? value) {
    _status = value;
  }

  String? get agama => _agama;

  set agama(String? value) {
    _agama = value;
  }

  String? get kecamatan => _kecamatan;

  set kecamatan(String? value) {
    _kecamatan = value;
  }

  String? get kelurahan => _kelurahan;

  set kelurahan(String? value) {
    _kelurahan = value;
  }

  String? get rtrw => _rtrw;

  set rtrw(String? value) {
    _rtrw = value;
  }

  String? get alamat => _alamat;

  set alamat(String? value) {
    _alamat = value;
  }

  String? get jenisKelamin => _jenisKelamin;

  set jenisKelamin(String? value) {
    _jenisKelamin = value;
  }

  String? get tglLahir => _tglLahir;

  set tglLahir(String? value) {
    _tglLahir = value;
  }

  String? get tempatLahir => _tempatLahir;

  set tempatLahir(String? value) {
    _tempatLahir = value;
  }

  set nama(String? value) {
    _nama = value;
  }


}