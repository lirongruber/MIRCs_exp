% xcorr comparison
for c=1:2
    figure(10)
    subplot(3,2,c)
    plot(nanmean(data_rel{1,c}))
    subplot(3,2,c+2)
    plot(nanmean(control_rel{1,c}))
    subplot(3,2,c+4)
    diff_xcorr{c}=nanmean(data_rel{1,c})-nanmean(control_rel{1,c});
    plot(diff_xcorr{1,c})
end


