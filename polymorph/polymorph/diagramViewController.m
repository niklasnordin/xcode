//
//  diagramViewController.m
//  polymorph
//
//  Created by Niklas Nordin on 2012-07-25.
//  Copyright (c) 2012 nequam. All rights reserved.
//

#import "diagramViewController.h"
#import "diagramView.h"

@interface diagramViewController ()
@end

@implementation diagramViewController

- (IBAction)generateTable:(id)sender
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            // ask for number of points
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter number of points" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter", nil];
            
            alert.delegate = self;
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            UITextField *tf = [alert textFieldAtIndex:0];
            tf.delegate = self;
            [tf setClearButtonMode:UITextFieldViewModeWhileEditing];
            [tf setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            tf.text = @"10";
            
            [alert show];

        }
        else
        {
            // error
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't send mail" message:@"device does not support email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        // error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't send mail" message:@"device does not support email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

}

-(void)setup:(id <functionValue>)f
        dict:(NSDictionary *)dict
         min:(double)Tmin
         max:(double)Tmax
         cpv:(double)cpv
{
    [self setFunction:f];
    _dict = dict;
    _xMin = Tmin;
    _xMax = Tmax;
    _cpv = cpv;
}

-(void) setDview:(diagramView *)dview
{
    // this is used before viewDidLoad
    //NSLog(@"setDview");
    
    _dview = dview;
    [_dview addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.dview action:@selector(pan:)]];
    [_dview addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.dview action:@selector(pinch:)]];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.dview action:@selector(tap:)];
    tapRecognizer.numberOfTapsRequired = 2;
    [_dview addGestureRecognizer:tapRecognizer];
    
    [_dview setFunction:_function];
    [_dview setDict:_dict];
    [_dview setCpv:_cpv];
    [_dview setXIsT:_xIsT];
    [_dview setup:self.xMin max:self.xMax];
}

- (void)viewDidLoad
{
    //NSLog(@"view did load");
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    int n = [_function nCoefficients];
    NSArray *coeffDictArray = [self.dict objectForKey:@"coefficients"];
    NSMutableArray *cs = [[NSMutableArray alloc] init];
    
    for (int i=0; i<n; i++)
    {
        NSDictionary *Adict = [coeffDictArray objectAtIndex:i];
        NSString *name = [NSString stringWithFormat:@"A%d",i];
        NSNumber *a = [Adict objectForKey:name];
        [cs addObject:a];
    }
    
    _coeffs = cs;

}

- (void)viewDidUnload
{
    [self setDview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        
        NSMutableString *output = [[NSMutableString alloc] init];
        int nPoints = [[[alertView textFieldAtIndex:0] text] intValue];
        for (int i=0; i<nPoints; i++)
        {
            double x = _dview.xMin + (_dview.xMax -_dview.xMin)*i/(nPoints-1.0);
            double y = 0.0;
            if (_xIsT)
            {
                y = [_function value:_coeffs T:x p:_cpv];
            }
            else
            {
                y = [_function value:_coeffs T:_cpv p:x];

            }
            output = [NSMutableString stringWithFormat:@"%@%g %g\n", output, x,y];
        }
        
        NSString *filename = [NSString stringWithFormat:@"%@-%@.dat",_specie,_property];
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        NSData *att = [output dataUsingEncoding:[NSString defaultCStringEncoding]];
        //NSString *msg = [NSString stringWithFormat:@"%@",output];
        NSString *msg = @"Sent from propertyView";
        [mailer addAttachmentData:att mimeType:@"text/plain" fileName:filename];
        [mailer setMessageBody:msg isHTML:NO];
        [mailer setSubject:filename];

        [self presentModalViewController:mailer animated:YES];
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result
                       error:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
