/// Controller for the categories page
/// Authors: Naumenko Maksim (xnaume01)
///          Vladyslav Kovalets (xkoval21)

import 'package:bonsai/constants/styles.dart';
import 'package:flutter/material.dart';
import '../../models/categories.dart';

import '../../models/category.dart';

class CreationCategoryController extends ChangeNotifier {
  List<bool> _careFlags = [false, false, false];
  int _careFlagsChanged = 0;

  List<int> _careFrequencyInDays = [0, 0, 0];

  List _careFrequency = [
    [0, 0],
    [0, 0],
    [0, 0],
  ];

  int _categoryCounter = 0; // ???

  List _careFrequencyText = [
    "Every day",
    "Every day",
    "Every day",
  ];

  List<String> _time = const <String>[
    "Day",
    "Week",
    "Month",
    "Year",
  ];

  final _categoryNameController = TextEditingController();

  final _categoryDescriptionController = TextEditingController();

  bool _submit = false;

  bool getSumbit() {
    return _submit;
  }

  int careChanged() {
    return _careFlagsChanged;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _categoryNameController.dispose();
    _categoryDescriptionController.dispose();
    super.dispose();
  }

  TextEditingController getCategoryNameController() {
    return _categoryNameController;
  }

  String? validateName() {
    if (_submit) {
      if (_categoryNameController.text.isEmpty) {
        return 'Enter category\'s name';
      }
      // if (_categoryNameController.text.length > 25) {
      //   return 'Too long';
      // }
    }
    return null;
  }

  String? validateDescription() {
    if ('\n'.allMatches(_categoryDescriptionController.text).length >= 3) {
      return 'Only 3 rows are available';
    }
    if (_categoryDescriptionController.text.length > 200) {
      return 'Too long';
    }
    return null;
  }

  String validateCare() {
    if ((_careFlags[0] == false) &&
        (_careFlags[1] == false) &&
        (_careFlags[2] == false) &&
        _submit == true) {
      return "Select at least one type of care";
    }
    return "Type of care";
  }

  TextEditingController getCategoryDescriptionController() {
    return _categoryDescriptionController;
  }

  String getCareFrequencyText(int index) {
    return _careFrequencyText[index];
  }

  void updateCareFrequencyText(int index) {
    if (_careFrequency[index][0] + 1 == 1) {
      _careFrequencyText[index] = "Every " + _time[_careFrequency[index][1]];
    } else {
      _careFrequencyText[index] = "Every " +
          (_careFrequency[index][0] + 1).toString() +
          " " +
          _time[_careFrequency[index][1]] +
          "s";
    }
    notifyListeners();
  }

  int getFrequencyIndex(int index) {
    return _careFrequency[index][0];
  }

  void setFrequencyIndex(int index, int value) {
    _careFrequency[index][0] = value;
    notifyListeners();
  }

  int getTimeIndex(int index) {
    return _careFrequency[index][1];
  }

  void setTimeIndex(int index, int value) {
    _careFrequency[index][1] = value;
    notifyListeners();
  }

  int getTimeListLength() {
    return _time.length;
  }

  String getTimeItem(int index) {
    return _time[index];
  }

  void UpdateFlag(bool value, int index) {
    _careFlags[index] = value;
    _careFlagsChanged++;
    notifyListeners();
  }

  bool getFlag(int index) {
    return _careFlags[index];
  }

  void cancel() {
    _careFlags = [false, false, false];
    _careFrequency = [
      [0, 0],
      [0, 0],
      [0, 0],
    ];
    _careFrequencyText = [
      "Every day",
      "Every day",
      "Every day",
    ];
    _categoryDescriptionController.clear();
    _categoryNameController.clear();
    _careFrequencyInDays = [0, 0, 0];
    _submit = false;
  }

  void _transformCareFrequency() {
    for (int i = 0; i < 3; i++) {
      switch (_careFrequency[i][1]) {
        case 0:
          _careFrequencyInDays[i] = (_careFrequency[i][0] + 1);
          break;
        case 1:
          _careFrequencyInDays[i] = (_careFrequency[i][0] + 1) * 7;
          break;
        case 2:
          _careFrequencyInDays[i] = (_careFrequency[i][0] + 1) * 31;
          break;
        case 3:
          _careFrequencyInDays[i] = (_careFrequency[i][0] + 1) * 365;
          break;
      }
    }
  }

  void createCategory(
    Categories categories,
    BuildContext context,
  ) {
    _categoryCounter++;
    _submit = true;
    if ((this.validateDescription() == null) &&
        (this.validateName() == null) &&
        (this.validateCare() == "Type of care")) {
      _transformCareFrequency();
      categories.addCategory(
          _categoryNameController.text,
          _categoryDescriptionController.text,
          _careFrequencyInDays[0],
          _careFlags[0],
          _careFrequency[0][0],
          _careFrequency[0][1],
          _careFrequencyInDays[1],
          _careFlags[1],
          _careFrequency[1][0],
          _careFrequency[1][1],
          _careFrequencyInDays[2],
          _careFlags[2],
          _careFrequency[2][0],
          _careFrequency[2][1]);
      cancel();
      Navigator.pop(context);
    }
    notifyListeners();
  }

  double setHeightOfDescriptionField(Category category) {
    if (category.getDescription().length < 40) {
      return 45;
    } else if (category.getDescription().length < 60) {
      return 68;
    } else {
      return category.getDescription().length.toDouble();
    }
  }

  List<DropdownMenuItem<String>> dropdownItems(Categories categories) {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text(Styles.notSelected), value: Styles.notSelected),
    ];

    for (int i = 0; i < categories.getCategoriesCounter(); i++) {
      menuItems.add(DropdownMenuItem(
          child: Text(categories.getCategories().elementAt(i).getName()),
          value: categories.getCategories().elementAt(i).getName()));
    }

    return menuItems;
  }
}
