import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../utils/global_variables.dart';

class DataPrivacy extends StatefulWidget {
  const DataPrivacy({Key? key}) : super(key: key);

  @override
  State<DataPrivacy> createState() => _DataPrivacyState();
}

class _DataPrivacyState extends State<DataPrivacy> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
          appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: darkBlue,
              elevation: 4,
              toolbarHeight: 56,
              actions: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: SizedBox(
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
                                  color: whiteDialog,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(width: 16),
                        const Text(
                          'Data Privacy',
                          style: TextStyle(
                            color: whiteDialog,
                            fontSize: 20,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
          body: Padding(
            padding: const EdgeInsets.only(
              right: 2.0,
              top: 2,
              bottom: 2,
            ),
            child: RawScrollbar(
              radius: const Radius.circular(25),
              thickness: 6,
              thumbVisibility: true,
              thumbColor: Colors.black.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 16.0,
                  left: 16,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24, top: 24.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                              child: Image.asset(
                                'assets/fairtalk_new_blue_transparent.png',
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text('$version  •  $year',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0,
                                    color: darkBlue)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Issuing Date",
                            style: TextStyle(
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "This Data Privacy statement was last updated on: May 28th, 2023.",
                            style: TextStyle(
                              letterSpacing: 0,
                              // fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Introduction",
                            style: TextStyle(
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Our Data Privacy statement describes the policies and procedures on the collection, use and disclosure of your information whenever you use our service and tells you about your privacy rights and how the law protects you. All information and data collected is strictly used for maintaining the app’s functionalities. We are not interested in collecting any additional data that has no relevance to the service we provide. Fairtalk will not distribute or sell personal information to third-party organizations. Fairtalk will not disclose, without your consent, personal information collected about you, except for certain explicit circumstances in which disclosure is required by law.",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Data Collection",
                            style: TextStyle(
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "When using our service, you have a total of 3 different options to choose from. All 3 options have differences in the collection of data:",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "(1)	Not creating an account.",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Not creating an account allows you to log in as a “guest” where no information or data is collected about you whatsoever.",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "(2)	Creating an account.",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Creating an account requires you to sign up to our service by providing an email address and a password. For this option, the only personal information collected about you is:",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 7),
                          const Text(
                            " • Your email address.",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "(3) Verifying your account.",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Verifying your account requires you to verify your identity by providing a picture of your identification card + a picture of yourself holding your identification card. For this option, the only personal information collected about you is:",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 7),
                          const Text(
                            " • Information on your identification card (first name, last name & country).",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const Text(
                            " • The two pictures taken during the verification process.",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "It is not mandatory to create an account and it is also not mandatory to verify your account. You're the one that decides whether you want any personal information above to be collected on our servers. We use the best possible technology to keep all of your personal data safe & secure. No personal information collected about you will ever be shared or sold. The only purpose for collecting any of the data mentioned above is to provide a fair voting system where users cannot engage in voting manipulation. If you wish to remove any personal data collected from our servers, you can simply delete your account and all personal data collected about you will be immediately removed from our servers.",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Data collected by third-party services",
                            style: TextStyle(
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "To facilitate Fairtalk's operations, we're currently making use of third-party services such as: AdMob & Google Play Services. Each third-party service collects different types of data and/or information about you. To learn more information about the collection of data for each third-party service, we strongly recommend that you read and understand their data collection policies. The links below will navigate you to each third-party services data collection policies:",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 7.5),
                          Row(
                            children: [
                              const Icon(Icons.arrow_forward, size: 15),
                              const SizedBox(width: 10),
                              Link(
                                target: LinkTarget.blank,
                                uri: Uri.parse(
                                    'https://support.google.com/admob/answer/6128543?hl=en'),
                                builder: (BuildContext context, followLink) =>
                                    InkWell(
                                  onTap: followLink,
                                  child: const Text(
                                    'AdMob',
                                    style: TextStyle(
                                        color: Colors.blue, letterSpacing: 0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 7.5),
                          Row(
                            children: [
                              const Icon(Icons.arrow_forward, size: 15),
                              const SizedBox(width: 10),
                              Link(
                                target: LinkTarget.blank,
                                uri: Uri.parse(
                                    'https://policies.google.com/privacy'),
                                builder: (BuildContext context, followLink) =>
                                    InkWell(
                                  onTap: followLink,
                                  child: const Text(
                                    'Google Play Services',
                                    style: TextStyle(
                                        color: Colors.blue, letterSpacing: 0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Other information collected",
                            style: TextStyle(
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Fairtalk allows users to access their device's camera and also upload pictures from their device's gallery. Personal pictures are considered sensitive user data and we always ask your permission before accessing that data. Your device's gallery isn't collected on our servers. The only pictures collected on our servers are: ",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 7),
                          const Text(
                            " • Pictures that you attach to a message.",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 7),
                          const Text(
                            " • Your account's profile picture. ",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 7),
                          const Text(
                            " • The two pictures required to complete the account verification process.",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Cookies",
                            style: TextStyle(
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory. Fairtalk does not use cookies explicitly. However, third-party services may use cookies to collect information and improve their services.",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "General Data Protection Regulation",
                            style: TextStyle(
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "If you are located in the EU, in accordance with the statutory provisions, you, as the data subject, have the right to receive information about your data stored by the controller free of charge at any time. In addition, you can assert your rights to correction, deletion or restriction of the processing or the right to object at any time. This also applies to your right to receive your data in a structured, current, and machine-readable format or (if applicable) to request the transmission to another person responsible (data portability). If you have provided personal data on the basis of a consent, you can withdraw the consent at any time for the future.",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Retention of Your Personal Data",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Fairtalk will retain your Personal Data only for as long as is necessary for the purposes set out in this Data Privacy. We will retain and use your Personal Data to the extent necessary to comply with our legal obligations (for example, if we are required to retain your data to comply with applicable laws), resolve disputes, and enforce our legal agreements and policies.",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Transfer of your Personal Data",
                            style: TextStyle(
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Your information, including Personal Data, is processed at Fairtalk’s main operating office and in any other places where the parties involved in the processing are located. It means that this information may be transferred to — and maintained on — computers located outside of your state, province, country or other governmental jurisdiction where the data protection laws may differ than those from your jurisdiction. Fairtalk will take all steps necessary to ensure that your data is treated securely and in accordance with this Data Privacy and no transfer of your Personal Data will take place to an organization or a country unless there are adequate controls in place including the security of your data and other personal information.",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Delete your Personal Data",
                            style: TextStyle(
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "You have the right to delete or request that we assist in deleting the Personal Data that we have collected about you. You may delete your information at any time by logging in to your account, if you have one, and visiting the settings page. Clicking on the option “Delete Account” will delete all information and data collected about you. You may also contact us to request access to, correct, or delete any personal information that you have provided to us. Please note, however, that we may need to retain certain information when we have a legal obligation or lawful basis to do so.",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Law enforcement",
                            style: TextStyle(
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Under certain circumstances, Fairtalk may be required to disclose your Personal Data if required to do so by law or in response to valid requests by public authorities (e.g. a court or a government agency).",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Security of your Personal Data",
                            style: TextStyle(
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "The security of your Personal Data is very important to us and we’re using the best possible technology (data encryption) to ensure its full security. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and we cannot guarantee its absolute security.",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Children's Privacy",
                            style: TextStyle(
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Our service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from anyone under the age of 13. If You are a parent or guardian and you are aware that your child has provided us with Personal Data, please contact us. If we become aware that we have collected Personal Data from anyone under the age of 13 without verification of parental consent, we’ll take the necessary steps to remove that information from our servers.",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Links to Other Websites",
                            style: TextStyle(
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Our service may contain links to other websites that are not operated by us. If you click on a third party link, you will be directed to that third party's site. We strongly advise You to review the Data Privacy of every site that you visit. We have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services.",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Changes to this Data Privacy",
                            style: TextStyle(
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "We may update our Data Privacy from time to time. We will notify you of any changes by posting the new Data Privacy on this page. You are advised to review this Data Privacy periodically for any changes. Changes to this Data Privacy are effective when they are posted on this page.",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Contact Information",
                            style: TextStyle(
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "If you have any questions, inquiries or simply need help, feel free to contact us:",
                            style: TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            " •	By email: $email ",
                            style: const TextStyle(
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
