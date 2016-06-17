//
//  BaseViewController.m
//  Escortstars
//
//  Created by TecOrb on 05/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import "BaseViewController.h"
#import "WhiteListViewController.h"
#import "BlackListViewController.h"
#import "AddNewViewController.h"
#import "DropInViewController.h"
#import "SettingsViewController.h"
#import "ContactsBaseViewController.h"
#import "KVNProgress.h"
@interface BaseViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate, MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,AddNewNumberToListProtocol>
{
    __weak IBOutlet UIButton *whiteListBtn;
    __weak IBOutlet UIButton *blackListBtn;
    __weak IBOutlet UIButton *dropInBtn;
    __weak IBOutlet UIButton *panicBtn;
    __weak IBOutlet UIScrollView *scrollV;
    __weak IBOutlet UIView *underLineV;
    User *user;
    UIImage *emergecyImage;
}
@property (assign) NSUInteger page;
@property (assign) NSUInteger currentPage;
@property (nonatomic,strong) UIImagePickerController *imagePickerController;
- (IBAction)whiteListBtnAction:(id)sender;
- (IBAction)blackListBtnAction:(id)sender;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabState = TabStatePauseDropIn;
    //setup the buttons colors
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
//                                                            bundle: nil];
//    BOOL contactCreated = (BOOL)[kUserDefault valueForKey:kContactCreated];
//    if (!contactCreated) {
//        [self addContacts];
//        [self syncronizeBlackList];
//        [self syncronizeWhiteList];
//    }
//    self.navigationItem.title = @"Black List";
//    self.navigationItem.rightBarButtonItems=nil;
//    UIBarButtonItem *addNewButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"plusButton"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickAddNewEntryToBlackList:)];
//    UIBarButtonItem *refreshButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"refreshButton"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickRefreshBlackList:)];
//    self.navigationItem.rightBarButtonItems=@[addNewButton,refreshButton];
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//
//
//
//    BlackListViewController *blackListVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"BlackListViewController"];
//    WhiteListViewController *whiteListVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"WhiteListViewController"];
//    DropInViewController *dropInVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"DropInViewController"];
//    [self addChildViewController:blackListVC];
//    [self addChildViewController:whiteListVC];
//    [self addChildViewController:dropInVC];
//    [self performSelector:@selector(LoadScolllView) withObject:nil afterDelay:0.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}


- (IBAction)whiteListBtnAction:(id)sender{
    [self raceTo:CGPointMake(whiteListBtn.superview.frame.origin.x, 0) withSnapBack:YES delegate:nil callback:nil];
    [self raceScrollTo:CGPointMake(self.view.frame.size.width, 0) withSnapBack:YES delegate:nil callback:nil];
    [self calledViewWillAppear];

}
- (IBAction)blackListBtnAction:(id)sender{
    [self raceTo:CGPointMake(blackListBtn.superview.frame.origin.x, 0) withSnapBack:YES delegate:nil callback:nil];
    [self raceScrollTo:CGPointMake(0, 0) withSnapBack:YES delegate:nil callback:nil];
    [self calledViewWillAppear];

}
- (IBAction)dropInBtnAction:(id)sender{
    [self raceTo:CGPointMake(dropInBtn.superview.frame.origin.x, 0) withSnapBack:YES delegate:nil callback:nil];
    [self raceScrollTo:CGPointMake(2*self.view.frame.size.width, 0) withSnapBack:YES delegate:nil callback:nil];
    [self calledViewWillAppear];
}
- (IBAction)panicBtnAction:(id)sender{
    //check the setting
    NSString *emergencyEMailID = [kUserDefault valueForKey:kEmergencyEmailID];
    NSString *emergencyContact = [kUserDefault valueForKey:kEmergencyContact];

    if ((emergencyEMailID == nil || [emergencyEMailID isEqualToString:@""]) && (emergencyContact == nil || [emergencyContact isEqualToString:@""])) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:@"You didn't provide any Emergency email or contact, Please provide these in Settings Screen" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
            //go to settings
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            SettingsViewController *settingVC = (SettingsViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"Settings"];
            settingVC.navigationController.title = @"Emergency Settings";
            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:settingVC
                                                                     withSlideOutAnimation:NO
                                                                             andCompletion:nil];

        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:cancelAction];
        [alert addAction:settingAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        _imagePickerController = [[UIImagePickerController alloc] init];
        if (([UIImagePickerController isSourceTypeAvailable:
              UIImagePickerControllerSourceTypeCamera] == NO))
        return ;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        _imagePickerController.allowsEditing = NO;
        _imagePickerController.showsCameraControls = YES;
        _imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        _imagePickerController.delegate = self;
        [_imagePickerController prefersStatusBarHidden];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:_imagePickerController animated:YES completion:^{}];
        });
    }
    }
