import 'package:flutter/material.dart';
import 'package:basketco/Utils/Colors.dart';
import 'package:basketco/Pages/Calculator.dart';
import 'package:basketco/Models/match_data.dart';

class ListMatchPage extends StatefulWidget {
  const ListMatchPage({Key? key}) : super(key: key);

  @override
  State<ListMatchPage> createState() => _ListMatchPageState();
}

class _ListMatchPageState extends State<ListMatchPage> {
  List<Color> _selectedColors = [
    Colors.blue,
    Colors.white,
    Colors.red,
    Colors.black,
  ];

  // late Kalkulator myKalkulator;
  String selectedValue = '2023-06-25';
  late String token;
  String _id = '';
  // late TanggalItem tanggalItem;
  List<MatchData> matchDataList = [];
  // List<TanggalItem> tanggalList = [];
  List<String> stringTanggalList = [];
  List<dynamic> tanggalData = [];
  MatchData matchData = MatchData(id: '', waktu: '', venue: '', terang: '', gelap: '', KU: '', pool: '', terangPemain: '', gelapPemain: '', terangId: '', gelapId: '', tanggalPlain: '', tanggal: '', jam: '');

  void onDropdownChanged(String? newValue) {
    setState(() {
      selectedValue = newValue!;
    });

    // fetchData(selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: BasketcoColors.midBackground,
        leading: Padding(padding: EdgeInsets.only(left: 0),),
        actions: [
          // SvgPicture.asset(
          //   'assets/image/logo-stat.svg',
          //   width: 424,
          //   height: 34,
          // ),
          SizedBox(width: 120,),
          DropdownButton<String>(
            value: selectedValue,
            style: TextStyle(color: Colors.white),
            icon: Icon(Icons.arrow_drop_down, color: Colors.white),
            elevation: 16,
            dropdownColor: BasketcoColors.darkBackground,
            items: stringTanggalList.map((String tanggal) {
              return DropdownMenuItem<String>(
                value: tanggal,
                child: Text(
                  tanggal,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            onChanged: onDropdownChanged,
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: matchDataList.length,
                  itemBuilder: (context, index) {
                    final matchData = matchDataList[index];
                    Color backgroundColor = index.isEven
                        ? BasketcoColors.darkBackground
                        : BasketcoColors.lightBackground;
                    return Container(
                      width: screenWidth,  // Atur panjang
                      height: 140, // Atur lebar
                      decoration: BoxDecoration(
                        color: backgroundColor,
                      ),
                      child: Stack(
                        children: [
                          Container(
                            width: screenWidth,
                            height: 140,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 200,
                                      //height: 20,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text('${matchData.terang ?? ''} vs ${matchData.gelap ?? ''}', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text('id'.toUpperCase(), style: TextStyle(fontSize: 12, color: Colors.white)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            // Navigasi ke layar WebView saat tombol ditekan
                                            // Navigator.of(context).push(
                                            //   MaterialPageRoute(
                                            //     builder: (context) => LogWebView(),
                                            //   ),
                                            // );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: BasketcoColors.grey,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                          ),
                                          child: const Icon(
                                            Icons.sort,
                                            size: 24,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Navigasi ke layar WebView saat tombol ditekan
                                            // Navigator.of(context).push(
                                            //   MaterialPageRoute(
                                            //     builder: (context) => StatistikWebView(),
                                            //   ),
                                            // );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), backgroundColor: BasketcoColors.grey,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.bar_chart,
                                            size: 24,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 200,
                                      height: 50,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text('${matchData.venue ?? ''}', style: TextStyle(fontSize: 12, color: Colors.white)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text('${matchData.tanggal ?? ''} ' '${matchData.jam ?? ''}', style: TextStyle(fontSize: 12, color: Colors.white)),
                                          ),
                                          // Add more Text widgets to display other data as needed
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            // String? id = matchData.id;
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) => InputConfiguration(
                                            //       initialColors: _selectedColors,
                                            //       onColorsChanged: (colors) {
                                            //         setState(() {
                                            //           _selectedColors = colors;
                                            //         });
                                            //         Navigator.of(context).pop();
                                            //       },token: widget.token, matchData: widget.matchData, selectedDate: selectedValue,
                                            //     ),
                                            //   ),
                                            // );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), backgroundColor: BasketcoColors.grey,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.settings,
                                            size: 24,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            String? id = matchData.id;
                                            // SchedulerBinding.instance.addPostFrameCallback((_) {
                                            //
                                            // });
                                            final result = Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => CalculatorPage(
                                                  // token: widget.token,
                                                  // matchData: widget.matchData,
                                                  // selectedColor1: Colors.white,
                                                  // selectedColor2: Colors.blue,
                                                  // selectedColor3: Colors.red,
                                                  // selectedColor4: Colors.black, data: {}, selectedDate: selectedValue, activeTerang: widget.activeTerang, activeGelap: widget.activeGelap,
                                                  // onColorsChanged: (colors) {
                                                  //   setState(() {
                                                  //     _selectedColors = colors;
                                                  //   });
                                                  //   Navigator.of(context).pop();
                                                  // },
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), backgroundColor: BasketcoColors.grey,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.play_arrow,
                                            size: 24,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: FloatingActionButton(
                backgroundColor: BasketcoColors.green,
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => InputConfiguration(
                  //       token: widget.token,
                  //       matchData: widget.matchData,
                  //       initialColors: _selectedColors,
                  //       onColorsChanged: (colors) {
                  //         setState(() {
                  //           _selectedColors = colors;
                  //         });
                  //         Navigator.of(context).pop();
                  //       }, selectedDate: '',
                  //     ),
                  //   ),
                  // );
                },
                child: Icon(Icons.add, size: 35, color: BasketcoColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
