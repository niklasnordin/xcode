//
//  thermoViewViewController.m
//  screetch
//
//  Created by Niklas Nordin on 2012-10-23.
//  Copyright (c) 2012 Niklas Nordin. All rights reserved.
//

#import "screetchViewController.h"

@interface screetchViewController ()
@property (strong, nonatomic) NSString *baseURL;
@end

@implementation screetchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _pictureView.delegate = self;
    
    _baseURL = @"http://www.nequam.se/screetch";
    NSString *http = @"categories.php";
    [self loadRandomPictureFromURL:http];
    _pictureView.bgImage = _loadedImage;
    _pictureView.bgImageRef = _loadedImage.CGImage;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)choiceButtonPressed:(UIButton *)sender
{
    [_pictureView clearAndAnimatePicture];
    usleep(5000);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You selected R" message:@"correct?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter", nil];
    
    alert.delegate = self;
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    //[alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    /*
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.delegate = self;
    [tf setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tf setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    //tf.text = [[NSString alloc] initWithFormat:@"%@", num];
    */
    [alert show];
    
}

-(void)setDisplayWithText:(NSString *)text
{
    _display.text = text;
}

-(void)setScoreWithInt:(int)score
{
    _scoreField.text = [[NSString alloc] initWithFormat:@"%d",score];
}

-(void)loadRandomPictureFromURL:(NSString *)name
{
    // structure of the pictures
    // toplevel
    // -- screetch/
    // ---- categories/
    // ------ selections/
    // -------- version/
    // ---------- picture.png
    // ---------- picture.info
    
    NSString *http = [NSString stringWithFormat:@"%@/%@",_baseURL,name];
    NSURL *url = [NSURL URLWithString:http];

    NSData *data = [NSData dataWithContentsOfURL:url];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *categories = [str componentsSeparatedByString:@":"];
    
    int categoryi = arc4random() % [categories count];
    categoryi = 1;
    NSString *categoryName = [categories objectAtIndex:categoryi];
    NSLog(@"category = %@",categoryName);
    
    NSString *catHttp = [NSString stringWithFormat:@"%@/%@/files.php",_baseURL,categoryName];
    NSURL *catURL = [NSURL URLWithString:catHttp];
    NSData *catData = [NSData dataWithContentsOfURL:catURL];
    NSString *stringForSelectedCategory = [[NSString alloc] initWithData:catData encoding:NSUTF8StringEncoding];
    NSArray *selections= [stringForSelectedCategory componentsSeparatedByString:@":"];


    int selectioni = arc4random() % [selections count];
    selectioni = 2;
    NSString *selectedName = [selections objectAtIndex:selectioni];
    NSLog(@"selected = %@",selectedName);
    
    NSString *selectedHttp = [NSString stringWithFormat:@"%@/%@/%@/files.php",_baseURL,categoryName,selectedName];

    NSURL *selectedURL = [NSURL URLWithString:selectedHttp];
    NSData *selectedData = [NSData dataWithContentsOfURL:selectedURL];
    NSString *stringSelected = [[NSString alloc] initWithData:selectedData encoding:NSUTF8StringEncoding];
    NSArray *selectedArray = [stringSelected componentsSeparatedByString:@":"];
    NSLog(@"selectedArray =%@",selectedArray);
    int versioni = arc4random() % [selectedArray count];
    NSString *version = [selectedArray objectAtIndex:versioni];
    NSLog(@"version = %@",version);
    
    
    // the name of the picture is picture.png
    NSString *imageFilename = [NSString stringWithFormat:@"%@/%@/%@/%@/picture.png",_baseURL,categoryName,selectedName,version];
    NSURL *imageURL = [NSURL URLWithString:imageFilename];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    _loadedImage = [UIImage imageWithData:imageData];
    
    // the geometry info for the picture is in the file picture.info
    

}
@end
