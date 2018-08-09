% CONVERGENCE WITHIN TRIAL
clear
close all

paths={...
    'C:\Users\bnapp\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub0Mirc1Full0Ref0_rec Yes.mat',...
    'C:\Users\bnapp\Documents\MIRCs_exp\data\processedData\OnlyFirst1_Sub0Mirc1Full0Ref0_rec No.mat',...
    };

currcolor={'b','c'};
numOfSubjects=0;

for group=1:length(paths)
    load(paths{group});
    curr_drifts_vel_deg2sec_1{group}=[];
    curr_drifts_vel_deg2sec_2{group}=[];
    meansPerRank{group}=zeros(1,20);
    for i=1:length(drifts_vel_deg2sec)
        curr_drifts_vel_deg2sec_1{group}=[curr_drifts_vel_deg2sec_1{group} drifts_vel_deg2sec{1,i}(1,1:floor(length(drifts_vel_deg2sec{1,i})/2))];
        curr_drifts_vel_deg2sec_2{group}=[curr_drifts_vel_deg2sec_2{group} drifts_vel_deg2sec{1,i}(1,floor(length(drifts_vel_deg2sec{1,i})/2)+1:end)];
        %         curr_drifts_vel_deg2sec_1{group}=[curr_drifts_vel_deg2sec_1{group} drifts_vel_deg2sec{1,i}(1,1)];
        %         curr_drifts_vel_deg2sec_2{group}=[curr_drifts_vel_deg2sec_2{group} drifts_vel_deg2sec{1,i}(1,2:end)];
        meansPerRank{group}=[meansPerRank{group} ; [drifts_vel_deg2sec{1,i}(drifts_vel_deg2sec{1,i}~=0) zeros(1,20-length(drifts_vel_deg2sec{1,i}(drifts_vel_deg2sec{1,i}~=0)))]];
        %         figure(group+10)
        %         hold all
        %         plot(drifts_vel_deg2sec{1,i}(drifts_vel_deg2sec{1,i}~=0))
    end
    figure(group)
    hold on
    currmean1=mean(curr_drifts_vel_deg2sec_1{group}(curr_drifts_vel_deg2sec_1{group}~=0));
    h1=histogram(curr_drifts_vel_deg2sec_1{group},0:0.25:30,'Normalization','probability','FaceColor',currcolor{1});
    plot(currmean1,0.2,'*','Color',currcolor{1})
    currmean2=mean(curr_drifts_vel_deg2sec_2{group}(curr_drifts_vel_deg2sec_2{group}~=0));
    h2=histogram(curr_drifts_vel_deg2sec_2{group},0:0.25:30,'Normalization','probability','FaceColor',currcolor{2});
    plot(currmean2,0.2,'*','Color',currcolor{2})
    legend('','first half','','second half')
    [s12,t12]=ttest2(curr_drifts_vel_deg2sec_1{group}(curr_drifts_vel_deg2sec_1{group}~=0),curr_drifts_vel_deg2sec_2{group}(curr_drifts_vel_deg2sec_2{group}~=0))
    
    for d=1:size(meansPerRank{group},1)
        currd=meansPerRank{group}(d,:);
        numberOfDrift(d)=length(currd(currd~=0));
    end
    avNumofD=mean(numberOfDrift);
    steNumofD=ste(numberOfDrift);
    for r=1:20
        currCol=meansPerRank{group}(:,r);
        if length(currCol(currCol~=0))> 0.1*length(currCol)
        relmeans(r)=mean(currCol(currCol~=0));
        relstes(r)=ste(currCol(currCol~=0));
        end
    end
    figure(group+20)
    hold all
    plot([avNumofD-steNumofD avNumofD+steNumofD],[5.5 5.5],'m')
    plot(relmeans,'.b')
    errorbar(relmeans,relstes,'b')
    plot(ones(1,2).*avNumofD-steNumofD,[5.4 5.6],'m')
    plot(ones(1,2).*avNumofD+steNumofD,[5.4 5.6],'m')
    axis([0 10 3 6])
    legi={'Number of Drift per trial (STE)'};
    legend(legi,'Fontsize',12)
    if group==1
    title('Drift velocities (MIRCs recognaized images)','Fontsize',20)
    else
        title('Drift velocities (MIRCs not-recognaized images)','Fontsize',20)
    end
    xlabel('rank','Fontsize',18)
    ylabel('velocity [deg/sec]','Fontsize',18)
end
tilefigs;