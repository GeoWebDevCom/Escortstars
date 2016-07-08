//
//  DropInViewController.m
//  Escortstars
//
//  Created by TecOrb on 05/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import "DropInViewController.h"
#import "DropDownListView.h"


@interface DropInViewController ()
{
    NSMutableDictionary *dropinParams;
    NSMutableDictionary *pauseParams;

    NSString *selectedDate;
    NSString *startTime;
    NSString *endTime;
    NSString *startDate;
    NSString *endDate;


}
@end

@implementation DropInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arryList=@[@"Today",@"Tomorrow"];
    dropinParams = [[NSMutableDictionary alloc]init];
    pauseParams = [[NSMutableDictionary alloc]init];

    [CommonMethods makeViewCircular:_selectDateButton withBorderColor:[UIColor clearColor] withBorderWidth:0 withCornerRadius:5];
    [CommonMethods makeViewCircular:_activateButton withBorderColor:[UIColor clearColor] withBorderWidth:0 withCornerRadius:5];
    [CommonMethods makeViewCircular:_pauseButton withBorderColor:[UIColor clearColor] withBorderWidth:0 withCornerRadius:5];
    [self setUpStartTimeTextFieldDatePicker];
    [self setUpEndTimeTextFieldDatePicker];
    [self setUpStartDateTextFieldDatePicker];
    [self setUpEndDateTextFieldDatePicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{


    Dropobj = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    Dropobj.delegate = self;
    [Dropobj showInView:_containerView animated:YES];
    /*----------------Set DropDown backGroundColor-----------------*/
    Dropobj.backgroundColor = kNavigationColor;
}
- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
    [_selectDateButton setTitle:[arryList objectAtIndex:anIndex] forState:UIControlStateNormal];
    if (anIndex == 0) {
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];

        selectedDate = [dateFormatter stringFromDate:today];
        _dateLabel.text = selectedDate;
    } else {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit unit = NSCalendarUnitDay;
        NSInteger value = 1;
        NSDate *today = [NSDate date];
        NSDate *tomorrow = [calendar dateByAddingUnit:unit value:value toDate:today options:NSCalendarMatchStrictly];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        selectedDate = [dateFormatter stringFromDate:tomorrow];
        _dateLabel.text = selectedDate;
    }

}
- (void)DropDownListView:(DropDownListView *)dropdownListView Datalist:(NSMutableArray*)ArryData
{
}
- (void)DropDownListViewDidCancel{

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    [self.view endEditing:YES];
    if ([touch.view isKindOfClass:[UIView class]]) {
        [Dropobj fadeOut];
    }
}

- (IBAction)DropDownPressed:(id)sender;
{
    [Dropobj fadeOut];
    [self showPopUpWithTitle:@"Select Date" withOption:arryList xy:_selectDateButton.frame.origin size:CGSizeMake( _selectDateButton.frame.size.width, 280) isMultiple:NO];
}

-(void)setUpStartTimeTextFieldDatePicker
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeTime;
    [datePicker setDate:[NSDate date]];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"da_DK"];
    [datePicker setLocale:locale];
    [datePicker addTarget:self action:@selector(updateStartTimeTextField:) forControlEvents:UIControlEventValueChanged];
    [self.startTimeTextFiled setInputView:datePicker];
    UIToolbar *doneBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width, 44)];
    [doneBar setBarStyle:UIBarStyleBlackTranslucent];
    UIBarButtonItem *spacer2 = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                target:nil
                                action:nil];
    [doneBar setItems: [NSArray arrayWithObjects:spacer2, [[UIBarButtonItem alloc]
                                                           initWithTitle:@"Done"
                                                           style:UIBarButtonItemStyleDone
                                                           target:self
                                                           action:@selector(resignFirstResponderStartTime)],nil ] animated:YES];
    doneBar.backgroundColor = kNavigationColor;
    doneBar.tintColor = [UIColor whiteColor];

    [self.startTimeTextFiled setInputAccessoryView:doneBar];

}


