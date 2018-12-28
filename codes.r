# Read the comments to get information about relevant figures in origianl paper.
library(ggplot2)
library(ggrepel)
##################################
# Part-III
# Table 1
(words = read.csv("pca_abdi_words.csv",header = T))
(words_centered = scale(words[,2:3],scale = F)) # Removing the first column
pca_words_cov = prcomp(words[,2:3],scale = F) # cov stands for Covariance PCA
factor_scores_words = pca_words_cov$x
round(factor_scores_words,2)
sum(factor_scores_words[,1]*factor_scores_words[,2]) # PCs are orthogonal
# Contibution of each factor (It is defined as square of factor score divided by sum of squares of factor scores in that column)
round(factor_scores_words[,1]^2/sum(factor_scores_words[,1]^2)*100,2)
round(factor_scores_words[,2]^2/sum(factor_scores_words[,2]^2)*100,2)
# The calculations in above two lines can be done in a single line
round(factor_scores_words^2/matrix(rep(colSums(factor_scores_words^2),nrow(words)),ncol = 2,byrow = T)*100,2)
# Squared distance to center of gravity
(dist = factor_scores_words[,1]^2+factor_scores_words[,2]^2)
# Ssquared cosine of observations of first PC
(sq_cos = round(factor_scores_words^2/matrix(rep(dist,2),ncol = 2)*100))# Nan's are prouced because of division by zero.

#############################
# Figue 1
p = ggplot(words,aes(x = Lines_in_dict,y = Word_length,label = Words))+
  geom_point()+ geom_text_repel()+ 
  geom_hline(yintercept = 6)+geom_vline(xintercept = 8)
print(p)
# Show directions of PCs
# Note that intercept argument in geom_abline considers the line to be at the origin. In our case the data are mean shifted.
# So we have to adjust the intercept taking new origin into consideration. These adjustments have been made below.
slope1 = pca_words_cov$rotation[1,1]/pca_words_cov$rotation[2,1] # Slope of first PC
slope2 = pca_words_cov$rotation[1,2]/pca_words_cov$rotation[2,2] # Slope of second PC
(new_origin = c(mean(words$Lines_in_dict),mean(words$Word_length)))
intercept1 = 6 - slope1*8
intercept2 = 6 - slope2*8
p+geom_abline(slope = slope1,intercept = intercept1,linetype = "dashed",size = 1.2,col = "red")+
  geom_abline(slope = slope2,intercept = intercept2,linetype = "dashed",size = 1.2,col = "blue")# Red dashed line is 1st PC and blue
#line is 2nd PC
# Rotated PCs
# This figure is obtained by plotting facotor scores. Note that we will 
# plot negative of the factor scores of 1st PC to make the figure consistent
# with the paper.
ggplot(as.data.frame(pca_words_cov$x),aes(-pca_words_cov$x[,1],pca_words_cov$x[,2],label = words$Words))+
  geom_point()+geom_text_repel()+geom_hline(yintercept = 0)+geom_vline(xintercept = 0)+
  xlab("Factor score along PC1")+ylab("Factor score along PC2")

##########################################
# Finding factor score of a new point
sur = c(3,12) # It has 3 letter and 12 lines of dictionary entry
(sur_centered = sur - colMeans(words[,2:3]))
(factor_scores_sur = round(sur_centered %*% pca_words_cov$rotation,2))

####################################
# Variance and eigenvalues
(total_var_before = round(sum(diag(var(words_centerd))),3))
(total_var_after = round(sum(diag(var(pca_words_cov$x))),3))
# Percentage of variance exlained
(cumsum(pca_words_cov$sdev^2/sum(pca_words_cov$sdev^2)*100))

#########################
# Supplementary variable (Table 4)
Frequency = c(8,230,700,1,500,1,9,2,1,700,7,1,4,500,900,3,1,10,1,1)
Num_entries = c(6,3,12,2,7,1,1,6,1,5,2,1,5,9,7,1,1,4,4,2)
supp_data = data.frame(Frequency,Num_entries) # Supplementary data
# Table 5
supp_data_cent = scale(supp_data,scale = F) # Centered supplementary data
(corr_score_supp = round(cor(pca_words_cov$x,supp_data_cent),4))
(round(cor(pca_words_cov$x,supp_data_cent)^2,4))
(round(colSums(cor(pca_words_cov$x,supp_data_cent)^2),4))

