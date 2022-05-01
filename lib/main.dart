import 'package:flutter/material.dart';
import 'package:flutter_onboarding/utilities/data_source.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Onboarding',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
              return RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50));
            }),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.all(25),
            ),
            backgroundColor: MaterialStateProperty.all(Colors.black),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List boardingData = DataSource.onboardingData;
  final PageController _controller = PageController(
    initialPage: 0,
  );
  int currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                makeBoardingWidget(0),
                makeBoardingWidget(1),
                makeBoardingWidget(2),
              ],
            ),
          ),
          Container(
            color: boardingData[currentPage]['color'],
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  makePageIndicatorWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (currentPage != 2)
                        const Text(
                          "SKIP",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      SizedBox(
                        width: currentPage != 2
                            ? MediaQuery.of(context).size.width * 0.3
                            : MediaQuery.of(context).size.width * 0.6,
                        child: ElevatedButton(
                          onPressed: () {
                            if (currentPage != 2) {
                              setState(() {
                                currentPage++;
                              });
                              _controller.animateToPage(
                                currentPage,
                                curve: Curves.easeIn,
                                duration: const Duration(milliseconds: 200),
                              );
                            }
                          },
                          child: Text(currentPage == 2 ? "START" : "NEXT"),
                        ),
                      )
                    ],
                  ),
                ]),
          ),
        ],
      ),
    );
  }

  makeBoardingWidget(int index) {
    return Container(
      color: boardingData[index]['color'],
      width: MediaQuery.of(context).size.width * 0.6,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(),
          Image.asset(
            boardingData[index]['image'],
            height: MediaQuery.of(context).size.width * 0.8,
            width: MediaQuery.of(context).size.width * 0.8,
          ),
          Column(
            children: [
              Text(
                boardingData[index]['title'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                boardingData[index]['description'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  makePageIndicatorWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        makeDot(0),
        makeDot(1),
        makeDot(2),
      ],
    );
  }

  makeDot(int index) {
    return Container(
      height: 10,
      width: index == currentPage ? 20 : 10,
      margin: EdgeInsets.only(right: index == 2 ? 0 : 5),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
    );
  }
}
