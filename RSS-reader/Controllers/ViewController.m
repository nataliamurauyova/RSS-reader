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

static NSString* const kCellIdentifier = @"Cell";
static NSString *const begin = @"<ul class=\"b-lists\"><li class=\"lists__li\">";
static NSString *const end = @"<i class=\"main-shd\"><i class=\"main-shd-i\">";

@interface ViewController ()
@property(nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataSource;
@property(nonatomic) NSMutableArray *urlsForParsing;
@property(assign,nonatomic) BOOL flag;
@property(strong,nonatomic) NSURL* destinationURL;
@property(strong,nonatomic) NSArray* result;
@property(strong,nonatomic) NSArray* resultRSS;

@end

@implementation ViewController

-(UITableView*)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}
-(NSMutableArray*)dataSource{
    if(!_dataSource){
        _dataSource = [NSMutableArray arrayWithObjects:@"Главные новости недели",@"Деньги и власть",@"Общество",@"В мире",@"Кругозор",@"Происшествия",@"Финансы",@"Недвижимость",@"Спорт",@"Авто",@"Леди",@"42",@"Афиша",@"GO",@"Новости компаний", nil];
    }
    return _dataSource;
}

-(NSMutableArray*)urlsForParsing{
    if(!_urlsForParsing){
        _urlsForParsing = [[NSMutableArray alloc] init];
    }
    return _urlsForParsing;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Категории";
    
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(barButtonLeft:)];
    self.navigationItem.leftBarButtonItem = settings;
    HTML_parser* parser= [[HTML_parser alloc] init];
    [parser doURLSession:^(NSMutableArray *destinationUrl) {
        self.urlsForParsing = destinationUrl;
    }];

    
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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    
   
}
//-(void)barButtonLeft:(UIBarButtonItem*) sender{
//    UIPopoverPresentationController *popover = [self popoverPresentationController];
//    popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
//    popover.delegate = self;
//
//    popover.sourceView = self.view;
//    popover.sourceRect = CGRectMake(30, 50, 10, 10);
//
//}

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
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    ListOfNews *news = [[ListOfNews alloc] init];
    self.dataSource[indexPath.row] = self.urlsForParsing[indexPath.row];

    
    [self.navigationController pushViewController:news animated:YES];
}


@end
