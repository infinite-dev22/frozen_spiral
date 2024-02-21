import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';

class ItemsWidget extends StatelessWidget {
  const ItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(top: 8,bottom: 120,left: 8,right: 8,),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          color: AppColors.white,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: constraints.maxWidth * .3,
                    child: Text(
                      "DESCRIPTION",
                      style: TextStyle(
                          color: AppColors.inActiveColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * .25,
                    child: Text(
                      "RATE",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: AppColors.inActiveColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * .1,
                    child: Text(
                      "QTY",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: AppColors.inActiveColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * .25,
                    child: Text(
                      "SUBTOTAL",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: AppColors.inActiveColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Divider(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: constraints.maxWidth * .3,
                    child: Text(
                      "RPA Services 1x3 months",
                      style: TextStyle(
                          color: AppColors.darker, fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * .25,
                    child: Text(
                      "\$3,000",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: AppColors.darker, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * .1,
                    child: Text(
                      "3",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: AppColors.darker, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * .25,
                    child: Text(
                      "\$9,000",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: AppColors.darker, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: constraints.maxWidth * .3,
                    child: Text(
                      "Server Costs",
                      style: TextStyle(
                          color: AppColors.darker, fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * .25,
                    child: Text(
                      "\$18,000",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: AppColors.darker, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * .1,
                    child: Text(
                      "2",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: AppColors.darker, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * .25,
                    child: Text(
                      "\$36,000",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: AppColors.darker, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(),
              const SizedBox(height: 10),
              _buildAmountsItem(constraints),
              const SizedBox(height: 10),
              Divider(),
              const SizedBox(height: 10),
              _buildGrandTotalItem(constraints),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildAmountsItem(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Subtotal",
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: AppColors.inActiveColor,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Discount",
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: AppColors.inActiveColor,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "TAX",
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: AppColors.inActiveColor,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        SizedBox(
          width: constraints.maxWidth * .35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("\$45,000"),
              const SizedBox(height: 10),
              Text("\$1,323"),
              const SizedBox(height: 10),
              Text("\$300"),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGrandTotalItem(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          child: Text(
            "GRAND TOTAL",
            style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: constraints.maxWidth * .35,
          child: Text(
            "\$44,000/-",
            textAlign: TextAlign.right,
            style:
                TextStyle(color: AppColors.darker, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
