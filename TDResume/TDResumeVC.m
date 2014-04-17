//
//  TDViewController.m
//  TDResume
//
//  Created by Thomas Delgado on 4/11/14.
//  Copyright (c) 2014 Thomas Delgado. All rights reserved.
//

#import "TDResumeVC.h"
#import "TDSection.h"
#import "UIColor+HexString.h"
#import "TDTranslucentView.h"
#import "TDMe.h"
#import <MediaPlayer/MediaPlayer.h>

@interface TDResumeVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSInteger cellExpanded;
@property NSMutableArray *sections;
@property NSString *titleFont;
@property NSString *bodyFont;
@property NSString *italicFont;
@property TDMe *me;
@property MPMoviePlayerController *player;
@end

@implementation TDResumeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	self.cellExpanded = -1;
    self.sections = [TDSection loadSections];
    self.titleFont = @"HelveticaNeue-Light";
    self.bodyFont = @"HelveticaNeue-Thin";
    self.italicFont = @"HelveticaNeue-ThinItalic";
    self.me = [[TDMe alloc] init];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#38ec75"]];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDSection *section = self.sections[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self customizeCell:cell WithSection:section withIndexPath:indexPath];
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sections.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellExpanded == indexPath.row)
    {
        self.cellExpanded = -1;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:self.cellExpanded inSection:indexPath.section];
        self.cellExpanded = indexPath.row;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath, lastIndexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.cellExpanded)
        return [(TDSection*) self.sections[indexPath.row] height];
    else
        return 60;
        
}

