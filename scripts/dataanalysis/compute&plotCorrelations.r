library(tidyverse)
library(ppcor)
library(ggpubr)
library(broom)
library(svglite)

#### import and format tract-tracing connectivity matrix
tt_path  <- '/home/celine/ferret-mri-annex/scratch/work_celine/compDiffTT/data/Bizley2009/retrogradeTT_raw_dzero_normFLN_sym.csv' 
tt_data <- read.csv(tt_path, header = FALSE, sep = '')
mask <- upper.tri(tt_data,diag = FALSE)
tt_data_flat <- tt_data[mask]


#### import euclidean distance between parcels
eucldist_path = '/home/celine/ferret-mri-annex/scratch/work_celine/compDiffTT/data/Bizley2009/euclideanDistance_selected.csv'
eucldist = read.csv(eucldist_path, header = FALSE, sep = '')
eucldist_flat <- eucldist[mask]

#### import and format diffusion data (connectivity matrices and average streamline lengths)
i <- 0
nbfib <- '1M'
pathConn <- '/home/celine/ferret-mri-annex/scratch/work_celine/compDiffTT/data/connectomes/F01_Adult/selected/processed/'
pathLen <- '/home/celine/ferret-mri-annex/scratch/work_celine/compDiffTT/data/connectomes/F01_Adult/length/selected/'
savepath <- '/home/celine/ferret-mri-annex/scratch/work_celine/compDiffTT/figures/'


dti_det_path <-  paste(pathConn,'connectomeBizley_whole_dti_',nbfib,'_',i,'_weights_selected_dzero_normFS_sym.csv',sep = '' )
dti_det_data <-  read.csv(dti_det_path, header = FALSE, sep = ' ')
dti_det_data_flat <- dti_det_data[mask]
dti_det_length_path <-  paste(pathLen,'connectomeBizley_whole_dti_',nbfib,'_',i,'_lengths_selected.csv',sep = '' )
dti_det_length_data <-  read.csv(dti_det_length_path, header = FALSE, sep = ' ')
dti_det_length_data_flat <- dti_det_length_data[mask]

dti_prob_path <-  paste(pathConn,'connectomeBizley_whole_dti_Prob_',nbfib,'_',i,'_weights_selected_dzero_normFS_sym.csv',sep = '' )
dti_prob_data <-  read.csv(dti_prob_path, header = FALSE, sep = ' ')
dti_prob_data_flat <- dti_prob_data[mask]
dti_prob_length_path <-  paste(pathLen,'connectomeBizley_whole_dti_Prob_',nbfib,'_',i,'_lengths_selected.csv',sep = '' )
dti_prob_length_data <-  read.csv(dti_prob_length_path, header = FALSE, sep = ' ')
dti_prob_length_data_flat <- dti_prob_length_data[mask]

csd_det_path <-  paste(pathConn,'connectomeBizley_whole_csd_SD_',nbfib,'_',i,'_weights_selected_dzero_normFS_sym.csv',sep = '' )
csd_det_data <-  read.csv(csd_det_path, header = FALSE, sep = ' ')
csd_det_data_flat <- csd_det_data[mask]
csd_det_length_path <-  paste(pathLen,'connectomeBizley_whole_csd_SD_',nbfib,'_',i,'_lengths_selected.csv',sep = '' )
csd_det_length_data <-  read.csv(csd_det_length_path, header = FALSE, sep = ' ')
csd_det_length_data_flat <- csd_det_length_data[mask]

csd_prob_path <-  paste(pathConn,'connectomeBizley_whole_csd_iFOD2_',nbfib,'_',i,'_weights_selected_dzero_normFS_sym.csv',sep = '' )
csd_prob_data <-  read.csv(csd_prob_path, header = FALSE, sep = ' ')
csd_prob_data_flat <- csd_prob_data[mask]
csd_prob_length_path <-  paste(pathLen,'connectomeBizley_whole_csd_iFOD2_',nbfib,'_',i,'_lengths_selected.csv',sep = '' )
csd_prob_length_data <-  read.csv(csd_prob_length_path, header = FALSE, sep = ' ')
csd_prob_length_data_flat <- csd_prob_length_data[mask]