###################################
# Plotting variables in circle of correlation
# First plot correlation circle
x = seq(0,2*pi,length.out = 300)
circle = ggplot() + geom_path(data = data.frame(a = cos(x),b = sin(x)),
                     aes(cos(x),sin(x)),alpha = 0.3, size = 1.5)+
            geom_hline(yintercept = 0)+geom_vline(xintercept = 0)+
  annotate("text",x = c(1.08,0.05),y = c(0.05,1.08),label = c("PC1","PC2"),angle = c(0,90))+
            xlab(NULL)+ylab(NULL)

# Plotting original variables
variable_plot_original = circle + geom_point(data = as.data.frame(pca_words_cov$rotation),
                      aes(pca_words_cov$rotation[,1],pca_words_cov$rotation[,2]))+
  geom_text_repel(aes(pca_words_cov$rotation[,1],pca_words_cov$rotation[,2],
                      label = c("Length of words","Number of lines in Dict."))) 
  print(variable_plot_original)
  
## Plotting supplementary variables
variable_plot_original+
  geom_point(data = as.data.frame(corr_score_supp),
             aes(corr_score_supp[,1],corr_score_supp[,2]))+
  geom_text_repel(aes(corr_score_supp[,1],corr_score_supp[,2],
                      label = c("Frequency","Number of entries"))) 
#########################################
# Example 2
# Correlation PCA using wine data 
# Table 6
(wine = read.csv("pca_abdi_wine.csv",header = T))
pca_wine_cor = prcomp(wine[2:8],scale = T)
ggplot(as.data.frame(pca_wine_cor$x),aes(x = pca_wine_cor$x[,1],y =  pca_wine_cor$x[,2],
                                         label = paste0("wine ",1:5)))+
  geom_point()+geom_text_repel()+ geom_vline(xintercept = 0)+ geom_hline(yintercept = 0)+
  xlab("Factor score along PC1")+ylab("Factor score along PC2")

# Table 7
# Factor scores along 1st and 2nd PC
(pca_wine_cor$x[,1:2])
# Contibution of each observation to principal component
round(pca_wine_cor$x[,1:2]^2/matrix(rep(colSums(pca_wine_cor$x[,1:2]^2),nrow(wine)),ncol = 2,byrow = T)*100,2)
dist = pca_wine_cor$x[,1]^2+pca_wine_cor$x[,2]^2
# Ssquared cosine of observations of first PC
(sq_cos = round(pca_wine_cor$x[,1:2]^2/matrix(rep(dist,2),ncol = 2)*100))# Nan's are prouced because of division by zero.
# Loading scores corresponding to first two principal components
(round(pca_wine_cor$rotation[,1:2],2))
# Correlation score variables with first two principal compoents
(corr_score_wine = round(cor(pca_wine_cor$x,wine[,2:8])[1:2,],2))

# Correlation circle
# Figure 6
circle + 
  geom_point(data = as.data.frame(t(corr_score_wine)),
             aes(corr_score_wine[1,],corr_score_wine[2,]))+
  geom_text_repel(aes(corr_score_wine[1,],corr_score_wine[2,],
                      label = c("Hedonic","For Meat","For dessert","Price","Sugar","Alcohol","Acidity")))

# Varimax rotation
# Loading scores of first two principal components
(round(pca_wine_cor$rotation[,1:2],2))
# Varimax applied to first two principal components
rotated_loading_scores = varimax(pca_wine_cor$rotation[,1:2])
# Loading scores after rotation (Table 10)
(round(rotated_loading_scores$loadings[,1:2],2))
# The same result can also be obtained by mulitplying the original loading 
# matrix by the rotation matrix obtained from varimax
(round(pca_wine_cor$rotation[,1:2] %*% rotated_loading_scores$rotmat,2))

