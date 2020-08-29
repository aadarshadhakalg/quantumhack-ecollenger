import 'package:flutter/material.dart';
import 'package:ecollenger/constants.dart';

class ChallengeContainer extends StatelessWidget {
  const ChallengeContainer({
    @required this.context,
    this.challenge,
    this.days,
    this.hours,
    this.imageUrl,
    this.min,
    this.point,
  });

  final BuildContext context;
  final String challenge;
  final int days, hours, min;
  final String imageUrl;
  final int point;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: kchallengeBoxDecoration,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                children: <Widget>[
                  Text(
                    challenge,
                    style: ktitleText,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            days.toString(),
                            style: ktitleText,
                          ),
                          Text(
                            "Days",
                            style: klabelText,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            hours.toString(),
                            style: ktitleText,
                          ),
                          Text(
                            "Hours",
                            style: klabelText,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            min.toString(),
                            style: ktitleText,
                          ),
                          Text(
                            "Mins",
                            style: klabelText,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Flexible(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: kchallengeBoxDecoration.copyWith(
                        color: Colors.lightGreenAccent,
                      ),
                      child: Text(
                        point.toString() + " Points",
                        style: klabelText,
                      ),
                    ),
                    Image.network(
                      imageUrl,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
