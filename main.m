clc, clear, close all;

segment_time = 4;     %4秒切一段

acc_hz = 50;
eda_hz = 4;
semg_hz = 200;
sampEn_m=3;
sampEn_n=0.2;
zero_cross_thres=0;

load_static_position = {};

save_static_position = {};

for i=1 : size(load_static_position, 2)
    
    load(load_static_position{i});

    Acc_x = partial_normal_signal.Acc_x;
    Acc_y = partial_normal_signal.Acc_y;
    Acc_z = partial_normal_signal.Acc_z;
    Semg = partial_normal_signal.Semg;
    Eda = partial_normal_signal.Eda;
 
    used_feature_name={};

    for p=1:size(used_feature_name,2)     %创建特征矩阵
        feature{1,p}=used_feature_name{1,p};
    end

    Acc = (Acc_x .* Acc_x + Acc_y .* Acc_y + Acc_z .* Acc_z) .^ 0.5;

    Gyr = (Gyr_x .* Gyr_x + Gyr_y .* Gyr_y + Gyr_z .* Gyr_z) .^ 0.5;
  
    %数据切断
    all_time = size(Acc,1) / 50;     %这里是计算，不同长度的癫痫发作数据可以切多少段数据
    q=0;
    while (q+1)*segment_time <= all_time
        q=q+1;
    end
    piece_number=2*q-1;
  
    for e=1:q
  
        feature{e+1, 1}=e;

        acc_segment(1 : segment_time * acc_hz, 1)=Acc((e-1) * acc_hz * segment_time + 1 : e * acc_hz * segment_time);     %数据切断
        semg_segment(1 : segment_time * semg_hz, 1) = Semg((e-1) * semg_hz * segment_time + 1 : e * semg_hz * segment_time);
        eda_segment(1 : segment_time * eda_hz, 1) = Eda((e-1) * eda_hz * segment_time + 1 : e * eda_hz * segment_time);
           
        if isnan(acc_segment(1)) 
            continue;
        end

        %特征提取
        %加速度信号特征提取
        acc_feature = timeDomainfeather(acc_segment);
        
        feature_index = find(ismember(used_feature_name, 'Acc max'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = acc_feature.max;
        end
        
        feature_index = find(ismember(used_feature_name, 'Acc min'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = acc_feature.min;
        end
        
        feature_index = find(ismember(used_feature_name, 'Acc peak'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = acc_feature.peak;
        end
            
        feature_index=find(ismember(used_feature_name, 'Acc p2p'));
        if size(feature_index ,2) == 1
            feature{e+1, feature_index} = acc_feature.p2p;
        end     
        
        feature_index = find(ismember(used_feature_name, 'Acc mean'));
        if size(feature_index,2) == 1
            feature{e+1, feature_index} = acc_feature.mean;
        end

        feature_index = find(ismember(used_feature_name, 'Acc averageAmplitude'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = acc_feature.averageAmplitude;
        end

        feature_index = find(ismember(used_feature_name, 'Acc rootAmplitude'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = acc_feature.rootAmplitude;
        end

        feature_index = find(ismember(used_feature_name, 'Acc var'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = acc_feature.var;
        end

        feature_index = find(ismember(used_feature_name, 'Acc std'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = acc_feature.std;
        end

        feature_index = find(ismember(used_feature_name, 'Acc rms'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = acc_feature.rms;
        end

        feature_index = find(ismember(used_feature_name, 'Acc kurtosis'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = acc_feature.kurtosis;
        end

        feature_index = find(ismember(used_feature_name, 'Acc skewness'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = acc_feature.skewness;
        end

        feature_index = find(ismember(used_feature_name, 'Acc shapeFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index}=acc_feature.shapeFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Acc peakingFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = acc_feature.peakingFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Acc pulseFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = acc_feature.pulseFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Acc marginFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = acc_feature.marginFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Acc clearanceFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = acc_feature.clearanceFactor;
        end
        
        acc_frequency_feature = frequencyDomainFeatures(acc_segment, acc_hz);
          
        feature_index = find(ismember(used_feature_name, 'Acc MSF'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = acc_frequency_feature.MSF;
        end

        feature_index = find(ismember(used_feature_name, 'Acc FC'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = acc_frequency_feature.FC;
        end

        feature_index = find(ismember(used_feature_name, 'Acc RMSF'));
        if size(feature_index,2) == 1
            feature{e+1, feature_index} = acc_frequency_feature.RMSF;
        end

        feature_index = find(ismember(used_feature_name, 'Acc RVF'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = acc_frequency_feature.RVF;
        end

        feature_index = find(ismember(used_feature_name, 'Acc MPSD'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = acc_frequency_feature.PSD;
        end

        acc_MF_feature = MF(acc_segment, acc_hz);
        
        feature_index = find(ismember(used_feature_name, 'Acc MF'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = acc_MF_feature;
        end          

        acc_sampleEn_feature = SampEn(acc_segment, sampEn_m, sampEn_n * acc_feature.std);

        feature_index = find(ismember(used_feature_name, 'Acc SampEn'));
        if size(feature_index,2)==1
            feature{e+1, feature_index} = acc_sampleEn_feature;
        end 

        acc_sampleMFMD_feature = MFMD(acc_segment);

        feature_index = find(ismember(used_feature_name, 'Acc MFMD'));
        if size(feature_index,2)==1
            feature{e+1, feature_index} = acc_sampleMFMD_feature;
        end 

        acc_FuzzyEn_feature = FuzzyEn(acc_segment, 2, 0.2 * acc_feature.std, 2);

        feature_index = find(ismember(used_feature_name, 'Acc FuzzyEn'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = acc_FuzzyEn_feature;
        end 

        acc_ApEn_feature = ApEn(2, 0.2 * acc_feature.std, acc_segment, 1);

        feature_index = find(ismember(used_feature_name, 'Acc ApEn'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = acc_ApEn_feature;
        end      

        %角速度特征提取            
        angular_velocity_feature = timeDomainfeather(angular_segment);

        feature_index = find(ismember(used_feature_name, 'Gyr max'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_feature.max;
        end

        feature_index = find(ismember(used_feature_name, 'Gyr min'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_feature.min;
        end

        feature_index = find(ismember(used_feature_name, 'Gyr peak'));
        if size(feature_index,2) == 1
            feature{e+1, feature_index} = angular_velocity_feature.peak;
        end

        feature_index = find(ismember(used_feature_name, 'Gyr p2p'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_feature.p2p;
        end

        feature_index = find(ismember(used_feature_name, 'Gyr mean'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_feature.mean;
        end

        feature_index = find(ismember(used_feature_name, 'Gyr averageAmplitude'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_feature.averageAmplitude;
        end

        feature_index = find(ismember(used_feature_name, 'Gyr rootAmplitude'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_feature.rootAmplitude;
        end

        feature_index = find(ismember(used_feature_name, 'Gyr var'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_feature.var;
        end

        feature_index = find(ismember(used_feature_name, 'Gyr std'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_feature.std;
        end

        feature_index = find(ismember(used_feature_name, 'Gyr rms'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_feature.rms;
        end

        feature_index = find(ismember(used_feature_name, 'Gyr kurtosis'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_feature.kurtosis;
        end

        feature_index = find(ismember(used_feature_name, 'Gyr skewness'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_feature.skewness;
        end

        feature_index = find(ismember(used_feature_name, 'Gyr shapeFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_feature.shapeFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Gyr peakingFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_feature.peakingFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Gyr pulseFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_feature.pulseFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Gyr marginFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_feature.marginFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Gyr clearanceFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_feature.clearanceFactor;
        end

        angular_velocity_feature_frequency_feature = frequencyDomainFeatures(angular_segment, acc_hz);

        feature_index = find(ismember(used_feature_name, 'Gyr MSF'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_feature_frequency_feature.MSF;
        end

        feature_index = find(ismember(used_feature_name, 'Gyr FC'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_feature_frequency_feature.FC;
        end

        feature_index = find(ismember(used_feature_name, 'Gyr RMSF'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_feature_frequency_feature.RMSF;
        end

        feature_index = find(ismember(used_feature_name, 'Gyr RVF'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_feature_frequency_feature.RVF;
        end

        feature_index = find(ismember(used_feature_name, 'Gyr MPSD'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_feature_frequency_feature.PSD;
        end
        
        angular_velocity_MF_feature = MF(angular_segment, acc_hz);

        feature_index = find(ismember(used_feature_name, 'Gyr MF'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_MF_feature;
        end          

        angular_velocity_sampleEn_feature = SampEn(angular_segment, sampEn_m, sampEn_n * angular_velocity_feature.std);

        feature_index = find(ismember(used_feature_name, 'Gyr SampEn'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_sampleEn_feature;
        end 

        angular_velocity_sampleMFMD_feature = MFMD(angular_segment);

        feature_index = find(ismember(used_feature_name, 'Gyr MFMD'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_sampleMFMD_feature;
        end 

        angular_velocity_FuzzyEn_feature = FuzzyEn(angular_segment, 2, 0.2 * angular_velocity_feature.std, 2);

        feature_index = find(ismember(used_feature_name, 'Gyr FuzzyEn'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_FuzzyEn_feature;
        end 

        angular_velocity_ApEn_feature = ApEn(2, 0.2 * angular_velocity_feature.std, angular_segment, 1);

        feature_index = find(ismember(used_feature_name, 'Gyr ApEn'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = angular_velocity_ApEn_feature;
        end      
        
        %倾斜角特征提取
        pitch_angle_feature=timeDomainfeather(pitch_segment);

        feature_index = find(ismember(used_feature_name, 'Pitch max'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_feature.max;
        end

        feature_index=find(ismember(used_feature_name, 'Pitch min'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_feature.min;
        end

        feature_index = find(ismember(used_feature_name, 'Pitch peak'));
        if size(feature_index,2) == 1
            feature{e+1, feature_index} = pitch_angle_feature.peak;
        end

        feature_index = find(ismember(used_feature_name, 'Pitch p2p'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_feature.p2p;
        end

        feature_index = find(ismember(used_feature_name, 'Pitch mean'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_feature.mean;
        end

        feature_index = find(ismember(used_feature_name, 'Pitch averageAmplitude'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_feature.averageAmplitude;
        end

        feature_index = find(ismember(used_feature_name, 'Pitch rootAmplitude'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_feature.rootAmplitude;
        end

        feature_index = find(ismember(used_feature_name, 'Pitch var'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_feature.var;
        end

        feature_index = find(ismember(used_feature_name, 'Pitch std'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_feature.std;
        end

        feature_index = find(ismember(used_feature_name, 'Pitch rms'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_feature.rms;
        end

        feature_index = find(ismember(used_feature_name, 'Pitch kurtosis'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_feature.kurtosis;
        end

        feature_index = find(ismember(used_feature_name, 'Pitch skewness'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_feature.skewness;
        end

        feature_index = find(ismember(used_feature_name, 'Pitch shapeFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_feature.shapeFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Pitch peakingFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_feature.peakingFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Pitch pulseFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_feature.pulseFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Pitch marginFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_feature.marginFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Pitch clearanceFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_feature.clearanceFactor;
        end

        pitch_angle_feature_frequency_feature = frequencyDomainFeatures(pitch_segment, acc_hz);

        feature_index = find(ismember(used_feature_name, 'Pitch MSF'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_feature_frequency_feature.MSF;
        end

        feature_index = find(ismember(used_feature_name, 'Pitch FC'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_feature_frequency_feature.FC;
        end

        feature_index = find(ismember(used_feature_name, 'Pitch RMSF'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_feature_frequency_feature.RMSF;
        end

        feature_index = find(ismember(used_feature_name, 'Pitch RVF'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_feature_frequency_feature.RVF;
        end

        feature_index = find(ismember(used_feature_name, 'Pitch MPSD'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_feature_frequency_feature.PSD;
        end

        pitch_angle_MF_feature = MF(pitch_segment, acc_hz);

        feature_index = find(ismember(used_feature_name, 'Pitch MF'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_MF_feature;
        end          

        pitch_angle_sampleEn_feature = SampEn(pitch_segment, sampEn_m, sampEn_n * pitch_angle_feature.std);

        feature_index = find(ismember(used_feature_name, 'Pitch SampEn'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_sampleEn_feature;
        end 

        pitch_angle_sampleMFMD_feature = MFMD(pitch_segment);

        feature_index = find(ismember(used_feature_name, 'Pitch MFMD'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_sampleMFMD_feature;
        end 

        pitch_angle_FuzzyEn_feature = FuzzyEn(pitch_segment, 2, 0.2 * pitch_angle_feature.std, 2);

        feature_index = find(ismember(used_feature_name, 'Pitch FuzzyEn'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_FuzzyEn_feature;
        end 

        pitch_angle_ApEn_feature = ApEn(2, 0.2 * pitch_angle_feature.std, pitch_segment, 1);

        feature_index = find(ismember(used_feature_name, 'Pitch ApEn'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = pitch_angle_ApEn_feature;
        end      

        %翻滚角特征提取
        roll_angle_feature=timeDomainfeather(roll_segment);

        feature_index=find(ismember(used_feature_name, 'Roll max'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_feature.max;
        end

        feature_index = find(ismember(used_feature_name, 'Roll min'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_feature.min;
        end

        feature_index = find(ismember(used_feature_name, 'Roll peak'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_feature.peak;
        end

        feature_index = find(ismember(used_feature_name, 'Roll p2p'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_feature.p2p;
        end

        feature_index = find(ismember(used_feature_name, 'Roll mean'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_feature.mean;
        end

        feature_index = find(ismember(used_feature_name, 'Roll averageAmplitude'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_feature.averageAmplitude;
        end

        feature_index = find(ismember(used_feature_name, 'Roll rootAmplitude'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_feature.rootAmplitude;
        end

        feature_index = find(ismember(used_feature_name, 'Roll var'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_feature.var;
        end

        feature_index = find(ismember(used_feature_name, 'Roll std'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_feature.std;
        end

        feature_index = find(ismember(used_feature_name, 'Roll rms'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_feature.rms;
        end

        feature_index = find(ismember(used_feature_name, 'Roll kurtosis'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_feature.kurtosis;
        end

        feature_index = find(ismember(used_feature_name, 'Roll skewness'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_feature.skewness;
        end

        feature_index = find(ismember(used_feature_name, 'Roll shapeFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_feature.shapeFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Roll peakingFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_feature.peakingFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Roll pulseFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_feature.pulseFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Roll marginFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_feature.marginFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Roll clearanceFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_feature.clearanceFactor;
        end

        roll_angle_feature_frequency_feature = frequencyDomainFeatures(roll_segment, acc_hz);

        feature_index = find(ismember(used_feature_name, 'Roll MSF'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_feature_frequency_feature.MSF;
        end

        feature_index = find(ismember(used_feature_name, 'Roll FC'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_feature_frequency_feature.FC;
        end

        feature_index = find(ismember(used_feature_name, 'Roll RMSF'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_feature_frequency_feature.RMSF;
        end

        feature_index = find(ismember(used_feature_name, 'Roll RVF'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_feature_frequency_feature.RVF;
        end

        feature_index = find(ismember(used_feature_name, 'Roll MPSD'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_feature_frequency_feature.PSD;
        end

        roll_angle_MF_feature = MF(roll_segment, acc_hz);

        feature_index = find(ismember(used_feature_name, 'Roll MF'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_MF_feature;
        end          
 
        roll_angle_sampleEn_feature = SampEn(roll_segment, sampEn_m, sampEn_n * roll_angle_feature.std);

        feature_index = find(ismember(used_feature_name, 'Roll SampEn'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_sampleEn_feature;
        end 

        roll_angle_sampleMFMD_feature = MFMD(roll_segment);

        feature_index = find(ismember(used_feature_name, 'Roll MFMD'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_sampleMFMD_feature;
        end 

        roll_angle_FuzzyEn_feature = FuzzyEn(roll_segment, 2, 0.2 * roll_angle_feature.std, 2);

        feature_index = find(ismember(used_feature_name, 'Roll FuzzyEn'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_FuzzyEn_feature;
        end 

        roll_angle_ApEn_feature = ApEn(2, 0.2 * roll_angle_feature.std, roll_segment, 1);

        feature_index = find(ismember(used_feature_name, 'Roll ApEn'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = roll_angle_ApEn_feature;
        end      
        
        %肌电信号特征提取
        semg_feature = timeDomainfeather(semg_segment);

        feature_index = find(ismember(used_feature_name, 'Semg max'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_feature.max;
        end

        feature_index = find(ismember(used_feature_name, 'Semg min'));
        if size(feature_index,2) == 1
            feature{e+1,feature_index} = semg_feature.min;
        end

        feature_index = find(ismember(used_feature_name, 'Semg peak'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_feature.peak;
        end

        feature_index = find(ismember(used_feature_name, 'Semg p2p'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_feature.p2p;
        end

        feature_index = find(ismember(used_feature_name, 'Semg mean'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_feature.mean;
        end

        feature_index = find(ismember(used_feature_name, 'Semg averageAmplitude'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_feature.averageAmplitude;
        end

        feature_index = find(ismember(used_feature_name, 'Semg rootAmplitude'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_feature.rootAmplitude;
        end

        feature_index = find(ismember(used_feature_name, 'Semg var'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_feature.var;
        end

        feature_index = find(ismember(used_feature_name, 'Semg std'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_feature.std;
        end

        feature_index = find(ismember(used_feature_name, 'Semg rms'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_feature.rms;
        end

        feature_index = find(ismember(used_feature_name, 'Semg kurtosis'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_feature.kurtosis;
        end

        feature_index = find(ismember(used_feature_name, 'Semg skewness'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_feature.skewness;
        end

        feature_index = find(ismember(used_feature_name, 'Semg shapeFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_feature.shapeFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Semg peakingFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_feature.peakingFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Semg pulseFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_feature.pulseFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Semg marginFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_feature.marginFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Semg clearanceFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_feature.clearanceFactor;
        end

        semg_feature_frequency_feature = frequencyDomainFeatures(semg_segment, semg_hz);

        feature_index = find(ismember(used_feature_name, 'Semg MSF'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_feature_frequency_feature.MSF;
        end

        feature_index = find(ismember(used_feature_name, 'Semg FC'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_feature_frequency_feature.FC;
        end

        feature_index = find(ismember(used_feature_name, 'Semg RMSF'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_feature_frequency_feature.RMSF;
        end

        feature_index = find(ismember(used_feature_name, 'Semg RVF'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_feature_frequency_feature.RVF;
        end

        feature_index = find(ismember(used_feature_name, 'Semg MPSD'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_feature_frequency_feature.PSD;
        end

        semg_MF_feature = MF(semg_segment, semg_hz);

        feature_index = find(ismember(used_feature_name, 'Semg MF'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_MF_feature;
        end    
        
        semg_ZC_feature = ZeroCross(semg_segment, zero_cross_thres);

        feature_index = find(ismember(used_feature_name, 'Semg ZeroCross'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_MF_feature;
        end      

        semg_sampleEn_feature = SampEn(semg_segment, sampEn_m, sampEn_n * semg_feature.std);

        feature_index = find(ismember(used_feature_name, 'Semg SampEn'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_sampleEn_feature;
        end 

        semg_sampleMFMD_feature = MFMD(semg_segment);

        feature_index = find(ismember(used_feature_name, 'Semg MFMD'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_sampleMFMD_feature;
        end 

        semg_FuzzyEn_feature = FuzzyEn(semg_segment, 2, 0.2 * semg_feature.std, 2);

        feature_index = find(ismember(used_feature_name, 'Semg FuzzyEn'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_FuzzyEn_feature;
        end 

        semg_ApEn_feature = ApEn(2, 0.2 * semg_feature.std, semg_segment, 1);

        feature_index = find(ismember(used_feature_name, 'Semg ApEn'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = semg_ApEn_feature;
        end      

        %皮肤电特征提取
        eda_feature = timeDomainfeather(eda_segment);

        feature_index = find(ismember(used_feature_name, 'Eda max'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_feature.max;
        end

        feature_index = find(ismember(used_feature_name, 'Eda min'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_feature.min;
        end

        feature_index = find(ismember(used_feature_name, 'Eda peak'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_feature.peak;
        end

        feature_index = find(ismember(used_feature_name, 'Eda p2p'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_feature.p2p;
        end

        feature_index = find(ismember(used_feature_name, 'Eda mean'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_feature.mean;
        end

        feature_index = find(ismember(used_feature_name, 'Eda averageAmplitude'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_feature.averageAmplitude;
        end

        feature_index = find(ismember(used_feature_name, 'Eda rootAmplitude'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_feature.rootAmplitude;
        end

        feature_index = find(ismember(used_feature_name, 'Eda var'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_feature.var;
        end

        feature_index = find(ismember(used_feature_name, 'Eda std'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_feature.std;
        end

        feature_index = find(ismember(used_feature_name, 'Eda rms'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_feature.rms;
        end

        feature_index = find(ismember(used_feature_name, 'Eda kurtosis'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_feature.kurtosis;
        end

        feature_index = find(ismember(used_feature_name, 'Eda skewness'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_feature.skewness;
        end

        feature_index = find(ismember(used_feature_name, 'Eda shapeFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_feature.shapeFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Eda peakingFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_feature.peakingFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Eda pulseFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_feature.pulseFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Eda marginFactor'));
        if size(feature_index, 2) == 1
            feature{e+1,feature_index} = eda_feature.marginFactor;
        end

        feature_index = find(ismember(used_feature_name, 'Eda clearanceFactor'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_feature.clearanceFactor;
        end

        eda_feature_frequency_feature = frequencyDomainFeatures(eda_segment, eda_hz);

        feature_index = find(ismember(used_feature_name, 'Eda MSF'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_feature_frequency_feature.MSF;
        end

        feature_index = find(ismember(used_feature_name, 'Eda FC'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_feature_frequency_feature.FC;
        end

        feature_index = find(ismember(used_feature_name, 'Eda RMSF'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_feature_frequency_feature.RMSF;
        end

        feature_index = find(ismember(used_feature_name, 'Eda RVF'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_feature_frequency_feature.RVF;
        end

        feature_index = find(ismember(used_feature_name, 'Eda MPSD'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_feature_frequency_feature.PSD;
        end

        eda_MF_feature = MF(eda_segment, eda_hz);

        feature_index = find(ismember(used_feature_name, 'Eda MF'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_MF_feature;
        end          

        eda_sampleEn_feature = SampEn(eda_segment, sampEn_m, sampEn_n * eda_feature.std);

        feature_index = find(ismember(used_feature_name, 'Eda SampEn'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_sampleEn_feature;
        end 

        eda_sampleMFMD_feature = MFMD(eda_segment);

        feature_index = find(ismember(used_feature_name, 'Eda MFMD'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_sampleMFMD_feature;
        end 

        eda_FuzzyEn_feature = FuzzyEn(eda_segment, 2, 0.2 * eda_feature.std, 2);

        feature_index = find(ismember(used_feature_name, 'Eda FuzzyEn'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_FuzzyEn_feature;
        end 

        eda_ApEn_feature = ApEn(2, 0.2 * eda_feature.std, eda_segment, 1);

        feature_index = find(ismember(used_feature_name, 'Eda ApEn'));
        if size(feature_index, 2) == 1
            feature{e+1, feature_index} = eda_ApEn_feature;
        end      

    end

    save([save_static_position{i}, 'Normal_Feature.mat'], 'feature');
    
end