#pragma mark customize cell
-(void) customizeCell:(UITableViewCell*)cell
          WithSection:(TDSection*) section
        withIndexPath:(NSIndexPath*) indexPath;
{
    UIView *titleView= (UIView*)[cell viewWithTag:2];
    UILabel *title = (UILabel*)[titleView viewWithTag:3];
    [title setText:section.name];
    [titleView setBackgroundColor:section.color];
    UIView *contentView = (UIView*)[cell viewWithTag:4];
    if (self.cellExpanded != indexPath.row)
        [contentView setHidden:YES];
    else
        [contentView setHidden:NO];
    [[contentView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //customizing acordingly with each section
    if ([section.name isEqualToString:@"About"])
    {
        UIImageView *backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile"]];
        [backImage setFrame:CGRectMake(0, 0, 320, 375)];
        [contentView addSubview:backImage];
        
        TDTranslucentView *tView = [[TDTranslucentView alloc] initWithFrame:CGRectMake(0, 0, 320, 375)];
        [tView setup];
        [contentView addSubview:tView];
        
        UIImageView *profileView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile"]];
        [profileView setFrame:CGRectMake(80, 10, 150, 150)];
        profileView.layer.cornerRadius = profileView.frame.size.width / 2;
        profileView.clipsToBounds = YES;
        [contentView addSubview:profileView];
        UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, 320, 30)];
        lblName.font = [UIFont fontWithName:self.titleFont size:17];
        lblName.textAlignment = NSTextAlignmentCenter;
        [lblName setText: self.me.info[@"name"]];
        [contentView addSubview:lblName];
        
        UILabel *lblAbout = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 60)];
        lblAbout.numberOfLines = 0;
        lblAbout.font = [UIFont fontWithName:self.italicFont size:14];
        lblAbout.textAlignment = NSTextAlignmentCenter;
        [lblAbout setText: self.me.info[@"about"]];
        [contentView addSubview:lblAbout];
        
        UILabel *lblSummary = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, 310, 100)];
        lblSummary.numberOfLines = 0;
        lblSummary.font = [UIFont fontWithName:self.bodyFont size:14];
        lblSummary.textAlignment = NSTextAlignmentJustified;
        [lblSummary setText:self.me.info[@"summary"]];
        [contentView addSubview:lblSummary];
    }
    else if ([section.name isEqualToString:@"Experience"])
    {
        NSArray* experiences = self.me.info[@"experiences"];
        NSInteger yPos = 0;
        NSString *labelStr = @"";
        for (NSDictionary *experience in experiences)
        {
            yPos = yPos + 15;
            UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, yPos, 305, 20)];
            lblTitle.numberOfLines = 0;
            lblTitle.font = [UIFont fontWithName:self.titleFont size:17];
            [lblTitle setTextColor:[UIColor grayColor]];
            [lblTitle setText:experience[@"job"]];
            [contentView addSubview:lblTitle];
            
            yPos = yPos + 20;
            UILabel *lblDuration = [[UILabel alloc] initWithFrame:CGRectMake(15, yPos, 305, 20)];
            lblDuration.numberOfLines = 0;
            lblDuration.font = [UIFont fontWithName:self.italicFont size:17];
            [lblDuration setText:experience[@"duration"]];
            [lblDuration sizeToFit];
            [lblDuration setTextColor:[UIColor darkGrayColor]];
            [contentView addSubview:lblDuration];
            
            yPos = yPos + lblDuration.frame.size.height+5;
            UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(15, yPos, 300, 20)];
            lblDescription.numberOfLines = 0;
            lblDescription.font = [UIFont fontWithName:self.bodyFont size:14];
            lblDescription.textAlignment = NSTextAlignmentJustified;
                        [lblDescription setTextColor:[UIColor darkGrayColor]];
            labelStr = experience[@"description"];
            labelStr = [labelStr stringByReplacingOccurrencesOfString:@"|" withString:@"\n"];
            [lblDescription setText:labelStr];
            [lblDescription sizeToFit];
            yPos = yPos + lblDescription.frame.size.height;
            [contentView addSubview:lblDescription];
        }
    }
    else if ([section.name isEqualToString:@"Education"])
    {
        NSArray* education = self.me.info[@"education"];
        NSInteger yPos = 0;
        NSString *labelStr = @"";
        for (NSDictionary *school in education)
        {
            yPos = yPos + 15;
            UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, yPos, 305, 20)];
            lblTitle.numberOfLines = 0;
            [lblTitle setText:school[@"school"]];
            lblTitle.font = [UIFont fontWithName:self.titleFont size:17];
            [lblTitle sizeToFit];
            [lblTitle setTextColor:[UIColor grayColor]];
            [contentView addSubview:lblTitle];
            
            yPos = yPos + lblTitle.frame.size.height;
            UILabel *lblDuration = [[UILabel alloc] initWithFrame:CGRectMake(15, yPos, 305, 20)];
            lblDuration.numberOfLines = 0;
            lblDuration.font = [UIFont fontWithName:self.italicFont size:14];
            [lblDuration setText:school[@"period"]];
            [lblDuration sizeToFit];
            [lblDuration setTextColor:[UIColor darkGrayColor]];
            [contentView addSubview:lblDuration];
            
            yPos = yPos + lblDuration.frame.size.height;
            UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(15, yPos, 300, 20)];
            lblDescription.numberOfLines = 0;
            lblDescription.font = [UIFont fontWithName:self.bodyFont size:14];
            lblDescription.textAlignment = NSTextAlignmentJustified;
            [lblDescription setTextColor:[UIColor darkGrayColor]];
            labelStr = school[@"info"];
            labelStr = [labelStr stringByReplacingOccurrencesOfString:@"|" withString:@"\n"];
            [lblDescription setText:labelStr];
            [lblDescription sizeToFit];
            yPos = yPos + lblDescription.frame.size.height;
            [contentView addSubview:lblDescription];
        }
    }
    else if ([section.name isEqualToString:@"Technical Skills"])
    {
        NSMutableArray* skills = self.me.info[@"technical skills"];
        NSInteger yPos = 10;
        for (NSString * skill in skills) {
            UILabel *lblSkill = [[UILabel alloc] initWithFrame:CGRectMake(15, yPos, 305, 60)];
            yPos = yPos + 50;
            lblSkill.numberOfLines = 0;
            lblSkill.font = [UIFont fontWithName:self.bodyFont size:17];
            [lblSkill setTextColor:[UIColor darkGrayColor]];
            [lblSkill setText:skill];
            [contentView addSubview:lblSkill];
        }
    }
    else if ([section.name isEqualToString:@"Projects & Publications"])
    {
        NSDictionary* publication = self.me.info[@"publication"];
        UIButton *btnTitle = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 305, 60)];
        [btnTitle setTitle:publication[@"title"] forState:UIControlStateNormal];
        [btnTitle.titleLabel setFont:[UIFont fontWithName:self.titleFont size:16]];
        btnTitle.titleLabel.numberOfLines = 0;
        [btnTitle.titleLabel sizeToFit];
        [btnTitle setTintColor:section.color];
        [btnTitle setTitleColor:section.color forState:UIControlStateNormal];
        [btnTitle addTarget:self
                     action:@selector(openArticle)
           forControlEvents:UIControlEventTouchDown];
        [contentView addSubview:btnTitle];
        
        UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(15, 60, 300, 80)];
        lblDescription.numberOfLines = 0;
        lblDescription.font = [UIFont fontWithName:self.bodyFont size:14];
        lblDescription.textAlignment = NSTextAlignmentJustified;
        [lblDescription setTextColor:[UIColor darkGrayColor]];
        [lblDescription setText:publication[@"summary"]];
        [contentView addSubview:lblDescription];

        UIButton *btnPost = [[UIButton alloc] initWithFrame:CGRectMake(12, 120, 125, 40)];
        [btnPost setTitle:@"Post about the event" forState:UIControlStateNormal];
        [btnPost.titleLabel setFont:[UIFont fontWithName:self.bodyFont size:14]];
        [btnPost.titleLabel sizeToFit];
        [btnPost setTintColor:section.color];
        [btnPost setTitleColor:section.color forState:UIControlStateNormal];
        [btnPost addTarget:self
                     action:@selector(openPost)
           forControlEvents:UIControlEventTouchDown];
        [contentView addSubview:btnPost];
        
        UILabel *lblVerona = [[UILabel alloc] initWithFrame:CGRectMake(15, 160, 305, 20)];
        [lblVerona setText:@"Verona"];
        lblVerona.font = [UIFont fontWithName:self.titleFont size:17];
        [lblVerona sizeToFit];
        [lblVerona setTextColor:[UIColor grayColor]];
        [contentView addSubview:lblVerona];
        
        UILabel *lblVeronaText = [[UILabel alloc] initWithFrame:CGRectMake(15, 170, 300, 80)];
        lblVeronaText.numberOfLines = 0;
        lblVeronaText.font = [UIFont fontWithName:self.bodyFont size:14];
        lblVeronaText.textAlignment = NSTextAlignmentJustified;
        [lblVeronaText setTextColor:[UIColor darkGrayColor]];
        [lblVeronaText setText:self.me.info[@"veronasummary"]];
        [contentView addSubview:lblVeronaText];

        UIButton *btnVideo = [[UIButton alloc] initWithFrame:CGRectMake(12, 230, 150, 40)];
        [btnVideo setTitle:@"App video demonstration" forState:UIControlStateNormal];
        [btnVideo.titleLabel setFont:[UIFont fontWithName:self.bodyFont size:14]];
        [btnVideo.titleLabel sizeToFit];
        [btnVideo setTintColor:section.color];
        [btnVideo setTitleColor:section.color forState:UIControlStateNormal];
        [btnVideo addTarget:self
                    action:@selector(playVideo)
          forControlEvents:UIControlEventTouchDown];
        [contentView addSubview:btnVideo];

        
        
    }
    else if ([section.name isEqualToString:@"Volunteer Experience"])
    {
        NSDictionary* volunteer = self.me.info[@"volunteer"];
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 305, 60)];
        lblTitle.numberOfLines = 0;
        lblTitle.font = [UIFont fontWithName:self.titleFont size:17];
        [lblTitle setText:volunteer[@"title"]];
        [lblTitle setTextColor:[UIColor darkGrayColor]];
        [contentView addSubview:lblTitle];
        
        UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, 305, 80)];
        lblDescription.numberOfLines = 0;
        lblDescription.font = [UIFont fontWithName:self.bodyFont size:17];
        lblDescription.textAlignment = NSTextAlignmentJustified;
        [lblDescription setTextColor:[UIColor darkGrayColor]];
        [lblDescription setText:volunteer[@"description"]];
        [contentView addSubview:lblDescription];
    }
    else if ([section.name isEqualToString:@"Contact Info"])
    {
        UIButton *btnEmail = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 280, 40)];
        [btnEmail setTitle:self.me.info[@"email"] forState:UIControlStateNormal];
        [btnEmail.titleLabel setFont:[UIFont fontWithName:self.titleFont size:17]];
        [btnEmail sizeToFit];
        [btnEmail setTintColor:section.color];
        [btnEmail setTitleColor:section.color forState:UIControlStateNormal];
        [btnEmail addTarget:self
                     action:@selector(emailMe)
           forControlEvents:UIControlEventTouchDown];
        [contentView addSubview:btnEmail];
        
        UIButton *btnPhone = [[UIButton alloc] initWithFrame:CGRectMake(20, 50, 200, 40)];
        [btnPhone setTitle:self.me.info[@"phone"] forState:UIControlStateNormal];
        [btnPhone.titleLabel setFont:[UIFont fontWithName:self.titleFont size:17]];
        [btnPhone sizeToFit];
        [btnPhone setTintColor:section.color];
        [btnPhone setTitleColor:section.color forState:UIControlStateNormal];
        [btnPhone addTarget:self
                     action:@selector(callMe)
           forControlEvents:UIControlEventTouchDown];
        [contentView addSubview:btnPhone];
        
        UIButton *btnLinkedin = [[UIButton alloc] initWithFrame:CGRectMake(20, 90, 280, 40)];
        [btnLinkedin setTitle:@"Linkedin" forState:UIControlStateNormal];
        [btnLinkedin.titleLabel setFont:[UIFont fontWithName:self.titleFont size:17]];
        [btnLinkedin sizeToFit];
        [btnLinkedin setTintColor:section.color];
        [btnLinkedin setTitleColor:section.color forState:UIControlStateNormal];
        [btnLinkedin addTarget:self
                        action:@selector(openLinkedin)
              forControlEvents:UIControlEventTouchDown];
        [contentView addSubview:btnLinkedin];
        
        UIButton *btnGit = [[UIButton alloc] initWithFrame:CGRectMake(20, 130, 280, 40)];
        [btnGit setTitle:@"GitHub" forState:UIControlStateNormal];
        [btnGit.titleLabel setFont:[UIFont fontWithName:self.titleFont size:17]];
        [btnGit sizeToFit];
        [btnGit setTintColor:section.color];
        [btnGit setTitleColor:section.color forState:UIControlStateNormal];
        [btnGit addTarget:self
                        action:@selector(openGithub)
              forControlEvents:UIControlEventTouchDown];
        [contentView addSubview:btnGit];
    }
    
    
}

-(void) emailMe
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@", self.me.info[@"email"]]]];
    
}

-(void) callMe
{
    NSString* phone = self.me.info[@"phone"];
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phone]]];
}

-(void) openLinkedin
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.me.info[@"linkedin"]]]];
}

-(void) openGithub
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.me.info[@"github"]]]];
}

-(void) openArticle
{
    NSDictionary* publication = self.me.info[@"publication"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", publication[@"articleurl"]]]];
}

-(void) openPost
{
    NSDictionary* publication = self.me.info[@"publication"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", publication[@"post"]]]];
}

-(void) playVideo
{
    NSString *video =[ [NSBundle mainBundle] pathForResource:@"verona_video" ofType:@"mov"];
    self.player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:video]];
    [self.view addSubview:self.player.view];
    self.player.fullscreen = YES;
}


@end
