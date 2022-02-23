import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/services/FirebaseOpertaion.dart';
import 'package:mared_social/services/authentication.dart';
import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';

class CounterView extends StatefulWidget {
  final int initNumber;
  final Function(int) counterCallback;
  final Function increaseCallback;
  final Function decreaseCallback;
  final int minNumber;
  final int auctionCurrentAmount;
  final DocumentSnapshot auctionDoc;
  const CounterView(
      {Key? key,
      required this.initNumber,
      required this.counterCallback,
      required this.increaseCallback,
      required this.decreaseCallback,
      required this.minNumber,
      required this.auctionCurrentAmount,
      required this.auctionDoc})
      : super(key: key);
  @override
  _CounterViewState createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  late int _currentCount;
  late Function _counterCallback;
  late Function _increaseCallback;
  late Function _decreaseCallback;
  late int _minNumber;
  late int _auctionCurrentAmount;

  @override
  void initState() {
    _currentCount = widget.initNumber;
    _counterCallback = widget.counterCallback;
    _increaseCallback = widget.increaseCallback;
    _decreaseCallback = widget.decreaseCallback;
    _minNumber = widget.minNumber;
    _auctionCurrentAmount = widget.auctionCurrentAmount;
    super.initState();
  }

  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.4,
      width: size.width,
      decoration: BoxDecoration(
        color: constantColors.blueGreyColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "Select Bid Amount",
              style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  backgroundColor: constantColors.darkColor,
                  onPressed: () => _dicrement(),
                  child: Icon(
                    FontAwesomeIcons.minus,
                    color: constantColors.redColor,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.1,
                  width: size.width * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "AED $_currentCount",
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: constantColors.darkColor,
                  onPressed: () => _increment(),
                  child: Icon(
                    FontAwesomeIcons.plus,
                    color: constantColors.greenColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: size.height * 0.1,
              width: size.width,
              decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: constantColors.blueColor,
                    width: 1,
                    style: BorderStyle.solid),
              ),
              child: SizedBox(
                height: size.height * 0.1,
                width: size.width * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Auction Item Price",
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "AED $_auctionCurrentAmount",
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors.pink,
                  fixedSize: const Size(300, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () async {
                  String bidId = nanoid(14).toString();
                  try {
                    await FirebaseFirestore.instance
                        .collection("auctions")
                        .doc(widget.auctionDoc.id)
                        .collection("bids")
                        .orderBy("time", descending: true)
                        .limit(1)
                        .get()
                        .then((bidCollection) async {
                      var bidVal = bidCollection.docs[0];
                      if (bidVal.exists &&
                          bidVal['useruid'] !=
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserId) {
                        await Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .notifyOverBid(
                                userToken: bidVal['fcmToken'],
                                auctionName: widget.auctionDoc['title']);
                      }
                    });
                    await Provider.of<FirebaseOperations>(context,
                            listen: false)
                        .placeBid(
                      currentPrice: _auctionCurrentAmount.toString(),
                      bidId: bidId,
                      auctionId: widget.auctionDoc.id,
                      bidderData: {
                        'bidid': bidId,
                        'bidamount': _auctionCurrentAmount.toString(),
                        'username': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getInitUserName,
                        'userimage': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getInitUserImage,
                        'useruid':
                            Provider.of<Authentication>(context, listen: false)
                                .getUserId,
                        'time': Timestamp.now(),
                        'useremail': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getInitUserEmail,
                        'fcmToken': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getFcmToken,
                      },
                      context: context,
                      myBidData: {
                        'bidid': bidId,
                        'time': Timestamp.now(),
                        'bidamount': _auctionCurrentAmount.toString(),
                        'auctionid': widget.auctionDoc.id,
                        'title': widget.auctionDoc['title'],
                        'description': widget.auctionDoc['description'],
                        'imageslist': widget.auctionDoc['imageslist'],
                        'enddate': widget.auctionDoc['enddate'],
                      },
                    )
                        .whenComplete(
                      () async {
                        Navigator.pop(context);

                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.success,
                            title: "Bid Successfully Placed");
                      },
                    );
                  } catch (e) {
                    CoolAlert.show(
                        context: context,
                        type: CoolAlertType.error,
                        title: "Bid unsuccessful",
                        text: e.toString());
                  }
                },
                icon: Icon(
                  FontAwesomeIcons.gavel,
                  color: constantColors.whiteColor,
                  size: 20,
                ),
                label: Text(
                  "Place Bid",
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 20,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  void _increment() {
    setState(() {
      _currentCount++;
      _auctionCurrentAmount++;
      _counterCallback(_currentCount);
      _increaseCallback();
    });
  }

  void _dicrement() {
    if (_currentCount > widget.minNumber) {
      setState(() {
        _currentCount--;
        _auctionCurrentAmount--;
        _counterCallback(_currentCount);
        _decreaseCallback();
      });
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: "Minimum Bid is AED ${widget.minNumber}",
        text:
            "The auction owner has set the minimum bid amount to be AED ${widget.minNumber}. You cannot place a bid lower than this.",
      );
    }
  }
}
