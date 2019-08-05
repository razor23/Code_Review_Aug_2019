%% Import .csv data from Engage

clear all; clc; close all;

%% Parameters
InDir=('/Users/neuroscape/Desktop/CodingReview/Engage');
OutDir=('/Users/neuroscape/Desktop/CodingReview/Engage');
Subjects = 22 ; %7 8]; 
%Groups info

%% Load data
for s = 1:length(Subjects)
    infile = sprintf('%s/%d/*.csv',InDir,Subjects(s));
    inpath = sprintf('%s/%d',InDir,Subjects(s));
    cd (inpath)
    files = dir(infile);
    for f= 1:length(files)
        fid = fopen(sprintf('%s/%d/%s',InDir,Subjects(s),files(f).name));
        fprintf(1,'Processing subject: %d, file %d\n',Subjects(s),f);      
        data = readtable (files(f).name); %imports file with various header
        BHV{f}.misdtrials = find(data.RT<0)  
        BHV{f}.hits = find (~(data.RT<0))
        BHV{f}.difficultyindx = find (data.Difficulty >100)
    end
end