dholl_det_path <-  paste(pathConn,'connectomeBizley_whole_msmt_dhollander_SD_',nbfib,'_',i,'_weights_selected_dzero_normFS_sym.csv',sep = '' )
dholl_det_data <-  read.csv(dholl_det_path, header = FALSE, sep = ' ')
dholl_det_data_flat <- dholl_det_data[mask]
dholl_det_length_path <-  paste(pathLen,'connectomeBizley_whole_msmt_dhollander_SD_',nbfib,'_',i,'_lengths_selected.csv',sep = '' )
dholl_det_length_data <-  read.csv(dholl_det_length_path, header = FALSE, sep = ' ')
dholl_det_length_data_flat <- dholl_det_length_data[mask]

dholl_prob_path <-  paste(pathConn,'connectomeBizley_whole_msmt_dhollander_',nbfib,'_',i,'_weights_selected_dzero_normFS_sym.csv',sep = '' )
dholl_prob_data <-  read.csv(dholl_prob_path, header = FALSE, sep = ' ')
dholl_prob_data_flat <- dholl_prob_data[mask]
dholl_prob_length_path <-  paste(pathLen,'connectomeBizley_whole_msmt_dhollander_',nbfib,'_',i,'_lengths_selected.csv',sep = '' )
dholl_prob_length_data <-  read.csv(dholl_prob_length_path, header = FALSE, sep = ' ')
dholl_prob_length_data_flat <- dholl_prob_length_data[mask]
  
#### compute correlations SPEARMAN

cor.test(x = tt_data_flat,y = dti_det_data_flat,method = 'spearman')
cor.test(x = tt_data_flat,y = dti_prob_data_flat,method = 'spearman')

cor.test(x = tt_data_flat,y = csd_det_data_flat,method = 'spearman')
cor.test(x = tt_data_flat,y = csd_prob_data_flat,method = 'spearman')

cor.test(x = tt_data_flat,y = dholl_det_data_flat,method = 'spearman')
cor.test(x = tt_data_flat,y = dholl_prob_data_flat,method = 'spearman')

#### compute bootstrapped confidence intervals for spearman correlations
library(DescTools)

spearman <- function(x,y) cor(x,y,method = "spearman",use = "p")

DescTools::BootCI(tt_data_flat, dti_det_data_flat,FUN = spearman, R = 10000, conf.level = 0.95)
DescTools::BootCI(tt_data_flat, dti_prob_data_flat,FUN = spearman, R = 10000, conf.level = 0.95)

DescTools::BootCI(tt_data_flat, csd_det_data_flat,FUN = spearman, R = 10000, conf.level = 0.95)
DescTools::BootCI(tt_data_flat, csd_prob_data_flat,FUN = spearman, R = 10000, conf.level = 0.95)

DescTools::BootCI(tt_data_flat, dholl_det_data_flat,FUN = spearman, R = 10000, conf.level = 0.95)
DescTools::BootCI(tt_data_flat, dholl_prob_data_flat,FUN = spearman, R = 10000, conf.level = 0.95)

  
#### compute correlations PEARSON (to be computed with the connectivity matrices incremented by one before normalisation)
  
cor.test(x = log10(tt_data_flat),y = log10(dti_det_data_flat),method = 'pearson')
cor.test(x = log10(tt_data_flat),y = log10(dti_prob_data_flat),method = 'pearson')

cor.test(x = log10(tt_data_flat),y = log10(csd_det_data_flat),method = 'pearson')
cor.test(x = log10(tt_data_flat),y = log10(csd_prob_data_flat),method = 'pearson')

