import 'package:flutter/material.dart';
import 'package:loading_skeleton_niu/loading_skeleton.dart';

class RequisitionShimmer extends StatelessWidget {
  const RequisitionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LoadingSkeleton(
          width: double.infinity,
          height: 275,
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 33,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildLoadActions(),
                          const SizedBox(width: 10),
                          _buildLoadActions(),
                          const SizedBox(width: 10),
                          _buildLoadActions(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                _buildLoadStringItem(100, 350),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLoadStringItem(50, 250),
                    _buildLoadStringItem(60, 100),
                  ],
                ),
                const SizedBox(height: 3),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: LoadingSkeleton(width: 100, height: 20),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLoadStringItem(130, 250),
                    _buildLoadStringItem(60, 100),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLoadStringItem(50, 100),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: LoadingSkeleton(width: 200, height: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildLoadStringItem(double widthHeader, double widthContent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: LoadingSkeleton(width: widthHeader, height: 20),
        ),
        const SizedBox(height: 2),
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: LoadingSkeleton(width: widthContent, height: 20),
        ),
      ],
    );
  }

  _buildLoadActions() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: LoadingSkeleton(width: 50, height: 20),
    );
  }
}
