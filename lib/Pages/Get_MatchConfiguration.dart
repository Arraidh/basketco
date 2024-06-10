import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:basketco/Utils/Colors.dart';
import 'package:basketco/Models/match_data.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:date_field/date_field.dart';
import 'package:basketco/Service/match_firestore.dart';
import 'package:intl/intl.dart';

class GetConfigurationPage extends StatefulWidget {
  final MatchData matchData;
  const GetConfigurationPage({required this.matchData});

  @override
  State<GetConfigurationPage> createState() => _GetConfigurationPageState();
}

class _GetConfigurationPageState extends State<GetConfigurationPage> {
  final FirestoreService _firestoreService = FirestoreService();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _jerseyController = TextEditingController();
  TextEditingController _colorsController = TextEditingController();
  TextEditingController _nameController2 = TextEditingController();
  TextEditingController _jerseyController2 = TextEditingController();
  TextEditingController _colorsController2 = TextEditingController();
  TextEditingController _quarterController = TextEditingController();
  TextEditingController _periodtimesController = TextEditingController();
  TextEditingController _timesController = TextEditingController();
  TextEditingController _matchController = TextEditingController();
  TextEditingController _venueController = TextEditingController();
  TextEditingController _dateTextController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay _selectedtime = TimeOfDay(hour: 7, minute: 15);
  Color _selectedColor1 = Colors.blue;
  Color _selectedColor2 = Colors.white;
  Color _selectedColor3 = Colors.red;
  Color _selectedColor4 = Colors.black;

  late MatchData _matchData; // Variable untuk menyimpan data dari Firestore

  @override
  void initState() {
    super.initState();
    // Mendapatkan data dari Firestore saat halaman diinisialisasi
    _getMatchData(widget.matchData.id!);
  }

  void _getMatchData(String matchId) async {
    // Mendapatkan data dari Firestore
    MatchData? matchData = await _firestoreService.getMatchData(matchId); // Misalnya metode untuk mendapatkan data dari Firestore adalah getMatchData()
    // Mengatur data yang diperoleh ke dalam state
    setState(() {
      _matchData = matchData!;
      // Mengatur nilai kontroller sesuai dengan data dari Firestore
      _nameController.text = _matchData.terang ?? '';
      _jerseyController.text = _matchData.terangPemain ?? '';
      _nameController2.text = _matchData.gelap ?? '';
      _jerseyController2.text = _matchData.gelapPemain ?? '';
      _quarterController.text = _matchData.KU ?? '';
      _periodtimesController.text = _matchData.pool ?? '';
      _matchController.text = _matchData.id ?? ''; // Atur ini sesuai kebutuhan
      _venueController.text = _matchData.venue ?? '';
      _selectedDate = DateTime.parse(_matchData.tanggalPlain ?? ''); // Mengubah string tanggal dari Firestore menjadi DateTime
      _selectedtime = TimeOfDay.fromDateTime(DateTime.parse(_matchData.jam ?? '')); // Mengubah string jam dari Firestore menjadi TimeOfDay
    });
  }

