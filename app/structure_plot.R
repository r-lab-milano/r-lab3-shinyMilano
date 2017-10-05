missionValues <- datafin %>% select(ds_missione) %>% unique()

structure_plot <- function(df, annoInput) {
  
  df %>% 
    filter(tipo == "USCITE",
    	anno == annoInput,
           rendiconto != 0) %>% 
    ggplot(aes(x = factor(ds_livello3), 
               y = factor(ds_cdc), 
               fill = log10(rendiconto))) +
    geom_tile() +
    facet_grid(. ~ ds_livello1 + ds_livello2, 
               scales = 'free',
               space = 'free',
               labeller = label_wrap_gen(10)) +
    scale_fill_distiller('Rendiconto', 
                         palette = 'Reds', 
                         direction = 1, 
                         guide = 'legend',
                         breaks = 1:6,
                         labels = c('10 €', '100 €', '1.000 €', '10.000 €', '100.000 €', '1Mil €')
                         ) +
    scale_x_discrete('', labels = function(x) str_wrap(x, width = 25), position = 'top') +
    scale_y_discrete('Centro di costo', labels = function(x) str_wrap(x, width = 25)) +
    ggtitle('Distribuzione del rendiconto') +
    guides(size = NULL) +
    theme_light() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1),
          strip.placement = 'outside'
    )
}


## NOT WORKING
# click_output_rendered <- function(click_pos, df, annoInput) {
#   
#   lev1_pos <- click_pos$panelvar1
#   lev2_pos <- click_pos$panelvar2
#   lev3_pos <- round(click_pos$x)
#   cdc_pos <- round(click_pos$y)
#   
#   res <- df %>% 
#     filter(
#       anno == annoInput, 
#       rendiconto != 0) %>% 
#     arrange(desc(factor(ds_livello3))) %>% 
#     mutate(lev3 = group_indices_(., .dots = 'livello3')) %>% 
#     filter(lev3 == lev3_pos) %>% 
#     arrange(desc(factor(ds_cdc))) %>% 
#     mutate(cdc_group = group_indices_(., .dots = 'cdc')) %>% 
#     filter(cdc_group == cdc_pos) %>%
#     select(ds_livello1, ds_livello2, ds_livello3, ds_cdc, rendiconto) %>% 
#     filter(ds_livello1 == lev1_pos,
#            ds_livello2 == lev2_pos) %>% 
#   group_by(ds_livello1, ds_livello2, ds_livello3, ds_cdc) %>% 
#     summarise(rendiconto = sum(rendiconto)) %>% 
#     as.list()
#   
#   list(lev1 = paste0('Livello 1: ', res$ds_livello1),
#        lev2 = paste0('Livello 2: ', res$ds_livello2),
#        lev3 = paste0('Livello 3: ', res$ds_livello3),
#        cdc = paste0('Centro di Costo:', res$ds_cdc),
#        rend = paste0('Rendiconto: ', res$rendiconto)
#   )
#   
# }