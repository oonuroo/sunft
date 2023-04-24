import 'package:flutter/material.dart';
import 'package:sunftmobilev3/Decoration/AnimatedGradient.dart';
import 'package:sunftmobilev3/decoration/NFTPageDecoration.dart';
import 'package:sunftmobilev3/models/Nft.dart';
import 'package:sunftmobilev3/Decoration/NFTPageDecoration.dart' as decoration;
import "package:sunftmobilev3/components/transactionHistoryChart.dart";
import 'package:provider/provider.dart';

import '../helpers/UserHelper.dart';
import '../models/TransactionHistory.dart';
import '../models/User.dart';
import '../providers/UserProvider.dart';

/*
CONDITIONS:
  1- ON SALE (means item is on market also),
  if user is not owner: can buy, else: can not buy.

  2- ON AUCTION (same as above)
  if user is not owner and is not the highest bidder: can bid
  else if user is not owner and is highest bidder: can not bid (show the user has highest bid as reason)
  else: can not bid (show the user is owner as reason)

  3- NOT ON SALE (same as above)
  if user is owner: can start auction or regular sale
  else:user can see that item is not for sale.

  4- NOT ON MARKET
  if user is owner: can deposit item
  else: user sees the item is not on market
 */
class NFTPage extends StatefulWidget {
  final NFT nftInfo;

  const NFTPage({Key? key, required this.nftInfo}) : super(key: key);

  @override
  NFTPageState createState() => NFTPageState();
}

class NFTPageState extends State<NFTPage> {
  GestureDetector paymentContainer(String marketStatus, bool isOwner) {
    String textOfBox = marketStatus;
    bool isActive = false;
    if (isOwner && textOfBox == "Not In Market") {
      isActive = true;
    }

    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width * 3 / 4,
        height: 36,
        margin: const EdgeInsets.all(10),
        decoration: nftMarketStatusBox,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.paid_outlined,
                  color: (isActive ? Colors.white : Colors.grey),
                ),
              ),
            ),
            Center(
                child: Text(
              textOfBox,
              style: decoration.marketStatusTextStyle(isActive),
            )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.nftInfo.name),
        backgroundColor: decoration.appBarColor,
      ),
      body: FutureBuilder<List<TransactionHistory>>(
          future: widget.nftInfo.transactionHistory,
          builder: (context, snapshot) {
            // list of transaction histories is visible here
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  const Positioned(child: AnimatedGradient()),
                  Positioned(
                      child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(image: NetworkImage(widget.nftInfo.dataLink)),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                            child: Text(
                              "Address: ${widget.nftInfo.address}",
                              style: decoration.addressOfNftText,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width * 3 / 4,
                            height: 3,
                            margin: const EdgeInsets.symmetric(vertical: 20),
                          ),
                          paymentContainer(widget.nftInfo.marketStatus,
                              widget.nftInfo.owner == user?.address),
                          //price history container.
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(left: 10, bottom: 20),
                            child: Text(
                              "Transaction History",
                              textAlign: TextAlign.start,
                              style: decoration.addressOfNftText,
                            ),
                          ),
                          //LAGGY
                          TransactionHistoryChart(
                            history: snapshot.data ?? <TransactionHistory>[],
                          ),
                          //get owner data

                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: decoration.listTileColor,
                                ),
                                child: FutureBuilder<User?>(
                                    future:
                                        getUser(address: widget.nftInfo.owner),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return ListTile(
                                          title: Text(
                                            snapshot.data!.username,
                                            style:
                                                decoration.listTileTitleStyle,
                                          ),
                                          subtitle: Text(widget.nftInfo.owner),
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.black,
                                            backgroundImage: NetworkImage(
                                                snapshot.data!.profilePicture),
                                          ),
                                          trailing: const Text("Owner"),
                                        );
                                      } else {
                                        return const SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()));
                                      }
                                    }),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: decoration.listTileColor,
                                ),
                                child: FutureBuilder<User?>(
                                    future: getUser(
                                        address: widget.nftInfo.creator),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return ListTile(
                                          title: Text(
                                            snapshot.data!.username,
                                            style:
                                                decoration.listTileTitleStyle,
                                          ),
                                          subtitle:
                                              Text(widget.nftInfo.creator),
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.black,
                                            backgroundImage: NetworkImage(
                                                snapshot.data!.profilePicture),
                                          ),
                                          trailing: const Text("Creator"),
                                        );
                                      } else {
                                        return const SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()));
                                      }
                                    }),
                              ),
                            ],
                          ),
                          //Buy / bid Button
                        ],
                      ),
                    ),
                  ))
                ],
              ),
            );
          }),
    );
  }
}
