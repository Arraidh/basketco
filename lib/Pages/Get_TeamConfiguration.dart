import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:basketco/Utils/Colors.dart';
import 'package:basketco/Models/team_data.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:date_field/date_field.dart';
import 'package:basketco/Service/team_firestore.dart';
import 'package:intl/intl.dart';

class GetTeamConfiguration extends StatefulWidget {
  final TeamData teamData;
  const GetTeamConfiguration({required this.teamData});

  @override
  State<GetTeamConfiguration> createState() => _GetTeamConfiguration();
}

class _GetTeamConfiguration extends State<GetTeamConfiguration> {
  final FirestoreService _firestoreService = FirestoreService();

  TextEditingController _teamController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _jerseyController = TextEditingController();
  TextEditingController _timesController = TextEditingController();
  TextEditingController _venueController = TextEditingController();
  TextEditingController _dateTextController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay _selectedTime = TimeOfDay(hour: 7, minute: 15);
  Color _selectedColor1 = Colors.blue;
  Color _selectedColor2 = Colors.white;

  late TeamData _teamData;

  @override
  void initState() {
    super.initState();
    _getTeamData(widget.teamData.id!);
  }

  void _getTeamData(String teamId) async {
    TeamData? teamData = await _firestoreService.getTeam(teamId);
    setState(() {
      _teamData = teamData!;
      _teamController.text = _teamData.namaTeam ?? '';
      _nameController.text = _teamData.pemain ?? '';
      _jerseyController.text = _teamData.jersey ?? '';
      _venueController.text = _teamData.asalTeam ?? '';
    });
  }

  void _updateTeamData() {

    final now = DateTime.now();
    final currentDate = DateTime(now.year, now.month, now.day);
    final currentTime = TimeOfDay.fromDateTime(now); _selectedTime = TimeOfDay.now();

    final team = TeamData(
      namaTeam: _teamController.text,
      pemain: _nameController.text,
      jersey: _jerseyController.text,
      asalTeam: _venueController.text,
      waktu: DateFormat('dd/MM/yyyy').format(currentDate) + ' ${currentTime.format(context)}',    );

    _firestoreService.updateTeam(_teamData.id!, team).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Team updated!')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update Team: $error')));
    });
  }

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (newTime != null) {
      setState(() {
        _selectedTime = newTime;
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
      backgroundColor: BasketcoColors.darkBackground,
      appBar: AppBar(
        title: Text('Team Configuration', style: TextStyle(color: Colors.white)),
        backgroundColor: BasketcoColors.midBackground,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.white,
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
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Name Team', style: TextStyle(fontSize: 16, color: Colors.white)),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 200,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Name Pemain', style: TextStyle(fontSize: 16, color: Colors.white)),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 200,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
                  Text('Jersey', style: TextStyle(fontSize: 16, color: Colors.white)),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 200,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
                        SizedBox(width: 20),
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
              Divider(
                color: Colors.white,
                thickness: 0.3,
                indent: 0.3,
                endIndent: 1,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Asal Team', style: TextStyle(fontSize: 16, color: Colors.white)),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 200,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _updateTeamData();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
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
