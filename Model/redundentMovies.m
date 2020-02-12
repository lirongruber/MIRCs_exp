%creating non-redundent movies

clear

movies_path='C:\Users\lirongr\Documents\MIRCs_exp\data\modelData\videos';
folders={'MIRCs_yes','MIRCs_no','subMIRCs_yes','subMIRCs_no'};

plotFlag=0;

class={};
class_num=0;
for folder=folders
    class_num=class_num+1;
    movies = dir([movies_path '\' folder{1,1}]);
    mov_nom=0;
    for currMov = movies'
        if ~strcmp(currMov.name,'.') && ~strcmp(currMov.name,'..')
            mov_nom=mov_nom+1;
            load([movies_path '\' folder{1,1} '\' currMov.name]);
            % make sure always similar to "features.m"
            %Reduces number of lines to avoid redundancy
            tic
            for fixation_num=1:size(filt_movie,2)
                L=size(filt_movie{2,fixation_num}(1):filt_movie{2,fixation_num}(2),2);
                temp=reshape(filt_movie{1,fixation_num},[402*402 L]);
                if mod(L,2)~=0
                    temp=temp(:,2:end);
                    L=L-1;
                end
                rel_movie_act=unique(temp, 'rows');
                
                rel_movie_act_MEAN=mean(rel_movie_act);
                r=zeros(1,size(rel_movie_act,1));
                p=zeros(1,size(rel_movie_act,1));
                if isempty(temp)
                    break
                end
                for i=1:size(temp,1)-1
                    [r(i),p(i)] = corr(rel_movie_act_MEAN',temp(i,:)');
                    if r(i)>0.5
                        temp(i,:)=rel_movie_act_MEAN;
%                         temp(i,:)=ones(size(temp(i,:)));
                    end
                end
                rel_act_notCorr=temp;
                rel_act_notCorr=rel_act_notCorr-rel_movie_act_MEAN;
                rel_movie_notCorr{1,fixation_num}=reshape(rel_act_notCorr,[402 402 L]);
            end
            toc
            name=[num2str(currMov.name(1:end-4)) '_r'];
            save([movies_path '\' folder{1,1} '\' name ], 'rel_movie_notCorr');
            if plotFlag==1
                figure('units','normalized','outerposition',[0 0 1 1])
                for i=1:size(rel_movie_notCorr,2)
                    for ii=1:size(rel_movie_notCorr{1,i},3)
                        imshow(rel_movie_notCorr{1,i}(:,:,ii)+1)
                        hold on
                        plot(201,201,'b*','MarkerSize',1)
                        hold off
                        pause(0.01)
                    end
                end
            end
        end
    end
end
 
