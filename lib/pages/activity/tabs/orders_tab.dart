import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexnet/pages/activity/order_details.page.dart';
import 'package:nexnet/services/auth/auth_services.dart';
import 'package:nexnet/services/cloud/cloud_order/cloud_order.dart';
import 'package:nexnet/services/cloud/cloud_order/cloud_order_service.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab({super.key, required this.isPlacedOrder});
  final bool isPlacedOrder;

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  final currentUser = AuthService.firebase().currentUser!;
  String get userId => currentUser.id;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.isPlacedOrder
          ? CloudOrderService.firebase().userAllPlacedOrders(userId)
          : CloudOrderService.firebase().userAllReceivedOrders(userId),
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            if (snapshot.hasData) {
              final allOrders = snapshot.data as Iterable<CloudOrder>;
              if (allOrders.isEmpty) {
                return Center(
                  child: Image.asset(
                    'assets/icons/nothing.png',
                    height: 68,
                    color: Colors.black54,
                  ),
                );
              }
              return SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  builder: (BuildContext context) {
                    return CustomScrollView(
                      slivers: [
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context,
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final order = allOrders.elementAt(index);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OrderDetailsPage(
                                          cloudOrder: order,
                                          isPlacedOrder: widget.isPlacedOrder,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 138,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      color:Colors.grey.shade100,
                                          //const Color.fromARGB(255, 59, 78, 87),
                                      //const Color(0xff242424),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            height: 55,
                                            width: 55,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 59, 78, 87),
                                                //Colors.blue,
                                                width: 2,
                                              ),
                                            ),
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                order.employerProfileUrl,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '\$${order.gigPrice}',
                                                style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              const Divider(
                                                height: 2,
                                                color: Colors.transparent,
                                              ),
                                              Text(
                                                order.projectRequirement,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const Divider(
                                                height: 2,
                                                color: Colors.transparent,
                                              ),
                                              Text(
                                                order.employerName,
                                                style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const Divider(
                                                height: 3,
                                                color: Colors.transparent,
                                              ),
                                              Text(
                                                'Ordered at: ${DateFormat.yMMMd().format(order.createdAt).toString()}',
                                                style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 14,
                                                  // color: Colors.grey.shade400,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const Divider(
                                                height: 3,
                                                color: Colors.transparent,
                                              ),
                                              Text(
                                                'Delivery in: ${order.deliveryTime}',
                                                style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 14,
                                                  // color: Colors.grey.shade400,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 12, left: 4),
                                          child: Container(
                                            height: 82,
                                            width: 82,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  order.gigCoverUrl,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: allOrders.length,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: Text(
                  'Gig Not found',
                  style: TextStyle(color: Colors.black87),
                ),
              );
            }
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
