import 'package:basketco/Pages/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:basketco/Utils/Colors.dart';
import 'package:basketco/Pages/Calculator.dart';
import 'package:basketco/Models/match_data.dart';
import 'package:basketco/Service/match_firestore.dart';

class ListMatchPage extends StatefulWidget {
  const ListMatchPage({Key? key}) : super(key: key);

  @override
  State<ListMatchPage> createState() => _ListMatchPageState();
}

class _ListMatchPageState extends State<ListMatchPage> {
  FirestoreService _firestoreService = FirestoreService();

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  List<Color> _selectedColors = [
    Colors.blue,
    Colors.white,
    Colors.red,
    Colors.black,
  ];

  @override
  void initState() {
    super.initState();
    fetchData(); // Panggil fungsi untuk memuat data saat halaman pertama kali dibuat
  }

  void fetchData() {
    FirestoreService _firestoreService = FirestoreService();
    _firestoreService.getMatchStream().listen((matches) {
      setState(() {
        matchDataList = matches;
      });
    }, onError: (error) {
      print("Failed to fetch matches: $error");
    });
  }

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

    print(FirebaseAuth.instance.currentUser);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Basketco',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: BasketcoColors.midBackground,
        leading: Padding(padding: EdgeInsets.only(left: 10),),
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
          Builder(
            builder: (context) {
              if (FirebaseAuth.instance.currentUser != null) {

                return IconButton(
                  onPressed: signUserOut,
                  icon: Icon(Icons.logout),
                );
              } else {
                return ElevatedButton(
                    onPressed: () {Navigator.pushNamed(context, '/auth');},
                    child: const Text("Masuk"));
              }
            },
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
                                        if (FirebaseAuth.instance.currentUser != null)
                                        ElevatedButton(
                                          onPressed: () {
                                            // Menghapus data saat tombol delete ditekan
                                            final matchID = matchDataList[index].id;
                                            if (matchID != null) {
                                              _firestoreService.deleteMatch(matchID)
                                                  .then((_) {
                                                setState(() {
                                                  // Setelah berhasil dihapus, perbarui tampilan dengan menghapus item dari daftar matchDataList
                                                  matchDataList.removeAt(index);
                                                });
                                              })
                                                  .catchError((error) {
                                                print("Failed to delete match: $error");
                                              });
                                            } else {
                                              print("Match ID is null, cannot delete.");
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: BasketcoColors.grey,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            size: 24,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        // ElevatedButton(
                                        //   onPressed: () {
                                        //     // Navigasi ke layar WebView saat tombol ditekan
                                        //     // Navigator.of(context).push(
                                        //     //   MaterialPageRoute(
                                        //     //     builder: (context) => StatistikWebView(),
                                        //     //   ),
                                        //     // );
                                        //   },
                                        //   style: ElevatedButton.styleFrom(
                                        //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), backgroundColor: BasketcoColors.grey,
                                        //     shape: RoundedRectangleBorder(
                                        //       borderRadius: BorderRadius.circular(4),
                                        //     ),
                                        //   ),
                                        //   child: const Icon(
                                        //     Icons.sort,
                                        //     size: 24,
                                        //     color: Colors.white,
                                        //   ),
                                        // ),
                                        // SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Navigasi ke layar WebView saat tombol ditekan
                                            // Navigator.of(context).push(
                                            //   MaterialPageRoute(
                                            //     builder: (context) => StatistikWebView(),
                                            //   ),
                                            // );
                                            Navigator.pushNamed(
                                              context,
                                              '/statistic',
                                              arguments: matchData,
                                            );
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
                                        if (FirebaseAuth.instance.currentUser != null)
                                        ElevatedButton(
                                          onPressed: () {
                                            // Navigator.pushNamed(context, '/configuration', arguments: matchData,);
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
                                            // Navigator.pushNamed(
                                            //   context,
                                            //   '/statistic',
                                            //   arguments: matchData,
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
                                        // ElevatedButton(
                                        //   onPressed: () {
                                        //     String? id = matchData.id;
                                        //     // SchedulerBinding.instance.addPostFrameCallback((_) {
                                        //     //
                                        //     // });
                                        //     final result = Navigator.push(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //         builder: (context) => CalculatorPage(
                                        //           // id: matchData.id,
                                        //           // token: widget.token,
                                        //           // matchData: widget.matchData,
                                        //           // selectedColor1: Colors.white,
                                        //           // selectedColor2: Colors.blue,
                                        //           // selectedColor3: Colors.red,
                                        //           // selectedColor4: Colors.black, data: {}, selectedDate: selectedValue, activeTerang: widget.activeTerang, activeGelap: widget.activeGelap,
                                        //           // onColorsChanged: (colors) {
                                        //           //   setState(() {
                                        //           //     _selectedColors = colors;
                                        //           //   });
                                        //           //   Navigator.of(context).pop();
                                        //           // },
                                        //         ),
                                        //       ),
                                        //     );
                                        //   },
                                        //   style: ElevatedButton.styleFrom(
                                        //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), backgroundColor: BasketcoColors.grey,
                                        //     shape: RoundedRectangleBorder(
                                        //       borderRadius: BorderRadius.circular(4),
                                        //     ),
                                        //   ),
                                        //   child: const Icon(
                                        //     Icons.play_arrow,
                                        //     size: 24,
                                        //     color: Colors.white,
                                        //   ),
                                        // ),
                                        if (FirebaseAuth.instance.currentUser != null)
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/calculator',
                                              arguments: matchData,
                                            );
                                            print('Navigating to CalculatorPage with matchData: ${matchData.id}');
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            backgroundColor: BasketcoColors.grey,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (FirebaseAuth.instance.currentUser != null)
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: FloatingActionButton(
                    backgroundColor: BasketcoColors.green,
                    onPressed: () {
                      Navigator.pushNamed(context, '/listteam');
                    },
                    child: Row(
                      children: [
                         Text(
                          'TEAM',
                          style: TextStyle(
                            fontSize: 20,
                            color: BasketcoColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (FirebaseAuth.instance.currentUser != null)
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: FloatingActionButton(
                    backgroundColor: BasketcoColors.green,
                    onPressed: () {
                      Navigator.pushNamed(context, '/configuration');
                    },
                    child: Icon(Icons.add, size: 35, color: BasketcoColors.white),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
