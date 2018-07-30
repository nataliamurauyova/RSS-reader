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

static NSString* const kEntityName = @"Favourites";
static NSString* const kAttributeLinkName = @"link";
static NSString* const kAttributeTitleName = @"title";
static NSString* const kAttributePubDateName = @"pubDate";
static NSString* const kAttributeImageLinkName = @"imageLink";

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
-(NSManagedObjectContext*)managedObjectContext{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return [delegate managedObjectContext];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIColor *colorForStarButton = [UIColor colorWithRed:252.0 green:194.0 blue:0.f alpha:1.0];
    NSString *butState = [[NSUserDefaults standardUserDefaults] stringForKey:@"stateOfButton"];
    if([butState compare:@"starTouched"] == NSOrderedSame) {
        self.star.tintColor == colorForStarButton;
    } else {
        self.star.tintColor == [UIColor grayColor];
    }
    
    NSLog(@"viewWillAppear");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Новости";
    
        

//    UIBarButtonItem *st = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bookmark1.png"] style:UIBarButtonItemStyleDone target:self action:@selector(bookmarkClicked)];
    UIBarButtonItem *bookmark = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(bookmarkClicked)];
  
    
    self.navigationItem.rightBarButtonItem = bookmark;
    //self.navigationItem.rightBarButtonItem = st1;
    
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

-(void)bookmarkClicked{
    FavoritesViewController *fav = [[FavoritesViewController alloc] init];
    
    [self.navigationController pushViewController:fav animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return feeds.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    self.news = [feeds objectAtIndex:indexPath.row];
    
//    NSLog(@"Object is %@",self.news);
//    NSLog(@"link is %@", self.news.link);
    
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
    //self.star.tag = self.star.isTouchInside;
    
    
    [self.star setFrame:CGRectMake(0, 0, 30, 30)];
    [self.star setTintColor:[UIColor grayColor]];
    [self.star setAlpha:0.25];
    

    [self.star setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
    [self.star addTarget:self action:@selector(handleMarkAsFavourite:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = self.star;
    
//    self.star = starButton;
    [self saveButtonState:self.star];
    [self resaveButtonState:self.star];
//    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];

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

-(void)saveButtonState:(UIButton*)sender{
//    UIColor *colorForStarButton = [UIColor colorWithRed:252.0 green:194.0 blue:0.f alpha:1.0];
//    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
//    if(![sender isTouchInside]){
//        //[userPreferences setObject:@"notTouched" forKey:@"stateOfButton"];
//        [userPreferences setObject:[UIColor grayColor] forKey:@"stateOfButton"];
//
//        sender.tintColor = [UIColor grayColor];
//    }
//    sender.tintColor = colorForStarButton;
//    NSString *isTouched = @"isTouchInside";
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if(![sender isTouchInside]){
//        isTouched = @"isNotTouchInside";
//
//    }
//    if([sender.tintColor == ])
//    [defaults setBool:sender.hidden forKey:@"isHidden"];
//    self.news = [feeds objectAtIndex:sender.tag];
//    NSLog(@"Star is clicked");
//    NSLog(@"I clicked a button %ld",sender.tag + 1);
    
//   NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
//    NSString *butState = @"starTouched";
//    if(!(sender.tintColor == colorForStarButton)){
//        butState = @"starNotTouched";
//        [userPreferences setObject:butState forKey:@"stateOfButton"];
//    }
//    [userPreferences setObject:butState forKey:@"stateOfButton"];
   
//    sender.alpha = [userPreferences floatForKey:[NSString stringWithFormat:@"alpha%ld",(long)sender.tag]];
//    [userPreferences setFloat:sender.alpha forKey:[NSString stringWithFormat:@"alpha%ld",(long)sender.tag]];
//    NSLog(@"saveButtonState");
    //[self.rssTableView reloadData];
    //NSLog(@"saveButtonState");
}
-(void)resaveButtonState:(UIButton*)sender{
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    sender.alpha = [userPreferences floatForKey:[NSString stringWithFormat:@"alpha%ld",(long)sender.tag]];
}
-(void)handleMarkAsFavourite:(UIButton*)sender {
    if(sender.isTouchInside){
        NSLog(@"Selected");
    }
    UIColor *colorForStarButton = [UIColor colorWithRed:252.0 green:194.0 blue:0.f alpha:1.0];
    //sender.tintColor = colorForStarButton;
    
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    if(![sender isTouchInside]){
        //[userPreferences setObject:@"notTouched" forKey:@"stateOfButton"];
        sender.tintColor = [UIColor grayColor];
    } else if ([sender isTouchInside]){
        //[userPreferences setObject:@"isTouchInside" forKey:@"stateOfButton"];
        sender.tintColor = colorForStarButton;
    }
//    sender.tintColor = colorForStarButton;
//    [userPreferences setObject:@"isTouchInside" forKey:@"stateOfButton"];
    
//    NSString *value = @"isTouchInside";
//    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
//    if(![sender isTouchInside]){
//        value = @"isNotTouchInside";
//        [userPreferences setObject:value forKey:@"stateOfButton"];
//    }
//    [userPreferences setObject:value forKey:@"stateOfButton"];
//    if([sender isTouchInside]){
//        NSLog(@"isSelected");
//   }
   
    
//    NSLog(@"Star is clicked");
//    NSLog(@"I clicked a button %ld",sender.tag + 1);
//    sender.backgroundColor = [UIColor yellowColor];
    
    self.news = [feeds objectAtIndex:sender.tag];
//    NSLog(@"Title is %@",self.news.title);
//    NSLog(@"Link is %@",self.news.link);
//    NSLog(@"Date is %@",self.news.pubDate);
//    NSLog(@"Image link is %@",self.news.imageLink);
    
    
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
    newsDetailController.linkToDownload = self.news.link;
    NSLog(@"%@",self.news.link);
    [self.navigationController pushViewController:newsDetailController animated:YES];
    NSLog(@"Tapped!!!");
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
    if ([element isEqualToString:@"media:content"]){
        NSString *urlString = [attributeDict objectForKey:@"url"];
        //NSLog(@"%@",urlString);
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
        
        PartOfNews *news = [[PartOfNews alloc] initWithTitle:title link:link pubDate:dates imageLink:imageLink];
        [feeds addObject:news];
        
    }
}
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    [self.rssTableView reloadData];
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"%@",[parseError localizedDescription]);
}
@end