  void _updateMatchData() {
    final match = MatchData(
      waktu: DateFormat('dd/MM/yyyy').format(_selectedDate!) + ' ${_selectedtime.format(context)}',
      venue: _venueController.text,
      terang: _nameController.text,
      gelap: _nameController2.text,
      KU: _quarterController.text,
      pool: _periodtimesController.text,
      terangPemain: _jerseyController.text,
      gelapPemain: _jerseyController2.text,
      terangId: '1', // Example ID, adjust accordingly
      gelapId: '2', // Example ID, adjust accordingly
      tanggalPlain: _selectedDate.toString(),
      tanggal: DateFormat('dd/MM/yyyy').format(_selectedDate!),
      jam: _selectedtime.format(context),
    );

    _firestoreService.updateMatch(_matchData.id!, match).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Match updated!')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update match: $error')));
    });
  }

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _selectedtime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (newTime != null) {
      setState(() {
        _selectedtime = newTime;
      });
    }
  }

  void _openColorPickerDialog(Color initialColor, Function(Color) onColorChanged) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color _tempColor = initialColor;
        return AlertDialog(
          title: Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _tempColor,
              onColorChanged: (color) {
                _tempColor = color;
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onColorChanged(_tempColor);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configuration',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: BasketcoColors.midBackground,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Fungsi untuk kembali
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 24, // Ukuran ikon
            color: Colors.white, // Warna ikon
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: BasketcoColors.darkBackground,
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TEAM #1', style: TextStyle(fontSize: 16, color: Colors.white)),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Name', style: TextStyle(fontSize: 16, color: Colors.white)),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 200,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0,),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: '',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Jersey #', style: TextStyle(fontSize: 16, color: Colors.white)),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 200,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0,),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: _jerseyController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('BG/FG Colors', style: TextStyle(fontSize: 16, color: Colors.white)),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _openColorPickerDialog(_selectedColor1, (color) {
                              setState(() {
                                _selectedColor1 = color;
                              });
                            });
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            color: _selectedColor1,
                          ),
                        ),
                        SizedBox(width: 20,),
                        GestureDetector(
                          onTap: () {
                            _openColorPickerDialog(_selectedColor2, (color) {
                              setState(() {
                                _selectedColor2 = color;
                              });
                            });
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            color: _selectedColor2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Divider( // Garis pembatas
                color: Colors.white,
                thickness: 0.3, // Ketebalan garis
                indent: 0.3, // Jarak dari kiri
                endIndent: 1, // Jarak dari kanan
              ),
              Text('TEAM #2', style: TextStyle(fontSize: 16, color: Colors.white)),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Name', style: TextStyle(fontSize: 16, color: Colors.white)),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 200,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0,),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: _nameController2,
                        decoration: InputDecoration(
                          hintText: '',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Jersey #', style: TextStyle(fontSize: 16, color: Colors.white)),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 200,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0,),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: _jerseyController2,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('BG/FG Colors', style: TextStyle(fontSize: 16, color: Colors.white)),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _openColorPickerDialog(_selectedColor3, (color) {
                              setState(() {
                                _selectedColor3 = color;
                              });
                            });
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            color: _selectedColor3,
                          ),
                        ),
                        SizedBox(width: 20,),
                        GestureDetector(
                          onTap: () {
                            _openColorPickerDialog(_selectedColor4, (color) {
                              setState(() {
                                _selectedColor4 = color;
                              });
                            });
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            color: _selectedColor4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Divider( // Garis pembatas
                color: Colors.white,
                thickness: 0.3, // Ketebalan garis
                indent: 0.3, // Jarak dari kiri
                endIndent: 1, // Jarak dari kanan
              ),
              Text('MATCH', style: TextStyle(fontSize: 16, color: Colors.white)),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Quarter', style: TextStyle(fontSize: 16, color: Colors.white)),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 200,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0,),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: _quarterController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Period', style: TextStyle(fontSize: 16, color: Colors.white)),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 200,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0,),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: _periodtimesController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Venue', style: TextStyle(fontSize: 16, color: Colors.white)),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 200,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0,),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: _venueController,
                        decoration: InputDecoration(
                          hintText: '',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Text('Date/Time', style: TextStyle(fontSize: 16, color: Colors.white)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0,),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DateTimeFormField(
                            decoration: InputDecoration(
                              //labelText: '',
                              border: InputBorder.none,
                            ),
                            mode: DateTimeFieldPickerMode.date,
                            autovalidateMode: AutovalidateMode.always,
                            onChanged: (DateTime? value) {
                              setState(() {
                                _selectedDate = value;
                              });
                            },
                            dateFormat: DateFormat('dd/MM/yyyy'), // Format tanggal yang diinginkan
                            initialPickerDateTime: _selectedDate,
                            initialValue: _selectedDate,
                            onSaved: (DateTime? value) {
                              if (value != null) {
                                setState(() {
                                  _selectedDate = value;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0,),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 18)),
                        Text(
                          '${_selectedtime.hour.toString().padLeft(2, '0')}:${_selectedtime.minute.toString().padLeft(2, '0')}',
                        ),
                        IconButton(
                          onPressed: _selectTime,
                          icon: Icon(Icons.arrow_drop_down_sharp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Divider( // Garis pembatas
                color: Colors.white,
                thickness: 0.3, // Ketebalan garis
                indent: 0.3, // Jarak dari kiri
                endIndent: 1, // Jarak dari kanan
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _updateMatchData(); // Saat tombol ditekan, perbarui data pada Firestore
                  },
                  child: Text('Update Match'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}