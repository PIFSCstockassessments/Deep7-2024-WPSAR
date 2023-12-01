## Script to run Deep7 JABBA model

#packages 
#install.packages("remotes")
install.packages("pacman")
remotes::install_github("PIFSCstockassessments/JABBA", ref="PIFSC-dev")
pacman::p_load(JABBA, quarto, this.path)

main_dir <- this.path::here(..=1)

scenario = "001_Base_case"

if(!dir.exists(file.path(main_dir, "Model", scenario))){
  dir.create(file.path(main_dir, "Model", scenario))
}

jb.params <- read.csv(file.path(main_dir, "Data", "JABBA_inputs.csv"))

### Catch
d7_catch<-read.csv(file.path(main_dir, "Data", "Total_catch_2023.csv")) 
d7_catch$Catch<-d7_catch$Catch/1000000 

### CPUE
d7_cpue <-read.csv(file.path(main_dir, "Data", "CPUE.csv")) 

### SE  
d7_se <- read.csv(file.path(main_dir, "Data", "SE.csv")) 

d7_se_log<-data.frame("Year" = d7_se$Year, "FRS" =  d7_se$FRS/d7_cpue$FRS, "BFISH" = d7_se$BFISH) 
d7_se_log$FRS<-sqrt(log(d7_se_log$FRS*d7_se_log$FRS+1)) 

d7_se_log$BFISH<- sqrt(log(d7_se_log$BFISH*d7_se_log$BFISH+1))


  jbinput = build_jabba(catch=d7_catch,
                        cpue=d7_cpue,se=d7_se_log,
                        assessment="Deep7",scenario = scenario,
                        model.type =jb.params$model.type,
                        add.catch.CV = jb.params$add.catch.cv,
                        catch.cv = jb.params$catch.cv, 
                        catch.error = jb.params$catch.error,
                        catch.adj = c(jb.params$catch.adj.lwr, jb.params$catch.adj.upr),
                        r.prior = c(jb.params$r.prior.mu, jb.params$r.prior.cv),  
                        K.prior=c(jb.params$k.prior.mu, jb.params$k.prior.cv), 
                        psi.prior = c(jb.params$psi.prior.mu, jb.params$psi.prior.cv), 
                        psi.dist = jb.params$psi.prior.dist,
                        sigma.proc=jb.params$sigma.proc,  
                        index_type = c("relative", "relative"),
                        igamma=c(0.001, 0.001),     
                        cpue_lambda=c(jb.params$cpue.lambda.frs, jb.params$cpue.lambda.bfish),
                        sets.var = jb.params$sets.var_1:jb.params$sets.var_2,
                        proc.dev.all = T,               
                        BmsyK = jb.params$BmsyK,  
                        shape.CV = jb.params$shape.cv[[1]], 
                        sigma.est=jb.params$sigma.est,
                        nsig.off.ind = jb.params$nsig.off.ind,
                        fixed.obsE = jb.params$fixed.obsE,
                        sigmaproc_bound = jb.params$sigmaproc_bound,
                        catch.metric = "Million lb",
                        bfrac = jb.params$bfrac,
                        verbose=TRUE)
  
  #fit                      
  fit_test = fit_jabba(jbinput,ni=150000,nt=10,nb=50000,nc=3,verbose=TRUE,
                       save.csvs = TRUE,do.ppc=TRUE,save.all = TRUE,
                       output.dir=file.path(main_dir,"Model",scenario),
                       jagsdir = file.path(main_dir,"Model",scenario)) 

  save(jbinput, file = file.path(main_dir, "Final_Model_Runs", scenario, "jbinput.Rdata"))
  save(fit_test, file = file.path(main_dir, "Final_Model_Runs", scenario, "fit_test.Rdata"))
  
  file.copy(from = file.path(main_dir,"Scripts",
                             "model_summary.qmd"), 
            to = file.path(main_dir, "Model", scenario,
                           "00_model_summary.qmd"),
            overwrite = TRUE)
  
  quarto::quarto_render(
    input = file.path(main_dir, "Model", scenario,
                      "00_model_summary.qmd"),
    output_format = "html",
    execute_params = list(
      scenario = scenario
    ),
    execute_dir = file.path(main_dir,"Model",scenario))
 
### Projections 
proj<-fw_jabba(fit_test,nyears=6,quant="Catch", initial = 0.4170326, 
               type="abs", imp.values=seq(0,2.0,0.01),
               stochastic=TRUE)

kjp <-proj %>%  
  filter(year > 2024) %>% 
  mutate(tac = unlist(str_remove_all(run, "C")))
UCR=1.09 # scalar for unreported catch to reported catch in final years
projyears <- 2025:2029
projTAC<-unique(kjp$tac) #integers for each TAC level
TACs <-  seq(0,2000000,10000) #Catch scenarios in lbs (not million lbs as in imp.values = seq(0,1,.001))
TACkey <- cbind(tac = as.numeric(projTAC), TACs = as.numeric(TACs), reportTAC= as.numeric(TACs/(1+UCR)))

## summarise risks of biomass overfished/overfishing
proj.summary <- 
  kjp %>% 
  data.frame() %>%
  group_by(year, tac) %>%
  dplyr::summarise(n = n(),
                   riskB = sum(stock < 0.867)/n, ## red and yellow #the proportion of iterations that stock was overfished
                   riskF = sum(Overfishing > 1)/n, ##red and orange #the proportion of iterations that stock was overfishing
                   medBBmsy = median(stock), #median B/BMSY values
                   medFFmsy = median(Overfishing), #median F/FMSY
                   ofishedB = medBBmsy * median(fit_test$posteriors$SBmsy),
                   ofishedH = median(harvest)) %>% 
  data.frame() %>%
  merge(.,TACkey, by = "tac", all.y = F) 

