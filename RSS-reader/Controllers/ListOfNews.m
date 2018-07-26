//
//  ListOfNews.m
//  RSS-reader
//
//  Created by Nataliya Murauyova on 7/23/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import "ListOfNews.h"
#import "HTML-parser.h"
#import "ListOfNewsTableViewCell.h"
#import "NewsDetailViewController.h"

@interface ListOfNews (){
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *imageLink;
    NSMutableString *dates;
    NSDate *pubDate;
    NSString *element;
    
}

@end

@implementation ListOfNews
-(UITableView*) rssTableView{
    if(!_rssTableView){
        _rssTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _rssTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Новости";
    
//    HTML_parser* parser = [[HTML_parser alloc] init];
//    NSArray *resultsRSS = [parser doURLSession];
//    NSLog(@"%@",resultsRSS);

    NSLog(@"item is %@",self.url);
    
    self.rssTableView.delegate = self;
    self.rssTableView.dataSource = self;
    
    [self.view addSubview:self.rssTableView];
    self.rssTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
                                              [self.rssTableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                              [self.rssTableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                                              [self.rssTableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                              [self.rssTableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
                                              ]];
   // [self.rssTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
  
    feeds = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:self.url];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return feeds.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil){
        cell = [[ListOfNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.detailTextLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey:@"dates"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    

    //image loading
    NSString *imageUrl = [[feeds objectAtIndex:indexPath.row] objectForKey:@"imageLink"];

    if(imageUrl){
        cell.imageView.image = nil;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                    UIImage *image = [[UIImage alloc] initWithData:imageData];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        cell.imageView.image = image;
//                        NSLog(@"Size of image:width - %f height - %f",cell.imageView.image.size.width,cell.imageView.image.size.height);
                        [cell setNeedsLayout];
                        


                    });
                });
    }

    
    //date formatting
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    [dateFormatter setDateStyle:@"E, d MMM yyyy HH:mm:ss Z"];
    NSDate *pubDate = [dateFormatter dateFromString:imageLink];
    //NSLog(@"%@",pubDate);
    return cell;
}
//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@" accessoryButton Tapped!!!");
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsDetailViewController *newsDetailController = [[NewsDetailViewController alloc] init];
    
    newsDetailController.linkToDownload = [[feeds objectAtIndex:indexPath.row]
                                           objectForKey:@"link"];
    NSLog(@"%@",[[feeds objectAtIndex:indexPath.row]
                 objectForKey:@"link"]);
    [self.navigationController pushViewController:newsDetailController animated:YES];
    NSLog(@"Tapped!!!");
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *more = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"More" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"More Button pressed");
    }];
    more.backgroundColor = [UIColor lightGrayColor];
    
    UITableViewRowAction *favourites = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Favourites" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"Favorites Button pressed");
    }];
    favourites.backgroundColor = [UIColor orangeColor];
    
    
    UITableViewRowAction *share = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Share" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"Share Button pressed");
    }];
    share.backgroundColor = [UIColor blueColor];
    NSArray *returnArray = [NSArray arrayWithObjects:more,favourites,share, nil];
    return returnArray;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    element=elementName;
    
    if([element isEqualToString:@"item"]){
        item = [[NSMutableDictionary alloc] init];
        title = [[NSMutableString alloc] init];
        link = [[NSMutableString alloc] init];
        imageLink = [[NSMutableString alloc] init];
        dates = [[NSMutableString alloc] init];
        pubDate = [[NSDate alloc] init];
    }
    if ([element isEqualToString:@"enclosure"]){
        NSString *urlString = [attributeDict objectForKey:@"url"];
        //NSLog(@"The url of image is %@",urlString);
        [imageLink appendString:urlString];
        //NSLog(@"imageLink - %@",imageLink);
        //NSLog(@"urlString -  %@",urlString);
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if([element isEqualToString:@"title"]){
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]){
        [link appendString:string];
        //NSLog(@"%@",link);
//    } else if ([element isEqualToString:@"description"]){
//        [imageLink appendString:string];
        //NSLog(@"%@",imageLink);
    } else if ([element isEqualToString:@"pubDate"]){
//        if ([element isEqualToString:@"img"]) {
         [dates appendString:string];
//    }
    } else if ([element isEqualToString:@"enclosure"]){
//        NSString *urlString = string;
//        NSLog(@"%@",urlString);
    }
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if([elementName isEqualToString:@"item"]){
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        [item setObject:dates forKey:@"dates"];
        [item setObject:imageLink forKey:@"imageLink"];
        //NSLog(@"%@",item);
        
        [feeds addObject:[item copy]];
    }
}
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    [self.rssTableView reloadData];
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"%@",[parseError localizedDescription]);
}
@end
