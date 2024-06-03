import 'package:basketco/Component/reusable_button1.dart';
import 'package:basketco/Pages/Calculator.dart';
import 'package:basketco/Service/match_firestore.dart';
import 'package:basketco/State/player_provider.dart';
import 'package:basketco/Utils/Colors.dart';
import 'package:basketco/Models/match_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubtitutionPage extends StatefulWidget {
  const SubtitutionPage({Key? key}) : super(key: key);

  @override
  State<SubtitutionPage> createState() => _SubtitutionPageState();
}

class _SubtitutionPageState extends State<SubtitutionPage> {
  late FirestoreService matchFirestoreService;
  MatchData? matchData;
  List<String> angkaList = [];
  List<String> angkaList2 = [];

  @override
  void initState() {
    super.initState();
    matchFirestoreService = FirestoreService();
    _fetchMatchData();
  }

  Future<void> _fetchMatchData() async {
    final data = await matchFirestoreService.getMatchPlayer('7nmmMoohUrEGKjRfpBfP'); // Sesuaikan dengan match ID yang diinginkan
    if (data != null) {
      setState(() {
        matchData = data;
        angkaList = data.terangPemain?.split(',') ?? [];
        angkaList2 = data.gelapPemain?.split(',') ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if (matchData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Subtitution', style: TextStyle(color: Colors.white)),
          backgroundColor: BasketcoColors.midBackground,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // Fungsi untuk kembali
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: Colors.white,
            ),
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Subtitution', style: TextStyle(color: Colors.white)),
        backgroundColor: BasketcoColors.midBackground,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Fungsi untuk kembali
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
          width: screenWidth,
          height: screenHeight,
          color: BasketcoColors.darkBackground,
          padding: EdgeInsets.only(left: 5, right: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildPlayerWrap(matchData!.terang, angkaList, true),
              _buildPlayerWrap(matchData!.gelap, angkaList2, false),
              Padding(padding: EdgeInsets.all(20)),
              ReusableButton1(
                text: 'OK',
                onPressed: _handleOkPressed,
                value: 'ok',
                width: 100,
                height: 50,
                backgroundColor: BasketcoColors.lightGreen,
                textColor: BasketcoColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerWrap(String? teamName, List<String> angkaList, bool isTerang) {
    return Wrap(
      children: [
        Padding(padding: EdgeInsets.all(12)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$teamName ', style: TextStyle(fontSize: 16, color: BasketcoColors.white)),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 4.0,
          children: angkaList.map((angka) {
            final isActive = isTerang
                ? context.read<MatchProvider>().isTerangActive(angka)
                : context.read<MatchProvider>().isGelapActive(angka);

            Color backgroundColor;
            Color textColor;
            if (isTerang) {
              backgroundColor = isActive ? Colors.white : Colors.white12;
              textColor = isActive ? Colors.blue : Colors.black87;
            } else {
              backgroundColor = isActive ? Colors.black : Colors.white12;
              textColor = isActive ? Colors.red : Colors.black87;
            }

            return Padding(
              padding: EdgeInsets.all(4),
              child: ReusableButton1(
                text: angka,
                onPressed: () {
                  setState(() {
                    if (isTerang) {
                      final isActiveList = context.read<MatchProvider>().activeTerang;
                      if (isActiveList.contains(angka)) {
                        isActiveList.remove(angka);
                      } else {
                        isActiveList.add(angka);
                      }
                    } else {
                      final isActiveList = context.read<MatchProvider>().activeGelap;
                      if (isActiveList.contains(angka)) {
                        isActiveList.remove(angka);
                      } else {
                        isActiveList.add(angka);
                      }
                    }
                  });
                },
                value: angka,
                width: 47,
                height: 47,
                backgroundColor: backgroundColor,
                textColor: textColor,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _handleOkPressed() {
    Navigator.of(context).pushNamed('/calculator');
  }
}