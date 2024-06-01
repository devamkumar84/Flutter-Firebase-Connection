import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:may_two/blocs/home.dart';
import 'package:may_two/pages/register.dart';
import 'package:provider/provider.dart';

import '../blocs/authentication.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<Home>().getHomeData();
  }
  @override
  Widget build(BuildContext context){
    final homeArt = context.watch<Home>();
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 80,
          leading: Padding(
            padding: const EdgeInsets.only(top: 7),
            child: IconButton(
                icon: const Icon(Icons.menu,size: 30,),
                onPressed: (){
                  _scaffoldKey.currentState?.openDrawer();
                }
            ),
          ),
          title: const Text('bao news',style: TextStyle(fontFamily: 'PlayFair',fontWeight:FontWeight.w600,fontSize: 30)),
          actions: [
            IconButton(
                icon: const Icon(Icons.search,size: 30,),
                onPressed: (){}
            ),
            IconButton(
                icon: const FaIcon(FontAwesomeIcons.youtube,size: 30,color: Color(
                    0xffe10000)),
                onPressed: (){}
            )
          ],
          bottom: const TabBar(
            labelStyle: TextStyle(fontSize: 16),
            tabs: [
              Tab(text: 'Latest',),
              Tab(text: 'Business',),
              Tab(text: 'Entertainment',),
              Tab(text: 'Health',),
              Tab(text: 'science',)
            ],
            padding: EdgeInsets.zero,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
          ),
        ),
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  debugPrint(context.read<Authentication>().isLogin.toString());
                },
                child: const Text(
                  'bao news',
                  style: TextStyle(
                    fontFamily: 'PlayFair',
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: const Text('Profile'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RefreshIndicator(
              onRefresh: ()async{
                context.read<Home>().onRefresh();
              },
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 250,
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                    image: AssetImage('assets/images/climate_change_challenge1.webp'),
                                  )
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 250,
                              color: Colors.black.withOpacity(.4),
                            ),
                            const Positioned(
                              bottom: 10,
                              left: 10,
                              right: 10,
                              child: Text('Sri Lanka crisis: Pro-government supporters attack protesters in',
                                style: TextStyle(fontSize: 26,color: Colors.white,fontWeight: FontWeight.w400),),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index){
                                return homeArt.data.isEmpty ? Center(child: CircularProgressIndicator(),):
                                Column(
                                  children: [
                                    ClipRRect(
                                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                                        child: CachedNetworkImage(imageUrl: homeArt.data[index].image,height: 160,fit: BoxFit.cover,width: MediaQuery.of(context).size.width,),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(homeArt.data[index].title,style: TextStyle(fontSize: 23,color: Colors.black,fontWeight: FontWeight.w400),),
                                          Text(homeArt.data[index].desc,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400)
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              IconButton(
                                                onPressed: (){},
                                                icon: const FaIcon(FontAwesomeIcons.shareFromSquare),
                                              ),
                                              IconButton(
                                                onPressed: (){},
                                                icon: const FaIcon(FontAwesomeIcons.bookmark),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              },
                              separatorBuilder: (context, index){
                                return const Divider(thickness: 1,color: Colors.grey,height: 30,);
                              },
                              itemCount: homeArt.data.isEmpty ? 1 : homeArt.data.length,
                          ),
                        ),
                      ]
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: const Image(
                                image: AssetImage('assets/images/climate_change_challenge1.webp'),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 15,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10,),
                              child: Column(
                                children: [
                                  Text('Sri Lanka crisis: Pro-government supporters attack protesters in',style: TextStyle(fontSize: 21,color: Colors.black,fontWeight: FontWeight.w400),overflow: TextOverflow.ellipsis,maxLines: 2),
                                  Text('The most secure and recommended approach is to reach out to the administrator responsible for the server. They can verify your identity and provide the correct credentials or guide you on the appropriate access procedure.'
                                    ,overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: const Image(
                                image: AssetImage('assets/images/protest1.webp'),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 15,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10,),
                              child: Column(
                                children: [
                                  Text('Sri Lanka crisis: Pro-government supporters attack protesters in',style: TextStyle(fontSize: 21,color: Colors.black,fontWeight: FontWeight.w400),overflow: TextOverflow.ellipsis,maxLines: 2),
                                  Text('The most secure and recommended approach is to reach out to the administrator responsible for the server. They can verify your identity and provide the correct credentials or guide you on the appropriate access procedure.'
                                    ,overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: const Image(
                                image: AssetImage('assets/images/error_img.webp'),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 15,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10,),
                              child: Column(
                                children: [
                                  Text('Sri Lanka crisis: Pro-government supporters attack protesters in',style: TextStyle(fontSize: 21,color: Colors.black,fontWeight: FontWeight.w400),overflow: TextOverflow.ellipsis,maxLines: 2),
                                  Text('The most secure and recommended approach is to reach out to the administrator responsible for the server. They can verify your identity and provide the correct credentials or guide you on the appropriate access procedure.'
                                    ,overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ]
              ),
            ),
            Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.all(7),
                child: ListView.separated(
                    itemCount: articlesList.length,
                    itemBuilder: (context, index){
                      return Container(
                        margin: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius:1.0,
                                blurRadius: 12.0,
                              )
                            ]
                        ),
                        child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12)),
                                child: Image(
                                  image: AssetImage(articlesList[index]['image']),
                                  height: 170,
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(articlesList[index]['title'],style: const TextStyle(fontSize: 21),),
                                      Text(articlesList[index]['desc'],style: const TextStyle(color: Colors.grey,fontSize: 17),overflow: TextOverflow.ellipsis,maxLines: 2,),
                                      TextButton(
                                        onPressed: (){},
                                        child: const Text('Read More',style: TextStyle(color: Colors.deepPurple),),
                                      )
                                    ]
                                ),
                              )
                            ]
                        ),
                      );
                    },
                    separatorBuilder: (context, index){
                      return const Divider(height: 10,thickness: 0,color: Colors.transparent,);
                    }
                )
            ),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}

List articlesList = [
  {
    'title': 'Sri Lanka crisis: Pro-government supporters attack protesters in',
    'desc': 'The most secure and recommended approach is to reach out to the administrator responsible for the server. They can verify your identity and provide the correct credentials or guide you on the appropriate access procedure.',
    'image': 'assets/images/climate_change_challenge1.webp'
  },
  {
    'title': 'Sri Lanka crisis: Pro-government supporters attack protesters in',
    'desc': 'The most secure and recommended approach is to reach out to the administrator responsible for the server. They can verify your identity and provide the correct credentials or guide you on the appropriate access procedure.',
    'image': 'assets/images/protest1.webp'
  },
  {
    'title': 'Sri Lanka crisis: Pro-government supporters attack protesters in',
    'desc': 'The most secure and recommended approach is to reach out to the administrator responsible for the server. They can verify your identity and provide the correct credentials or guide you on the appropriate access procedure.',
    'image': 'assets/images/error_img.webp'
  },
];