-(IBAction)onClickRefreshBlackList:(UIBarButtonItem*)sender{
    [self syncronizeBlackList];
}
-(IBAction)onClickRefreshWhiteList:(UIBarButtonItem*)sender{
    [self syncronizeWhiteList];
}
-(IBAction)onClickAddNewEntryToBlackList:(UIBarButtonItem*)sender{
    //barTint, titleColor, backGround
    AddNewViewController *addNewVC = [[UIStoryboard storyboardWithName:@"Main"
                                                                bundle: nil] instantiateViewControllerWithIdentifier:@"AddNewViewController"];
    addNewVC.delegate = self;

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addNewVC];
    navController.navigationBar.barTintColor = kNavigationColor;
    navController.navigationBar.backgroundColor = kNavigationColor;
    navController.navigationBar.tintColor = [UIColor whiteColor];
    [navController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    addNewVC.listType = BlackList;
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:navController animated:true completion:nil];

}
-(IBAction)onClickAddNewEntryToWhiteList:(UIBarButtonItem*)sender{
    AddNewViewController *addNewVC = [[UIStoryboard storyboardWithName:@"Main"
                                                                bundle: nil] instantiateViewControllerWithIdentifier:@"AddNewViewController"];
    addNewVC.delegate = self;

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addNewVC];
    navController.navigationBar.barTintColor = kNavigationColor;
    navController.navigationBar.backgroundColor = kNavigationColor;
    navController.navigationBar.tintColor = [UIColor whiteColor];
    [navController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    addNewVC.listType = WhiteList;
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:navController animated:YES completion:nil];
}


#pragma mark-
#pragma mark- UIImagePickerControllerDelegate Methods

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [picker dismissViewControllerAnimated:YES completion:nil];
    if(image){
        emergecyImage = [[UIImage alloc]initWithData:UIImageJPEGRepresentation(image, 0.5)];
        NSString *emergencyMail = [kUserDefault valueForKey:kEmergencyEmailID];
        if(emergencyMail != nil && ![emergencyMail isEqualToString:@""]) {
            [self sendMail:image];
        }else{
            NSString *emergencyContact = [kUserDefault valueForKey:kEmergencyContact];
            if(emergencyContact != nil && ![emergencyContact isEqualToString:@""]) {
                [self sendMessage:emergecyImage];
            }
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController prefersStatusBarHidden];
}

#pragma mark-
#pragma mark-

-(void) LoadScolllView
{
    _currentPage=0;
    _page = 0;
    scrollV.delegate = nil;
    scrollV.contentSize = CGSizeMake(self.view.frame.size.width * 3, scrollV.frame.size.height);
    for (NSUInteger i =0; i < [self.childViewControllers count]; i++)
        {
        [self loadScrollViewWithPage:i];

        }
    scrollV.delegate = self;
}