-(void)updateStartTimeTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.self.startTimeTextFiled.inputView;
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm"]; //24hr time format

    NSString *dateString = [outputFormatter stringFromDate:picker.date];
    self.startTimeTextFiled.text = [NSString stringWithFormat:@"%@",dateString];
}

-(void)setUpEndTimeTextFieldDatePicker
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeTime;
    [datePicker setDate:[NSDate date]];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"da_DK"];
    [datePicker setLocale:locale];
    [datePicker addTarget:self action:@selector(updateEndTimeTextField:) forControlEvents:UIControlEventValueChanged];
    [self.endTimeTextFiled setInputView:datePicker];
    UIToolbar *doneBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [doneBar setBarStyle:UIBarStyleBlackTranslucent];
    UIBarButtonItem *spacer2 = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                target:nil
                                action:nil];
    [doneBar setItems: [NSArray arrayWithObjects:spacer2, [[UIBarButtonItem alloc]
                                                           initWithTitle:@"Done"
                                                           style:UIBarButtonItemStyleDone
                                                           target:self
                                                           action:@selector(resignFirstResponderEndTime)],nil ] animated:YES];
    doneBar.backgroundColor = kNavigationColor;
    doneBar.tintColor = [UIColor whiteColor];
    [self.endTimeTextFiled setInputAccessoryView:doneBar];
}
-(void)updateEndTimeTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.self.endTimeTextFiled.inputView;
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm"]; //24hr time format
    NSString *dateString = [outputFormatter stringFromDate:picker.date];
    self.self.endTimeTextFiled.text = [NSString stringWithFormat:@"%@",dateString];
}
-(void)resignFirstResponderEndTime
{
    UIDatePicker *picker = (UIDatePicker*)self.self.endTimeTextFiled.inputView;
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm"]; //24hr time format
    NSString *dateString = [outputFormatter stringFromDate:picker.date];
    self.endTimeTextFiled.text = [NSString stringWithFormat:@"%@",dateString];
    [self.view endEditing:YES];
}
-(void)resignFirstResponderStartTime
{
    UIDatePicker *picker = (UIDatePicker*)self.self.startTimeTextFiled.inputView;
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm"];
    NSString *dateString = [outputFormatter stringFromDate:picker.date];
    self.startTimeTextFiled.text = [NSString stringWithFormat:@"%@",dateString];
    [self.view endEditing:YES];
}
//Pause Profile methods
-(void)setUpStartDateTextFieldDatePicker
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setDate:[NSDate date]];
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateStartDateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.startDateTextFiled setInputView:datePicker];
    UIToolbar *doneBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width, 44)];
    [doneBar setBarStyle:UIBarStyleBlackTranslucent];
    UIBarButtonItem *spacer2 = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                target:nil
                                action:nil];
    [doneBar setItems: [NSArray arrayWithObjects:spacer2, [[UIBarButtonItem alloc]
                                                           initWithTitle:@"Done"
                                                           style:UIBarButtonItemStyleDone
                                                           target:self
                                                           action:@selector(resignFirstResponderStartDate)],nil ] animated:YES];
    doneBar.backgroundColor = kNavigationColor;
    doneBar.tintColor = [UIColor whiteColor];
    [self.startDateTextFiled setInputAccessoryView:doneBar];

}


-(void)updateStartDateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.startDateTextFiled.inputView;
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateStyle:NSDateFormatterMediumStyle];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString *dateString = [outputFormatter stringFromDate:picker.date];
    self.startDateTextFiled.text = [NSString stringWithFormat:@"%@",dateString];
}

