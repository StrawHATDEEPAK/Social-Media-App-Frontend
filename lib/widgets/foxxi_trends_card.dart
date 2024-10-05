import 'package:flutter/material.dart';
import 'package:foxxi/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:foxxi/providers/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FoxxiTrendCard extends StatelessWidget {
  final String caption;
  final String createdAt;
  const FoxxiTrendCard({
    Key? key,
    required this.caption,
    required this.createdAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String date = createdAt.replaceAll('T', ' ').replaceAll('.000', '');
    DateTime datetime = DateTime.parse(date);
    final tempDate = DateFormat.yMd().add_jm().format(datetime);
    // final formattedString =
    //     DateFormat('MM d, yyyy h:mm a').parse(createdAt.replaceAll('T', ' '));
    final isDark = Provider.of<ThemeProvider>(context, listen: true).isDarkMode;
    return Container(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
        child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: isDark ? Colors.grey.shade700 : Colors.white),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 16,
                      ).copyWith(right: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Card(
                            shape: const CircleBorder(),
                            elevation: 5,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundImage:
                                  const AssetImage('lib/assets/foxxiLogo.png'),
                              onBackgroundImageError: (exception, stackTrace) =>
                                  const Icon(Icons.person_outline),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const <Widget>[
                                      Text(
                                        'Foxxi',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'InstagramSans',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '@FoxxiOfficial',
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Text(
                                      tempDate
                                          .toString()
                                          .replaceFirst(' ', '\n'),
                                      style: TextStyle(color: Colors.grey[300]),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Linkify(
                            options: const LinkifyOptions(humanize: false),
                            text: caption,
                            onOpen: (link) async {
                              if (await canLaunchUrl(Uri.parse(link.url))) {
                                await launchUrl(Uri.parse(link.url),
                                    mode: LaunchMode.externalApplication);
                              } else {
                                if (context.mounted) {
                                  showSnackBar(context, 'Cannot Launch URL');
                                }
                              }
                            },
                            linkStyle: const TextStyle(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
              ),
            )));
  }
}
