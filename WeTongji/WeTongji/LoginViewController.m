//
//  LoginViewController.m
//  WeTongji
//
//  Created by tang zhixiong on 12-11-13.
//
//

#import "LoginViewController.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "User+Addition.h"
#import "Macro.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()<MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollVIew;
@property (weak, nonatomic) IBOutlet UITextField *NOTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *noAccountSign;
@property (weak, nonatomic) IBOutlet UIButton *regButton;
@property (weak, nonatomic) IBOutlet UIButton *useButton;
@property (strong,nonatomic) MBProgressHUD * progress;
- (void)configureButton;
- (void)enableButton:(NSNotification *)notification;
@end

@implementation LoginViewController

-(MBProgressHUD *) progress
{
    if ( !_progress )
    {
        _progress = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_progress];
        _progress.delegate = self;
        _progress.labelText = @"登录中...";
    }
    return _progress;
}

- (void)autolayout
{
    CGRect frame = self.scrollVIew.frame;
    frame.size.height = self.view.frame.size.height;
    [self.scrollVIew setFrame:frame];
    frame = self.noAccountSign.frame;
    frame.origin.y = self.view.frame.size.height-77;
    [self.noAccountSign setFrame:frame];
    frame = self.regButton.frame;
    frame.origin.y = self.view.frame.size.height-54;
    [self.regButton setFrame:frame];
    frame = self.useButton.frame;
    frame.origin.y = self.view.frame.size.height-54;
    [self.useButton setFrame:frame];
}

- (void)configureButton
{
    self.closeBtn.hidden = YES;
}

- (void)enableButton:(NSNotification *)notification
{
    self.view.userInteractionEnabled = YES;
    self.navButton.userInteractionEnabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self autolayout];
    [self configureButton];
    [self.navigationItem setHidesBackButton:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableButton:) name:kEnableInteractionNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setScrollVIew:nil];
    [self setNOTextField:nil];
    [self setPasswordTextField:nil];
    [self setCloseBtn:nil];
    [self setPasswordForgetBtn:nil];
    [self setNavButton:nil];
    [self setNoAccountSign:nil];
    [self setRegButton:nil];
    [self setUseButton:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resignAllFirstResponder
{
    [self.NOTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
    self.scrollVIew.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [UIView commitAnimations];
}

- (IBAction)textEditDidBegin:(id)sender
{
    self.closeBtn.hidden = NO;
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
    self.scrollVIew.contentInset = UIEdgeInsetsMake(-90, 0, 580, 0);
    [UIView commitAnimations];
}

- (IBAction)textDidEndEdit:(id)sender
{
    [self resignAllFirstResponder];
    [self configureButton];
}

- (IBAction)logInClick:(id)sender
{
    
    [self.progress show:YES];
    [self resignAllFirstResponder];
    WTClient * client = [WTClient sharedClient];
    WTRequest * request = [WTRequest requestWithSuccessBlock: ^(id responseData)
    {
        [NSUserDefaults setCurrentUserID:[[responseData objectForKey:@"User"] objectForKey:@"UID"] session:[responseData objectForKey:@"Session"]];
        [User updateUser:[responseData objectForKey:@"User"] inManagedObjectContext:self.managedObjectContext];
        NSLog(@"%@",responseData);
        self.progress.mode = MBProgressHUDModeText;
        self.progress.labelText = @"登陆成功";
        [self.progress hide:YES afterDelay:1];
    }failureBlock:^(NSError * error)
    {
        [self.progress hide:YES];
        UIAlertView *  alert = [[UIAlertView alloc]
                                initWithTitle:@"登陆失败" message:[[error userInfo] objectForKey:@"errorDesc"] delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
        self.closeBtn.hidden = YES;
    }];
    [request login:self.NOTextField.text password:self.passwordTextField.text];
    [client enqueueRequest:request];
}

-(void) hudWasHidden:(MBProgressHUD *)hud
{
    if ( [hud.labelText isEqualToString:@"登陆成功"] )
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:self];
    [hud removeFromSuperview];
    self.progress = nil;
}

- (IBAction)slide:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSlideNotification object:self];
}
@end
