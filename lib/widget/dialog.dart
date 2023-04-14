import 'package:flutter/material.dart';
import '../localization/localization.dart';
import '../util/darken_lighten_color.dart';
import '../constant/constant.dart';
import '../dbhelper/dbhelper.dart';
import '../provider/theme_provider.dart';

Future dialogWarning(BuildContext context, Map messageData,
    {IconData? icon, bool? close}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: AlertDialog(
          backgroundColor: theme(context).colorBackground,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius))),
          content: SizedBox(
            width: mediaSize(context).width / 1.5,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                icon != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12),
                        child: messageData['result'] == true ||
                                messageData['status'] == true ||
                                messageData['success'] == true ||
                                messageData['code'] == 200
                            ? Icon(
                                icon,
                                size: 100,
                                color: Colors.green,
                              )
                            : Icon(
                                icon,
                                size: 100,
                                color: theme(context).colorPrimary,
                              ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12),
                        child: messageData['result'] == true ||
                                messageData['status'] == true ||
                                messageData['success'] == true ||
                                messageData['code'] == 200
                            ? Icon(
                                Icons.check_circle,
                                size: 100,
                                color: theme(context).colorPrimary.lighten(25),
                              )
                            : Icon(
                                Icons.warning_amber_rounded,
                                size: 100,
                                color: theme(context).colorPrimary.lighten(25),
                              ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                      messageData['result'] == true ||
                              messageData['status'] == true ||
                              messageData['success'] == true ||
                              messageData['code'] == 200
                          ? "Success"
                          : "Sorry",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                  child: Text("${messageData['message']}",
                      style: const TextStyle(color: Colors.black),
                      textAlign: messageData['validation'] != null
                          ? TextAlign.start
                          : TextAlign.center),
                ),
                (() {
                  if (messageData['validation'] != null) {
                    return SizedBox(
                      width: mediaSize(context).width / 1.5,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: messageData['validation']?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          String? key =
                              messageData['validation'].keys.elementAt(index);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                '  $key : ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount:
                                    messageData['validation'][key]?.length ?? 0,
                                itemBuilder:
                                    (BuildContext context, int index2) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Text('- '),
                                      Expanded(
                                          child: Text(messageData['validation']
                                              [key][index2]))
                                    ],
                                  );
                                },
                              )
                            ],
                          );
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                })(),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Divider(
                    height: 1,
                    color: Colors.transparent,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: Container(
                    width: mediaSize(context).width / 2,
                    height: 40,
                    color: theme(context).colorPrimary,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(close),
                      child: Text(context.strLocal.close,
                          style: TextStyle(
                              color: theme(context).colorPrimaryFont,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void dialogCloseAplikasi(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: theme(context).colorBackground,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      title: Icon(
        Icons.warning_amber_rounded,
        size: 100,
        color: theme(context).colorPrimary.lighten(25),
      ),
      content: SizedBox(
        width: mediaSize(context).width / 1.5,
        child: ListView(shrinkWrap: true, children: [
          Text(context.strLocal.attention,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
              textAlign: TextAlign.center),
          const SizedBox(
            height: 8,
          ),
          Text(context.strLocal.doYouWantToClose,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center),
        ]),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: mediaSize(context).width / 1.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radius),
                    child: Container(
                      color: theme(context).colorPrimary,
                      width: mediaSize(context).width / 2,
                      height: 40,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(context.strLocal.isNo,
                            style: TextStyle(
                                color: theme(context).colorPrimaryFont,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radius),
                    child: Container(
                      width: mediaSize(context).width / 2,
                      height: 40,
                      color: theme(context).colorPrimary,
                      child: TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        child: Text(context.strLocal.isYes,
                            style: TextStyle(
                                color: theme(context).colorPrimaryFont,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}

void dialogLogOut(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: theme(context).colorBackground,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      title: Icon(
        Icons.power_settings_new,
        size: 100,
        color: theme(context).colorPrimary,
      ),
      content: SizedBox(
        width: mediaSize(context).width / 1.5,
        child: ListView(shrinkWrap: true, children: [
          Text(
            context.strLocal.attention,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(context.strLocal.doYouWantToClose,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center),
        ]),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: mediaSize(context).width / 1.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radius),
                    child: Container(
                      color: theme(context).colorPrimary,
                      width: mediaSize(context).width / 2,
                      height: 40,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(context.strLocal.isNo,
                            style: TextStyle(
                                color: theme(context).colorPrimaryFont,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radius),
                    child: Container(
                      width: mediaSize(context).width / 2,
                      height: 40,
                      color: theme(context).colorPrimary,
                      child: TextButton(
                        onPressed: () async {
                          dbHelper.deleteUser();
                          // Navigator.of(context, rootNavigator: true)
                          //     .pushAndRemoveUntil(
                          //   MaterialPageRoute(
                          //       builder: (context) => const LoginPage()),
                          //   (Route<dynamic> route) => false,
                          // );
                        },
                        child: Text(context.strLocal.isYes,
                            style: TextStyle(
                                color: theme(context).colorPrimaryFont,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
