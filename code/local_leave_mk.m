clear;
load('You_dataset.mat');
y_train = miRNA_disease_Y;
[II,JJ] = find(miRNA_disease_Y == 1);
K1 = [];
K1(:,:,1)=miRNA_Function_S;
K1(:,:,2)=miRNA_Sequences_Needle_S;
K2 = [];
K2(:,:,1)=disease_Function_S;
K2(:,:,2)=disease_Sem_S;
[n_miRNA,n_Diseas]=size(y_train);
Pre_value = [];
for i = 1:n_Diseas   
	y_train = miRNA_disease_Y;
	y_train(:,i) = 0;    
	 K1(:,:,3)=kernel_gip(y_train,1, 1);
	 K2(:,:,3)=kernel_gip(y_train,2, 1);
	 
	[weight_v1] = FKL_weights(K1,y_train,1,10000);
	K_COM1 = combine_kernels(weight_v1, K1);		
		
	[weight_v2] = FKL_weights(K2,y_train,2,10000);
	K_COM2 = combine_kernels(weight_v2, K2);
         
	[F_1] = LapRLS_mb(K_COM1,K_COM2,y_train, 2^(-4),40,1);
	
	Pre_value = [Pre_value,F_1(:,i)];
	 if mod(i,50) == 0
		 i             
	 end
end

[X_1,Y_1,tpr,aupr_1] = perfcurve(miRNA_disease_Y(:), Pre_value(:),1, 'xCrit', 'reca', 'yCrit', 'prec');
[X,Y,THRE,AUC_1,OPTROCPT,SUBY,SUBYNAMES] = perfcurve(miRNA_disease_Y(:), Pre_value(:),1);

