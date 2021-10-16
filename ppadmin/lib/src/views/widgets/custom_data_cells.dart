import 'package:flutter/material.dart';
import 'package:ppadmin/src/utils/utils.dart';

DataCell customTextDataCell(var data) {
  if (data != null) {
    return DataCell(Text(
      "$data",
      style: Styles.tableValuesTextStyle(),
    ));
  } else {
    return DataCell(Text(
      "-",
      style: Styles.tableValuesTextStyle(),
    ));
  }
}

DataCell noDataInCell() {
  return DataCell(Text(
    "-",
    style: Styles.tableValuesTextStyle(),
  ));
}
