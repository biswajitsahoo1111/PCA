# Read the comments to get information about relevant figures in origianl paper.
library(ggplot2)
library(ggrepel)


X = read.csv("pca_abdi_ex1.csv",header = T)

pca = prcomp(X[,2:3],scale = F)

# Projection of points on first two PCs
ggplot()+geom_point(data = as.data.frame(pca$x),
                    aes(pca$x[,1],pca$x[,2]))+
  geom_text_repel(aes(pca$x[,1],pca$x[,2],label = X[,1]))

# Correlation circle
x = seq(0,2*pi,length.out = 300)
ggplot() + geom_path(data = data.frame(a = cos(x),b = sin(x)),
                     aes(cos(x),sin(x)),alpha = 0.3, size = 1.5)+
  geom_point(data = as.data.frame(pca$rotation),
                      aes(pca$rotation[,1],pca$rotation[,2]))+
  geom_text_repel(aes(pca$rotation[,1],pca$rotation[,2],
                      label = c("Length","Dict"))) +
  geom_hline(yintercept = 0)+geom_vline(xintercept = 0)


## Add supplementary variables

Frequency = c(8,230,700,1,500,1,9,2,1,700,7,1,4,500,900,3,1,10,1,1)
Num_entries = c(6,3,12,2,7,1,1,6,1,5,2,1,5,9,7,1,1,4,4,2)
supp_data = data.frame(Frequency, Num_entries)

cor_score_supp = cor(pca$x,supp_data)

x = seq(0,2*pi,length.out = 300)
ggplot() + geom_path(data = data.frame(a = cos(x),b = sin(x)),
                     aes(cos(x),sin(x)),alpha = 0.3, size = 1.5)+
  geom_point(data = as.data.frame(pca$rotation),
             aes(pca$rotation[,1],pca$rotation[,2]))+
  geom_text_repel(aes(pca$rotation[,1],pca$rotation[,2],
                      label = c("Length","Dict"))) +
  geom_hline(yintercept = 0)+geom_vline(xintercept = 0)+
  geom_point(data = as.data.frame(cor_score_supp),
             aes(cor_score_supp[,1],cor_score_supp[,2]))+
  geom_text_repel(aes(cor_score_supp[,1],cor_score_supp[,2],
                      label = names(supp_data))) 

# Correlation circle
cor_loading = cor(pca_wine_cor$x[,1:2],scale(wine[,2:8]))
ggplot() + geom_path(data = data.frame(a = cos(x),b = sin(x)),
                     aes(cos(x),sin(x)),alpha = 0.3, size = 1.5)+
  # geom_point(data = as.data.frame(pca_wine_cor$rotation[,1:2]),
  #            aes(pca_wine_cor$rotation[,1],pca_wine_cor$rotation[,2]))+
  # geom_text_repel(aes(pca_wine_cor$rotation[,1],pca_wine_cor$rotation[,2],
  #                     label = names(wine)[2:8])) +
  geom_hline(yintercept = 0)+geom_vline(xintercept = 0)+
  geom_point(data = as.data.frame(t(cor_loading)),
             aes(cor_loading[1,],cor_loading[2,]))+
  geom_text_repel(aes(cor_loading[1,],cor_loading[2,],
                      label = names(wine)[2:8]))


## Applying varimax
ggplot() + geom_path(data = data.frame(a = cos(x),b = sin(x)),
                     aes(cos(x),sin(x)),alpha = 0.3, size = 1.5)+
  geom_hline(yintercept = 0)+geom_vline(xintercept = 0)+
  geom_point(data = as.data.frame(pca_wine_cor$rotation),
             aes(pca_wine_cor$rotation[,1],pca_wine_cor$rotation[,2]))+
  geom_text_repel(aes(pca_wine_cor$rotation[,1],pca_wine_cor$rotation[,2],
                      label = names(wine)[2:8]))


## French food example
food = read.csv("pca_abdi_food.csv",header = T)
pca_food_cov = prcomp(food[,3:9],scale = F)
cent_food = food[,3:9]-matrix(rep(colMeans(food[,3:9]),times = 12),nrow = 12,
                              byrow = T)
svd_food = svd(cent_food)

## Table 14
# Eigenvalues
(Eigenvalues = (svd_food$d)^2)
# Another way of getting the same result
(Eigenvalues_diff = diag(cov(pca_food_cov$x)*11))
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


# Figure 9
pca_food_cor = prcomp(food[,3:9],scale = T)
x = seq(0,2*pi,length.out = 300)
cor_loading = cor(pca_food_cor$x[,1:2],scale(food[,3:9]))
ggplot() + geom_path(data = data.frame(a = cos(x),b = sin(x)),
                     aes(cos(x),sin(x)),alpha = 0.3, size = 1.5)+
  geom_hline(yintercept = 0)+geom_vline(xintercept = 0)+
  geom_point(data = as.data.frame(t(cor_loading)),
             aes(-cor_loading[1,],-cor_loading[2,]))+
  geom_text_repel(aes(-cor_loading[1,],-cor_loading[2,],
                      label = names(food)[3:9]))

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