cor.test(x = log10(tt_data_flat),y = log10(dholl_det_data_flat),method = 'pearson')
cor.test(x = log10(tt_data_flat),y = log10(dholl_prob_data_flat),method = 'pearson')
  

#### PLOT correlation tt/diff ####

max_len = max(cbind(t(dti_det_length_data_flat),t(dti_prob_length_data_flat),t(csd_det_length_data_flat),t(csd_prob_length_data_flat),t(dholl_det_length_data_flat),t(dholl_prob_length_data_flat)))

(cdti_det <- ggplot(data = NULL, aes(x=rank(tt_data_flat),y = rank(dti_det_data_flat))) +
    geom_point(aes(fill=dti_det_length_data_flat/max_len),shape=21,size=2) + 
    geom_smooth(method = 'lm',se = TRUE,color='royalblue1',fill='royalblue1',alpha=0.2) + 
    scale_fill_gradient(guide = FALSE,low = 'white',high = 'black') +
    scale_x_continuous(limits = c(-1,length(tt_data_flat)+1.5)) +
    scale_y_continuous(limits = c(-1,length(tt_data_flat)+1.5))+
    theme_set(theme_gray(base_size = 11))+
    theme(
      axis.title.x=element_blank(),
      axis.title.y=element_blank())+
    coord_fixed())

(cdti_prob <- ggplot(data = NULL, aes(x=rank(tt_data_flat),y = rank(dti_prob_data_flat))) +
    geom_point(aes(fill=dti_prob_length_data_flat/max_len),shape=21,size=2) + 
    geom_smooth(method = 'lm',se = TRUE,color='royalblue1',fill='royalblue1',alpha=0.2) + 
    scale_fill_gradient(guide = FALSE,low = 'white',high = 'black') +
    scale_x_continuous(limits = c(-1,length(tt_data_flat)+1.5)) +
    scale_y_continuous(limits = c(-1,length(tt_data_flat)+1.5))+
    theme_set(theme_gray(base_size = 11))+
    theme(
      axis.title.x=element_blank(),
      axis.title.y=element_blank())+
    coord_fixed())

(ccsd_det <- ggplot(data = NULL, aes(x=rank(tt_data_flat),y = rank(csd_det_data_flat))) +
    geom_point(aes(fill=csd_det_length_data_flat/max_len),shape=21,size=2) + 
    geom_smooth(method = 'lm',se = TRUE,color='darkorange',fill='darkorange',alpha=0.2) + 
    scale_fill_gradient(guide = FALSE,low = 'white',high = 'black')+
    scale_x_continuous(limits = c(-1,length(tt_data_flat)+1.5)) +
    scale_y_continuous(limits = c(-1,length(tt_data_flat)+1.5))+
    theme_set(theme_gray(base_size = 11))+
    theme(
      axis.title.x=element_blank(),
      axis.title.y=element_blank())+
    coord_fixed())

(ccsd_prob <- ggplot(data = NULL, aes(x=rank(tt_data_flat),y = rank(csd_prob_data_flat))) +
    geom_point(aes(fill=csd_prob_length_data_flat/max_len),shape=21,size=2) + 
    geom_smooth(method = 'lm',se = TRUE,color='darkorange',fill='darkorange',alpha=0.2) + 
    scale_fill_gradient(guide = FALSE,low = 'white',high = 'black')+
    scale_x_continuous(limits = c(-1,length(tt_data_flat)+1.5)) +
    scale_y_continuous(limits = c(-1,length(tt_data_flat)+1.5))+
    theme_set(theme_gray(base_size = 11))+
    theme(
      axis.title.x=element_blank(),
      axis.title.y=element_blank())+
    coord_fixed())

