import 'dart:async';

import 'package:aft/ATESTS/provider/filter_provider.dart';
import 'package:aft/ATESTS/provider/most_liked_provider.dart';
import 'package:aft/ATESTS/provider/poll_provider.dart';
import 'package:aft/ATESTS/provider/post_provider.dart';
import 'package:aft/ATESTS/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../responsive/my_flutter_app_icons.dart';
import '../utils/utils.dart';
import 'filter_arrays.dart';

class Countries extends StatefulWidget {
  final durationInDay;
  final int removeFilterOptions;
  final int pageIndex;

  const Countries(
      {this.durationInDay,
      required this.removeFilterOptions,
      required this.pageIndex,
      super.key});

  @override
  State<Countries> createState() => _CountriesState();
}

class _CountriesState extends State<Countries> {
  final TextEditingController _countriesController = TextEditingController();
  String searchText = '';
  int selectedCountryIndex = short.indexOf('us');
  var oneValue = 'Highest Score';
  var twoValue = '≤ 7 Days';
  var two1Value = '≤ 7 Days';

  @override
  void initState() {
    super.initState();
    // getValue();
    if (widget.pageIndex == 0 || widget.pageIndex == 1) {
      twoValue = 'All Days';
      two1Value = 'All Days';
    }
    getValueOne();

    getValue1();
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    selectedCountryIndex = short.indexOf(filterProvider.countryCode);
    _countriesController.addListener(_filterList);
  }

  @override
  void dispose() {
    _countriesController.dispose();
    super.dispose();
  }

  void _filterList() {
    setState(() {
      searchText = _countriesController.text.toLowerCase();
    });
  }

