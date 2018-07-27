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
        _urlsForParsing = [NSMutableArray arrayWithObjects:@"https://news.tut.by/rss/index.rss",@"https://news.tut.by/rss/economics.rss",@"https://news.tut.by/rss/society.rss",@"https://news.tut.by/rss/world.rss",@"https://news.tut.by/rss/culture.rss",@"https://news.tut.by/rss/accidents.rss",@"https://news.tut.by/rss/finance.rss",@"https://news.tut.by/rss/realty.rss",@"https://news.tut.by/rss/sport.rss",@"https://news.tut.by/rss/auto.rss",@"https://news.tut.by/rss/lady.rss",@"https://news.tut.by/rss/it.rss",@"https://news.tut.by/rss/afisha.rss",@"https://news.tut.by/rss/go.rss",@"https://news.tut.by/rss/press.rss", nil];
    }
    return _urlsForParsing;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Категории";
    
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
    self.navigationItem.leftBarButtonItem = settings;
//    HTML_parser* html = [[HTML_parser alloc] init];
//     [html doURLSession:^(NSArray *destinationUrl) {
//        NSLog(@"INSIDE BLOCK;");
//         self.res = destinationUrl;
//         NSLog(@"%@",self.res);
//    }];
    
        
//    NSArray *anotherArray = [results subarrayWithRange:NSMakeRange(1, 15)];
//    NSLog(@"%@",anotherArray);
//    HTML_parser* parser = [[HTML_parser alloc] init];
//    NSArray *resultsRSS = [parser doURLSession];
//    NSLog(@"%@",resultsRSS);
   
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
//    NSURL *documentsDirectory = [urls objectAtIndex:0];
//    NSURL *originalUrl = [NSURL URLWithString:[location lastPathComponent]];
//    NSURL *destinationUrl = [documentsDirectory URLByAppendingPathComponent:[originalUrl lastPathComponent]];
//
//    NSError *err;
//    NSLog(@"%@", location);
//    [fileManager copyItemAtURL:location toURL:destinationUrl error:&err];
//    [self printError:err withDescr:@"Failed to copy item"];
//
//
//    self.destinationURL = destinationUrl;
//    NSLog(@"%@", self.destinationURL);
//    NSData *data = [[NSData alloc] initWithContentsOfURL:destinationUrl];
//    NSString *resStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSArray *temp = [self parseHTML:resStr];
//
//    self.result = [[self parseHTML2:temp] mutableCopy];
    
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

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
//    if(cell == nil){
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
//    }
    if([self.dataSource count] > indexPath.row){
        cell.textLabel.text = self.dataSource[indexPath.row];
//        cell.detailTextLabel.text = @"1";
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"You've tapped on %@",self.dataSource[indexPath.row]);
    
//        HTML_parser* html = [[HTML_parser alloc] init];
//        [html doURLSession:^(NSArray *destinationUrl) {
//            NSLog(@"INSIDE BLOCK %@",destinationUrl);
//            NSLog(@"Urls are %@",destinationUrl);
//            NSArray *resultsForParsing = [destinationUrl subarrayWithRange:NSMakeRange(2, 15)];
//            NSLog(@"%@",resultsForParsing);
//            ListOfNews *news = [[ListOfNews alloc] init];
//            self.dataSource[indexPath.row] = resultsForParsing[indexPath.row];
//            news.url = resultsForParsing[indexPath.row];
//            [self.navigationController pushViewController:news animated:YES];
//        }];
    
    
    ListOfNews *news = [[ListOfNews alloc] init];
    self.dataSource[indexPath.row] = self.urlsForParsing[indexPath.row];
//    NSLog(@"%@",_urlsForParsing);
//    NSLog(@"%@",self.urlsForParsing[indexPath.row]);
    news.url = self.urlsForParsing[indexPath.row];
//    ListOfNews *news = [[ListOfNews alloc] init];
//
//    HTML_parser* parser = [[HTML_parser alloc] init];
//    self.resultRSS = [[parser doURLSession] objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 15)]];
//    NSLog(@"%@",self.resultRSS);
//
//    self.dataSource[indexPath.row] = self.resultRSS[indexPath.row];
//    news.url = self.resultRSS[indexPath.row];
    
    [self.navigationController pushViewController:news animated:YES];
}


@end
