//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Lindsay Silk on 12-07-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain* brain;
@end

@implementation CalculatorViewController

@synthesize display;
@synthesize displayHistory;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain*)brain
{
    if(!_brain){
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (IBAction)digitPressed:(id)sender 
{
    NSString *digit = [sender currentTitle];
    if( self.userIsInTheMiddleOfEnteringANumber ){
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed 
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
    if( [self.displayHistory.text isEqualToString:@""]){
        self.displayHistory.text = self.display.text;        
    }
    else {
        self.displayHistory.text = [[self.displayHistory.text stringByAppendingString:@" "] stringByAppendingString:self.display.text];
    }

}

- (IBAction)operationPressed:(id)sender 
{
    if(self.userIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    self.displayHistory.text = [self.displayHistory.text stringByAppendingFormat:@" %@", operation];

}

- (IBAction)decimalPressed:(id)sender {
    NSString *decimal = [sender currentTitle];
    NSRange range = [self.display.text rangeOfString:@"."];
    if( range.location == NSNotFound ){
        self.display.text = [self.display.text stringByAppendingFormat:decimal];
    }
    if( !self.userIsInTheMiddleOfEnteringANumber ){
        self.display.text = decimal;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)clearPressed 
{
    [self.brain clearCalculator];
    self.display.text = @"0";
    self.displayHistory.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)backspacePressed {
    if( self.userIsInTheMiddleOfEnteringANumber && self.display.text.length > 1){
        self.display.text = [self.display.text substringToIndex:self.display.text.length-1];
    }
    else {
        self.display.text=@"0";
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }
}

- (IBAction)plusminusPressed:(id)sender {
    NSString *minus = @"-";
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if ( [self.display.text hasPrefix: minus]){
            self.display.text = [self.display.text substringFromIndex:1]; 
        }
        
        else {
            self.display.text = [minus stringByAppendingString:self.display.text];
        }
    }
    else {
        double result = [self.brain performOperation:@"+-"];
        self.display.text = [NSString stringWithFormat:@"%g", result];
        self.displayHistory.text = [[self.displayHistory.text stringByAppendingString:@" "] stringByAppendingString:self.display.text] ;
    }

}
@end
