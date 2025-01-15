import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hm_web_flutter/utils.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';

import 'item_repository.dart';

class DetailPage extends ConsumerStatefulWidget {
  const DetailPage({super.key, required this.id});

  final String id;

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  @override
  Widget build(BuildContext context) {
    final itemDataValue = ref.watch(getItemDetailProvider(widget.id));
    return Scaffold(
      appBar: AppBar(
        title: Text('H&M'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 15),
        child: itemDataValue.when(
          data: (data) {
            return RefreshIndicator(
              onRefresh: () async{
                await ref.refresh(getItemDetailProvider(widget.id).future);
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Product Image
                    Row(
                      children: [
                        Expanded(
                          flex: isMobileDevice(context) ? 1 : 0,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(width: 1.5),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: CachedNetworkImage(
                                imageUrl: data.image,
                                imageRenderMethodForWeb:
                                    ImageRenderMethodForWeb.HttpGet,
                                fit: BoxFit.cover,
                                width: isMobileDevice(context)
                                    ? MediaQuery.sizeOf(context).width
                                    : 350,
                                height: 350,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.error,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Spacing
                    const SizedBox(height: 12),

                    // Product Title
                    Text(
                      data.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Spacing
                    const SizedBox(height: 12),

                    // Product Price
                    Text(
                      '${formatNumber(data.price)} Ks',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    // Spacing
                    const SizedBox(height: 12),

                    // Product Description
                    Text(
                      data.description,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          error: (e, st) {
            return Center(
              child: Text(
                '$e',
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
