//
//  ViewController.m
//  CookieTosser
//
//  Created by Brian Michel on 4/30/13.
//  Copyright (c) 2013 Brian Michel. All rights reserved.
//

#import "ViewController.h"
#import "ModifyCookieViewController.h"

@interface ViewController () <UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong) UIWebView *webView;
@property (strong) UITableView *table;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Cookies";
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    UIBarButtonItem *createCookie = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCookie:)];
    self.navigationItem.rightBarButtonItem = createCookie;
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300) style:UITableViewStyleGrouped];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.table.frame), self.view.frame.size.width, self.view.frame.size.height - self.table.frame.size.height)];
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:4567"]]];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.table reloadData];
    [self.webView reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate / Datasource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Current";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellId = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    NSHTTPCookie *cookie = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies[indexPath.row];
    cell.textLabel.text = cookie.name;
    cell.detailTextLabel.text = cookie.value;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete: {
            NSHTTPCookie *cookie = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies[indexPath.row];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.webView reload];
        }  break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSHTTPCookie *cookie = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies[indexPath.row];
    ModifyCookieViewController *cookieVC = [[ModifyCookieViewController alloc] initWithCookie:cookie];
    [self.navigationController pushViewController:cookieVC animated:YES];
}

- (void)addCookie:(id)sender {
    [self.navigationController pushViewController:[[ModifyCookieViewController alloc] initWithCookie:nil] animated:YES];
}

@end
