import 'package:flutter/material.dart';
import 'package:news_app/models/category_data.dart';

import 'package:news_app/pages/category_item_page.dart';
import 'package:news_app/utils/next_screen.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  double paddingValue = 20;


  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 0)).then((f){
      setState(() {
        paddingValue = 0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text('Categories', style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600
            ),),
          ),

          Expanded(
              child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
              padding: EdgeInsets.only(left: 20, top: 20, right: 20),
              children: List.generate(categories.length, (index){
                return InkWell(
                    child: Hero(
                      tag: 'category$index',
                      child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        
                        borderRadius: BorderRadius.circular(12),
                        color: categoryColors[index],
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.grey[300],
                            blurRadius: 3,
                            offset: Offset(3, 3)
                          )
                        ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          AnimatedPadding(
                            duration: Duration(milliseconds: 600),
                            padding: EdgeInsets.all(paddingValue),
                              child: Container(
                                
                                height: 60,
                                width: 60,
                                
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.white10,
                                    blurRadius: 30,
                                    offset: Offset(3, 3)
                                  )
                                ]
                                  
                                ),
                                child: Icon(Icons.category, size: 30, color: Colors.black54,)
                                ),
                              
                          ),
                           Spacer(), 
                          Text(categories[index], style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15
                          ),),

                          
                        ],
                      ),
                  ),
                    ),
                  onTap: (){
                    nextScreen(context, CategoryItemPage(
                      category: categories[index],
                      tag: 'category$index',
                      color: categoryColors[index],
                    ));
                  },
                );
              }),
              
            ),
          )
        ],
      ),
    );
  }
}