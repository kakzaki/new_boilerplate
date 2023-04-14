import 'package:flutter/material.dart';
import '../constant/constant.dart';
import '../provider/theme_provider.dart';

InkWell bigButton(BuildContext context,
    {IconData? icon, required String title, required Function() onPressed}) {
  return InkWell(
    onTap: onPressed,
    child: SizedBox(
      width: MediaQuery.of(context).size.width,
      height: buttonHeight,
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  // gradient: linearGradient,
                  color: theme(context).colorPrimary,
                  borderRadius: BorderRadius.circular(radius)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  icon == null
                      ? Container()
                      : Flexible(
                          child: Icon(
                            icon,
                            color: theme(context).colorPrimaryFont,
                            size: 28,
                          ),
                        ),
                  icon == null
                      ? Container()
                      : const Flexible(
                          child: SizedBox(
                          width: 16,
                        )),
                  Expanded(
                    child: Center(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSize1,
                          fontWeight: FontWeight.w600,
                          color: theme(context).colorPrimaryFont,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}
