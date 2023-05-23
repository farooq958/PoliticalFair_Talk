import 'package:aft/ATESTS/utils/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/filter_arrays.dart';

class FilterProvider extends ChangeNotifier {
  FilterProvider() {
    twoValueGet();
  }

  twoValueGet() async {
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(twoValue1H) ?? '';

    setTwoValue(value);
    debugPrint("page value $value");
  }

  bool isHome = true;

  bool isMostLiked = false;
  String _global = 'true';
  String _messages = 'true';
  String _oneValue = 'Highest Score';
  String _twoValue = '';
  String _threeValue = '';
  String _countryCode = 'us';
  bool isAllKey = true;
  bool isSearchAllKey = false;
  bool isUser = false;
  bool searchFieldSelected = false;
  bool showMessages = false;
  bool showPolls = false;
  String? trendkeystore;
  List<String>? listPostPollId;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchController1 = TextEditingController();
  var _durationInDay;

  bool _notificationNav = false;

  int _initialPage = 0;

  setOneValue(String value) {
    _oneValue = value;

    notifyListeners();
  }

  setListPostPollId(List<String> val) {
    listPostPollId = val;

    notifyListeners();
  }

  setisHome(value) {
    isHome = value;

    notifyListeners();
  }

  setShowMessage(val) {
    showMessages = val;
    notifyListeners();
  }

  setshowPolls(val) {
    showPolls = val;
    notifyListeners();
  }

  setsearchFieldSelected(val) {
    searchFieldSelected = val;
    notifyListeners();
  }

  setisUser(val) {
    isUser = val;
    notifyListeners();
  }

  setisSearchAllKey(val) {
    isSearchAllKey = val;
    notifyListeners();
  }

  setisAllKey(val) {
    isAllKey = val;
    notifyListeners();
  }

  setTwoValue(String value) {
    _twoValue = value;
    //notifyListeners();
    debugPrint("set two values  ${_twoValue}");
  }

  setDurationInDay(var value) async {
    await Future.delayed(Duration.zero);
    // debugPrint('duration in date changed 3');
    _durationInDay = value;
    notifyListeners();
  }

  setGlobal(String value) {
    _global = value;
    notifyListeners();
  }

  setCountry(int index) {
    _countryCode = short[index];
    notifyListeners();
  }

  setCountryByString(String code) {
    _countryCode = code;
    notifyListeners();
  }

  setMessage(String value) {
    _messages = value;

    notifyListeners();
  }

  setIsMostLiked(value) {
    isMostLiked = value;

    notifyListeners();
  }

  Future<void> getValueG() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('selected_radio3') != null) {
      _global = prefs.getString('selected_radio3')!;
    }
  }

  Future<void> setValueG(String valueg) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _global = valueg.toString();
    prefs.setString('selected_radio3', _global);
    notifyListeners();
  }

  Future<void> getValueM() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('selected_radio4') != null) {
      _messages = prefs.getString('selected_radio4')!;
    }
    notifyListeners();
  }

  Future<void> getValue1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('selected_radio') != null) {
      _oneValue = prefs.getString('selected_radio')!;
    }
    notifyListeners();
  }

  setValueM(String valuem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _messages = valuem.toString();

    prefs.setString('selected_radio4', _messages);
  }

  loadCountryFilterValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int selectedCountryIndex = prefs.getInt('countryRadio') ?? 188;
    _countryCode = short[selectedCountryIndex];
  }

  Future<void> loadFilters() async {
    debugPrint('loadFilters working ');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int selectedCountryIndex = prefs.getInt('countryRadio') ?? 188;
    _countryCode = short[selectedCountryIndex];
    _oneValue = prefs.getString('selected_radio') ?? 'Highest Score';
    _twoValue = prefs.getString('selected_radio1') ?? 'All Days';
    if (_twoValue.isEmpty) {
      _twoValue = 'All Days';
    }
    if (_oneValue.isEmpty) {
      _oneValue = 'Highest Score';
    }
    _threeValue = prefs.getString('selected_radio2') ?? '';
    if (prefs.getString('selected_radio3') != null) {
      _global = prefs.getString('selected_radio3')!;
    }
    if (prefs.getString('selected_radio4') != null) {
      _messages = prefs.getString('selected_radio4')!;
    }

    notifyListeners();
  }

  setTrendKeyStore(String val) {
    trendkeystore = val;

    notifyListeners();
  }

  setAllValue() {
    isHome = true;
    _global = 'true';
    _messages = 'true';
    // _oneValue = 'Highest Score';
    // _twoValue = 'All Days';
    _threeValue = '';
    // _countryCode = 'us';
    isAllKey = true;
    isSearchAllKey = false;
    isUser = false;
    searchFieldSelected = false;
    showMessages = false;
    showPolls = false;
    isMostLiked = false;
    trendkeystore = null;
    searchController.text = searchController1.text;
    notifyListeners();
  }

  setInitialPage(int page) async {
    await Future.delayed(Duration.zero);
    _initialPage = page;
    _notificationNav = true;

    notifyListeners();
  }

  String get global => _global;

  String get messages => _messages;

  String get oneValue => _oneValue;

  String get twoValue => _twoValue;

  String get threeValue => _threeValue;

  String get countryCode => _countryCode;

  String get _trendkeystore => trendkeystore!;

  bool get _isAllKey => isAllKey;

  bool get _isSearchAllKey => isSearchAllKey;

  bool get _isUser => isUser;

  bool get _searchFieldSelected => searchFieldSelected;

  bool get _showMessages => showMessages;

  bool get _showPolls => showPolls;

  TextEditingController get _searchController => searchController;

  get durationInDay => _durationInDay;

  int get initialPage => _initialPage;

  bool get notificationNav => _notificationNav;
}
