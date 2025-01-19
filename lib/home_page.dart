import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:hm_web_flutter/utils.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';

import 'item_data.dart';
import 'item_repository.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final itemDataValue = ref.watch(getItemsProvider);
    if (kReleaseMode) {
      return Material(
          child: Center(
        child: Text(
          'Coming Soon',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('H&M'),
        centerTitle: true,
        actions: [
          // to preload font for web
          Text(
            'က🕵️',
            style: TextStyle(color: Colors.transparent),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: itemDataValue.when(
          data: (data) {
            return RefreshIndicator(
              onRefresh: () async {
                await ref.refresh(getItemsProvider.future);
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: isMobileDevice(context)
                          ? SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, mainAxisExtent: 250)
                          : SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 350, mainAxisExtent: 320),
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return ItemCard(
                          item: item,
                          onClick: () {
                            context.go('/detail/${item.id}');
                          },
                        );
                      },
                      itemCount: data.length,
                    ),
                  ],
                ),
              ),
            );
          },
          error: (e, st) {
            return Center(
              child: Text(
                '$e $st',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class ItemCard extends StatefulWidget {
  final ItemData item;
  final VoidCallback onClick;

  const ItemCard({
    super.key,
    required this.item,
    required this.onClick,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  late Color offsetCardColor;
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    offsetCardColor = getRandomColor().withValues(alpha: .7);
  }

  @override
  Widget build(BuildContext context) {
    final double width =
        isMobileDevice(context) ? MediaQuery.sizeOf(context).width / 2.4 : 220;
    final double height = isMobileDevice(context) ? 220 : 280;
    return MouseRegion(
      onEnter: (event) {
        isHovered = true;
        setState(() {});
      },
      onExit: (event) {
        isHovered = false;
        setState(() {});
      },
      child: Stack(
        children: [
          // Back card
          Positioned(
            left: 8,
            top: 8,
            child: SizedBox(
              width: width,
              height: height,
              child: Card(
                color: offsetCardColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(width: 1.5)),
                elevation: 0,
              ),
            ),
          ),
          // Front card
          AnimatedPositioned(
            left: isHovered ? 16 : 0,
            top: isHovered ? 16 : 0,
            duration: kThemeAnimationDuration,
            child: SizedBox(
              width: width,
              height: height,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(width: 1.5)),
                elevation: 0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(13),
                  onTap: widget.onClick,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(14)),
                          child: CachedNetworkImage(
                              imageUrl: widget.item.image,
                              fit: BoxFit.cover,
                              width: width,
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              imageRenderMethodForWeb:
                                  ImageRenderMethodForWeb.HttpGet),
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Text(
                              widget.item.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                            ),
                            Text(
                              "${formatNumber(widget.item.price)} Ks",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