- (void)loadScrollViewWithPage:(NSInteger)page
{
    if (page < 0)
        return;
    if (page >= [self.childViewControllers count])
        return;
    BlackListViewController *blackListsVC;
    WhiteListViewController *whiteListVC;
    DropInViewController *dropInVC;
    CGRect frame = scrollV.frame;
    switch (page) {
        case 0:
            blackListsVC = [self.childViewControllers objectAtIndex:page];
            [blackListsVC viewWillAppear:YES];
            frame.origin.x = frame.size.width * page;
            frame.origin.y = 0;
            blackListsVC.view.frame = frame;
            [scrollV addSubview:blackListsVC.view];
            break;
        case 1:
            whiteListVC = [self.childViewControllers objectAtIndex:page];
            [whiteListVC viewWillAppear:YES];
            frame.origin.x = frame.size.width * page;
            frame.origin.y = 0;
            whiteListVC.view.frame = frame;
            [scrollV addSubview:whiteListVC.view];
            break;
        case 2:
            dropInVC = [self.childViewControllers objectAtIndex:page];
            frame.origin.x = frame.size.width * page;
            frame.origin.y = 0;
            dropInVC.view.frame = frame;
            [scrollV addSubview:dropInVC.view];
            break;
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{

}


#pragma mark-
#pragma mark- Scroll View Delegate

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int pageCurrent  = (int)floor(scrollV.contentOffset.x/self.view.frame.size.width);
    switch (pageCurrent)
    {
        case 0:
        {
        [self raceTo:CGPointMake(blackListBtn.superview.frame.origin.x, 0) withSnapBack:YES delegate:nil callback:nil];
        }
        break;
        case 1:
        {
        [self raceTo:CGPointMake(whiteListBtn.superview.frame.origin.x, 0) withSnapBack:YES delegate:nil callback:nil];
        }
        break;
        case 2:
        {
        [self raceTo:CGPointMake(dropInBtn.superview.frame.origin.x, 0) withSnapBack:YES delegate:nil callback:nil];
        }
        break;
        default:
        break;
    }
    [self calledViewWillAppear];
}

-(void) calledViewWillAppear
{
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((scrollV.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    BlackListViewController *blackListsVC;
    WhiteListViewController *whiteListVC;

    if (page == 0) {
        //self.navigationItem.rightBarButtonItems=nil;
        self.navigationItem.title = @"Black List";
        UIBarButtonItem *addNewButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"plusButton"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickAddNewEntryToBlackList:)];
        UIBarButtonItem *refreshButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"refreshButton"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickRefreshBlackList:)];
        self.navigationItem.rightBarButtonItems=@[addNewButton,refreshButton];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        blackListsVC = [self.childViewControllers objectAtIndex:page];
        [blackListsVC viewWillAppear:YES];

    }else if(page==1){
        self.navigationItem.rightBarButtonItems=nil;

        self.navigationItem.title = @"White List";
        UIBarButtonItem *addNewButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"plusButton"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickAddNewEntryToWhiteList:)];
        UIBarButtonItem *refreshButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"refreshButton"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickRefreshWhiteList:)];
        self.navigationItem.rightBarButtonItems=@[addNewButton,refreshButton];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        whiteListVC = [self.childViewControllers objectAtIndex:page];
        [whiteListVC viewWillAppear:YES];
    }else{
        self.navigationItem.title = @"Drop In";
        self.navigationItem.rightBarButtonItems=nil;
    }
}

- (void)raceTo:(CGPoint)destination withSnapBack:(BOOL)withSnapBack delegate:(id)delegate callback:(SEL)method
{
    CGPoint stopPoint = destination;
    if (withSnapBack)
        {
        int diffx = destination.x - underLineV.frame.origin.x;
        int diffy = destination.y - underLineV.frame.origin.y;
        if (diffx < 0)
            {
            stopPoint.x -= 10.0;
            }
        else if (diffx > 0)
            {
            stopPoint.x += 10.0;
            }
        if (diffy < 0)
            {
            stopPoint.y -= 10.0;
            }
        else if (diffy > 0)
            {
            stopPoint.y += 10.0;
            }
        }

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    underLineV.frame = CGRectMake(stopPoint.x, stopPoint.y, underLineV.frame.size.width, underLineV.frame.size.height);
    [UIView commitAnimations];
    double firstDelay = 0.3;
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, firstDelay * NSEC_PER_SEC);
    dispatch_after(startTime, dispatch_get_main_queue(), ^(void)
                   {
                   [UIView beginAnimations:nil context:nil];
                   [UIView setAnimationDuration:0.1];
                   [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                   underLineV.frame = CGRectMake(destination.x, destination.y, underLineV.frame.size.width, underLineV.frame.size.height);
                   [UIView commitAnimations];
                   });
}

