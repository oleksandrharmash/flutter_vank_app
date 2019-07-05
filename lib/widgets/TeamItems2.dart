import 'package:flutter/material.dart';
import 'package:squadre/utils/MyCallback.dart';
import 'package:squadre/utils/AppConstant.dart' as AppConstants;
import 'package:flutter_advanced_networkimage/src/flutter_advanced_networkimage.dart';

class TeamItems2 extends StatefulWidget {
  OnClickListener callback;
  bool isSelected = false;

  double width, height;
  int count = 0;
  Map data;

  TeamItems2(this.data, this.width, this.height,
      {this.count = 0, this.isSelected = false, this.callback});

  @override
  _TeamItems2State createState() => _TeamItems2State();
}

class _TeamItems2State extends State<TeamItems2> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.callback(!widget.isSelected);
      },
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                width: widget.width,
                height: widget.height,
                image: AdvancedNetworkImage(
                  widget.data[AppConstants.TEAM_IMAGE],
                  scale: 0.4,
                  useDiskCache: true,
                ),
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  widget.data[AppConstants.TEAM_NAME],
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
          widget.count > 0
              ? Positioned(
                  right: 1,
                  top: 1,
                  child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: Text(
                        widget.data[AppConstants.POST_NUMBER].toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                        textAlign: TextAlign.right,
                      )),
                )
              : Container()
        ],
      ),
    );
  }
}
