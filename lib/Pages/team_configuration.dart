import 'package:basketco/Pages/Calculator.dart';
import 'package:flutter/material.dart';
import 'package:basketco/Utils/Colors.dart';
import 'package:basketco/Models/team_data.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:date_field/date_field.dart';
import 'package:basketco/Service/team_firestore.dart';

import 'dart:core';
import 'dart:async';
import 'package:intl/intl.dart';

class TeamConfigurationPage extends StatefulWidget {
  const TeamConfigurationPage({Key? key}) : super(key: key);

  @override
  State<TeamConfigurationPage> createState() => _TeamConfigurationPageState();
}

class _TeamConfigurationPageState extends State<TeamConfigurationPage> {

  final FirestoreService _firestoreService = FirestoreService();

  TextEditingController _teamController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _jerseyController = TextEditingController();
  // TextEditingController _colorsController = TextEditingController();
  // TextEditingController _nameController2 = TextEditingController();
  // TextEditingController _jerseyController2 = TextEditingController();
  // TextEditingController _colorsController2 = TextEditingController();
  // TextEditingController _quarterController = TextEditingController();
  // TextEditingController _periodtimesController = TextEditingController();
  TextEditingController _timesController = TextEditingController();
  TextEditingController _venueController = TextEditingController();
  TextEditingController _dateTextController = TextEditingController();
  DateTime? _selectedDate;

  TimeOfDay _selectedtime = TimeOfDay(hour: 7, minute: 15);

  Color _selectedColor1 = Colors.blue;
  Color _selectedColor2 = Colors.white;
  Color _selectedColor3 = Colors.red;
  Color _selectedColor4 = Colors.black;

