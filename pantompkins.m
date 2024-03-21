%%Pan Tompkins Function
function [QRS_Table] = pantompkins(ecgfilename,fs,dt)
    data = readtable(ecgfilename);
    secondcoldata = data{:,2};
    n = length(secondcoldata);    % get no. of samples

    %T = n*dt ; %sampling window in seconds
    t=(1:n)/250;        % time sampling vector
    x = secondcoldata / 1;      % scaled to mV
    rng('default');     % seed random number generator for repeatability

    %Plot the original signal
    figure (1);
    plot(t,x);
    xlim([0,30])  
    xlabel('Time [sec]');
    ylabel('Signal [mV]');
    title('ECG original');

    % Looking in frequency domain
    x_f = fftshift(fft(x));
    df = 1/(n*dt); % frequency resolution
    f = ((1:n)-1-n/2)*df;
    figure(2)
    plot(f,abs(x_f)); %set(gca,'yscale','log')
    xlim([-fs/2,fs/2]) % plot up to Nyquist
    xlabel('freq, Hz');
    ylabel('Magnitude of FFT Coeffifients [mV]');
    title('Frequency domain of unfiltered signal')


%% Start of Pan-Tompkins 

    %Band Pass Filter 

    %- may need to adjust butterworth
    [b,a] = butter(3, [5 15]/(fs/2), 'bandpass'); % nth order Butterworth band-pass filter
    %adjust the order to get different results.
    filteredECG = filter(b, a, x);

    %filter made from filter designer- not as good as the above filter
    % filteredECG = filter(filter_1,x);
    %time plot
    figure(3) 
    subplot(2,2,1)
    plot(t,filteredECG)
    title('ECG Filtered')
    xlabel('Time [sec]');
    ylabel('Signal [mV]');
    xlim([0,2.5]); 
    ylim([-0.4,0.8]);
    subplot(2,2,2);
    plot(t,x);
    title('ECG Original')
    xlabel('Time [sec]');
    ylabel('Signal [mV]');
    xlim([0,2.5]); 
    ylim([-0.4,0.8]);
    %freq plot
    
    %Derivation
    b_derv = [1, 0 ,-1];
    diffECG = conv(filteredECG, b_derv,'same');
    % diffECG = diff(filteredECG);
    %time plot
    subplot(2,2,3);
    plot(t,filteredECG,t,diffECG);
    legend('Filtered ECG','Derivative');
    title('ECG After Derivation');
    xlabel('Time [sec]');
    ylabel('Signal [mV]');
    xlim([0,2.5]); 
    ylim([-0.4,0.8]);
    %freq plot
    
    %Squaring
    squaredECG = diffECG.^2;
    %time plot
    subplot(2,2,4);
    plot(squaredECG);
    title('Squared Signal')
    xlim([0 5000]);

    %freq plot- to be added 
    
    %% Average and threshold
    %moving window
    b_int = ones(1,round(0.06*fs));  % to get 30 sample windows (started with 150msinstread of 0.06)
    integratedECG = conv(squaredECG,b_int,'same');
    
    
    %time plot
    figure(4)
    plot(t,integratedECG);
    title('Integrated ECG Signal');
    xlabel('Time [sec]');
    ylabel('Amplitude');
    xlim([0, 2.5]);
    
    %freq plot
    %% threshold- Need to work on here down
    
    figure(2)
    % thr = 8e5;
    thr = 0.025;
    x_thr = integratedECG > thr; %Grabbing values above threshhold
    plot(t,x,'linewidth',1);
    hold on
    % plot(t,100*x_thr, 'linewidth',3)
    plot(t,x_thr,'linewidth',2)
    hold off;
    xlim([0,2.5])
    title('Threshold shown');
    
    
    
    %% locate rising edge of thresholded signal - not sure if this plot helps
    x_thr_d = conv(x_thr,[1,-1],'same') > 0;
    figure (6)
    stem(x_thr_d)
    title('Showing rising edge of threshhold signal')
    %% plot together
    figure(8)
    plot(t,x);
    hold on;
    plot(t,x_thr_d,'linewidth',2)
    
    % plot(t,200*x_thr_d,'linewidth',2)
    hold off;
    xlim([0,4])
    title('Marking the QRS complex locations');
    %time plot
    %freq plot
    
    %Heart rate calculation- from first two peaks
    [~,locs] = findpeaks(x,'MinPeakHeight',0.6);
    heart_rate_BPM = 60/(t(locs(2))-t(locs(1)));
    %Heart rate from average
    Avg = 0;
    for i = 1:length(locs)-1
        Avg = Avg + sum(t(locs(i+1))-t(locs(i)))/length(locs);
    end
    HR_AVG = 60/Avg;
    
    %% Prelim dianosis based on features and report
    % Looking for Ventricular fibrillation
    %If HR >200 then Vectricular fibrillation
    if HR_AVG > 200
        disp('This patient was experiencing Ventricular fibrillation')
    % If HR> 100 then Tachycardia
    elseif HR_AVG < 60
        disp('This patient may have Bradycardia');
    % If HR<60 then Bradycardia
    elseif HR_AVG > 100 && HR_AVG < 200
        disp('This patient may have Tachycardia');
    else
        disp('The average heart rate did not flag for Bradycaria or Tachycardia or Ventricular fibrillation');
    end

    % QRS Detection
    [~, qrs_locs] = findpeaks(integratedECG, 'MinPeakHeight', thr, 'MinPeakDistance', round(0.2*fs)); %fill in if qrs peaks are needed
    %figure %to check the QRS peaks were found
    %findpeaks(integratedECG, 'MinPeakHeight', thr, 'MinPeakDistance', round(0.2*fs));
    % Calculating RR intervals
    RR_intervals = diff(qrs_locs) / fs; % Convert indices to time in seconds
    
    % Checking for second degree AV block, If R-R is much longer than the avg
    % then there is suspision for 2nd AV block
    %average R-R
    Avg_RR = mean(RR_intervals);
    second_degree_AV_block = any(RR_intervals > Avg_RR * 1.40); % Threshold is randomly picked, may need adjustment
    % Flagging for Second degree AV block
    if second_degree_AV_block ~= 0
        disp('A potential second degree AV block was detected');
    else
        disp('No second degree AV block was detected');
      
    end
    
    %Detecting first degree AV block
    % This is done by using p wave detection
    % add in code for p wave detection
    
    %complete heart block Asystole
    % Look for an absence of QRS for a significant duration, which might indicate Asystole or Complete Heart Block.
    %threshold is arbitruary and will need to be adjusted for accuracy
    asystole_threshold = 1.5; % seconds without a QRS complex
    complete_heart_block = any(RR_intervals > asystole_threshold);
    if complete_heart_block ~=0
        disp('Potential Asystole Detected');
    else
        disp("No Asystole Detected");
      
    end
    % %Classifying the data into a nice table
    % Convert from indices to time
    qrs_times = qrs_locs/ fs;
    %Get amplitudes of peaks
    qrs_amplitudes = x(qrs_locs);
     % Initialize column for marking irregular QRS complexes
    qrs_irregular = zeros(length(qrs_locs), 1);
    R2R = zeros(length(qrs_locs),1);
    % calculate individual heart rates or r-r times
    for i = 1:length(qrs_times)-1
        current_hr = 60 /(qrs_times(i+1)-qrs_times(i));
        R2R(i) = qrs_times(i+1)-qrs_times(i);
        if R2R(i) < 0.45
            qrs_irregular(i) = 1; %Marks for Ventricular fribrilation
        else
            qrs_irregular(i) = 0;
        end
    end
    % % Create a table with the required columns
    QRS_Table = table(qrs_times(1:end-1), qrs_amplitudes(1:end-1), qrs_irregular(1:end-1),R2R(1:end-1),...
                       'VariableNames', {'TimeOfRPeak', 'AmplitudeOfPeak', 'IsIrregular','R-R Interval'});
end