- (void)raceScrollTo:(CGPoint)destination withSnapBack:(BOOL)withSnapBack delegate:(id)delegate callback:(SEL)method {
    CGPoint stopPoint = destination;
    BOOL isleft=NO;
    if (withSnapBack)
        {
        int diffx = destination.x - scrollV.contentOffset.x;
        if (diffx < 0)
            {
            isleft=YES;
            stopPoint.x -= 10.0;
            }
        else if (diffx > 0)
            {
            isleft=NO;
            stopPoint.x += 10.0;
            }
        }

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    if(isleft)
        {
        scrollV.contentOffset =CGPointMake(destination.x-5, destination.y);
        }
    else
        {
        scrollV.contentOffset =CGPointMake(destination.x+5, destination.y);
        }
    [UIView commitAnimations];
    double firstDelay = 0.3;
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, firstDelay * NSEC_PER_SEC);
    dispatch_after(startTime, dispatch_get_main_queue(), ^(void)
                   {
                   [UIView beginAnimations:nil context:nil];
                   [UIView setAnimationDuration:0.1];
                   [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                   if(isleft)
                       {
                       scrollV.contentOffset =CGPointMake(destination.x+5, destination.y);
                       }
                   else
                       {
                       scrollV.contentOffset =CGPointMake(destination.x-5, destination.y);
                       }
                   [UIView commitAnimations];
                   double secondDelay = 0.1;
                   dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, secondDelay * NSEC_PER_SEC);
                   dispatch_after(startTime, dispatch_get_main_queue(), ^(void)
                                  {
                                  [UIView beginAnimations:nil context:nil];
                                  [UIView setAnimationDuration:0.1];
                                  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                                  scrollV.contentOffset =CGPointMake(destination.x, destination.y);
                                  [UIView commitAnimations];
                                  [self calledViewWillAppear];
                                  });
                   });
}

#pragma -
#pragma Sending Mail

-(void)sendMail:(UIImage *)image{
    //here go the logic to send the mail via third party api
    NSDictionary *userDict = [kUserDefault valueForKey:kUserInfo];
    user = [User modelObjectWithDictionary:userDict];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:user.userDisplayName forKey:@"user_name"];
    [params setValue:@"send_mail" forKey:@"action"];
    NSString *emergencyEMailID = [kUserDefault valueForKey:kEmergencyEmailID];
    [params setValue:emergencyEMailID forKey:@"mail_to"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil];
    ;

    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:BASE_URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:@"mail_image" fileName:@"mail_image" mimeType:@"image/jpeg"];
    } error:nil];

    NSURLSessionUploadTask *uploadTask;
    [KVNProgress showProgress:0.0 status:@"Uploading"];
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if (uploadProgress.fractionCompleted == 1.00000) {
                              [CommonMethods showSuccessWithStatus:@"Done"];
                          }else{
                              [KVNProgress updateStatus:[NSString stringWithFormat:@"Sending...\n%.0f %% Done", (uploadProgress.fractionCompleted * 100)]];
                              [KVNProgress updateProgress:uploadProgress.fractionCompleted animated:YES];
                          }
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                      } else {
                                BOOL result = (_Bool)responseObject[@"result"];
                                if (result)
                                    {
                                        NSString *emergencyContact = [kUserDefault valueForKey:kEmergencyContact];
                                        if(emergencyContact != nil && ![emergencyContact isEqualToString:@""]){
                                            [self sendMessage:emergecyImage];
                                        }
                                      }else
                                      {
                                      [CommonMethods showErrorWithStatus:@"Something went wrong!" inView:self.view];
                                      }

                      }
                  }];
    
    [uploadTask resume];







}

