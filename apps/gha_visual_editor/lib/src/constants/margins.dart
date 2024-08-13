import 'package:flutter/material.dart';

const emptyWidget = SizedBox.shrink();

const horizontalMargin4 = SizedBox(width: 4);
const horizontalMargin8 = SizedBox(width: 8);
const horizontalMargin12 = SizedBox(width: 12);
const horizontalMargin16 = SizedBox(width: 16);
const horizontalMargin20 = SizedBox(width: 20);
const horizontalMargin24 = SizedBox(width: 24);
const horizontalMargin32 = SizedBox(width: 32);
const horizontalMargin40 = SizedBox(width: 40);

const verticalMargin4 = SizedBox(height: 4);
const verticalMargin8 = SizedBox(height: 8);
const verticalMargin10 = SizedBox(height: 10);
const verticalMargin12 = SizedBox(height: 12);
const verticalMargin16 = SizedBox(height: 16);
const verticalMargin20 = SizedBox(height: 20);
const verticalMargin24 = SizedBox(height: 24);
const verticalMargin32 = SizedBox(height: 32);
const verticalMargin40 = SizedBox(height: 40);

SizedBox horizontalMarginDynamic(double value) => SizedBox(
      width: value,
    );
SizedBox verticalMarginDynamic(double value) => SizedBox(
      height: value,
    );
