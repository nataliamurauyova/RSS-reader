//
//  FavoritesViewController.m
//  RSS-reader
//
//  Created by Nataliya Murauyova on 7/26/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import "FavoritesViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "NewsDetailViewController.h"
#import "ListOfNews.h"
#import "ListOfNewsTableViewCell.h"

static NSString* const kEntityName = @"Favourites";

@interface FavoritesViewController ()
@property(nonatomic) NSMutableArray* news;
@end

@implementation FavoritesViewController
-(NSManagedObjectContext*)managedObjectContext{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return [delegate managedObjectContext];
}
-(UITableView*) tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Закладки";
    
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
                                              [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                              [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                                              [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                              [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
                                              ]];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadCoreData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.news.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil){
        cell = [[ListOfNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
     
    NSManagedObject *partOfNews = [self.news objectAtIndex:indexPath.row];
    
   
    cell.textLabel.text = [partOfNews valueForKey:@"title"];
    cell.detailTextLabel.text = [[partOfNews valueForKey:@"pubDate"] substringWithRange:NSMakeRange(4, 18)];
    
    NSString *imageUrl = [partOfNews valueForKey:@"imageLink"];
    if(imageUrl){
        cell.imageView.image = nil;
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
    
-(void)loadCoreData{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName: kEntityName];

    NSError *fetchError = nil;
    self.news = [[context executeFetchRequest:request error:&fetchError] mutableCopy];

    [self.tableView reloadData];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsDetailViewController *newsDetailController = [[NewsDetailViewController alloc] init];
    NSManagedObject *news = [self.news objectAtIndex:indexPath.row];
    newsDetailController.linkToDownload = [news valueForKey:@"link"];
//    NSLog(@"%@",self.favNews.link);
    [self.navigationController pushViewController:newsDetailController animated:YES];
    NSLog(@"Tapped!!!");
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        NSManagedObjectContext *context = [self managedObjectContext];
        [context deleteObject:[self.news objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if(![context save:&error]){
            NSLog(@"problems with deleting - %@",[error localizedDescription]);
        }
        [self.news removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        ListOfNews *vc = [[ListOfNews alloc] init];
        
    }
}

@end
