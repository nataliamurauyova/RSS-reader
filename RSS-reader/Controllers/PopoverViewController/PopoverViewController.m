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

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    Channel *channel = self.allChannels[indexPath.row];
    
    cell.textLabel.text = channel.channelName;
    if([self getCheckedForIndex:indexPath.row] == YES){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        channel.isChecked = YES;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        channel.isChecked = NO;
    }
    if(channel.isChecked == YES){
        [self.checkmarkStates addObject:channel.channelName];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.checkmarkStates] forKey:@"savedArray"];
    NSLog(@"checkmarkStates - %@",self.checkmarkStates);
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectRowAtIndexPath");

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self checkedCellAtIndex:indexPath.row];
    
    if([self getCheckedForIndex:indexPath.row] == YES){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    NSLog(@"checkmarkStates from didSelectRowAtIndexPath - %@",self.checkmarkStates);


    
}
-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(NSString*)getKeyForIndex:(int)index{
    return [NSString stringWithFormat:@"KEY%d",index];
}
-(BOOL)getCheckedForIndex:(int)index{

    if([[[NSUserDefaults standardUserDefaults] valueForKey:[self getKeyForIndex:index]] boolValue] == YES){
        return YES;
    } else {
        return NO;
    }
}
-(void)checkedCellAtIndex:(int)index{
    BOOL boolChecked = [self getCheckedForIndex:index];
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:!boolChecked] forKey:[self getKeyForIndex:index]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
