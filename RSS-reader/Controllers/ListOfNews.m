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
#import "AppDelegate.h"
#import "FavoritesViewController.h"
#import "XMLParser.h"

static NSString* const kEntityName = @"Favourites";
static NSString* const kAttributeLinkName = @"link";
static NSString* const kAttributeTitleName = @"title";
static NSString* const kAttributePubDateName = @"pubDate";
static NSString* const kAttributeImageLinkName = @"imageLink";

@interface ListOfNews (){
    NSXMLParser *parser;
    //NSMutableArray *feeds;
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
-(NSManagedObjectContext*)managedObjectContext{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return [delegate managedObjectContext];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Новости";
    
        


    UIBarButtonItem *bookmark = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(bookmarkClicked)];
  
    
    self.navigationItem.rightBarButtonItem = bookmark;
    
    
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
//    NSLog(@"%@",self.url);
//    feeds = [[NSMutableArray alloc] init];
//    NSURL *url = [NSURL URLWithString:self.url];
//    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
//
//    [parser setDelegate:self];
//    [parser setShouldResolveExternalEntities:NO];
//    [parser parse];
    XMLParser *xmlparser = [[XMLParser alloc] init];
    self.feeds = [xmlparser parseXML:self.url];

    //NSLog(@"self.feeds %@",[self.feeds objectAtIndex:1]);
        //self.news = [xmlparser parseXML:self.url];
}

-(void)bookmarkClicked{
    FavoritesViewController *fav = [[FavoritesViewController alloc] init];
    
    [self.navigationController pushViewController:fav animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.feeds.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    self.news = [self.feeds objectAtIndex:indexPath.row];
    
//    NSLog(@"Object is %@",self.news);
    //NSLog(@"link is %@", self.news.link);
    
    if(cell == nil){
        cell = [[ListOfNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    
    //NSLog(@"%@",self.news.pubDate);
    NSString *formattedString = [self.news.pubDate substringWithRange:NSMakeRange(4, 18)];
    //NSLog(@"%@",formattedString);
    cell.textLabel.text = self.news.title;
    cell.detailTextLabel.text = formattedString;

    self.star = [UIButton buttonWithType:UIButtonTypeSystem];
  
    self.star.tag = indexPath.row;

    [self.star setFrame:CGRectMake(0, 0, 30, 30)];
    [self.star setTintColor:[UIColor grayColor]];
    [self.star setAlpha:0.25];
    
    [self.star setImage:[UIImage imageNamed:@"fav1.png"] forState:UIControlStateNormal];
    [self.star addTarget:self action:@selector(handleMarkAsFavourite:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = self.star;

    //image loading
    NSString *imageUrl = self.news.imageLink;
    if(imageUrl){
        cell.imageView.image = [UIImage imageNamed:@"placeholder.png"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                    UIImage *image = [[UIImage alloc] initWithData:imageData];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        cell.imageView.image = image;
                        [cell setNeedsLayout];
                    });
                });
    }

    return cell;
}



-(void)handleMarkAsFavourite:(UIButton*)sender {

    self.news = [self.feeds objectAtIndex:sender.tag];

    NSManagedObject *partOfNewsForCoreData = [NSEntityDescription insertNewObjectForEntityForName:kEntityName inManagedObjectContext:[self managedObjectContext]];
    [partOfNewsForCoreData setValue:self.news.title forKey:kAttributeTitleName];
    [partOfNewsForCoreData setValue:self.news.link forKey:kAttributeLinkName];
    [partOfNewsForCoreData setValue:self.news.pubDate forKey:kAttributePubDateName];
    [partOfNewsForCoreData setValue:self.news.imageLink forKey:kAttributeImageLinkName];

    NSError *error = nil;
    if(![[self managedObjectContext] save:&error]){
                NSLog(@"Problems with CoreData - %@",[error localizedDescription]);
            }
   
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsDetailViewController *newsDetailController = [[NewsDetailViewController alloc] init];
    newsDetailController.linkToDownload = [[self.feeds objectAtIndex:indexPath.row] valueForKey:@"link"];
    //NSLog(@"%@",self.news.link);
    [self.navigationController pushViewController:newsDetailController animated:YES];
}

@end