-(void)sendMessage:(UIImage *)image{
    if ([MFMessageComposeViewController canSendAttachments])
    {
    MFMessageComposeViewController *messageComposer = [[MFMessageComposeViewController alloc] init];
    messageComposer.messageComposeDelegate = self;
    [messageComposer setSubject:@"Emergency Escortstars"];
    NSString *body = @"It's an emergency";
    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
    [messageComposer addAttachmentData:imageData typeIdentifier:@"image/jpeg" filename:@"emergency.jpeg"];
    NSString *emergencyContact = [kUserDefault valueForKey:kEmergencyContact];
    NSArray *toRecipients = [NSArray arrayWithObjects:emergencyContact,nil];
    [messageComposer setRecipients:toRecipients];
    [messageComposer setBody:body];
    [self presentViewController: messageComposer animated:YES completion:nil];
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    NSString *message;
    switch (result) {
        case MFMailComposeResultCancelled:
            message = @"Mail cancelled";
            //NSLog(@"Mail cancelled");
            break;

        case MFMailComposeResultSaved:
            message = @"Mail saved";
            //NSLog(@"Mail saved");
            break;

        case MFMailComposeResultSent:
            message = @"Mail sent";
            //NSLog(@"Mail sent");
            break;

        case MFMailComposeResultFailed:
            message = [NSString stringWithFormat:@"Mail sent failure: %@", [error localizedDescription]];
            break;

        default:
            break;
    }
    // Close the Mail Interface
    [controller dismissViewControllerAnimated:YES completion:^{
        NSString *emergencyContact = [kUserDefault valueForKey:kEmergencyContact];
        if(emergencyContact != nil && ![emergencyContact isEqualToString:@""]) {
            [self sendMessage:emergecyImage];

        }
    }];
//    [CommonMethods showAlertWithMessage:message title:@"Message" inViewController:self];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    NSString *message;
    switch (result) {
            case MessageComposeResultCancelled:
            message = @"SMS cancelled";
            //NSLog(@"Mail cancelled");
            break;

            case MessageComposeResultSent:
            message = @"SMS sent";
            //NSLog(@"Mail sent");
            break;

            case MessageComposeResultFailed:
            message = @"SMS couldn't sent";
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:^{
    }];
    [CommonMethods showAlertWithMessage:message title:@"Message" inViewController:self];
}

-(void)addContacts{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];

    if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted) {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"This app previously was refused permissions to contacts; Please go to settings and grant permission to this app so it can add the desired contact" preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];

        [self presentViewController:alert animated:TRUE completion:nil];

        return;

    }



    CNContactStore *store = [[CNContactStore alloc] init];

    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {

        if (!granted) {

            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@" store request error = %@", error);

            });

            return;

        }

        // create contact
        CNMutableContact *contactToBlacklist = [[CNMutableContact alloc] init];
        contactToBlacklist.givenName = @"Blacklisted Callers";
        contactToBlacklist.imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"spam"], 0.7);
        contactToBlacklist.note = @"Hi there 👋! This contact was created by Escortstars and contains the latest reported spammers by Escorts. It’s updated every time you refresh your Spam List — so please don’t delete this contact!";
        CNMutableContact *contactToWhitelist = [[CNMutableContact alloc] init];
        contactToWhitelist.givenName = @"Whitelisted Callers";
        contactToWhitelist.note = @"Hi there 👋! This contact was created by Escortstars and contains the latest reported whitelist custumers by Escorts. It’s updated every time you refresh your WhiteList — so please don’t delete this contact!";
        CNSaveRequest *request = [[CNSaveRequest alloc] init];
        NSString *containerId = store.defaultContainerIdentifier;

        [request addContact:contactToBlacklist toContainerWithIdentifier:containerId];
        [request addContact:contactToWhitelist toContainerWithIdentifier:containerId];

        NSError *saveError;

        if (![store executeSaveRequest:request error:&saveError]) {
            [kUserDefault setBool:NO forKey:kContactCreated];
        }
        else{
            [kUserDefault setBool:YES forKey:kContactCreated];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];

}