-(void)setUpEndDateTextFieldDatePicker
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateEndDateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.endDateTextFiled setInputView:datePicker];
    UIToolbar *doneBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [doneBar setBarStyle:UIBarStyleBlackTranslucent];
    UIBarButtonItem *spacer2 = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                target:nil
                                action:nil];
    [doneBar setItems: [NSArray arrayWithObjects:spacer2, [[UIBarButtonItem alloc]
                                                           initWithTitle:@"Done"
                                                           style:UIBarButtonItemStyleDone
                                                           target:self
                                                           action:@selector(resignFirstResponderEndDate)],nil ] animated:YES];
    doneBar.backgroundColor = kNavigationColor;
    doneBar.tintColor = [UIColor whiteColor];
    [self.endDateTextFiled setInputAccessoryView:doneBar];
}
-(void)updateEndDateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.endDateTextFiled.inputView;
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateStyle:NSDateFormatterMediumStyle];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [outputFormatter stringFromDate:picker.date];
    self.endDateTextFiled.text = [NSString stringWithFormat:@"%@",dateString];
}
-(void)resignFirstResponderEndDate
{
    UIDatePicker *picker = (UIDatePicker*)self.endDateTextFiled.inputView;
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateStyle:NSDateFormatterMediumStyle];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [outputFormatter stringFromDate:picker.date];
    self.endDateTextFiled.text = [NSString stringWithFormat:@"%@",dateString];
    [self.view endEditing:YES];
}
-(void)resignFirstResponderStartDate
{
    UIDatePicker *picker = (UIDatePicker*)self.startDateTextFiled.inputView;
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateStyle:NSDateFormatterMediumStyle];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [outputFormatter stringFromDate:picker.date];
    self.startDateTextFiled.text = [NSString stringWithFormat:@"%@",dateString];
    [self.view endEditing:YES];
}



-(IBAction)onClickClearDropin:(id)sender{
    [self resetDropin];
}
-(IBAction)onClickClearPause:(id)sender{
    [self resetPauseProfile];
}

-(void)resetDropin{
    dropinParams = [[NSMutableDictionary alloc]init];
    [_selectDateButton setTitle:@"Select Date" forState:UIControlStateNormal];
    _dateLabel.text = @"yyyy-MM-dd";
    selectedDate = @"";
    startTime = @"";
    endTime = @"";
    _startTimeTextFiled.text = @"";
    _endTimeTextFiled.text = @"";
}
-(void)resetPauseProfile{
    pauseParams = [[NSMutableDictionary alloc]init];
    startDate = @"";
    endDate = @"";
    _startDateTextFiled.text = @"";
    _endDateTextFiled.text = @"";
}


-(IBAction)onClickActivate:(id)sender{
    startTime = _startTimeTextFiled.text;
    endTime = _endTimeTextFiled.text;
    if ([self validateParams]) {
        startTime = [NSString stringWithFormat:@"%@:00",_startTimeTextFiled.text];
        endTime = [NSString stringWithFormat:@"%@:00",_endTimeTextFiled.text];
        NSDictionary *userDict = [kUserDefault valueForKey:kUserInfo];
        user = [User modelObjectWithDictionary:userDict];
        [dropinParams setValue:user.userID forKey:@"id_user"];
        [dropinParams setValue:@"app_adddropin" forKey:@"action"];
        [dropinParams setValue:[NSString stringWithFormat:@"%@ %@",selectedDate,startTime] forKey:@"date_start"];
        [dropinParams setValue:[NSString stringWithFormat:@"%@ %@",selectedDate,endTime] forKey:@"date_end"];
        [self activateDropIn];
    } else {
        [self showAlertWithMessage:@"Please fill all the fields" title:@"Error!"];
    }
}

