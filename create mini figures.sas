libname libG 'C:\Users\icarlso1\Google Drive\Dissertation';
run;
/* */
data libG.exp1_mini5; set libF.exp1_mini5;
run;

proc sort data = libG.exp1_mini5;
by n j btwn win icc slp ;
run;

proc means data = libG.exp1_mini5; 
by n j btwn win icc slp ;
output out=libG.outmeans_mini5 mean=  /autoname;
run;

proc format ;
value nformat 	1 = "5"
				4 = "40";

value jformat 	1 = "30"
				2 = "50";

value btwnformat 	1 = "-.59"
					2 = "-.14"
					3 = "0"
					4 = ".14"
					5 = ".59";

value winformat 	1 = "-.59"
					2 = "-.14"
					3 = "0"
					4 = ".14"
					5 = ".59";

value iccformat 	1 = ".10"
					
					3 = ".50"
					;

value slpformat 	1 = ".05"
					
					3 = ".15";

run;

data libG.exp1_mini5; set libG.exp1_mini5;
label 	nsize = "t"
		jsize = "i"
		icc = "ICCx"
		btwn = "btwn"
		win = "win"
		slp = "slope";
format 	nsize nformat.
		jsize jformat.
		btwn btwnformat.
		win winformat.
		icc iccformat.
		slp slpformat.;
	  run;




data libG.exp1_mini5; set libG.exp1_mini5;
label 	nsize = "No. (t) of Level 1 units"
		jsize = "No. (i) of Level 2 units"
		icc = "ICCx"
		btwn = "Level-2 effect"
		win = "Level-1 effect"
		slp = "Slope Variance (t211)"
		TRUE_context = "Contextual Effect"

				slope_var_coverage = "Slope variance coverage"
		context_coverage = "Contextual effect coverage"

		slope_var_sig = "Slope variance power"
		context_sig= "Contextual effect power"

		context_typeI = "Contextual effect Type I error"

		context_diff = "Standardized and unstandardized contextual effect difference";
format 	nsize nformat.
		jsize jformat.
		btwn btwnformat.
		win winformat.
		icc iccformat.
		slp slpformat.;
		run;

		**do this only once;
		/*
data libG.exp1_mini5; set libG.exp1_mini5;
slope_var_relbias = slope_var_relbias*100;
context_relbias = context_relbias*100;
context_std_relbias = context_std_relbias*100;

slope_var_coverage = slope_var_coverage*100;
context_coverage = context_coverage*100;

slope_var_sig = slope_var_sig*100;
context_sig = context_sig*100;
within_sig = within_sig*100;
between_sig = between_sig*100;

context_typeI = context_typeI*100;
within_typeI = within_typeI*100;
between_typeI = between_typeI*100;

	  run;*/


%modstyle(parent=statistical, name=regressionst,type=CLM,
colors=black , fillcolors=colors,
markers=circle,
linestyles=mediumdashdotdot solid shortdashdot dot longdash);
ods html style = regressionst;

ods graphics on /width = 10in;
ods graphics on /height = 7.5in;

/*make tables based on sim factors with largest eta squared*/
OPTIONS MLOGIC MPRINT SYMBOLGEN;
%macro figures;

%do outcomes1 = 1 %to 2;

	%do outcomes2 = 1 %to 2;


		%if &outcomes1 = 1 %then %let dv1 = slope_var;
		%if &outcomes1 = 2 %then %let dv1 = context;

		%if &outcomes2 = 1 %then %let dv2 = coverage;
		%if &outcomes2 = 2 %then %let dv2 = sig;

			title1 "&dv1. &dv2";
			proc tabulate data=libG.exp1_mini5
			format= 6.4;
			class nsize jsize TRUE_context icc slp;
			var &dv1._&dv2.;
			table  nsize *TRUE_context*&dv1._&dv2.=""*mean='',jsize *icc*slp
			;
			run;


	%end;
%end;
			title1 "Context type I";
			proc tabulate data=libG.exp1_mini5;
			format= 5.3;
			class nsize jsize icc slp;
			var context_TypeI;
			table nsize *jsize *context_TypeI=""*mean='',icc*slp
			;
			run;

%mend figures;
%figures;	



proc sort data=libG.outmeans out=libG.contextstd;
by TRUE_context_std_Mean nsize jsize slp;
run;

			title1 "true context";
			proc tabulate data=libG.contextstd;
			class TRUE_context_std_Mean nsize jsize slp;
			var context_std_relbias_Mean;
			table TRUE_context_std_Mean*context_std_relbias_Mean=""*mean='',
			nsize *jsize *slp;
			run;

/*bar charts*/
proc sgpanel data =libG.outmeans;
panelby j/rows=1 columns=5;
vbar icc/response=context_RMSE_mean;
run;

proc sgpanel data =libG.outmeans;
panelby n j /rows=5 columns=5;
vbar slp/response=slope_var_rawbias_mean;
run;

/*line plots*/
proc sgpanel data =libG.outmeans;
panelby n j /rows=5 columns=5;
vline icc/response=slope_var_rawbias_mean group=slp;
run;

/*box plots*/

proc sgpanel data =libG.exp1_alldata_working;
panelby n j /rows=5 columns=5;
vbox slope_var_rawbias /category=slp;
run;


		proc sgpanel data =libG.outmeans;
		panelby n j /layout=lattice onepanel rowheaderpos=right ;
		vline icc/response=slope_var_relbias_mean group=slp;
		run;

		proc sort data=libG.combinedresults;
		by Dependent omegasq;
		run;

		proc print data=libG.combinedresults;
		run;