-(void)syncronizeBlackList{
    NSDictionary *userDict = [kUserDefault valueForKey:kUserInfo];
    user = [User modelObjectWithDictionary:userDict];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:user.userID forKey:@"id_user"];
    [params setValue:@"app_getphones" forKey:@"action"];
    [params setValue:@"0" forKey:@"list_type"];
    [CommonMethods showLoader:@"Please wait.."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil];
    [manager POST:BASE_URL parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
     [CommonMethods hideLoader];
     NSDictionary *phones = responseObject[@"phones"];
     [self addSyncronizedListInSystemContacts:phones inlistType:BlackList];
     } failure:^(NSURLSessionTask *operation, NSError *error) {
         [CommonMethods hideLoader];
     }];

}

-(void)syncronizeWhiteList{
    NSDictionary *userDict = [kUserDefault valueForKey:kUserInfo];
    user = [User modelObjectWithDictionary:userDict];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:user.userID forKey:@"id_user"];
    [params setValue:@"app_getphones" forKey:@"action"];
    [params setValue:@"1" forKey:@"list_type"];
    [CommonMethods showLoader:@"Please wait.."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil];
    [manager POST:BASE_URL parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
     [CommonMethods hideLoader];
     NSLog(@"whitelist syncronize response is : %@", responseObject);
     NSDictionary *phones = responseObject[@"phones"];
     [self addSyncronizedListInSystemContacts:phones inlistType:WhiteList];
     } failure:^(NSURLSessionTask *operation, NSError *error) {
         [CommonMethods hideLoader];
     }];

}

-(void)addSyncronizedListInSystemContacts:(NSDictionary*)phones inlistType:(NumberListType)listType{

    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];

    if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted) {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"This app previously was refused permissions to contacts; Please go to settings and grant permission to this app so it can add the desired contact" preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];

        [self presentViewController:alert animated:TRUE completion:nil];

        return;

    }

    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            NSArray *keys = @[CNContactBirthdayKey,CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactEmailAddressesKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                return ;
            } else {
                NSMutableArray *numbers = [[NSMutableArray alloc]init];
                [numbers removeAllObjects];
                for (NSString * key in phones)
                    {
                    NSString *rId = key;
                    NSDictionary *details = phones[rId];
                    NSString *name = details[@"name"];
                    NSString *number = details[@"phone"];
                    if ( name == nil || name == NULL || name.class == [NSNull class]) {
                        name = number;
                    }
                    CNLabeledValue *aLabel = [CNLabeledValue labeledValueWithLabel:[NSString stringWithFormat:@"%@ |%@",name,rId] value:[CNPhoneNumber phoneNumberWithStringValue:[NSString stringWithFormat:@"%@",number]]];
                    [numbers addObject:aLabel];
                    }
                NSString *searchingContact;
                if (listType == BlackList) {
                    searchingContact = @"Blacklisted Callers";
                } else if (listType == WhiteList){
                    searchingContact = @"Whitelisted Callers";
                }
                BOOL found = NO;
                for (CNContact *contact in cnContacts) {
                    if ([contact.givenName isEqualToString:searchingContact])
                        {
                        found = YES;
                        CNMutableContact *cont = [contact mutableCopy];
//                        [numbers addObjectsFromArray:contact.phoneNumbers];
                        cont.phoneNumbers = numbers;
                        CNSaveRequest *request = [[CNSaveRequest alloc] init];
                        [request updateContact:cont];
                        NSError *saveError;
                        if (![store executeSaveRequest:request error:&saveError]) {
                            NSLog(@"error in saving contact..");
                        }else{
                            [self calledViewWillAppear];
                        }
                        }
                }
                if (!found) {
                    //[self addContactsForList:listType rowID:rowID];
                }
            }
        }else{
            [CommonMethods showAlertWithMessage:@"Not Authorised!" title:@"Error!" inViewController:self];
        }
    }];


}