(cdholl_det <- ggplot(data = NULL, aes(x=rank(tt_data_flat),y = rank(dholl_det_data_flat))) +
  geom_point(aes(fill=dholl_det_length_data_flat/max_len),shape=21,size=2) + 
  geom_smooth(method = 'lm',se = TRUE,color='green4',fill='green4',alpha=0.2) +  #se=TRUE
  scale_fill_gradient(guide=FALSE,low = 'white',high = 'black')+#guide='colorbar'
    scale_x_continuous(limits = c(-1,length(tt_data_flat)+1.5)) +
    scale_y_continuous(limits = c(-1,length(tt_data_flat)+1.5))+
  theme_set(theme_gray(base_size = 11))+
    theme(
      axis.title.x=element_blank(),
      axis.title.y=element_blank())+
    coord_fixed())

(cdholl_prob <- ggplot(data = NULL, aes(x=rank(tt_data_flat),y = rank(dholl_prob_data_flat))) +
    geom_point(aes(fill=dholl_prob_length_data_flat/max_len),shape=21,size=2) + 
    geom_smooth(method = 'lm',se = TRUE,color='green4',fill='green4',alpha=0.2) +  #se=TRUE
    scale_fill_gradient(guide=FALSE,low = 'white',high = 'black')+#guide='colorbar'
    scale_x_continuous(limits = c(-1,length(tt_data_flat)+1.5)) +
    scale_y_continuous(limits = c(-1,length(tt_data_flat)+1.5))+
    theme_set(theme_gray(base_size = 11))+
    theme(
      axis.title.x=element_blank(),
      axis.title.y=element_blank())+
    coord_fixed())

(ggarrange(cdti_det,ccsd_det,cdholl_det,cdti_prob,ccsd_prob,cdholl_prob,ncol=3,nrow = 2))
ggsave(paste(savepath,'spearmancorr_det_prob_sym_plot_FSFLN.svg'), device = svg(),width = 18,height = 10,units = 'cm')
ggsave(paste(savepath,'spearmancorr_det_prob_sym_plot_FSFLN.png'), device = svg(),width = 18,height = 10,units = 'cm')

(ggarrange(cdti_det,ccsd_det,cdholl_det,ncol=3,nrow = 1))
ggsave(paste(savepath,'spearmancorr_det_prob_sym_plot_FS-DET.svg'), device = svg(),width = 18,height = 5,units = 'cm')
ggsave(paste(savepath,'spearmancorr_det_prob_sym_plot_FS-DET.png'), device = svg(),width = 18,height = 5,units = 'cm')

(ggarrange(cdti_prob,ccsd_prob,cdholl_prob,ncol=3,nrow = 1))
ggsave(paste(savepath,'spearmancorr_det_prob_sym_plot_FS-PROB.svg'), device = svg(),width = 18,height = 5,units = 'cm')
ggsave(paste(savepath,'spearmancorr_det_prob_sym_plot_FS-PROB.png'), device = svg(),width = 18,height = 5,units = 'cm')


##save colorbar
(ggplot(data = NULL, aes(x=rank(tt_data_flat),y = rank(dti_det_data_flat))) +
    geom_point(aes(fill=dti_det_length_data_flat/max(dti_det_length_data_flat)),shape=21,size=3) + 
    geom_smooth(method = 'lm',se = TRUE,color='royalblue1',fill='royalblue1',alpha=0.2) +  #se=TRUE
    scale_fill_gradient(guide='colorbar',low = 'white',high = 'black')+#guide='colorbar'
    scale_x_continuous(limits = c(-1,length(tt_data_flat))) +
    scale_y_continuous(limits = c(-1,length(tt_data_flat)))+
    guides(fill=guide_colorbar(barwidth = 2.5,barheight = 15))+
    theme(legend.text = element_text(size = 15),
          legend.title = element_blank(),
          axis.title.x=element_blank(),
          axis.title.y=element_blank())+
    coord_fixed())

ggsave(paste(savepath,'spearmancorr_colorbar.svg'),dpi=300)


#### partial corr, distance regressed ####

ttlm <- lm(log10(tt_data_flat)~eucldist_flat,na.action=na.exclude)
ttresid <- resid(ttlm)

