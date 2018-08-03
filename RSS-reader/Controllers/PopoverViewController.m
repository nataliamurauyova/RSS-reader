//
//  PopoverViewController.m
//  RSS-reader
//
//  Created by Nataliya Murauyova on 8/2/18.
//  Copyright © 2018 Nataliya Murauyova. All rights reserved.
//

#import "PopoverViewController.h"
#import "Channel.h"
#import "ViewController.h"

static NSString* const kCellIdentifier = @"Cell";

@interface PopoverViewController ()
@property(strong, nonatomic) NSMutableArray *allChannels;
@property(nonatomic) NSMutableArray *checkmarkStates;
@end

@implementation PopoverViewController
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSString *stateChecked = [[NSUserDefaults standardUserDefaults] stringForKey:@"stateOfCheckmark"];
    
//    if([stateChecked compare:@"isChecked"] == NSOrderedSame) {
//
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.isChecked = false;
    self.allChannels = [NSMutableArray array];
    self.checkmarkStates = [NSMutableArray array];
    
    
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tableView];
    

    [NSLayoutConstraint activateConstraints:@[
                                              [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                              [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                                              [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                              [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
                                              ]];
  
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    
    for(int i = 0; i < self.dataSource.count; i++) {
        NSString *header = self.dataSource[i];
        Channel *channel = [[Channel alloc] initWithName:header checkState:NO];
        [self.allChannels addObject:channel];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    Channel *channel = self.allChannels[indexPath.row];
    
    cell.textLabel.text = channel.channelName;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"stateOfCheckmark"]) {
        NSLog(@"Yeees");
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        NSLog(@"Nooo");
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectRowAtIndexPath");

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //self.channel = [self.allChannels objectAtIndex:indexPath.row];
    //NSLog(@"Tap - %@",self.allChannels);
    Channel *chan = [self.allChannels objectAtIndex:indexPath.row];
//    NSString* stateChecked = @"isChecked";
//    NSUserDefaults *userPref = [NSUserDefaults standardUserDefaults];
    chan.isChecked = !chan.isChecked;
    if(chan.isChecked){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.checkmarkStates addObject:chan];
//        [userPref setObject:stateChecked forKey:@"stateOfCheckmark"];
    } else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.checkmarkStates removeObject:chan];
//        stateChecked = @"isNotChecked";
//        [userPref setObject:stateChecked forKey:@"stateOfCheckmark"];
    }
    NSLog(@"Set is %@",self.checkmarkStates );
    
    NSUserDefaults *userPref = [NSUserDefaults standardUserDefaults];
    [userPref setBool:chan.isChecked forKey:@"stateOfCheckmark"];
    
//    NSData *checkedObjects = [NSKeyedArchiver archivedDataWithRootObject:self.checkmarkStates];
//    [[NSUserDefaults standardUserDefaults] setObject:checkedObjects forKey:@"stateOfCheckmark"];
//    NSUserDefaults *userPref = [NSUserDefaults standardUserDefaults];
//    [userPref setObject:self.checkmarkStates forKey:@"stateOfCheckmark"];
    
    //NSString *stateOfCheckMark = [[NSUserDefaults standardUserDefaults] stringForKey:@"stateOfCheckmark"];
    ViewController *vc = [[ViewController alloc] init];
    vc.allChannels = self.allChannels;
    //[self presentViewController:vc animated:YES completion:nil];
    

}
-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
