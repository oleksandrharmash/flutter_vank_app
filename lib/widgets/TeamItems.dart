import 'package:flutter/material.dart';
import 'package:squadre/utils/AppConstant.dart' as AppConstants;
import 'package:squadre/utils/MyCallback.dart';
import 'package:squadre/utils/Utils.dart';
import 'package:flutter_advanced_networkimage/src/flutter_advanced_networkimage.dart';

class TeamItems extends StatefulWidget {
  OnClickListener callback;
  bool isSelected = false;
  Map data;

  TeamItems(this.data, {this.isSelected = false, this.callback});

  @override
  _TeamItemsState createState() => _TeamItemsState();
}

class _TeamItemsState extends State<TeamItems> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.callback(!widget.isSelected);
      },
      child: Card(
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: widget.isSelected ? Utils.blueColor : Utils.greyColor,
                width: 3.0),
            borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 0),
        color: Utils.cardColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AdvancedNetworkImage(
                widget.data[AppConstants.TEAM_IMAGE],
                useDiskCache: true,
              ),
              fit: BoxFit.scaleDown,
              width: 150,
              height: 120,
            ),

            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                widget.data[AppConstants.TEAM_NAME],
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
