/*
 The MIT License (MIT)
 
 Copyright (c) 2013 Clover Studio Ltd. All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "HUForgotPasswordViewController.h"
#import "HUControls.h"
#import "NSString+Extensions.h"
#import "AlertViewManager.h"
#import "DatabaseManager.h"
@interface HUForgotPasswordViewController ()
@property (nonatomic, weak) UITextField *emailField;
@end

@implementation HUForgotPasswordViewController

-(void) loadView {
    self.view = [CSKit view];
    self.view.backgroundColor = kHUColorDarkGray;
    
    UIImageView *imageView = [CSKit imageViewWithImageNamed:@"hp_email_field"];
    [self.view addSubview:imageView];
    imageView.center = [CSKit center];
    imageView.y = 70;
    imageView.userInteractionEnabled = YES;
    
    _emailField = [HUControls emailFieldWithFrame:CGRectMake(44, 14, 220, 30)];
    [imageView addSubview:_emailField];
    
    UIButton *button = [HUControls buttonWithCenter:[CSKit center]
                                     localizedTitle:@"ForgotPassword-Send"
                                    backgroundColor:kHUColorGreen
                                         titleColor:kHUColorWhite
                                             target:self
                                           selector:@selector(sendForgotPasswordRequest)];
    button.y = 135;
    [self.view addSubview:button];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self addBackButton];
}

- (NSString *) title {
    
    return NSLocalizedString(@"ForgetPassword-Title", @"");
}

-(void) sendForgotPasswordRequest {
    
    [self.view endEditing:YES];
    
    if ([_emailField.text isValidEmail]) {

        [[AlertViewManager defaultManager] showWaiting:@"" message:@""];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *result = [[DatabaseManager defaultManager] sendReminderSynchronous:_emailField.text];
            
            [[AlertViewManager defaultManager] dismiss];
            
            if([result isEqualToString:@"OK"]){
                [[AlertViewManager defaultManager] showAlert:NSLocalizedString(@"ForgotPassword-Sent", NULL)];
                _emailField.text = @"";
            }else{
                [[AlertViewManager defaultManager] showAlert:NSLocalizedString(@"Invalid-Email-Message", NULL)];
            }
            
        });
    }
    else {
        
        [[AlertViewManager defaultManager] showAlert:NSLocalizedString(@"Invalid-Email-Message", NULL)];
        
    }
}


@end