//-(void)addToContactList:(NSString*)rowID{
//    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
//
//    if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted) {
//
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"This app previously was refused permissions to contacts; Please go to settings and grant permission to this app so it can add the desired contact" preferredStyle:UIAlertControllerStyleAlert];
//
//        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
//
//        [self presentViewController:alert animated:TRUE completion:nil];
//
//        return;
//
//    }
//
//    CNContactStore *store = [[CNContactStore alloc] init];
//    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        if (granted == YES) {
//            NSArray *keys = @[CNContactBirthdayKey,CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactEmailAddressesKey];
//            NSString *containerId = store.defaultContainerIdentifier;
//            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
//            NSError *error;
//            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
//            if (error) {
//                return ;
//            } else {
//                NSMutableArray *numbers = [[NSMutableArray alloc]init];
//                CNLabeledValue *aLabel = [CNLabeledValue labeledValueWithLabel:[NSString stringWithFormat:@"%@ |%@",_nameTextField.text,rowID] value:[CNPhoneNumber phoneNumberWithStringValue:[NSString stringWithFormat:@"%@",_numberTextField.text]]];
//                [numbers removeAllObjects];
//                [numbers addObject:aLabel];
//                NSString *searchingContact;
//                if (self.listType == BlackList) {
//                    searchingContact = @"Blacklisted Callers";
//                } else if (self.listType == WhiteList){
//                    searchingContact = @"Whitelisted Callers";
//                }
//                BOOL found = NO;
//                for (CNContact *contact in cnContacts) {
//                    if ([contact.givenName isEqualToString:searchingContact])
//                        {
//                        found = YES;
//                        CNMutableContact *cont = [contact mutableCopy];
//                        [numbers addObjectsFromArray:contact.phoneNumbers];
//                        cont.phoneNumbers = numbers;
//                        CNSaveRequest *request = [[CNSaveRequest alloc] init];
//                        [request updateContact:cont];
//                        NSError *saveError;
//                        if (![store executeSaveRequest:request error:&saveError]) {
//                            NSLog(@"error in saving contact..");
//                        }else{
//                        }
//                        }
//                }
//                if (!found) {
//                    [self addContactsForList:self.listType rowID:rowID];
//                }
//            }
//        }else{
//            [CommonMethods showAlertWithMessage:@"Not Authorised!" title:@"Error!" inViewController:self];
//        }
//    }];
//}

//-(void)addContactsForList:(NumberListType)listType rowID:(NSString*)rowID{
//    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
//    if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted) {
//
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"This app previously was refused permissions to contacts; Please go to settings and grant permission to this app so it can add the desired contact" preferredStyle:UIAlertControllerStyleAlert];
//
//        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
//        [self.presentingViewController presentViewController:alert animated:TRUE completion:nil];
//        return;
//    }
//
//
//
//    CNContactStore *store = [[CNContactStore alloc] init];
//
//    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
//
//        if (!granted) {
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@" store request error = %@", error);
//
//            });
//
//            return;
//
//        }
//
//        // create contact
//        CNMutableContact *contact = [[CNMutableContact alloc] init];
//        if (listType == BlackList) {
//            contact.givenName = @"Blacklisted Callers";
//
//            contact.imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"spam"], 0.7);
//            contact.note = @"Hi there 👋! This contact was created by Escortstars and contains the latest reported spammers by Escorts. It’s updated every time you refresh your Spam List — so please don’t delete this contact!";
//        } else {
//            contact.givenName = @"Whitelisted Callers";
//            contact.note = @"Hi there 👋! This contact was created by Escortstars and contains the latest reported whitelist custumers by Escorts. It’s updated every time you refresh your WhiteList — so please don’t delete this contact!";
//        }
//        NSMutableArray *numbers = [[NSMutableArray alloc]init];
//        CNLabeledValue *aLabel = [CNLabeledValue labeledValueWithLabel:[NSString stringWithFormat:@"%@|%@",_nameTextField.text,rowID] value:[CNPhoneNumber phoneNumberWithStringValue:[NSString stringWithFormat:@"%@",_numberTextField.text]]];
//        [numbers removeAllObjects];
//        [numbers addObject:aLabel];
//        contact.phoneNumbers = numbers;
//        CNSaveRequest *request = [[CNSaveRequest alloc] init];
//        NSString *containerId = store.defaultContainerIdentifier;
//        [request addContact:contact toContainerWithIdentifier:containerId];
//        NSError *saveError;
//
//        if (![store executeSaveRequest:request error:&saveError]) {
//            [kUserDefault setBool:NO forKey:kContactCreated];
//        }
//        else{
//            [kUserDefault setBool:YES forKey:kContactCreated];
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }
//    }];
//}