  void _saveteam(BuildContext context) {
    // Set _selectedDate dan _selectedtime sebelum membuat objek TeamData
    final now = DateTime.now();
    final currentDate = DateTime(now.year, now.month, now.day);
    final currentTime = TimeOfDay.fromDateTime(now);_selectedtime = TimeOfDay.now(); // Gunakan TimeOfDay.now() untuk mendapatkan waktu saat ini

    final team = TeamData(
      namaTeam: _teamController.text,
      pemain: _nameController.text,
      jersey: _jerseyController.text,
      asalTeam: _venueController.text,
      waktu: DateFormat('dd/MM/yyyy').format(currentDate) + ' ${currentTime.format(context)}',
    );

    // Tambahkan delay sebelum menampilkan SnackBar
    Timer(Duration(milliseconds: 500), () {
      _firestoreService.addTeam(team).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('team saved!')));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save team: $error')));
      });
    });
  }


  void _updateteam(String docID) {
    final team = TeamData(
      namaTeam: _teamController.text,
      pemain: _nameController.text,
      jersey: _jerseyController.text,
      asalTeam: _venueController.text,
    );

    _firestoreService.updateTeam(docID, team).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('team updated!')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update team: $error')));
    });
  }


  void _deleteteam(String docID) {
    _firestoreService.deleteTeam(docID).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('team deleted!')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete team: $error')));
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
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  late String token;
  late String id;
  late TeamData teamData;
  String selectedDate = '2023-06-25';

  @override
  void initState() {
    super.initState();
    // token = widget.token;
    // teamData = widget.teamData;
    // id = widget.id;
    // initializeToken();
    // fetchData(widget.selectedDate);
    // _quarterController.text = "4";
    // _periodtimesController.text = "10";
    _timesController.text = "5";
  }

  @override
  void dispose() {
    _teamController.dispose();
    _nameController.dispose();
    _jerseyController.dispose();
    _venueController.dispose();
    // _nameController2.dispose();
    // _jerseyController2.dispose();
    // _quarterController.dispose();
    _timesController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BasketcoColors.darkBackground,
      appBar: AppBar(
        title: Text('Team Configuration', style: TextStyle(color: Colors.white),),
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
              Text('TEAM Detail', style: TextStyle(fontSize: 16, color: Colors.white)),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Name Team', style: TextStyle(fontSize: 16, color: Colors.white)),
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
                        controller: _teamController,
                        decoration: InputDecoration(
                          hintText: '',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Name Pemain', style: TextStyle(fontSize: 16, color: Colors.white)),
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
                  Text('Jersey ', style: TextStyle(fontSize: 16, color: Colors.white)),
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
              // Text('TEAM #2', style: TextStyle(fontSize: 16, color: Colors.white)),
              // SizedBox(height: 10,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text('Name', style: TextStyle(fontSize: 16, color: Colors.white)),
              //     SizedBox(width: 10),
              //     SizedBox(
              //       width: 200,
              //       child: Container(
              //         padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0,),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(5),
              //           border: Border.all(color: Colors.grey),
              //           color: Colors.white,
              //         ),
              //         child: TextFormField(
              //           controller: _nameController2,
              //           decoration: InputDecoration(
              //             hintText: '',
              //             border: InputBorder.none,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 20.0),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text('Jersey #', style: TextStyle(fontSize: 16, color: Colors.white)),
              //     SizedBox(width: 10),
              //     SizedBox(
              //       width: 200,
              //       child: Container(
              //         padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0,),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(5),
              //           border: Border.all(color: Colors.grey),
              //           color: Colors.white,
              //         ),
              //         child: TextFormField(
              //           controller: _jerseyController2,
              //           keyboardType: TextInputType.number,
              //           decoration: InputDecoration(
              //             hintText: '',
              //             border: InputBorder.none,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 20.0),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text('BG/FG Colors', style: TextStyle(fontSize: 16, color: Colors.white)),
              //     SizedBox(width: 10),
              //     SizedBox(
              //       width: 200,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           GestureDetector(
              //             onTap: () {
              //               _openColorPickerDialog(_selectedColor3, (color) {
              //                 setState(() {
              //                   _selectedColor3 = color;
              //                 });
              //               });
              //             },
              //             child: Container(
              //               width: 30,
              //               height: 30,
              //               color: _selectedColor3,
              //             ),
              //           ),
              //           SizedBox(width: 20,),
              //           GestureDetector(
              //             onTap: () {
              //               _openColorPickerDialog(_selectedColor4, (color) {
              //                 setState(() {
              //                   _selectedColor4 = color;
              //                 });
              //               });
              //             },
              //             child: Container(
              //               width: 30,
              //               height: 30,
              //               color: _selectedColor4,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 20.0),
              // Divider( // Garis pembatas
              //   color: Colors.white,
              //   thickness: 0.3, // Ketebalan garis
              //   indent: 0.3, // Jarak dari kiri
              //   endIndent: 1, // Jarak dari kanan
              // ),
              SizedBox(height: 10,),
              // Row(
              //   children: [
              //     Text('Number of periods/quarters', style: TextStyle(fontSize: 16, color: Colors.white)),
              //     SizedBox(width: 10),
              //     Expanded(
              //       child: Container(
              //         padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0,),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(5),
              //           border: Border.all(color: Colors.grey),
              //           color: Colors.white,
              //         ),
              //         child: TextFormField(
              //           controller: _quarterController,
              //           keyboardType: TextInputType.number,
              //           inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Hanya menerima angka
              //           decoration: InputDecoration(
              //             hintText: '',
              //             border: InputBorder.none,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 20.0),
              // Row(
              //   children: [
              //     Text('Period/quarter length (mins)', style: TextStyle(fontSize: 16, color: Colors.white)),
              //     SizedBox(width: 10),
              //     Expanded(
              //       child: Container(
              //         padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0,),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(5),
              //           border: Border.all(color: Colors.grey),
              //           color: Colors.white,
              //         ),
              //         child: TextFormField(
              //           controller: _periodtimesController,
              //           keyboardType: TextInputType.number,
              //           inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Hanya menerima angka
              //           decoration: InputDecoration(
              //             hintText: '',
              //             border: InputBorder.none,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 20.0),
              // Row(
              //   children: [
              //     Text('Overtime length (mins)', style: TextStyle(fontSize: 16, color: Colors.white)),
              //     SizedBox(width: 10),
              //     Expanded(
              //       child: Container(
              //         padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0,),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(5),
              //           border: Border.all(color: Colors.grey),
              //           color: Colors.white,
              //         ),
              //         child: TextFormField(
              //           controller: _timesController,
              //           keyboardType: TextInputType.number,
              //           inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Hanya menerima angka
              //           decoration: InputDecoration(
              //             hintText: '',
              //             border: InputBorder.none,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 20,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text('team Title', style: TextStyle(fontSize: 16, color: Colors.white)),
              //     SizedBox(width: 10),
              //     SizedBox(
              //       width: 200,
              //       child: Container(
              //         padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0,),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(5),
              //           border: Border.all(color: Colors.grey),
              //           color: Colors.white,
              //         ),
              //         child: TextFormField(
              //           controller: _teamController,
              //           decoration: InputDecoration(
              //             hintText: '',
              //             border: InputBorder.none,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Asal Team', style: TextStyle(fontSize: 16, color: Colors.white)),
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
              // Row(
              //   children: [
              //     Text('Date ', style: TextStyle(fontSize: 16, color: Colors.white)),
              //     SizedBox(width: 10),
              //     Expanded(
              //       child: Container(
              //         padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0,),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(5),
              //           border: Border.all(color: Colors.grey),
              //           color: Colors.white,
              //         ),
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              // DateTimeFormField(
              //   decoration: InputDecoration(
              //     hintText: '',
              //     border: InputBorder.none,
              //   ),
              //   mode: DateTimeFieldPickerMode.date,
              //   autovalidateMode: AutovalidateMode.always,
              //   onChanged: (DateTime? value) {
              //     setState(() {
              //       _selectedDate = value;
              //     });
              //   },
              //   dateFormat: DateFormat('dd/MM/yyyy'), // Format tanggal yang diinginkan
              //   initialPickerDateTime: _selectedDate,
              //   initialValue: _selectedDate,
              //   onSaved: (DateTime? value) {
              //     if (value != null) {
              //       setState(() {
              //         _selectedDate = value;
              //       });
              //     }
              //   },
              // ),

              //           ],
              //         ),
              //       ),
              //     ),
              //     SizedBox(width: 10),
              //     Container(
              //       padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0,),
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(5),
              //         border: Border.all(color: Colors.grey),
              //         color: Colors.white,
              //       ),
              //       child: Row(
              //         children: [
              //           Padding(padding: EdgeInsets.only(left: 18)),
              //           Text(
              //             '${_selectedtime.hour.toString().padLeft(2, '0')}:${_selectedtime.minute.toString().padLeft(2, '0')}',
              //           ),
              //           IconButton(
              //             onPressed: _selectTime,
              //             icon: Icon(Icons.arrow_drop_down_sharp),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
//                   ElevatedButton(
//                     onPressed: () {
// // Mengisi data dalam configurationModel menggunakan TextEditingController
//                       bool isButtonClicked = false;
//                       setState(() {
//                         isButtonClicked = !isButtonClicked;
//                       });
//
//                       String name = _nameController.text;
//                       String jersey = _jerseyController.text;
//                       String colors = _colorsController.text;
//                       String name2 = _nameController2.text;
//                       String jersey2 = _jerseyController2.text;
//                       String colors2 = _colorsController2.text;
//                       String periods = _periodtimesController.text;
//                       //int time = int.tryParse(configuration.periodtimesController.text) ?? 0;
//                       int? time = int.tryParse(periods);
//                       // print('Name $name');
//                       // print('Jersey # $jersey');
//                       // print('BG/FG Colors $colors');
//                       // configuration.updateData(name, jersey, colors, name2, jersey2, colors2, time!);
//
//                       Navigator.of(context).pop();
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => CalculatorPage(
//                             // selectedColor1: _selectedColor1,
//                             // selectedColor2: _selectedColor2,
//                             // selectedColor3: _selectedColor3,
//                             // selectedColor4: _selectedColor4,
//                             // token: token,
//                             // teamData: teamData,
//                             // data: configuration.configurationData,
//                             // // id: widget.id!,
//                             // selectedDate: selectedDate,
//                             // activeTerang: [],
//                             // activeGelap: [],
//                           ),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(horizontal: 60), backgroundColor: BasketcoColors.green,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ),
//                     child: Text('Save', style: TextStyle(fontSize: 20, color: Colors.white)),
//                   ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () => _saveteam(context),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      backgroundColor: BasketcoColors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text('Save', style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
