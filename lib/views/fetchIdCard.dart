import 'package:flutter/material.dart';
import 'package:simple_app/model/fetchIdCardModel.dart';

class FetchIdCard extends StatefulWidget {
  final FetchIdCardModel model;

  FetchIdCard(this.model);

  @override
  _FetchIdCardState createState() => _FetchIdCardState();
}

class _FetchIdCardState extends State<FetchIdCard> {
  final _key = new GlobalKey<FormState>();

  TextEditingController txtNama, txtNik, txtTempatTglLahir, txtJenisKelamin, txtAlamat, txtRtrw, txtKelurahan, txtKecamatan, txtAgama, txtStatus, txtPekerjaan;

  setup(){
    txtNama = TextEditingController(text: widget.model.nama);
    txtNik = TextEditingController(text: widget.model.nik);
    txtTempatTglLahir = TextEditingController(text: widget.model.tempatLahir + "/" + widget.model.tglLahir);
    txtJenisKelamin = TextEditingController(text: widget.model.jenisKelamin);
    txtAlamat = TextEditingController(text: widget.model.alamat);
    txtRtrw = TextEditingController(text: widget.model.rtrw);
    txtKelurahan = TextEditingController(text: widget.model.kelurahan);
    txtKecamatan = TextEditingController(text: widget.model.kecamatan);
    txtAgama = TextEditingController(text: widget.model.agama);
    txtStatus = TextEditingController(text: widget.model.status);
    txtPekerjaan = TextEditingController(text: widget.model.pekerjaan);


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face vs Ktp - Result'),
        leading: IconButton(icon: Icon(
            Icons.arrow_back),
            onPressed: () {
              // Write some code to control things, when user press back button in AppBar
              moveToLastScreen();
            }
        ),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              enabled: false,
              controller: txtNik,
              decoration: InputDecoration(
                  labelText: "NIK"
              ),
            ),
            TextFormField(
              enabled: false,
              controller: txtNama,
              decoration: InputDecoration(
                  labelText: "Nama"
              ),
            ),
            TextFormField(
              enabled: false,
              controller: txtTempatTglLahir,
              decoration: InputDecoration(
                  labelText: "Tempat / Tgl Lahir"
              ),
            ),
            TextFormField(
              enabled: false,
              controller: txtAgama,
              decoration: InputDecoration(
                  labelText: "Agama"
              ),
            ),
            TextFormField(
              enabled: false,
              controller: txtJenisKelamin,
              decoration: InputDecoration(
                  labelText: "Jenis Kelamin"
              ),
            ),
            TextFormField(
              enabled: false,
              controller: txtAlamat,
              decoration: InputDecoration(
                  labelText: "Alamat"
              ),
            ),
            TextFormField(
              enabled: false,
              controller: txtRtrw,
              decoration: InputDecoration(
                  labelText: "RT/RW"
              ),
            ),
            TextFormField(
              enabled: false,
              controller: txtKecamatan,
              decoration: InputDecoration(
                  labelText: "Kecamatan"
              ),
            ),
            TextFormField(
              enabled: false,
              controller: txtKelurahan,
              decoration: InputDecoration(
                  labelText: "Kelurahan"
              ),
            ),
            TextFormField(
              enabled: false,
              controller: txtStatus,
              decoration: InputDecoration(
                  labelText: "Status"
              ),
            ),
            TextFormField(
              enabled: false,
              controller: txtPekerjaan,
              decoration: InputDecoration(
                  labelText: "Pekerjaan"
              ),
            ),


          ],
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
