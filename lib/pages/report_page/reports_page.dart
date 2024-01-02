import 'package:flutter/material.dart';
import 'package:smart_case/pages/report_page/widgets/report_type_widget.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_appbar.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
        backgroundColor: AppColors.primary,
        title: AppBarContent(
          searchable: false,
          filterable: false,
          canNavigate: true,
          isNetwork: currentUser.avatar != null ? true : false,
        ),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        ReportTypeWidget(
          image: "assets/images/report_types/law_hammer.jpg",
          title: "Cause List",
          onTap: () => Navigator.pushNamed(context, "/reports"),
        ),
        ReportTypeWidget(
          image: "assets/images/report_types/done_list.jpg",
          title: "Done Activities",
          onTap: () => Navigator.pushNamed(context, "/done_activities_report"),
        ),
      ],
    );
  }
}
