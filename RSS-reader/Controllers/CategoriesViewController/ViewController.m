//
//  ViewController.m
//  RSS-reader
//
//  Created by Nataliya Murauyova on 7/23/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import "ViewController.h"
#import "ListOfNews.h"
#import "HTML-parser.h"
#import "DownLoader.h"
#import "PopoverViewController.h"

static NSString* const kCellIdentifier = @"Cell";
static NSString* const kHControllerTitle = @"Категории";
static NSString* const kHeaderName = @"Новости по рубрикам";


@interface ViewController ()

@property (nonatomic) NSMutableArray *dataSource;
@property(nonatomic) NSMutableArray *urlsForParsing;
@property(strong,nonatomic) NSURL* destinationURL;
@property(strong,nonatomic) NSArray* result;
@property (nonatomic) NSMutableArray *sections;

@end

@implementation ViewController

-(UITableView*)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}

-(NSMutableArray*)urlsForParsing{
    if(!_urlsForParsing){
        _urlsForParsing = [[NSMutableArray alloc] init];
    }
    return _urlsForParsing;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kHControllerTitle;
    
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *savedArray = [currentDefaults objectForKey:@"savedArray"];
    if (savedArray != nil){
        NSArray *oldArray = [NSKeyedUnarchiver unarchiveObjectWithData:savedArray];
        NSLog(@"oldArray - %@",oldArray);
        if(oldArray != nil){
           NSMutableArray *someArray = [[NSMutableArray alloc] initWithArray:oldArray];
            _dataSource = [[someArray subarrayWithRange:NSMakeRange(1, (someArray.count - 1))] mutableCopy];
        
        } else {
            _dataSource = [[NSMutableArray alloc] init];
        }
    }
    [self.tableView reloadData];
    
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(popoverPressed:)];
    self.navigationItem.leftBarButtonItem = settings;
    HTML_parser* parser= [[HTML_parser alloc] init];

    [parser getUrlsForParsing:^(NSMutableArray *parseURLs) {
        self.urlsForParsing = parseURLs;
    }];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    [self setConstraints];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    
   
}
-(void)popoverPressed:(UIBarButtonItem*)sender{
    PopoverViewController *vc = [[PopoverViewController alloc] init];

    vc.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popVC = vc.popoverPresentationController;
    popVC.barButtonItem = sender;
    popVC.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popVC.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - UIPopoverPresentationControllerDelegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}
- (UIViewController *)presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style{
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller.presentedViewController];
    navController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:nil];
    
    return navController;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];

    if([self.dataSource count] > indexPath.row){
        cell.textLabel.text = self.dataSource[indexPath.row];
    }
    cell.layer.borderWidth = 0.2;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return kHeaderName;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    ListOfNews *news = [[ListOfNews alloc] init];
    self.dataSource[indexPath.row] = self.urlsForParsing[indexPath.row];
    news.url = self.urlsForParsing[indexPath.row];

    [self.navigationController pushViewController:news animated:YES];
}
-(void) setConstraints{
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
                                              [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                              [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                                              [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                              [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
                                              ]];
}


@end