#pragma -
#pragma - Addnewnumber to list protocol

-(void)numberDidSavedToList:(NumberListType)listType number:(NSString *)number{

//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self prefersStatusBarHidden];
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        [self calledViewWillAppear];
//        if (listType == BlackList) {
//            [params setValue:@"0" forKey:@"list"];
//        } else if (listType == WhiteList){
//            [params setValue:@"1" forKey:@"list"];
//        }
//        NSDictionary *userDict = [kUserDefault valueForKey:kUserInfo];
//        user = [User modelObjectWithDictionary:userDict];
//        [params setValue:user.userID forKey:@"id_user"];
//        [params setValue:@"app_addnumber" forKey:@"action"];
//        [params setValue:number forKey:@"phone"];
//
//        [CommonMethods showLoader:@"Please wait.."];
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil];
//        [manager POST:BASE_URL parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
//         {
//         [CommonMethods hideLoader];
//         NSLog(@"response is : %@", responseObject);
//         } failure:^(NSURLSessionTask *operation, NSError *error) {
//             [CommonMethods hideLoader];
//         }];
//    });
}
-(void)addingNumberDidCanceled{

}

-(IBAction)onClickPauseDropIn:(UIButton*)sender{
//    if(_tabState == TabStatePauseDropIn){
//        return;
//    }
    _tabState = TabStatePauseDropIn;
    // make the root view controller of slidenavigation Pause and DropIn view controller
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    DropInViewController *dropInVC = (DropInViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"DropInViewController"];
    dropInVC.navigationController.title = @"Pause/DropIn";
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:dropInVC
                                                             withSlideOutAnimation:NO
                                                                     andCompletion:nil];


}

-(IBAction)onClickContactBookButton:(UIButton*)sender{
//    if(_tabState == TabStateBlackAndWhiteList){
//        return;
//    }
    _tabState = TabStateBlackAndWhiteList;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ContactsBaseViewController *contactBaseVC = (ContactsBaseViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"ContactsBaseViewController"];
    contactBaseVC.navigationController.title = @"Black And WhiteList";
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:contactBaseVC
                                                             withSlideOutAnimation:NO
                                                                     andCompletion:nil];
    

}
-(IBAction)onClickPanicButton:(UIButton*)sender{
//    if(_tabState == TabStatePanic){
//        return;
//    }
    _tabState = TabStatePanic;

    //check the setting
    NSString *emergencyEMailID = [kUserDefault valueForKey:kEmergencyEmailID];
    NSString *emergencyContact = [kUserDefault valueForKey:kEmergencyContact];

    if ((emergencyEMailID == nil || [emergencyEMailID isEqualToString:@""]) && (emergencyContact == nil || [emergencyContact isEqualToString:@""])) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:@"You didn't provide any Emergency email or contact, Please provide these in Emergency Settings Screen" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"Emergency Settings" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
            //go to settings
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            SettingsViewController *settingVC = (SettingsViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"Settings"];
            settingVC.navigationController.title = @"Emergency Settings";
            [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:settingVC
                                                                     withSlideOutAnimation:NO
                                                                             andCompletion:nil];

        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:cancelAction];
        [alert addAction:settingAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        _imagePickerController = [[UIImagePickerController alloc] init];
        if (([UIImagePickerController isSourceTypeAvailable:
              UIImagePickerControllerSourceTypeCamera] == NO))
            return ;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        _imagePickerController.allowsEditing = NO;
        _imagePickerController.showsCameraControls = YES;
        _imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        _imagePickerController.delegate = self;
        [_imagePickerController prefersStatusBarHidden];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:_imagePickerController animated:YES completion:^{}];
        });
    }
}
@end