dti_det_data_na <- dti_det_data_flat
dti_det_data_na[dti_det_data_na==0] <- NA
dti_det_dist_data_na <- eucldist_flat
dti_det_dist_data_na[is.na(dti_det_data_na)] <- NA
dtilm_d <- lm(log10(dti_det_data_na)~dti_det_dist_data_na,na.action=na.exclude)
dtiresid_d <- resid(dtilm_d)

dti_prob_data_na <- dti_prob_data_flat
dti_prob_data_na[dti_prob_data_na==0] <- NA
dti_prob_dist_data_na <- eucldist_flat
dti_prob_dist_data_na[is.na(dti_prob_data_na)] <- NA
dtilm_p <- lm(log10(dti_prob_data_na)~dti_prob_dist_data_na,na.action=na.exclude)
dtiresid_p <- resid(dtilm_p)


csd_det_data_na <- csd_det_data_flat
csd_det_data_na[csd_det_data_na==0] <- NA
csd_det_dist_data_na <- eucldist_flat
csd_det_dist_data_na[is.na(csd_det_data_na)] <- NA
csdlm_d <- lm(log10(csd_det_data_na)~csd_det_dist_data_na,na.action=na.exclude)
csdresid_d <- resid(csdlm_d)

csd_prob_data_na <- csd_prob_data_flat
csd_prob_data_na[csd_prob_data_na==0] <- NA
csd_prob_dist_data_na <- eucldist_flat
csd_prob_dist_data_na[is.na(csd_prob_data_na)] <- NA
csdlm_p <- lm(log10(csd_prob_data_na)~csd_prob_dist_data_na,na.action=na.exclude)
csdresid_p <- resid(csdlm_p)


dholl_det_data_na <- dholl_det_data_flat
dholl_det_data_na[dholl_det_data_na==0] <- NA
dholl_det_dist_data_na <- eucldist_flat
dholl_det_dist_data_na[is.na(dholl_det_data_na)] <- NA
dholllm_d <- lm(log10(dholl_det_data_na)~dholl_det_dist_data_na,na.action=na.exclude)
dhollresid_d <- resid(dholllm_d)

dholl_prob_data_na <- dholl_prob_data_flat
dholl_prob_data_na[dholl_prob_data_na==0] <- NA
dholl_prob_dist_data_na <- eucldist_flat
dholl_prob_dist_data_na[is.na(dholl_prob_data_na)] <- NA
dholllm_p <- lm(log10(dholl_prob_data_na)~dholl_prob_dist_data_na,na.action=na.exclude)
dhollresid_p <- resid(dholllm_p)


dtiresid_d[is.na(dtiresid_d)] <- 0
dtiresid_p[is.na(dtiresid_p)] <- 0
csdresid_d[is.na(csdresid_d)] <- 0
csdresid_p[is.na(csdresid_p)] <- 0
dhollresid_d[is.na(dhollresid_d)] <- 0
dhollresid_p[is.na(dhollresid_p)] <- 0

#### SPEARMAN semi-partial correlations

cor.test(ttresid,dtiresid_d,method = 'spearman')
cor.test(ttresid,dtiresid_p,method = 'spearman')
cor.test(ttresid,csdresid_d,method = 'spearman')
cor.test(ttresid,csdresid_p,method = 'spearman')
cor.test(ttresid,dhollresid_d,method = 'spearman')
cor.test(ttresid,dhollresid_p,method = 'spearman')

#### PEARSON semi-partial correlations

cor.test(ttresid,(dtiresid_d),method = 'pearson')
cor.test(ttresid,(dtiresid_p),method = 'pearson')
cor.test(ttresid,(csdresid_d),method = 'pearson')
cor.test(ttresid,(csdresid_p),method = 'pearson')
cor.test(ttresid,(dhollresid_d),method = 'pearson')
cor.test(ttresid,(dhollresid_p),method = 'pearson')

#### plot partial correlations

