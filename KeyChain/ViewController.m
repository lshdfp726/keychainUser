//
//  ViewController.m
//  KeyChain
//
//  Created by 刘松洪 on 2016/11/15.
//  Copyright © 2016年 刘松洪. All rights reserved.
//

#import "ViewController.h"
#import "KeychainWrapper.h"

static NSString *const kKeychain = @"com.lsh726.keychain";//可以认为是用户名
static NSString *const kPassword = @"com.password.keychain";
@interface ViewController ()
//@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) IBOutlet UITextField *setPassword;
@property (strong, nonatomic) IBOutlet UITextField *getPassword;

@property (strong, nonatomic) IBOutlet UIButton *setBtn;
@property (strong, nonatomic) IBOutlet UIButton *getBtn;

@end


@implementation ViewController
//@synthesize name = _name;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *reg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyboard)];
    [self.view addGestureRecognizer:reg];
}


- (void)hiddenKeyboard {
    [self.view endEditing:YES];
}

- (IBAction)savePassword:(id)sender {
    [KeychainWrapper save:kKeychain withString:self.setPassword.text withDataUsingEncoding:NSUTF8StringEncoding];
}

- (IBAction)achievePassword:(id)sender {
    self.getPassword.text = [[NSString alloc]initWithData:[KeychainWrapper load:kKeychain] encoding:NSUTF8StringEncoding];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