#Figure 7
# Plot of loading socres before rotation
ggplot(as.data.frame(pca_wine_cor$rotation[,1:2]),aes(x = pca_wine_cor$rotation[,1],y = pca_wine_cor$rotation[,2],
                                                      label = c("Hedonic","For Meat","For dessert","Price","Sugar","Alcohol","Acidity")))+
  geom_point()+geom_text_repel()+geom_hline(yintercept = 0)+geom_vline(xintercept = 0)+
  xlab("Loading score along PC1")+ylab("Loading score along PC2")
# Plot of loading scores after rotation
ggplot(as.data.frame(rotated_loading_scores$loadings[,1:2]),
                     aes(x = rotated_loading_scores$loadings[,1],
                         y = rotated_loading_scores$loadings[,2],
                         label = c("Hedonic","For Meat","For dessert","Price","Sugar","Alcohol","Acidity")))+
  geom_point()+geom_text_repel()+geom_hline(yintercept = 0)+geom_vline(xintercept = 0)+
    xlab("Loading score along PC1 after rotation")+
    ylab("Loading score along PC2 after rotation")



# Example 3
# French food example (Covariance PCA example)
# Load data (Table 11) 
(food = read.csv("pca_abdi_food.csv",header = T))
pca_food_cov = prcomp(food[,3:9],scale = F)

# Table 12
# Factor scores
(factor_scores_food = round(pca_food_cov$x[,1:2],2))
# Contibution of each observation to principal component
round(pca_food_cov$x[,1:2]^2/matrix(rep(colSums(pca_food_cov$x[,1:2]^2),nrow(food)),ncol = 2,byrow = T)*100,2)
dist = pca_food_cov$x[,1]^2+pca_food_cov$x[,2]^2
# Squared cosine of observations of first PC
(sq_corr = round(pca_food_cov$x[,1:2]^2/matrix(rep(dist,2),ncol = 2)*100))

# Table 13
# squared loading score
(round(pca_food_cov$rotation[,1:2]^2,2))
# Correlation score
corr_score_food = cor(pca_food_cov$x,food[,3:9])[1:2,]
(round(corr_score,2))
# squared correlation score
(round((cor(pca_food_cov$x,food[,3:9])[1:2,])^2,2))

# Figure 9
# Correlation circle for food data
circle + geom_point(data = as.data.frame(t(corr_score)), 
                    aes(x = corr_score[1,],y = corr_score[2,]))+
  geom_text_repel(data = as.data.frame(t(corr_score)), 
                  aes(x = corr_score[1,],y = corr_score[2,],
                      label = c("Bread","Vegetables","Fruit","Meat","Poultry","Milk","Wine")))
                      
## Table 14
cent_food = food[,3:9]-matrix(rep(colMeans(food[,3:9]),times = 12),nrow = 12,
                              byrow = T)
svd_food = svd(cent_food)
# Eigenvalues
(Eigenvalues = (svd_food$d)^2)

# Percentage contribution of each PC
(round(Eigenvalues/sum(Eigenvalues),2))
# Cumulative sum of eigen values
(round(cumsum(Eigenvalues),2))
# Cumulative percentage
(round(cumsum(Eigenvalues)/sum(Eigenvalues),2))
# RESS
RESS = array(rep(0,7))
for (i in 1:7){
  RESS[i] = sum(Eigenvalues)-sum(Eigenvalues[1:i])
}
RESS
# RESS/sum of eigenvalues
round(RESS/sum(Eigenvalues),2)


###################################
# Random effect model
x_recon = array(rep(0,12*7),dim = c(12,7))
press = rep(0,7)
for (j in 1:7){
  for (i in 1:12){
    pca = prcomp(cent_food[-i,],scale = F)
    #x_trans = food[i,3:9] %*% pca$rotation[,1]
    x_recon[i,]= as.matrix(cent_food[i,]) %*% pca$rotation[,1:j] %*% t(pca$rotation[,1:j])
  }
  press[j] = sum((cent_food-x_recon)^2)
}
#sum((cent_food-x_recon)^2)
#sum((food[,3:9]-x_recon)^2)