//
//  ADBViewController.m
//  bacetto
//
//  Created by Alberto De Bortoli on 04/01/2014.
//  Copyright (c) 2014 Alberto De Bortoli. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "ADBViewController.h"
#import "UIEffectDesignerView.h"

@interface ADBViewController ()

@property (nonatomic, weak) IBOutlet UIButton *puppetButton;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation ADBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.puppetButton setImage:[UIImage imageNamed:@"puppet_normal.png"] forState:UIControlStateNormal];
    [self.puppetButton setImage:[UIImage imageNamed:@"puppet_pressed.png"] forState:UIControlStateHighlighted];
}

- (void)performHeartsEmissionInMainViewAtPoint:(CGPoint)point
{
    UIEffectDesignerView *effectView = [UIEffectDesignerView effectWithFile:@"hearts.ped"];
    
    CGRect frame = effectView.frame;
    frame.origin = point;
    frame.origin.x -= (frame.size.width / 2);
    frame.origin.y -= (frame.size.height / 2);
    effectView.frame = frame;
    
    [effectView setAlpha:0.0f];
    [self.view addSubview:effectView];
    [UIView animateWithDuration:0.6f animations:^{
        [effectView setAlpha:1.0f];
    }];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:1.0 animations:^{
            [effectView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [effectView removeFromSuperview];
        }];
    });
}

- (void)playBacettoAudio
{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bacetto" ofType:@"mp3"]];
	
	NSError *error;
	self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	self.audioPlayer.numberOfLoops = 0;
	
	if (self.audioPlayer == nil) {
		NSLog(@"%@", [error description]);
    }
	else {
		[self.audioPlayer play];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)puppetPressed:(UIButton *)sender forEvent:(UIEvent *)event
{
    NSSet *touches = [event touchesForView:sender];
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    [self performHeartsEmissionInMainViewAtPoint:touchPoint];
    [self playBacettoAudio];
}

@end
