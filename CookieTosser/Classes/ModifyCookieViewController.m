//
//  ModifyCookieViewController.m
//  CookieTosser
//
//  Created by Brian Michel on 4/30/13.
//  Copyright (c) 2013 Brian Michel. All rights reserved.
//

#import "ModifyCookieViewController.h"

@interface ModifyCookieViewController ()
@property (strong) NSHTTPCookie *cookie;
@property (strong) UITextField *nameField;
@property (strong) UITextField *valueField;
@end

@implementation ModifyCookieViewController
- (id)initWithCookie:(NSHTTPCookie *)cookie {
    self = [super init];
    if (self) {
        self.cookie = cookie;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = self.cookie ? [NSString stringWithFormat:@"Edit '%@'", self.cookie.name] : @"Create Cookie";
    self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 40)];
    self.valueField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.nameField.frame) + 10, self.nameField.frame.size.width, self.nameField.frame.size.height)];
    
    for (UITextField *field in @[self.nameField, self.valueField]) {
        field.backgroundColor = [UIColor whiteColor];
        field.borderStyle = UITextBorderStyleRoundedRect;
        field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = item;
    
    [self.view addSubview:self.nameField];
    [self.view addSubview:self.valueField];
    
    self.nameField.placeholder = @"Cookie Name";
    self.valueField.placeholder = @"Cookie Value";
    
    self.nameField.text = self.cookie.name;
    self.valueField.text = self.cookie.value;
	// Do any additional setup after loading the view.
}

#pragma mark - Actions
- (void)save:(id)sender {
    if ([self.nameField.text length] > 0 && [self.valueField.text length] > 0) {
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:@{
                                              NSHTTPCookieDomain : @"localhost",
                                                NSHTTPCookiePath : @"/",
                                                NSHTTPCookieName : self.nameField.text,
                                               NSHTTPCookieValue : self.valueField.text,
                                             NSHTTPCookieExpires : [[NSDate distantFuture] description]
                                }];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
