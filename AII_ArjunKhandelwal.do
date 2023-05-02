*panel data definition and new variables*
xtset pair_num year
generate lngdp_o = ln(GDP_o)
generate lngdp_d = ln(GDP_d)
generate lnexp_od = ln(Export_od)

encode Income_Group_o, gen(IG_o)
encode Income_Group_d, gen(IG_d)

*The Conventional Gravity Model*

*OLS Regression*
reg lnexp_od lngdp_o lngdp_d distance,robust

*LSDV Regression*
reg lnexp_od lngdp_o lngdp_d distance i.pair_num
estimates store LSDV_Basic

*Fixed Effects Regression*
xtreg lnexp_od lngdp_o lngdp_d distance, fe
estimates store FE_Basic

*Comparing Fixed and LSDV*
estimates table LSDV_Basic FE_Basic, star stats(N r2 r2_a)

*Random Effects Regression*
xtreg lnexp_od lngdp_o lngdp_d distance, re
estimates store RE_Basic

*Hausman Test*
hausman FE_Basic RE_Basic

*Testing for Time-Fixed Effects*
xtreg lnexp_od lngdp_o lngdp_d distance i.year, fe
testparm i.year

*Random Fixed Effects*
xtreg lnexp_od lngdp_o lngdp_d distance, re
xttest0


*Augmented Gravity Model*

*OLS Regression*
reg lnexp_od lngdp_o lngdp_d distance i.IG_o#member_wto_o agree_fta i.year#member_wto_joint

*LSDV Regression*
reg lnexp_od lngdp_o lngdp_d distance i.IG_o#member_wto_o agree_fta i.year#member_wto_joint i.pair_num
estimates store LSDV_Augmented

*Fixed Effects Regression*
xtreg lnexp_od lngdp_o lngdp_d distance i.IG_o#member_wto_o agree_fta i.year#member_wto_joint, fe
estimates store FE_Augmented

*Comparision Table*
estimates table LSDV_Augmented FE_Augmented, star stats(N r2 r2_a)

*Random Effects Regression*
xtreg lnexp_od lngdp_o lngdp_d distance i.IG_o#member_wto_o agree_fta i.year#member_wto_joint, re
estimates store RE_Augmented

*Hausman Test*
hausman FE_Augmented RE_Augmented

*Time-Fixed Effects*
xtreg lnexp_od lngdp_o lngdp_d distance i.IG_o#member_wto_o agree_fta i.year#member_wto_joint i.year, fe
testparm i.year

*Random Effects*
xtreg lnexp_od lngdp_o lngdp_d distance i.IG_o#member_wto_o agree_fta i.year#member_wto_joint, re
xttest0
