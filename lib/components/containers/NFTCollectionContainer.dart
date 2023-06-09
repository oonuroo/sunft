import 'package:flutter/material.dart';
import "package:sunftmobilev3/decoration/ContainerDecoration/NFTCollectionContainerDecoration.dart"
    as decoration;
import 'package:sunftmobilev3/models/NftCollection.dart';
import 'package:sunftmobilev3/pages/CollectionPage.dart';

class NFTCollectionContainer extends StatefulWidget {
  const NFTCollectionContainer({Key? key, required this.collection})
      : super(key: key);
  final NFTCollection collection;
  const NFTCollectionContainer.parameterized(this.collection, Key? key)
      : super(key: key);
  @override
  NFTCollectionContainerState createState() => NFTCollectionContainerState();
}

class NFTCollectionContainerState extends State<NFTCollectionContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CollectionPage(collectionInfo: widget.collection)))
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: MediaQuery.of(context).size.width * 3 / 4,
        height: MediaQuery.of(context).size.width * 1 / 3,
        decoration: decoration.containerBoxDecoration,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image(
              image: NetworkImage(widget.collection.collectionImage),
            ),
          ),
        ),
      ),
    );
  }
}
