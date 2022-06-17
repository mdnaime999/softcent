import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/custom_card_type_icon.dart';
import 'package:flutter_credit_card/glassmorphism_config.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:softcent/controller/card_controller.dart';

class CardView extends StatelessWidget {
  CardView({Key? key}) : super(key: key);
  final CardController cardController = Get.put(CardController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      // extendBody: true,
      body: Column(
        children: [
          SizedBox(height: 4.h),
          SizedBox(
            width: 100.w,
            child: ListTile(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Get.back(),
              ),
              title: Center(
                child: Text(
                  "Card",
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
              ),
              trailing: CircleAvatar(
                radius: 15.sp,
                backgroundColor: cardController.tcolor,
                child: IconButton(
                  splashRadius: 15.sp,
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          CreditCardWidget(
            glassmorphismConfig: cardController.useGlassMorphism
                ? Glassmorphism.defaultConfig()
                : null,
            cardNumber: cardController.cardNumber,
            expiryDate: cardController.expiryDate,
            cardHolderName: cardController.cardHolderName,
            cvvCode: cardController.cvvCode,
            showBackView: cardController.isCvvFocused,
            obscureCardNumber: false,
            obscureCardCvv: true,
            isHolderNameVisible: true,
            cardBgColor: Colors.green,
            backgroundImage: cardController.useBackgroundImage
                ? 'assets/images/card.jpg'
                : null,
            isSwipeGestureEnabled: true,
            onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
            customCardTypeIcons: <CustomCardTypeIcon>[
              CustomCardTypeIcon(
                cardType: CardType.mastercard,
                cardImage: Image.asset(
                  'assets/mastercard.png',
                  height: 48,
                  width: 48,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              "Recent Transaction",
              style: TextStyle(
                fontSize: 15.sp,
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () {
                if (cardController.data.isNotEmpty) {
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: cardController.data.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      var item = cardController.data;
                      return Card(
                        elevation: 2,
                        shadowColor: Colors.white54,
                        child: ListTile(
                          isThreeLine: true,
                          leading: CachedNetworkImage(
                            imageUrl: item[index]['shop_logo'],
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: imageProvider,
                            ),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          title: Text("${item[index]['shop_name']}"),
                          subtitle: Text(
                              "Trans ID : ${item[index]['transaction_id']} \n${item[index]['payment_type']}"),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${item[index]['timestamp']}",
                                style: TextStyle(
                                  color: Color(0xC6A6A6A6),
                                ),
                              ),
                              Text(
                                "৳${item[index]['amount_recieved']}",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                "+ ৳${item[index]['amount_send']}",
                                style: TextStyle(
                                  color: cardController.tcolor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: cardController.tcolor,
        foregroundColor: Colors.white,
        child: Icon(Icons.qr_code_scanner),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(
        () => AnimatedBottomNavigationBar.builder(
          height: 10.h,
          elevation: 3,
          backgroundColor: Colors.white,
          itemCount: 4,
          tabBuilder: (int index, bool isActive) {
            final color = isActive ? cardController.tcolor : Colors.grey;
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  cardController.iconList[index]['icon'],
                  size: 24,
                  color: color,
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    cardController.iconList[index]['name'],
                    maxLines: 1,
                    style: TextStyle(color: color),
                  ),
                )
              ],
            );
          },
          activeIndex: cardController.bottomNavIndex.value,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          // leftCornerRadius: 10.sp,
          // rightCornerRadius: 10.sp,
          onTap: (index) =>
              cardController.handleNavigationChange(context, index),
          //other params
        ),
      ),
    );
  }
}
