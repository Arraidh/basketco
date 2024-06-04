import 'dart:async';

import 'package:basketco/State/player_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:basketco/Utils/Colors.dart';
import 'package:basketco/Component/reusable_button1.dart';
import 'package:basketco/Component/reusable_button_calc.dart';
// import 'package:vibration/vibration.dart';
import 'package:basketco/Models/match_data.dart';
import 'package:provider/provider.dart';

class CalculatorPage extends StatefulWidget {
  final MatchData matchData;

  CalculatorPage({required this.matchData});
  // const CalculatorPage({Key? key}) : super(key: key);

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  List<dynamic> terangMain = [];
  List<dynamic> gelapMain = [];

  List<String> selectedValues2 = [];
  String value1 = '';
  String value2 = '';
  String _handleButtonPress(String newValue) {
    // setState(() {
    //   value1 = newValue;
    // });
    setState(() {
      if (selectedValues2.contains(newValue) && selectedValues2.isNotEmpty) {
        selectedValues2.clear();
        selectedValues2.remove(newValue);
        //selectedValues2.removeAt(0);
      } else {
        //selectedValues2.clear();
        selectedValues2.add(newValue);
        value1 = newValue;
      }
    });
    return newValue;
  }

  List<String> selectedValues = [];

  String combinedValue = '';
  String? gelapTerang1;
  String? namaTim;
  late final MatchData matchData;
  void _handleButtonPressNumber(String value, String gelapTerang) {

    gelapTerang1 = gelapTerang;
    namaTim = (gelapTerang == 'terang') ? '${matchData.terang}' : '${matchData.gelap}';
    combinedValue = '$namaTim #$value';

    setState(() {
      if (selectedValues.contains(combinedValue)) {
        selectedValues.clear();
        selectedValues.remove(combinedValue);
      } else {
        //selectedValues.clear();
        selectedValues.add(combinedValue);
        value2 = value;
      }
    });
  }

  late Timer _timer = Timer(Duration(seconds: 0), () {});
  bool _isActive = false;
  int _start = 0;

  void _startTimer() {
    if (!_isActive) {
      _isActive = true;
      _timer = Timer.periodic(Duration(seconds: 1), _tick);
      // _runningMinutes = _minutes;
      // _runningSeconds = _seconds;
    }
  }

  void _tick(Timer timer) {
    if (_start == 0) {
      _resetTimer();
    } else {
      setState(() {
        _start--;
      });
    }
  }

  void _pauseTimer() {
    if (_isActive) {
      _isActive = false;
      setState(() {
        _timer.cancel();
      });
    }
  }

  void _resetTimer() {
    _isActive = false;
    _timer.cancel();
    setState(() {
      //_start = 10 * 60; // Reset waktu ke nilai awal
      _start;
    });
  }


  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String selectedOption = 'Q1';
  void _handleSelection(String value) {
    setState(() {
      selectedOption = value;
      _resetTimer();
    });
  }

  void _handleClearButtonPress() {
    setState(() {
      selectedValues.clear();
      selectedValues2.clear();
      // _fulfillmentText = '';
      combinedValue = '';
      value1 = '';
      value2 = '';
    });
  }


  TextEditingController _minutesController = TextEditingController();
  TextEditingController _secondsController = TextEditingController();

  int _minutes = 0;
  int _seconds = 0;

  bool _isRunning = false;
  late Stream<int> _timerStream;
  late StreamSubscription<int> _timerSubscription;

