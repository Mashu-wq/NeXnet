
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nexnet/pages/gig_details/send_custom_offer.dart';
import 'package:nexnet/pages/gig_details/team_members_account_page.dart';
import 'package:nexnet/pages/order/checkout_page.dart';
import 'package:nexnet/services/auth/auth_services.dart';
import 'package:nexnet/services/cloud/cloud_gig/cloud_gig.dart';
import 'package:nexnet/services/cloud/cloud_user/cloud_user.dart';
import 'package:nexnet/services/cloud/cloud_user/cloud_user_service.dart';

class GigDetailsPage extends StatefulWidget {
  const GigDetailsPage({
    super.key,
    required this.cloudGig,
  });
  final CloudGig cloudGig;

  @override
  State<GigDetailsPage> createState() => _GigDetailsPageState();
}

class _GigDetailsPageState extends State<GigDetailsPage> {

  final currentUser = AuthService.firebase().currentUser!;
  String get userId => currentUser.id;

  List<CloudUser> teamMembers = [];
  bool isLoading = false;

  @override
  void initState() {
    getAllTeamMembers();
    super.initState();
  }

  Future<void> getAllTeamMembers() async {
    setState(() {
      isLoading = true;
    });
    final teamMembersId = widget.cloudGig.teamMembers;
    for (String memberId in teamMembersId) {
      CloudUser? cloudUser =
          await CloudUserService.firebase().getUser(userId: memberId);
      if (cloudUser != null) {
        teamMembers.add(cloudUser);
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor:Colors.white,
            expandedHeight: 392,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                child: Image.network(
                  widget.cloudGig.gigCoverUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                top: 22,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RatingBar.builder(
                    initialRating: widget.cloudGig.gigRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 18,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Color.fromARGB(255, 210, 161, 64),
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  Text(
                    widget.cloudGig.gigTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(
                    height: 29,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      !isLoading
                          ? Row(
                              children: [
                                SizedBox(
                                  // width: 200,
                                  height: 45,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(right: 32),
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: teamMembers.length,
                                    itemBuilder: (context, index) {
                                      final teamMember = teamMembers[index];
                                      return Align(
                                        widthFactor: 0.4,
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          height: 45,
                                          width: 45,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color.fromARGB(255, 59, 78, 87),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                teamMember.profileUrl!,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  '${widget.cloudGig.teamMembers.length.toString()}+ Members',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(54, 47),
                          backgroundColor: const Color.fromARGB(255, 59, 78, 87),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TeamMembersAccountPage(
                                teamMembers: teamMembers,
                              ),
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/icons/right-arrow.png',
                          color: Colors.white,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 28),
              child: Container(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.cloudGig.gigDescription,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
                decoration: BoxDecoration(
                  color:Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Service specifications :',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Divider(),
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: widget.cloudGig.serviceSpecifications.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final service =
                            widget.cloudGig.serviceSpecifications[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${service['specificationName']}:',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                service['shortDetail'],
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 109),
              child: (widget.cloudGig.userId != userId)
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(140, 48),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutPage(
                              cloudGig: widget.cloudGig,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Continue (\$${widget.cloudGig.gigStartingPrice.toString()})',
                        style: const TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                    )
                  : ElevatedButton(
          
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 83, 136, 162),
                        minimumSize: const Size(140, 48),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SendCustomeOfferPage(cloudGig: widget.cloudGig,)
                          ),
                        );
                      },
                      child: const Text(
                        'Send custom offer',
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