(rdti_d <- ggplot(mapping = aes(x=rank(ttresid),y=rank(dtiresid_d))) + 
    geom_point()+geom_smooth(method = 'lm', se = TRUE,color='royalblue1',fill='royalblue1',alpha=0.2)+
    scale_x_continuous(limits = c(-1,length(tt_data_flat))) +
    scale_y_continuous(limits = c(-1,length(tt_data_flat)))+
    theme_set(theme_gray(base_size = 11))+
    theme(
      axis.title.x=element_blank(),
      axis.title.y=element_blank())+
    coord_fixed())

(rdti_p <- ggplot(mapping = aes(x=rank(ttresid),y=rank(dtiresid_p))) + 
    geom_point()+geom_smooth(method = 'lm', se = TRUE,color='royalblue1',fill='royalblue1',alpha=0.2)+
    scale_x_continuous(limits = c(-1,length(tt_data_flat))) +
    scale_y_continuous(limits = c(-1,length(tt_data_flat)))+
    theme_set(theme_gray(base_size = 11))+
    theme(
      axis.title.x=element_blank(),
      axis.title.y=element_blank())+
    coord_fixed())

(rcsd_d <- ggplot(mapping = aes(x=rank(ttresid),y=rank(csdresid_d))) + 
    geom_point()+geom_smooth(method = 'lm', se = TRUE,color='darkorange',fill='darkorange',alpha=0.2)+
    scale_x_continuous(limits = c(-1,length(tt_data_flat))) +
    scale_y_continuous(limits = c(-1,length(tt_data_flat)))+
    theme_set(theme_gray(base_size = 11))+
    theme(
      axis.title.x=element_blank(),
      axis.title.y=element_blank())+
    coord_fixed())

(rcsd_p <- ggplot(mapping = aes(x=rank(ttresid),y=rank(csdresid_p))) + 
    geom_point()+geom_smooth(method = 'lm', se = TRUE,color='darkorange',fill='darkorange',alpha=0.2)+
    scale_x_continuous(limits = c(-1,length(tt_data_flat))) +
    scale_y_continuous(limits = c(-1,length(tt_data_flat)))+
    theme_set(theme_gray(base_size = 11))+
    theme(
      axis.title.x=element_blank(),
      axis.title.y=element_blank())+
    coord_fixed())

(rdholl_d <- ggplot(mapping = aes(x=rank(ttresid),y=rank(dhollresid_d))) + 
  geom_point()+geom_smooth(method = 'lm', se = TRUE,color='green4',fill='green4',alpha=0.2)+
    scale_x_continuous(limits = c(-1,length(tt_data_flat))) +
    scale_y_continuous(limits = c(-1,length(tt_data_flat)))+
    theme_set(theme_gray(base_size = 11))+
    theme(
      axis.title.x=element_blank(),
      axis.title.y=element_blank())+
    coord_fixed())

(rdholl_p <- ggplot(mapping = aes(x=rank(ttresid),y=rank(dhollresid_p))) + 
    geom_point()+geom_smooth(method = 'lm', se = TRUE,color='green4',fill='green4',alpha=0.2)+
    scale_x_continuous(limits = c(-1,length(tt_data_flat))) +
    scale_y_continuous(limits = c(-1,length(tt_data_flat)))+
    theme_set(theme_gray(base_size = 11))+
    theme(
      axis.title.x=element_blank(),
      axis.title.y=element_blank())+
    coord_fixed())

(ggarrange(rdti_d,rcsd_d,rdholl_d,rdti_p,rcsd_p,rdholl_p,nrow = 2,ncol = 3))
ggsave(paste(savepath,'spearmancorr_residuals_partcorr_det_prob_sym_plot.svg'),dpi=300,width = 18,height = 10,units = 'cm')
ggsave(paste(savepath,'spearmancorr_residuals_partcorr_det_prob_sym_plot.png'),dpi=300,width = 18,height = 10,units = 'cm')
