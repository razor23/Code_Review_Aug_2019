%% Import txt data from Worder

clear all; clc; close all;

%% Parameters

InDir=('/Users/neuroscape/Desktop/CodingReview/Worder');
OutDir=('/Users/neuroscape/Desktop/CodingReview');
%Groups = {'Older', 'Younger'};
Subjects = 3 ; %7 8]; 


%% Load data
for s = 1:length(Subjects)
    infile = sprintf('%s/%d/*.txt',InDir,Subjects(s));
    files = dir(infile); %get info of all files in the directory
    for f= 1:length(files)
        fid = fopen(sprintf('%s/%d/%s',InDir,Subjects(s),files(f).name)); %you always want to get a +ve integer here
        fprintf(1,'Processing subject: %d, file %d\n',Subjects(s),f);
        while ~feof(fid) %returns 1 if EOF, returns 0 if not
            line = fgetl(fid); % gets the line and notices it's the EOF
            indx1 = strfind(line,' ');
            indx2 = strfind(line,'-');
            BHV{f}.Series = cell2mat(extractBetween(line,indx1+1,indx2(1)-1));
            BHV{f}.Level  = cell2mat(extractBetween(line,indx2(1)+1,indx2(2)-1));
            BHV{f}.Session = extractAfter(line,indx2(2));
            if BHV{f}.Series == 'X' %after Series 10 comes series X which I'm converting to 11
                BHV{f}.Series = '11'; %mvp line
            end
        end %while loop
        fclose(fid); %closes the file associated with fid
    end % files
     %% Save data
    save(sprintf('%s/Sub%d.mat',OutDir,Subjects(s)),'BHV');
    clear BHV
end % Subject

%% Plot Progression

figure;
for s = 1:length(Subjects)
    load(sprintf('%s/Sub%d.mat',OutDir,Subjects(s)));
    for d=1:length(BHV)
        Weighted(d) = (str2num(BHV{d}.Series))+ (str2num(BHV{d}.Level)/100) % Progression metric
        Sessno(d) = str2num(BHV{d}.Session) % Session No
         
    end
       
        subplot(8,2,s)
        plot(Sessno,Weighted)
        title (sprintf('Subject %d',Subjects(s)));
        axis ([1 d 1 11]) 
        xlabel('Session #')
        ylabel('Series+Level')
      
end