  Future<void> _showPickerDialog(BuildContext context) async {
    final selectedTime = await showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _minutesController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Minutes'),
                      onChanged: (value) {
                        _minutes = int.tryParse(value) ?? 0;
                      },
                    ),
                  ),
                  Text(':', style: TextStyle(fontSize: 24)),
                  Expanded(
                    child: TextFormField(
                      controller: _secondsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Seconds'),
                      onChanged: (value) {
                        _seconds = int.tryParse(value) ?? 0;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Set'),
              onPressed: () {
                Navigator.of(context).pop(TimeOfDay(
                  hour: _minutes,
                  minute: _seconds,
                ));
              },
            ),
          ],
        );
      },
    );

    if (selectedTime != null) {
      setState(() {
        _minutes = selectedTime.hour;
        _seconds = selectedTime.minute;
        _start = (_minutes * 60) + _seconds;
      });
    }
  }

  bool isOk = false;

  DateTime? timestamp;
  int startMinutes = 0;
  int startSeconds = 0;
  int elapsedMinutes = 0;
  int elapsedSeconds = 0;
  int _lastElapsedTime = 0;
  String option = '';

  void _handleOkButtonPress() {

    option = selectedOption;

    setState(() {
      if (!isOk) {
        // Tombol OK ditekan pertama kali
        startMinutes = _minutes;
        startSeconds = _seconds;
        //isOk = true;
        //isOk = false;
      }
      // else {
      //   // Tombol OK ditekan lagi
      //   //_pauseTimer(); // Hentikan timer
      //   int elapsedSeconds = (startMinutes - _minutes) * 60 + (startSeconds - _seconds);
      //   isOk = false;
      //   String formattedTime = _formatTime(elapsedSeconds);
      //   print('Selisih waktu: $formattedTime');
      // }

      isOk = true;
      // _handleButtonPressNumber;
      // _handleButtonPress;
      // _handleSelection;
      _lastElapsedTime = _start;
      // sendDataToAPI();

      // if(selectedValues.isNotEmpty || selectedValues2.isNotEmpty) {
      //   //isOk = false;
      //   nomor = '';
      //   action = '';
      //   quarter = '';
      //   klub = '';
      // }
      if(!isOk){
        if(selectedValues.isNotEmpty || selectedValues2.isNotEmpty) {
          // selectedValues2.clear();
          // selectedValues.clear();
          Timer(Duration(seconds: 3), () {
            setState(() {
              isOk = false;
              value1 = '';
              value2 = '';
              combinedValue = '';
              selectedValues.clear();
              selectedValues2.clear();
              _lastElapsedTime = 0;
              option = '';
            });
          });
        }
      }
      if(!isOk) {
        print('Selisih waktu: ${_formatTime(elapsedMinutes)}');
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data terkirim'),
        duration: Duration(seconds: 2), // Durasi tampilan Snackbar
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<MatchProvider>(context);
    final terangMain = playerProvider.activeTerang;
    final gelapMain = playerProvider.activeGelap;
    print('Match Data ID: ${widget.matchData.id}');

    return Scaffold(
      backgroundColor: BasketcoColors.darkBackground,
      appBar:  AppBar(
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
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //timer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PopupMenuButton<String>(
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'Q1',
                          child: Text('Q1'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Q2',
                          child: Text('Q2'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Q3',
                          child: Text('Q3'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Q4',
                          child: Text('Q4'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'OT',
                          child: Text('OT'),
                        ),
                      ];
                    },
                    onSelected: _handleSelection,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: BasketcoColors.yellow,
                        borderRadius: BorderRadius.circular(4), // Memberikan border radius
                      ),
                      child: Center(
                        child: Text(
                          selectedOption,
                          style: TextStyle(color: BasketcoColors.black, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: BasketcoColors.black,
                            borderRadius: BorderRadius.circular(4)
                        ),
                        child: GestureDetector(
                          onTap: () {
                            _showPickerDialog(context);
                          },
                          child: Text(
                            _formatTime(_start),
                            style: TextStyle(fontSize: 24, color: BasketcoColors.lightGreen, fontWeight: FontWeight.bold, fontFamily: 'DotMatrix'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _isActive ? _pauseTimer : _startTimer,
                    child: Icon(
                      _isActive ? Icons.pause : Icons.play_arrow,
                      size: 25,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BasketcoColors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4), // Radius border
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/subtitution');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BasketcoColors.yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4), // Radius border (sesuaikan dengan kebutuhan)
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(1),
                      child: Icon(
                        Icons.sync_alt,
                        size: 30, // Ukuran ikon
                        color: Colors.white, // Warna ikon
                      ),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(3)),
              //Screen
              Stack(
                children: [
                  Container(
                    //alignment: Alignment.center,
                    height: 110,
                    width: 657,
                    decoration: BoxDecoration(
                      color: BasketcoColors.lightBackground, borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Positioned(
                  //   top: 5,
                  //   left: 15,
                  //   child: Column(
                  //     children: [
                  //       Text(
                  //         _fulfillmentText,
                  //         style: GoogleFonts.poppins(fontSize: 20, color: BasketcoColors.white),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Positioned(
                    top: 5,
                    left: 15,
                    child: isOk
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:[
                            Icon(Icons.check_circle, color: BasketcoColors.green, size: 30,),
                            Padding(padding: EdgeInsets.all(8)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('$selectedOption ${_formatTime(_lastElapsedTime)}', style: TextStyle(fontSize: 20, color: Colors.white)),
                                Text('${selectedValues.join()}', style: TextStyle(fontSize: 20, color: Colors.white)),
                                Text('${selectedValues2.join()}', style: TextStyle(fontSize: 20, color: Colors.white)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                        : SizedBox(), // Jika false, tidak menampilkan apapun
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(4)),
              Container(
                alignment: Alignment.center,
                height: 50,
                width: 657,
                decoration: BoxDecoration(
                  color: BasketcoColors.black, borderRadius: BorderRadius.circular(1),
                ),
                child: Text(
                  combinedValue,
                  style: TextStyle(color: BasketcoColors.green,  fontFamily: 'DotMatrix', fontWeight: FontWeight.bold),
                ),
              ),
              Padding(padding: EdgeInsets.all(3)),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SingleChildScrollView(
                    child:  Column(
                      children: [
                        Wrap(
                          //children: terangButtons,
                          children: terangMain.map((angka) {
                            //final angkaStr = angka.toString();
                            return Padding(
                              padding: EdgeInsets.all(3),
                              child: ReusableButton1(
                                text: angka,
                                onPressed: () {
                                  _handleButtonPressNumber(angka, 'terang');
                                  // Vibration.vibrate(duration: 100, amplitude: 128);
                                  //buttonStatusProvider.saveButtonStatusToStorage();
                                },
                                value: angka,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(2)),
                  SingleChildScrollView(
                    child:  Wrap(
                      //children: gelapButtons,
                      children: gelapMain.map((angka) {
                        //final angkaStr = angka.toString();
                        return Padding(
                          padding: EdgeInsets.all(3),
                          child: ReusableButton1(
                            text: angka,
                            onPressed: () {
                              _handleButtonPressNumber(angka, 'gelap');
                              // Vibration.vibrate(duration: 100, amplitude: 128);
                            },
                            value: angka,
                            backgroundColor: Colors.red,
                            textColor: Colors.black,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(3)),
                ],
              ),
              Padding(padding: EdgeInsets.all(3)),
              Container(
                alignment: Alignment.center,
                height: 50,
                width: 657,
                decoration: BoxDecoration(
                  color: BasketcoColors.black, borderRadius: BorderRadius.circular(1),
                ),
                child: Text(
                  _handleButtonPress(value1),
                  style: TextStyle(color: BasketcoColors.green,  fontFamily: 'DotMatrix', fontWeight: FontWeight.bold),
                ),
              ),
              Padding(padding: EdgeInsets.all(3)),
              //Input
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SingleChildScrollView(
                    // scrollDirection: Axis.horizontal,
                    child:  Wrap(
                      children: [
                        ReusableButton(
                          text1: '1',
                          text2: 'Made',
                          // onPressed: () => _handleButtonPress('Made +1'),
                          onPressed: () {
                            _handleButtonPress('Made +1');
                            // Vibration.vibrate(duration: 100, amplitude: 128);
                          },
                          value: 'Made 1',
                          backgroundColor: BasketcoColors.green,
                          textColor: BasketcoColors.white,
                          width: MediaQuery.of(context).size.width * 0.1,
                        ),
                        Padding(padding: EdgeInsets.all(3)),
                        ReusableButton(
                          text1: '1',
                          text2: 'Missed',
                          // onPressed: () => _handleButtonPress('Missed 1'),
                          onPressed: () {
                            _handleButtonPress('Missed +1');
                            // Vibration.vibrate(duration: 100, amplitude: 128);
                          },
                          value: 'Missed 1',
                          backgroundColor: BasketcoColors.red,
                          textColor: BasketcoColors.white,
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                        Padding(padding: EdgeInsets.all(3)),
                        ReusableButton(
                          text1: 'A',
                          text2: 'Assist',
                          onPressed: () {
                            _handleButtonPress('Assist');
                            // Vibration.vibrate(duration: 100, amplitude: 128);
                          },
                          value: 'Assist',
                          backgroundColor: BasketcoColors.green,
                          textColor: BasketcoColors.white,
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                        Padding(padding: EdgeInsets.all(3)),
                        ReusableButton(
                          text1: 'TO',
                          text2: 'Turn Over',
                          onPressed: () {
                            _handleButtonPress('Turn Over');
                            // Vibration.vibrate(duration: 100, amplitude: 128);
                          },
                          value: 'Turn Over',
                          backgroundColor: BasketcoColors.red,
                          textColor: BasketcoColors.white,
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                        Padding(padding: EdgeInsets.all(3)),
                        ReusableButton(
                          text1: 'P',
                          text2: 'Personal',
                          onPressed: () {
                            _handleButtonPress('Personal Foul');
                            // Vibration.vibrate(duration: 100, amplitude: 128);
                          },
                          value: 'Personal Foul',
                          backgroundColor: BasketcoColors.red,
                          textColor: BasketcoColors.white,
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(3)),
                  SingleChildScrollView(
                    child:  Wrap(
                      children: [
                        ReusableButton(
                          text1: '2',
                          text2: 'Made',
                          onPressed: () {
                            _handleButtonPress('Made +2');
                            // Vibration.vibrate(duration: 100, amplitude: 128);
                          },
                          value: 'Made 2',
                          backgroundColor: BasketcoColors.green,
                          textColor: BasketcoColors.white,
                        ),
                        Padding(padding: EdgeInsets.all(3)),
                        ReusableButton(
                          text1: '2',
                          text2: 'Missed',
                          onPressed: () {
                            _handleButtonPress('Missed +2');
                            // Vibration.vibrate(duration: 100, amplitude: 128);
                          },
                          value: 'Missed 2',
                          backgroundColor: BasketcoColors.red,
                          textColor: BasketcoColors.white,
                        ),
                        Padding(padding: EdgeInsets.all(3)),
                        ReusableButton(
                          text1: 'OR',
                          text2: 'Ofs Rebound',
                          onPressed: () {
                            _handleButtonPress('Offensive Rebound');
                            // Vibration.vibrate(duration: 100, amplitude: 128);
                          },
                          value: 'Offensive Rebound',
                          backgroundColor: BasketcoColors.green,
                          textColor: BasketcoColors.white,
                        ),
                        Padding(padding: EdgeInsets.all(3)),
                        ReusableButton(
                          text1: 'B',
                          text2: 'Block',
                          onPressed: () {
                            _handleButtonPress('Block');
                            // Vibration.vibrate(duration: 100, amplitude: 128);
                          },
                          value: 'Block',
                          backgroundColor: BasketcoColors.green,
                          textColor: BasketcoColors.white,
                        ),
                        Padding(padding: EdgeInsets.all(3)),
                        ReusableButton(
                          text1: 'T',
                          text2: 'Technical',
                          onPressed: () {
                            _handleButtonPress('Technical Foul');
                            // Vibration.vibrate(duration: 100, amplitude: 128);
                          },
                          value: 'Technical Foul',
                          backgroundColor: BasketcoColors.red,
                          textColor: BasketcoColors.white,
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(3)),
                  SizedBox(
                    child: Wrap(
                      children: [
                        ReusableButton(
                          text1: '3',
                          text2: 'Made',
                          onPressed: () {
                            _handleButtonPress('Made +3');
                            // Vibration.vibrate(duration: 100, amplitude: 128);
                          },
                          value: 'Made 3',
                          backgroundColor: BasketcoColors.green,
                          textColor: BasketcoColors.white,
                        ),
                        Padding(padding: EdgeInsets.all(3)),
                        ReusableButton(
                          text1: '3',
                          text2: 'Missed',
                          onPressed: () {
                            _handleButtonPress('Missed +3');
                            // Vibration.vibrate(duration: 100, amplitude: 128);
                          },
                          value: 'Missed 3',
                          backgroundColor: BasketcoColors.red,
                          textColor: BasketcoColors.white,
                        ),
                        Padding(padding: EdgeInsets.all(3)),
                        ReusableButton(
                          text1: 'DR',
                          text2: 'Dfs Rebound',
                          onPressed: () {
                            _handleButtonPress('Defensive Rebound');
                            // Vibration.vibrate(duration: 100, amplitude: 128);
                          },
                          value: 'Defensive Rebound',
                          backgroundColor: BasketcoColors.green,
                          textColor: BasketcoColors.white,
                        ),
                        Padding(padding: EdgeInsets.all(3)),
                        ReusableButton(
                          text1: 'S',
                          text2: 'Steal',
                          onPressed: () {
                            _handleButtonPress('Steal');
                            // Vibration.vibrate(duration: 100, amplitude: 128);
                          },
                          value: 'Steal',
                          backgroundColor: BasketcoColors.green,
                          textColor: BasketcoColors.white,
                        ),
                        Padding(padding: EdgeInsets.all(3)),
                        ReusableButton(
                          text1: 'U',
                          text2: 'Unsports',
                          onPressed: () {
                            _handleButtonPress('Unsportmanship Foul');
                            // Vibration.vibrate(duration: 100, amplitude: 128);
                          },
                          value: 'Unsportsmanship Foul',
                          backgroundColor: BasketcoColors.red,
                          textColor: BasketcoColors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(3)),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child:  Wrap(
                      children: [
                        ReusableButton1(
                          text: 'Clear',
                          onPressed: () {
                            _handleClearButtonPress();
                            // Vibration.vibrate(duration: 100, amplitude: 128);
                          },
                          value: 'clear',
                          width: 93,
                          height: 50,
                          backgroundColor: BasketcoColors.lightBackground,
                          textColor: BasketcoColors.white,
                        ),
                        Padding(padding: EdgeInsets.all(3)),
                        ReusableButton1(
                          text: 'OK',
                          onPressed: () {
                            _handleOkButtonPress();
                            // Vibration.vibrate(duration: 100, amplitude: 128);
                          },
                          value: 'ok',
                          width: 80,
                          height: 50,
                          backgroundColor: BasketcoColors.lightGreen,
                          textColor: BasketcoColors.white,
                        ),
                        Padding(padding: EdgeInsets.all(3)),
                      ],
                    ),
                  ),
                  // Padding(padding: EdgeInsets.all(1)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
