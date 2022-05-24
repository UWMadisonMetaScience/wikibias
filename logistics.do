clear
import delimited "single_gender.csv" // single-authored publications after CEM of country

global field "bhs les pse ssh mcs"
global years "v31 v32 v33 v34 v35 v36 v37 v38 v39 v40 v41 v42 v43"

logistic is_wiki_cited author_1_gender $years [iweight = w], or
est sto at
logistic is_wiki_cited author_1_gender $years [iweight = w] if author_1_sphere == 0, or
est sto a0
logistic is_wiki_cited author_1_gender $years [iweight = w] if author_1_sphere == 1, or
est sto a1
outreg2 [a0 a1 at] using "single_gender_reg_result.xls", replace stats(coef ci) keep(author_1_gender) alpha(0.001, 0.01, 0.05) dec(3) eform excel

foreach var of global field {
	logistic is_wiki_cited author_1_gender $years [iweight = w] if `var'==1, or
	est sto `var'_t
	forvalues i = 0/1 {
		display "******************************"
		display "****    `var'   `i'     ****"
		display "******************************"
		logistic is_wiki_cited author_1_gender $years [iweight = w] if `var'==1 & author_1_sphere == `i', or
		est sto `var'_`i'
	}
	outreg2 [`var'_0 `var'_1 `var'_t] using "single_gender_reg_result.xls", append stats(coef ci) keep(author_1_gender) alpha(0.001, 0.01, 0.05) dec(3) eform excel
}

**************************************

clear
import delimited "single_ctry.csv"
gen is_nonanglo = 0
replace is_nonanglo = 1 if author_1_sphere == 0

global field "bhs les pse ssh mcs"
global years "v31 v32 v33 v34 v35 v36 v37 v38 v39 v40 v41 v42 v43"

logistic is_wiki_cited is_nonanglo $years [iweight = w], or
est sto at
logistic is_wiki_cited is_nonanglo $years [iweight = w] if author_1_gender == 0, or
est sto a0
logistic is_wiki_cited is_nonanglo $years [iweight = w] if author_1_gender == 1, or
est sto a1
outreg2 [a1 a0 at] using "single_ctry_reg_result.xls", replace stats(coef ci) keep(is_nonanglo) alpha(0.001, 0.01, 0.05) dec(3) eform excel

foreach var of global field {
	logistic is_wiki_cited is_nonanglo $years [iweight = w] if `var'==1
	est sto `var'_t
	forvalues i = 0/1 {
		display "******************************"
		display "****    `var'   `i'     ****"
		display "******************************"
		logistic is_wiki_cited is_nonanglo $years [iweight = w] if `var'==1 & author_1_gender == `i'
		est sto `var'_`i'
	}
	outreg2 [`var'_1 `var'_0 `var'_t] using "single_ctry_reg_result.xls", append stats(coef ci) keep(is_nonanglo) alpha(0.001, 0.01, 0.05) dec(3) eform excel
}

**************************************

clear
import delimited "multi_gender.csv"
gen gender_combo = 1
replace gender_combo = -1 if male_male == 1
replace gender_combo = 0 if mix_gender == 1

global field "bhs les pse ssh mcs"
global years "v31 v32 v33 v34 v35 v36 v37 v38 v39 v40 v41 v42 v43"

logit is_wiki_cited mix_gender female_female nb_author $years [iweight = w], or
est sto at
logit is_wiki_cited mix_gender female_female nb_author $years [iweight = w] if other_other == 1, or
est sto a0
logit is_wiki_cited mix_gender female_female nb_author $years [iweight = w] if anglo_anglo == 1, or
est sto a1
logit is_wiki_cited mix_gender female_female nb_author $years [iweight = w] if mix_ctry == 1, or
est sto a2
outreg2 [a0 a1 a2 at] using "multi_gender_reg_result.xls", replace stats(coef ci) keep(mix_gender female_female) alpha(0.001, 0.01, 0.05) dec(3) eform excel

foreach var of global field {
	display "******************************"
	display "****    `var'        ****"
	display "******************************"
	logit is_wiki_cited mix_gender female_female nb_author $years [iweight = w] if `var'==1, or
	est sto `var'_t
	logit is_wiki_cited mix_gender female_female nb_author $years [iweight = w] if `var'==1 & other_other == 1, or
	est sto `var'_0
	logit is_wiki_cited mix_gender female_female nb_author $years [iweight = w] if `var'==1 & anglo_anglo == 1, or
	est sto `var'_1
	logit is_wiki_cited mix_gender female_female nb_author $years [iweight = w] if `var'==1 & mix_ctry == 1, or
	est sto `var'_2
	outreg2 [`var'_0 `var'_1 `var'_2 `var'_t] using "multi_gender_reg_result.xls", append stats(coef ci) keep(mix_gender female_female) alpha(0.001, 0.01, 0.05) dec(3) eform excel
}

**************************************

clear
import delimited "multi_ctry.csv"
gen ctry_combo = 1
replace ctry_combo = -1 if anglo_anglo == 1
replace ctry_combo = 0 if mix_ctry == 1

global field "bhs les pse ssh mcs"
global years "v31 v32 v33 v34 v35 v36 v37 v38 v39 v40 v41 v42 v43"

logit is_wiki_cited mix_ctry other_other nb_author $years [iweight = w], or
est sto at
logit is_wiki_cited mix_ctry other_other nb_author $years [iweight = w] if female_female == 1, or
est sto a0
logit is_wiki_cited mix_ctry other_other nb_author $years [iweight = w] if male_male == 1, or
est sto a1
logit is_wiki_cited mix_ctry other_other nb_author $years [iweight = w] if mix_gender == 1, or
est sto a2
*outreg2 [a0 a1 a2 at] using "multi_ctry_reg_result.xls", replace stats(coef ci) keep(mix_ctry other_other) alpha(0.001, 0.01, 0.05) dec(3) eform excel

foreach var of global field {
	display "******************************"
	display "****    `var'        ****"
	display "******************************"
	logit is_wiki_cited mix_ctry other_other nb_author $years [iweight = w] if `var'==1, or
	est sto `var'_t
	logit is_wiki_cited mix_ctry other_other nb_author $years [iweight = w] if `var'==1 & female_female == 1, or
	est sto `var'_0
	logit is_wiki_cited mix_ctry other_other nb_author $years [iweight = w] if `var'==1 & male_male == 1, or
	est sto `var'_1
	logit is_wiki_cited mix_ctry other_other nb_author $years [iweight = w] if `var'==1 & mix_gender == 1, or
	est sto `var'_2
	*outreg2 [`var'_0 `var'_1 `var'_2 `var'_t] using "multi_ctry_reg_result.xls", append stats(coef ci) keep(mix_ctry other_other) alpha(0.001, 0.01, 0.05) dec(3) eform excel
}