-(IBAction)onClickPause:(id)sender{
    startDate = _startDateTextFiled.text;
    endDate = _endDateTextFiled.text;
    if ([self validatePauseParams]) {
        NSDictionary *userDict = [kUserDefault valueForKey:kUserInfo];
        user = [User modelObjectWithDictionary:userDict];
        [pauseParams setValue:user.userID forKey:@"id_user"];
        [pauseParams setValue:@"app_addpause" forKey:@"action"];
        [pauseParams setValue:startDate forKey:@"pause_start"];
        [pauseParams setValue:endDate forKey:@"pause_end"];
        [self pauseProfile];
    } else {
        [self showAlertWithMessage:@"Please fill all the fields" title:@"Error!"];
    }
}
-(void)activateDropIn{
        [CommonMethods showLoader:@"Please wait.."];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil];
        [manager POST:BASE_URL parameters:dropinParams progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
         [CommonMethods hideLoader];
         //[self resetDropin];
         [self showAlertWithMessage:@"Huuuray! Your profile is now marked as \"Available\"" title:@"Message"];

         } failure:^(NSURLSessionTask *operation, NSError *error) {
             [CommonMethods hideLoader];
             [self showAlertWithMessage:@"OOPSS!! Some thing went wrong" title:@"Error!"];
         }];
}
-(void)pauseProfile{
    [CommonMethods showLoader:@"Please wait.."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil];
    [manager POST:BASE_URL parameters:pauseParams progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
     [CommonMethods hideLoader];
     //[self resetPauseProfile];
     [self showAlertWithMessage:@"You paused your profile successfully" title:@"Message"];
     } failure:^(NSURLSessionTask *operation, NSError *error) {
         [CommonMethods hideLoader];
         [self showAlertWithMessage:@"OOPSS!! Some thing went wrong" title:@"Error!"];
     }];
}


-(BOOL)validateParams{

    NSString *message;
    if([selectedDate isEqualToString:@""] || selectedDate == NULL ){
        message = @"Please select the day";
        [self showAlertWithMessage:message title:@"Error!"];
        return NO;
    }

    if([startTime isEqualToString:@""] || startTime == NULL){
        message = @"Start time cann't be empty";
        [self showAlertWithMessage:message title:@"Error!"];
        return NO;
    }

    if([endTime isEqualToString:@""] || endTime == NULL){
        message = @"End time cann't be empty";
        [self showAlertWithMessage:message title:@"Error!"];
        return NO;
    }
    //to check the start time < ent time
    if (![self validateStartAndEndTime:_startTimeTextFiled.text andEndTime:_endTimeTextFiled.text]) {
        return NO;
    }
    return YES;
}

-(BOOL)validatePauseParams{

    NSString *message;
    if([startDate isEqualToString:@""] || startDate == NULL){
        message = @"Start time cann't be empty";
        [self showAlertWithMessage:message title:@"Error!"];
        return NO;
    }

    if([endDate isEqualToString:@""] || endDate == NULL){
        message = @"End time cann't be empty";
        [self showAlertWithMessage:message title:@"Error!"];
        return NO;
    }
    //to check the start Date < ent date
    if (![self validateStartAndEndDate:_startDateTextFiled.text andEndDate:_endDateTextFiled.text]) {
        return NO;
    }
    return YES;
}

-(BOOL)validateStartAndEndTime:(NSString*)startDateTime andEndTime:(NSString*)endDateTime{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm"]; //24hr time format
    NSDate *sTime = [outputFormatter dateFromString:startDateTime];
    NSDate *eTime = [outputFormatter dateFromString:endDateTime];

    if( [sTime compare:eTime]==NSOrderedDescending ){
        [self showAlertWithMessage:@"Start time cann't be gretter than End time" title:@"Error!"];
        return NO;
    }

    if( [sTime compare:eTime]==NSOrderedSame){
        [self showAlertWithMessage:@"Start time cann't be same as End time" title:@"Error!"];
        return NO;
    }
    if( [sTime compare:eTime]==NSOrderedAscending ){
        return YES;
    }
    return NO;
}
-(BOOL)validateStartAndEndDate:(NSString*)startingDate andEndDate:(NSString*)endingDate{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *sTime = [outputFormatter dateFromString:startingDate];
    NSDate *eTime = [outputFormatter dateFromString:endingDate];

    if( [sTime compare:eTime]==NSOrderedDescending ){
        [self showAlertWithMessage:@"Start date cann't be gretter than End date" title:@"Error!"];
        return NO;
    }

    if( [sTime compare:eTime]==NSOrderedSame){
        [self showAlertWithMessage:@"Start date cann't be same as End date" title:@"Error!"];
        return NO;
    }
    if( [sTime compare:eTime]==NSOrderedAscending ){
        return YES;
    }
    return NO;
}
-(void)showAlertWithMessage:(NSString*)message title:(NSString*)title{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:okayAction];
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