  // Future<void>
  getValue() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('countryRadio') != null) {
      setState(() {
        if (userProvider.getUser != null) {
          selectedCountryIndex = short.indexOf(userProvider.getUser!.aaCountry);
        } else {
          // selectedCountryIndex = prefs.getInt('countryRadio')!;
          selectedCountryIndex = short.indexOf(
              Provider.of<FilterProvider>(context, listen: false).countryCode);
        }
      });
    }
  }

  // Future<void>
  setValue(int countryIndex) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    filterProvider.setCountry(countryIndex);
    if (filterProvider.messages == 'true') {
      // debugPrint("post country is ${filterProvider.countryCode}");
      Provider.of<PostProvider>(context, listen: false).getPosts(
          filterProvider.twoValue,
          filterProvider.global,
          filterProvider.countryCode,
          widget.durationInDay,
          filterProvider.oneValue);
      Provider.of<MostLikedProvider>(context, listen: false).getMostLikedPosts(
          filterProvider.global,
          filterProvider.countryCode,
          filterProvider.oneValue);
    } else {
      Provider.of<PollsProvider>(context, listen: false).getPolls(
          filterProvider.twoValue,
          filterProvider.global,
          filterProvider.countryCode,
          widget.durationInDay,
          filterProvider.oneValue);

      Provider.of<MostLikedProvider>(context, listen: false).getMostLikedPolls(
          filterProvider.global,
          filterProvider.countryCode,
          filterProvider.oneValue);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCountryIndex = countryIndex;
      prefs.setInt('countryRadio', selectedCountryIndex);
    });
  }

  Future<void> getValueOne() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      String value2 = '';
      if (widget.pageIndex == 2) {
        value2 = prefs.getString('selected_radio1') ?? "";
      } else {
        value2 = prefs.getString('selected_radio1H') ?? "";
      }
      if (value2.isNotEmpty) {
        twoValue = value2;
        if (widget.pageIndex == 2) {
          debugPrint("two value for chek working ${twoValue}");
          if (twoValue == 'All Days') {
            twoValue = '≤ 7 Days';
          }
        }
      }

      debugPrint("value two check $twoValue   1 $two1Value");
    });
  }

  Future<void> setValueOne(String valueo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      twoValue = valueo.toString();
      if (widget.pageIndex == 2) {
        prefs.setString('selected_radio1', twoValue);
      } else {
        prefs.setString('selected_radio1H', twoValue);
      }
    });
  }

  Future<void> getValue1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('selected_radio') != null) {
      setState(() {
        String value1 = prefs.getString('selected_radio')!;
        if (value1.isNotEmpty) {
          oneValue = value1;
        }
        debugPrint("value one $oneValue");
      });
    }
  }

  Future<void> setValue1(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      oneValue = value.toString();
      prefs.setString('selected_radio', oneValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);

    List<String> filtedlist = long
        .where(
            (c) => c.toLowerCase().startsWith(searchText) || searchText == '')
        .toList();

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.05),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 245, 245, 245),
            elevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: 92,
            actions: [
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      PhysicalModel(
                        color: Colors.white,
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 3, top: 3),
                          child: SizedBox(
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Material(
                                          shape: const CircleBorder(),
                                          color: Colors.white,
                                          child: InkWell(
                                            customBorder: const CircleBorder(),
                                            splashColor:
                                                Colors.grey.withOpacity(0.5),
                                            onTap: () {
                                              Future.delayed(
                                                const Duration(
                                                    milliseconds: 50),
                                                () {
                                                  Navigator.pop(context);
                                                },
                                              );
                                            },
                                            child: const Icon(Icons.arrow_back,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Material(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(8),
                                        splashColor:
                                            Colors.grey.withOpacity(0.3),
                                        onTap: () {
                                          filterDialog(context: context);
                                        },
                                        child: MediaQuery.of(context)
                                                    .size
                                                    .width >
                                                600
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Text('Sort & ',
                                                      style: TextStyle(
                                                          fontSize: 19,
                                                          letterSpacing: 0.5,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  Text('Filter',
                                                      style: TextStyle(
                                                          fontSize: 19,
                                                          letterSpacing: 0.5,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ],
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Text('Sort &',
                                                      style: TextStyle(
                                                          fontSize: 19,
                                                          letterSpacing: 0.5,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  Text('Filter',
                                                      style: TextStyle(
                                                          fontSize: 19,
                                                          letterSpacing: 0.5,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ],
                                              ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: const Padding(
                                        padding: EdgeInsets.only(left: 3.0),
                                        child: Icon(
                                          Icons.info_outline,
                                          color: Colors.black,
                                          size: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, right: 14, bottom: 8),
                                  child: PhysicalModel(
                                    elevation: 3,
                                    color: const Color.fromARGB(
                                        255, 240, 240, 240),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        // border: Border.all(
                                        //   width: 1,
                                        //   color: Colors.grey,
                                        // ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width >
                                              600
                                          ? 230
                                          : 200,
                                      height: 60,
                                      child: Theme(
                                        data: ThemeData(
                                          colorScheme: ThemeData()
                                              .colorScheme
                                              .copyWith(
                                                primary: const Color.fromARGB(
                                                    255, 131, 135, 138),
                                              ),
                                        ),
                                        child: TextField(
                                          onEditingComplete: () {},
                                          onTap: () {},
                                          maxLines: 1,
                                          controller: _countriesController,
                                          decoration: const InputDecoration(
                                            prefixIcon: Icon(Icons.search,
                                                color: Colors.grey, size: 20),
                                            hintText: "Search Countries",
                                            labelStyle: TextStyle(
                                              color: Colors.grey,
                                              fontStyle: FontStyle.normal,
                                            ),
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.only(
                                              top: 11,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 8,
                      ),
                      widget.removeFilterOptions == 3
                          ? const SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                widget.removeFilterOptions == 0 ||
                                        widget.removeFilterOptions == 1 ||
                                        widget.removeFilterOptions == 2
                                    ? Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3 -
                                                11,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3 -
                                                  11,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0),
                                              child: const Center(
                                                child: Text(
                                                  'Sorting Order',
                                                  style: TextStyle(
                                                      fontSize: 13.5,
                                                      letterSpacing: 0.3,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                widget.removeFilterOptions == 0 ||
                                        widget.removeFilterOptions == 1
                                    ? Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3 -
                                                11,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3 -
                                                  11,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0),
                                              child: const Center(
                                                child: Text('Voting Cycles',
                                                    style: TextStyle(
                                                        fontSize: 13.5,
                                                        letterSpacing: 0.3,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      child: const Center(
                                        child: Text('Countries',
                                            style: TextStyle(
                                                fontSize: 13.5,
                                                letterSpacing: 0.3,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      // Container(
                      //   height: 2,
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: widget.removeFilterOptions == 3
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'No sorting or filtering options are available when searching for users.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8, top: 4),
                  child: Row(
                    children: <Widget>[
                      widget.removeFilterOptions == 0 ||
                              widget.removeFilterOptions == 1 ||
                              widget.removeFilterOptions == 2
                          ? Expanded(
                              child: ListView.separated(
                                itemCount: one.length,
                                controller: ScrollController(),
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 6),
                                itemBuilder: (context, index) =>
                                    NoRadioListTile<String>(
                                        type: 'one value',
                                        pageIndex: widget.pageIndex,
                                        value: one[index],
                                        durationInDay: widget.durationInDay,
                                        groupValue: filterProvider.oneValue,
                                        leading: one[index],
                                        // onChanged: (value) => setValue1(
                                        //   value.toString(),
                                        // ),
                                        onChanged: (value) {
                                          if (value == 'Highest Score') {
                                            if (widget.pageIndex == 2) {
                                              // setValueOne('≤ 7 Days');
                                              // getValueOne();
                                              // filterProvider
                                              //     .setOneValue('≤ 7 Days');
                                            }
                                          }

                                          filterProvider.setOneValue(
                                              value ?? 'Highest Score');
                                          // debugPrint('change is here ${value}');
                                          setValue1(
                                            value.toString(),
                                          );
                                        }),
                              ),
                            )
                          // : widget.removeFilterOptions == 1
                          //     ? Expanded(
                          //         child: Column(
                          //           children: [
                          //             SizedBox(
                          //               height: 41,
                          //               child: PhysicalModel(
                          //                 color: Color.fromARGB(
                          //                     255, 187, 225, 255),
                          //                 elevation: 2,
                          //                 borderRadius:
                          //                     BorderRadius.circular(5),
                          //                 child: Container(
                          //                   decoration: BoxDecoration(
                          //                     borderRadius:
                          //                         BorderRadius.circular(5),
                          //                   ),
                          //                   child: Row(
                          //                     mainAxisAlignment:
                          //                         MainAxisAlignment.start,
                          //                     children: [
                          //                       Padding(
                          //                         padding:
                          //                             const EdgeInsets.only(
                          //                                 left: 6.0),
                          //                         child: Icon(Icons.trending_up,
                          //                             color: Colors.black,
                          //                             size: 21),
                          //                       ),
                          //                       const SizedBox(width: 5),
                          //                       Expanded(
                          //                         child: SizedBox(
                          //                           child: Text(
                          //                             'Highest Score',
                          //                             textAlign:
                          //                                 TextAlign.center,
                          //                             style: TextStyle(
                          //                               color: Colors.black,
                          //                               fontSize: 11,
                          //                               fontWeight:
                          //                                   FontWeight.w500,
                          //                             ),
                          //                           ),
                          //                         ),
                          //                       ),
                          //                       const SizedBox(width: 10),
                          //                     ],
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       )
                          : const SizedBox(),
                      SizedBox(
                          width: widget.removeFilterOptions == 0 ||
                                  widget.removeFilterOptions == 1 ||
                                  widget.removeFilterOptions == 2
                              ? 6
                              : 0),
                      widget.removeFilterOptions == 0 ||
                              widget.removeFilterOptions == 1
                          ? Expanded(
                              child: ListView.separated(
                                itemCount: oneValue != 'Most Recent'
                                    ? widget.pageIndex == 0 ||
                                            widget.pageIndex == 1
                                        ? twoHome.length
                                        : two.length
                                    : widget.pageIndex == 0 ||
                                            widget.pageIndex == 1
                                        ? twoHome1.length
                                        : two1.length,
                                controller: ScrollController(),
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 6),
                                itemBuilder: (context, index) =>
                                    NoRadioListTile<String>(
                                  type: 'two value',
                                  durationInDay: widget.durationInDay,
                                  value: oneValue != 'Most Recent'
                                      ? widget.pageIndex == 0 ||
                                              widget.pageIndex == 1
                                          ? twoHome[index]
                                          : two[index]
                                      : widget.pageIndex == 0 ||
                                              widget.pageIndex == 1
                                          ? twoHome1[index]
                                          : two1[index],
                                  groupValue: oneValue != 'Most Recent'
                                      ? twoValue
                                      : two1Value,
                                  leading: oneValue != 'Most Recent'
                                      ? widget.pageIndex == 0 ||
                                              widget.pageIndex == 1
                                          ? twoHome[index]
                                          : two[index]
                                      : widget.pageIndex == 0 ||
                                              widget.pageIndex == 1
                                          ? twoHome1[index]
                                          : two1[index],
                                  pageIndex: widget.pageIndex,
                                  onChanged: (valueo) {
                                    // onChanged: (valueo) => setValueOne(valueo.toString()),
                                    if (oneValue != "Most Recent") {
                                      setValueOne(valueo.toString());
                                    }
                                  },
                                ),
                              ),
                            )
                          : const SizedBox(),
                      SizedBox(
                          width: widget.removeFilterOptions == 0 ||
                                  widget.removeFilterOptions == 1
                              ? 6
                              : 0),
                      Expanded(
                        child: ListView.separated(
                          itemCount: filtedlist.length,
                          controller: ScrollController(),
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 6),
                          itemBuilder: (context, index) => MyRadioListTile(
                            selectedIndex: selectedCountryIndex,
                            index: long.indexOf(filtedlist[index]),
                            onChanged: (i) {
                              setValue(i);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class NoRadioListTile<T> extends StatefulWidget {
  final T value;
  final T groupValue;
  final String leading;
  final String type;
  final durationInDay;
  final ValueChanged<T?> onChanged;
  final int pageIndex;

  const NoRadioListTile({
    super.key,
    required this.type,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.leading,
    required this.durationInDay,
    required this.pageIndex,
  });

  @override
  State<NoRadioListTile<T>> createState() => _NoRadioListTileState<T>();
}

class _NoRadioListTileState<T> extends State<NoRadioListTile<T>> {
  @override
  Widget build(BuildContext context) {
    final isSelected = widget.value == widget.groupValue;

    return InkWell(
      onTap: () async {
        widget.onChanged(widget.value);
        debugPrint("widget value :${widget.value}");

        final filterProvider =
            Provider.of<FilterProvider>(context, listen: false);
        if (widget.type == 'one value') {
          if (widget.value.toString() == 'Most Recent') {
            filterProvider.setTwoValue(
                widget.pageIndex == 0 || widget.pageIndex == 1
                    ? 'All Days'
                    : '≤ 7 Days');
          }
          filterProvider.setOneValue(widget.value.toString());
        } else if (widget.type == 'two value') {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          if (widget.pageIndex == 2) {
            await prefs.setString('selected_radio1', widget.value.toString());
          } else {
            await prefs.setString('selected_radio1H', widget.value.toString());
          }

          filterProvider.setTwoValue(widget.value.toString());
        }
        if (filterProvider.messages == 'true') {
          Provider.of<PostProvider>(context, listen: false).getPosts(
              filterProvider.twoValue,
              filterProvider.global,
              filterProvider.countryCode,
              widget.durationInDay,
              filterProvider.oneValue);
          Provider.of<MostLikedProvider>(context, listen: false)
              .getMostLikedPosts(
            filterProvider.global,
            filterProvider.countryCode,
            filterProvider.oneValue,
          );
        } else {
          Provider.of<PollsProvider>(context, listen: false).getPolls(
              filterProvider.twoValue,
              filterProvider.global,
              filterProvider.countryCode,
              widget.durationInDay,
              filterProvider.oneValue);
          Provider.of<MostLikedProvider>(context, listen: false)
              .getMostLikedPolls(
            filterProvider.global,
            filterProvider.countryCode,
            filterProvider.oneValue,
          );
        }
      },
      child: SizedBox(
        height: 41,
        child: PhysicalModel(
          color: isSelected
              ? const Color.fromARGB(255, 187, 225, 255)
              : Colors.white,
          elevation: 2,
          borderRadius: BorderRadius.circular(5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              // border: Border.all(
              //   width: isSelected ? 1 : 1,
              //   color: isSelected ? Colors.blue : Colors.grey,
              // ),
            ),
            // : null,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Icon(
                      widget.leading == 'Highest Score'
                          ? Icons.trending_up
                          : widget.leading == 'Most Recent'
                              ? Icons.stars
                              : MyFlutterApp.hourglass_2,
                      color: isSelected ? Colors.black : Colors.grey,
                      size: widget.leading == 'Highest Score' ||
                              widget.leading == 'Most Recent'
                          ? 21
                          : 18),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      // width: MediaQuery.of(context).size.width / 3 - 60,
                      child: Text(
                        widget.leading,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.grey,
                          fontSize: widget.leading == 'Highest Score' ||
                                  widget.leading == 'Most Recent'
                              ? 11
                              : 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyRadioListTile extends StatelessWidget {
  final int selectedIndex;
  final int index;
  final ValueChanged<int> onChanged;

  const MyRadioListTile({
    super.key,
    required this.selectedIndex,
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    String flag = short[index];
    return InkWell(
      onTap: () {
        // debugPrint('country on changed 1st ${index}');
        onChanged(index);
      },
      child: SizedBox(
        height: 41,
        child: InkWell(
          onTap: () {
            // debugPrint('country on changed 2nd ${index}');
            onChanged(index);
          },
          child: SizedBox(
            height: 41,
            child: PhysicalModel(
              color: index == selectedIndex
                  ? const Color.fromARGB(255, 187, 225, 255)
                  : Colors.white,
              borderRadius: BorderRadius.circular(5),
              elevation: 2,
              child: Container(
                // width: 200,
                padding: const EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  // color: index == selectedIndex
                  //     ? Colors.blue.withOpacity(0.3)
                  //     : Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  // border: Border.all(
                  //   width: index == selectedIndex ? 1 : 1,
                  //   color: index == selectedIndex ? Colors.blue : Colors.grey,
                  // ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0, right: 2),
                      child: SizedBox(
                        width: 25,
                        height: 15,
                        child: Image.asset('icons/flags/png/$flag.png',
                            package: 'country_icons'),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          // width: MediaQuery.of(context).size.width / 3 - 50,
                          child: Text(
                            long[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: index == selectedIndex
                                  ? Colors.black
                                  : Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
