import 'package:flutter/material.dart';
import '../Methods/firestore_methods.dart';
import '../utils/utils.dart';

class ReportBug extends StatefulWidget {
  const ReportBug({Key? key}) : super(key: key);

  @override
  State<ReportBug> createState() => _ReportBugState();
}

class _ReportBugState extends State<ReportBug> {
  final TextEditingController _reportBug = TextEditingController();
  final TextEditingController _deviceType = TextEditingController();

  final int _bugReportFieldMaxLength = 1000;
  final int _deviceTypeFieldMaxLength = 50;
  bool _isLoading = false;
  bool emptyBugReport = false;
  bool emptyDeviceType = false;

  @override
  void dispose() {
    super.dispose();
    _reportBug.dispose;
    _deviceType.dispose;
  }

  void uploadReportedBug() async {
    try {
      emptyBugReport = _reportBug.text.trim().isEmpty;
      emptyDeviceType = _deviceType.text.trim().isEmpty;
      setState(() {});
      if (!emptyBugReport) {
        if (!emptyDeviceType) {
          setState(() {
            _isLoading = true;
          });

          String res = await FirestoreMethods().uploadReportedBug(
            _reportBug.text,
            _deviceType.text,
          );
          if (res == "success") {
            Future.delayed(const Duration(milliseconds: 1000), () {
              setState(() {
                _isLoading = false;
              });
              showSnackBar('Bug successfully reported.', context);
              _reportBug.clear();
              _deviceType.clear();
              FocusScope.of(context).unfocus();
            });
          } else {
            // showSnackBar(res, context);
          }
        } else {
          showSnackBar('Device type cannot be empty.', context);
        }
      } else {
        showSnackBar('Report a bug cannot be empty.', context);
      }
    } catch (e) {
      // showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
          appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 4,
              toolbarHeight: 56,
              actions: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 6,
                      right: 6,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: Material(
                            shape: const CircleBorder(),
                            color: Colors.transparent,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              splashColor: Colors.grey.withOpacity(0.5),
                              onTap: () {
                                Future.delayed(
                                  const Duration(milliseconds: 50),
                                  () {
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                size: 24,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Container(width: 12),
                        const Text('Report a Bug',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ]),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, right: 16, left: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Help us improve by reporting a bug.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          letterSpacing: 0.3,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 10),
                  const Text(
                      "Errors can be very irritating, we get it. Sometimes these errors can occur without us knowing and this is why you can report them here. If you believe you've found a bug, feel free to report it in full detail below and we'll do our very best to fix it.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5,
                        letterSpacing: 0.3,
                      )),
                  const SizedBox(height: 12),
                  PhysicalModel(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    elevation: 2.5,

                    // height: 200,
                    // padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Stack(
                      children: [
                        TextField(
                          maxLength: _bugReportFieldMaxLength,
                          onChanged: (val) {
                            setState(() {});
                          },
                          controller: _reportBug,
                          onTap: () {},
                          decoration: const InputDecoration(
                            hintText: "Report a bug",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                top: 10, left: 8, right: 8, bottom: 24),
                            isDense: true,
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 101, 101, 101),
                              fontSize: 16,
                            ),
                            labelStyle: TextStyle(color: Colors.black),
                            counterText: '',
                          ),
                          maxLines: 8,
                        ),
                        Positioned(
                          bottom: 5,
                          right: 3,
                          child: Text(
                            '${_reportBug.text.length}/$_bugReportFieldMaxLength',
                            style: TextStyle(
                              fontSize: 12,
                              color: _reportBug.text.length ==
                                      _bugReportFieldMaxLength
                                  ? const Color.fromARGB(255, 220, 105, 96)
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  PhysicalModel(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    elevation: 2.5,
                    // height: 45,
                    // padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: SizedBox(
                      height: 45,
                      child: Stack(
                        children: [
                          TextField(
                            maxLength: _deviceTypeFieldMaxLength,
                            onChanged: (val) {
                              setState(() {});
                            },
                            controller: _deviceType,
                            onTap: () {},
                            decoration: const InputDecoration(
                              hintText: "Device type",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  top: 13, left: 8, right: 45, bottom: 8),
                              isDense: true,
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 101, 101, 101),
                                fontSize: 16,
                              ),
                              labelStyle: TextStyle(color: Colors.black),
                              counterText: '',
                            ),
                            maxLines: 1,
                          ),
                          Positioned(
                            bottom: 5,
                            right: 3,
                            child: Text(
                              '${_deviceType.text.length}/$_deviceTypeFieldMaxLength',
                              style: TextStyle(
                                fontSize: 12,
                                color: _deviceType.text.length ==
                                        _deviceTypeFieldMaxLength
                                    ? const Color.fromARGB(255, 220, 105, 96)
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PhysicalModel(
                        elevation: 2.5,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        child: Material(
                          color: const Color.fromARGB(255, 36, 64, 101),
                          borderRadius: BorderRadius.circular(30),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            splashColor: Colors.black.withOpacity(0.3),
                            onTap: () {
                              uploadReportedBug();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: 100,
                              child: Center(
                                child: _isLoading == true
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                            color: Colors.white),
                                      )
                                    : const Text(
                                        'Send',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            letterSpacing: 1),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
