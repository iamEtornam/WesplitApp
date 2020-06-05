import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wesplit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(26, 65, 207, 1),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double sliderValue = 0.0;
  String payableAmount = '0.00';
  int personCount = 1;

  incrementOfPerson() {
    ++personCount;
    setState(() {});
  }

  decrementOfPerson() {
    if (personCount > 1) {
      --personCount;
    }
    setState(() {});
  }

  onKeyboardPressed({@required String keyboardValue}) {
    if (payableAmount == '0.00') {
      payableAmount = keyboardValue;
    } else {
      payableAmount = payableAmount + keyboardValue;
    }
    setState(() {});
  }

  onDeletePressed() {
    if (payableAmount.length > 0) {
      payableAmount = payableAmount.substring(0, payableAmount.length - 1);
    } else if (payableAmount.isEmpty) {
      payableAmount = '0.00';
    }
    setState(() {});
  }

  ///add tip to payable amount divide it by the personCount
  String calculateSplitAmount() {
    double newSubTotal = double.tryParse(payableAmount) + (100 / sliderValue);
    double total = newSubTotal / personCount;
    return total.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 65, 207, 1),
      appBar: AppBar(
        title: Text(
          'Wesplit',
          style: TextStyle(color: Colors.white38),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          Center(
            child: Text(
              'Total (incl. tax & tip)',
              style: TextStyle(color: Colors.white38),
            ),
          ),
          Center(
            child: RichText(
                text: TextSpan(children: [
              WidgetSpan(
                  child: Transform.translate(
                offset: Offset(2, -23),
                child: Text(
                  'GHC ',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              )),
              TextSpan(
                  text: payableAmount,
                  style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))
            ])),
          ),
          SizedBox(height: 30),
          Center(
            child: Text(
              'Tip allocation ($sliderValue%)',
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
          ),
          SliderTheme(
            data: SliderThemeData(
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.white38,
                trackShape: RoundedRectSliderTrackShape(),
                trackHeight: 4,
                thumbShape:
                    RoundSliderThumbShape(elevation: 2, enabledThumbRadius: 12),
                thumbColor: Colors.white,
                overlayColor: Colors.white.withAlpha(32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 28),
                tickMarkShape: RoundSliderTickMarkShape(),
                activeTickMarkColor: Colors.white,
                inactiveTickMarkColor: Colors.white38,
                valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                valueIndicatorColor: Colors.white,
                valueIndicatorTextStyle:
                    TextStyle(color: Color.fromRGBO(26, 65, 207, 1))),
            child: Slider(
                value: sliderValue,
                min: 0,
                max: 100,
                divisions: 100,
                onChanged: (value) {
                  setState(() {
                    sliderValue = value;
                  });
                }),
          ),
          SizedBox(height: 25),
          Material(
            color: Color.fromRGBO(27, 62, 179, 1),
            borderRadius: BorderRadius.circular(45),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    decrementOfPerson();
                  },
                  color: Colors.white,
                ),
                Wrap(
                  children: [
                    Text(
                      '$personCount',
                      style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.people,
                      color: Colors.white38,
                    )
                  ],
                ),
                IconButton(
                    icon: Icon(Icons.add),
                    color: Colors.white,
                    onPressed: () {
                      incrementOfPerson();
                    })
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              keyboardRowWidget(
                  firstValue: '1', secondValue: '2', thirdValue: '3'),
              keyboardRowWidget(
                  firstValue: '4', secondValue: '5', thirdValue: '6'),
              keyboardRowWidget(
                  firstValue: '7', secondValue: '8', thirdValue: '9'),
              keyboardRowWidget(
                  firstValue: '.', secondValue: '0', thirdValue: 'Del')
            ],
          ),
          SizedBox(height: 15),
          FlatButton(
            onPressed: () {
              String totalAmount = calculateSplitAmount();
              showModalBottomSheet(
                  context: context,
                  isDismissible: true,
                  isScrollControlled: true,
                  enableDrag: true,
                  builder: (_) {
                    return PriceDisplayWidget(
                      numberOfPeople: personCount,
                      totalAmount: totalAmount,
                      tipPercentage: sliderValue,
                    );
                  });
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            color: Colors.green,
            child: Text(
              'SPLIT',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Row keyboardRowWidget(
      {String firstValue, String secondValue, String thirdValue}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FlatButton(
            onPressed: () {
              onKeyboardPressed(keyboardValue: firstValue);
            },
            child: Text(
              firstValue,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            )),
        FlatButton(
            onPressed: () {
              onKeyboardPressed(keyboardValue: secondValue);
            },
            child: Text(
              secondValue,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            )),
        FlatButton(
            onPressed: () {
              if (thirdValue == 'Del') {
                onDeletePressed();
              } else {
                onKeyboardPressed(keyboardValue: thirdValue);
              }
            },
            child: Text(
              thirdValue,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ))
      ],
    );
  }
}

class PriceDisplayWidget extends StatelessWidget {
  final String totalAmount;
  final int numberOfPeople;
  final double tipPercentage;

  const PriceDisplayWidget(
      {Key key, this.totalAmount, this.numberOfPeople, this.tipPercentage})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 65, 207, 1),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            SizedBox(height: 25),
            Text(
              'Amount per Person:',
              style: TextStyle(
                  color: Colors.white38,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
            SizedBox(height: 5),
            RichText(
                text: TextSpan(children: [
              WidgetSpan(
                  child: Transform.translate(
                offset: Offset(2, -25),
                child: Text(
                  'GHC ',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              )),
              TextSpan(
                  text: totalAmount,
                  style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))
            ])),
            SizedBox(height: 15),
            Text(
              'Tip Percentage is:',
              style: TextStyle(
                  color: Colors.white38,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
            Text(
              '$tipPercentage%',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
            ),
            SizedBox(height: 15),
            Text(
              'Number of people is:',
              style: TextStyle(
                  color: Colors.white38,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
            Text(
              '$numberOfPeople%',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
            ),
            SizedBox(height: 25),
            FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(45)),
                color: Colors.red,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Dismiss',style: TextStyle(color: Colors.white),))
          ],
        ),
      ),
    );
  }
}
