import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_case/pages/engagement_page/bloc/engagement_bloc.dart';
import 'package:smart_case/pages/engagement_page/widgets/layout_widget.dart';

class EngagementsPage extends StatelessWidget {
  const EngagementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EngagementBloc>(
      create: (context) => EngagementBloc(),
      child: const LayoutWidget(),
    );
  }
}
