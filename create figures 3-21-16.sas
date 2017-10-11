/*libname defense 'C:\Users\icarlso1\Google Drive\Dissertation';
run;
 
data defense.combinedresults_defense; set defense.combinedresults_defense;
run;

data defense.outmeans_new; set defense.outmeans_new;
run;
*/

libname libF 'F:\Ingrid Dissertation Simulation';
run;

libname defense 'F:\Ingrid Dissertation Simulation\Defense';
run;

data defense.outmeans_new; set libF.outmeans;
if icc ne 4;
run;


data defense.outmeans_new; set defense.outmeans_new;
ratio = jsize_Mean/nsize_Mean;
run;

data defense.outmeans_new; set defense.outmeans_new;
slope_var_rawbias_Mean_new = slope_var_Mean - TRUE_slope_var_Mean;
slope_var_rawbias_Mean_new2 = slope_var_rawbias_Mean;
run;



data defense.outmeans_new; set defense.outmeans_new;
effective = (nsize_Mean*jsize_Mean)/(1+(nsize_Mean-1)*.2);
context_rawbias_Mean_new = context_Mean - TRUE_context_Mean;
run;

proc means data = defense.outmeans_new;
run;

proc format ;
value nformat 	1 = "5"
				2 = "10"
				3 = "20"
				4 = "40"
				5 = "80";

value jformat 	1 = "30"
				2 = "50"
				3 = "100"
				4 = "150"
				5 = "200";

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
					2 = ".20"
					3 = ".50"
					4 = ".60";

value slpformat 	1 = ".05"
					2 = ".10"
					3 = ".15";

run;

data defense.outmeans_new; set defense.outmeans_new;
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




data defense.outmeans_new; set defense.outmeans_new;
label 	nsize = "Level 1 units (t)"
		jsize = "Level 2 units (i)"
		icc = "ICCx"
		btwn = "Level-2 effect"
		win = "Level-1 effect"
		slp = "Slope Variance"

		effective = "Effective sample size"
		slope_var_rawbias_Mean = "Raw bias of slope variance"
		context_rawbias_Mean = "Raw bias of contextual effect"
		context_std_rawbias_Mean = "Raw bias of standardized contextual effect"

		slope_var_biasstd_Mean = "Standardized bias of slope variance"
		context_biasstd_Mean = "Standardized bias of contextual effect"
		context_std_biasstd_Mean = "Standardized bias of standardized contextual effect"

		slope_var_RMSE_Mean = "Slope variance RMSE"
		context_RMSE_Mean = "Contextual effect RMSE"
		context_std_RMSE_Mean = "Standardized contextual effect RMSE"

		slope_var_coverage_Mean = "Slope variance coverage"
		context_coverage_Mean = "Contextual effect coverage"

		slope_var_sig_Mean = "Slope variance power"
		context_sig_Mean = "Contextual effect power"

		context_typeI_Mean = "Contextual effect Type I error"
		TRUE_context_Mean = "Contextual effect size"

		context_diff_Mean = "Standardized and unstandardized contextual effect difference";
format 	nsize nformat.
		jsize jformat.
		btwn btwnformat.
		win winformat.
		icc iccformat.
		slp slpformat.;
	  run;




data defense.combinedresults_defense;
length Dependent $ 30;
 set defense.combinedresults_defense;
if Dependent = 'context_RMSE_mean' then Dependent = 'context_RMSE_Mean';
if Dependent = 'context_std_RMSE_mean' then Dependent = 'context_std_RMSE_Mean';
if Dependent = 'slope_var_RMSE_mean' then Dependent = 'slope_var_RMSE_Mean';
if Dependent = 'context_std_rawbias_Me' then Dependent = 'context_std_rawbias_Mean';
if Dependent = 'context_std_relbias_Me' then Dependent = 'context_std_relbias_Mean';
if Dependent = 'slope_var_coverage_Mea' then Dependent = 'slope_var_coverage_Mean';
if Dependent = 'context_diff_Mea' then Dependent = 'context_diff_Mean';
if Dependent = 'context_typeI_Me' then Dependent = 'context_typeI_Mean';
if Dependent = 'context_coverage_Mea' then Dependent = 'context_coverage_Mean';
if Dependent = 'context_std_biasstd_Me' then Dependent = 'context_std_biasstd_Mean';
run;

data defense.combinedresults05; set defense.combinedresults_defense;
if etasq ge .05;
run;

data defense.combinedresults07; set defense.combinedresults_defense;
if etasq ge .07;
run;

data defense.combinedresults10; set defense.combinedresults_defense;
if etasq ge .10;
run;

/*this works*/
data defense.factors; set defense.combinedresults10;
n = index(Source,'n');
j = index(Source,'j');
btwn=index(Source,'btwn');
win=index(Source,'win');
icc=index(Source,'icc');
slp=index(Source,'slp');
run;

data defense.factors; set defense.factors;
if n ne 1 then n = 0;
if j ge 1 then j = 1;
if btwn ge 1 then btwn = 1;
if win ge 1 then win = 1;
if icc ge 1 then icc = 1;
if slp ge 1 then slp = 1;
keep Dependent Source n j btwn win icc slp ;
run;

proc sort data= defense.factors OUT=defense.factors;
by Dependent;
run;
/*Create dataset with group means*/

proc means data = defense.factors noprint;
by Dependent ;
output out=defense.factors_matrix max=  ;
run;

data defense.factors_matrix; set defense.factors_matrix;
num_levels = sum(n, j, btwn, win, icc, slp);
run;

data defense.factors_matrix; set defense.factors_matrix;

if j = 1 then  level1 = 'jsize ';
if n = 1 then  level2 = 'nsize ';
if slp = 1 then  level4 = 'slp ';
if icc = 1 then  level3 = 'icc ';
if win = 1 then  level5 = 'win ';
if btwn = 1 then  level6 = 'btwn ' ;
levels = level1||level2||level3||level4||level5||level6;
factor1=scan(levels,1);
factor2=scan(levels,2);
factor3=scan(levels,3);
factor4=scan(levels,4);
factor5=scan(levels,5);
factor6=scan(levels,6);
run;



%modstyle(parent=statistical, name=regressionst,type=CLM,
colors=black , fillcolors=colors,
markers=circle,
linestyles=mediumdashdotdot solid shortdashdot dot longdash);
ods html style = regressionst;

ods graphics on /width = 8.75in;
ods graphics on /height = 5.25in;

/*make tables based on sim factors with largest eta squared*/
OPTIONS MLOGIC MPRINT SYMBOLGEN;
%macro figures;

%do outcomes1 = 1 %to 3;
	%if &outcomes1 = 3 %then %let o2 = 3;
	%if &outcomes1 = 2 %then %let o2 = 7;
	%if &outcomes1 = 1 %then %let o2 = 5;
	%if &outcomes1 ge 4 %then %let o2 = 6;
	%if &outcomes1 ge 4 %then %let o1 = 6;
		%else %let o1 = 1;

	%do outcomes2 = &o1 %to &o2;


		%if &outcomes1 = 1 %then %let dv1 = slope_var;
		%if &outcomes1 = 2 %then %let dv1 = context;
		%if &outcomes1 = 3 %then %let dv1 = context_std;
		%if &outcomes1 = 4 %then %let dv1 = between;
		%if &outcomes1 = 5 %then %let dv1 = within;

		%if &outcomes2 = 1 %then %let dv2 = rawbias ;
		%if &outcomes2 = 2 %then %let dv2 = biasstd;
		%if &outcomes2 = 3 %then %let dv2 = RMSE;
		%if &outcomes2 = 4 %then %let dv2 = coverage;
		%if &outcomes2 = 5 %then %let dv2 = sig;
		%if &outcomes2 = 6 %then %let dv2 = typeI;
		%if &outcomes2 = 7 %then %let dv2 = diff;

		data &dv1._&dv2._mean; set defense.factors_matrix;
			if Dependent= "&dv1._&dv2._Mean";
			run;

			data _NULL_; set &dv1._&dv2._mean;
			call symput("fac1",factor1);
			call symput("fac2",factor2);
			call symput("fac3",factor3);
			call symput("fac4",factor4);
			call symput("fac5",factor5);
			call symput("fac6",factor6);
			call symput("levels",num_levels);

			run;

			%if (&outcomes2 = 4) or (&outcomes2 = 5) or (&outcomes2 =6) or (&outcomes2 = 6) or (&outcomes2 = 2) %then %do;
			data defense.outmeans_new;
			   set defense.outmeans_new;
			    &dv1._&dv2._Mean = &dv1._&dv2._Mean / 100; /* adjust range to [0, 1] */
			   format &dv1._&dv2._Mean PERCENT5.;
			run;
			%end;
				
		%if &levels gt 1 %then %let comma = ,;
			%else %let comma = ;
		%if &levels gt 2 %then %let ast1 = *;
			%else %let ast1 = ;
		%if &levels gt 3 %then %let ast2 = *;
			%else %let ast2 =;

		%if &outcomes2 = 1 or &outcomes2 = 3  or &outcomes2 = 7 %then %let format = 5.3;
			%else %let format = 5.1;


		%if &levels le 3 and &outcomes2 ne 3 %then %do;
			%if &levels ge 2 %then %let plot = sgpanel;
				%else %let plot = sgplot;

			%if &levels lt 3 %then %let layout = columnlattice;
			%if &levels ge 3 %then %let layout = lattice;

			%if &levels ge 2 %then %let panelby = 
				%str(panelby &fac2 &fac3/ layout=&layout onepanel rowheaderpos=right;);
				%else %let panelby =;

			%if &levels ne 1 %then %let vline = %str(vbar &fac1/response=&dv1._&dv2._Mean stat=mean;);
				%else %let vline = %str(vbar &fac1/response=&dv1._&dv2._Mean stat=mean;);

		%end;

		%else %do;
			%if &levels gt 2 %then %let plot = sgpanel;
				%else %let plot = sgplot;

			%if &levels le 3 %then %let layout = columnlattice;
			%if &levels gt 3 %then %let layout = lattice;

			%if &levels gt 2 %then %let panelby = 
				%str(panelby &fac3 &fac4/ layout=&layout onepanel rowheaderpos=right;);
				%else %let panelby =;

			%if &levels ne 1 %then %let vline = %str(vline &fac2/response=&dv1._&dv2._Mean group=&fac1 stat=mean;);
				%else %let vline = %str(vline &fac1/response=&dv1._&dv2._Mean stat=mean;);
		%end;
			

	
			 %if &outcomes2 = 2 %then %let refline = %str(refline .40 -40;);
				%else %if &outcomes2 = 4 %then %let refline = %str(refline .90;);
					%else %if &outcomes2 = 5 %then %let refline = %str(refline .80;);
						%else %if &outcomes2 = 6 %then %let refline = %str(refline .075;);
							%else %let refline = ;

			

		%if &levels lt 5 %then %do;

			title1;
			proc &plot data =defense.outmeans_new;
			&panelby 
			&vline
			&refline
			run;
/*
			proc tabulate data=defense.outmeans_new
			format= &format;
			class &fac3 &fac2 &fac4 &fac1;
			var &dv1._&dv2._Mean;
			table &fac3 &ast1 &fac1*&dv1._&dv2._Mean=""*mean=''&comma
			&fac4 &ast2 &fac2;
			run;*/

		%end;

		
	%end;
%end;

%mend figures;
%figures;	

/*CE power by CE effect size*/

			data defense.outmeans_new;
			   set defense.outmeans_new;
			    context_sig_Mean = context_sig_Mean / 100; /* adjust range to [0, 1] */
			   format context_sig_Mean PERCENT5.;
			run;

title1 ;
proc sgplot data =defense.outmeans_new;
vbar TRUE_context_mean/response =context_sig_Mean stat=mean;
run;

/*make tables for specific hypotheses*/
%macro tables2;

%do outcomes1 = 1 %to 4;
	%if &outcomes1 = 1 %then %let o2 = 4;
	%if &outcomes1 ge 2 %then %let o2 = 1;

	%do outcomes2 = 1 %to 4;

		%if &outcomes1 = 1 %then %let dv1 = context;
		%if &outcomes1 = 2 %then %let dv1 = between;
		%if &outcomes1 = 3 %then %let dv1 = within;
		%if &outcomes1 = 4 %then %let dv1 = slope_var;

		%if &outcomes2 = 1 %then %let dv2 = sig;
		%if &outcomes2 = 2 %then %let dv2 = rawbias;
		%if &outcomes2 = 3 %then %let dv2 = coverage;
		%if &outcomes2 = 4 %then %let dv2 = typeI;

		%do factor = 1 %to 4;

			%if &factor = 1 %then %let fac = win;
			%if &factor = 2 %then %let fac = btwn;			
			%if &factor = 3 %then %let fac = slp;
			%if &factor = 4 %then %let fac = icc;

			title1 "&dv1. &dv2.";
			/*proc sgplot data =defense.outmeans_new;
			*panelby win / layout=columnlattic onepanel rowheaderpos=right;
			vbar &fac/response=&dv1._&dv2._Mean stat=mean;
			run;*/

			proc tabulate data=defense.outmeans_new
			format= 5.3;
			class &fac;
			var &dv1._&dv2._Mean;
			table &fac*&dv1._&dv2._Mean=""*mean='';
			run;

		%end;



	%end;
%end;

%do outcomes1 = 1 %to 4;

	%do outcomes2 = 1 %to 2;

		%if &outcomes1 = 1 %then %let dv1 = between;
		%if &outcomes1 = 2 %then %let dv1 = within;
		%if &outcomes1 = 3 %then %let dv1 = context;
		%if &outcomes1 = 4 %then %let dv1 = slope_var;

		%if &outcomes2 = 1 %then %let dv2 = sig;
		%if &outcomes2 = 2 %then %let dv2 = typeI;

			title1 "&dv1. &dv2.";
			proc tabulate data=defense.outmeans_new
			format= 5.3;
			class nsize jsize;
			var &dv1._&dv2._Mean;
			table jsize*&dv1._&dv2._Mean=""*mean='',nsize;
			run;

	%end;
%end;

%do outcomes1 = 1 %to 2;
	%do outcomes2 = 1 %to 3;

		%if &outcomes1 = 1 %then %let dv1 = slope_var;
		%if &outcomes1 = 2 %then %let dv1 = context;

		%if &outcomes2 = 1 %then %let dv2 = sig;
		%if &outcomes2 = 2 %then %let dv2 = coverage;
		%if &outcomes2 = 3 %then %let dv2 = typeI;

			title1 "&dv1. &dv2.";
			proc tabulate data=defense.outmeans_new
			format= 5.3;
			class icc jsize;
			var &dv1._&dv2._Mean;
			table jsize*&dv1._&dv2._Mean=""*mean='',icc;
			run;

	%end;
%end;

			title1 "contextual rawbias";
			proc tabulate data=defense.outmeans_new
			format= 5.3;
			class nsize;
			var context_rawbias_Mean;
			table nsize*context_rawbias_Mean=""*mean='';
			run;


			title1 "contextual biasstd";
			proc tabulate data=defense.outmeans_new
			format= 5.3;
			class btwn win nsize;
			var context_biasstd_Mean;
			table nsize*btwn*context_biasstd_Mean=""*mean='',win;
			run;


						title1 "contextual biasstd";
			proc tabulate data=defense.outmeans_new
			format= 5.3;
			class btwn win;
			var context_rawbias_Mean;
			table btwn*context_rawbias_Mean=""*mean='',win;
			run;




%mend tables2;
%tables2;

title1 "contextual rawbias";
proc tabulate data=defense.outmeans_new
format= 5.3;
class btwn win;
var context_rawbias_Mean;
table btwn*context_rawbias_Mean=""*mean='',win;
run;

title1 "contextual relbias";
proc tabulate data=defense.outmeans_new
format= 5.3;
class btwn win;
var context_relbias_Mean;
table btwn*context_relbias_Mean=""*mean='',win;
run;

title1 "contextual stdbias";
proc tabulate data=defense.outmeans_new
format= 5.3;
class btwn win;
var context_biasstd_Mean;
table btwn*context_biasstd_Mean=""*mean='',win;
run;


/*make tables for when bias, coverage, power, etc are above or below a certain threshold*/
%macro tables3;

%do outcomes1 = 1 %to 3;
	%if &outcomes1 = 1 %then %let o2 = 3;	
	%if &outcomes1 = 2 %then %let o2 = 4;
	%if &outcomes1 = 3 %then %let o2 = 1;

	%do outcomes2 = 1 %to &o2;


		%if &outcomes1 = 1 %then %let dv1 = slope_var;
		%if &outcomes1 = 2 %then %let dv1 = context;
		%if &outcomes1 = 3 %then %let dv1 = context_std;

		%if &outcomes2 = 1 %then %let dv2 = biasstd;
		%if &outcomes2 = 2 %then %let dv2 = coverage;
		%if &outcomes2 = 3 %then %let dv2 = sig;
		%if &outcomes2 = 4 %then %let dv2 = typeI;


		%if &outcomes2 = 5 %then %let cutoff = %str(ge 10 or &dv1._&dv2._Mean le -10);
			%else %if &outcomes2 = 1 %then %let cutoff = %str(ge 40 or &dv1._&dv2._Mean le -40);
				%else %if &outcomes2 = 2 %then %let cutoff = %str(gt 95);
					%else %if &outcomes2 = 3 %then %let cutoff = %str(gt 80);
						%else %if &outcomes2 = 4 %then %let cutoff = %str(le 7.5 and &dv1._&dv2._Mean ge 2.5);


							data &dv1._&dv2._data; set defense.outmeans_new;
							if &dv1._&dv2._Mean &cutoff;
							if &dv1._&dv2._Mean ne .;
							run;

							proc sort data=&dv1._&dv2._data;
							by btwn win icc nsize jsize slp;
							run;

							title1 "&dv1. &dv2.";
							proc tabulate data=&dv1._&dv2._data;
							class nsize jsize btwn win icc slp;
							var &dv1._&dv2._Mean;
							table btwn *win *icc *&dv1._&dv2._Mean=""*mean='',nsize *jsize*slp
							;
							run;
	%end;
%end;

%mend tables3;
%tables3;



/*std bias of std CE interaction explain */

title1 "std effect explain";
proc sgpanel data =defense.outmeans_new;
panelby  icc /layout=columnlattice onepanel rowheaderpos=right;
vbar btwn/response =context_std_biasstd_Mean stat=mean;
run;

title1 "std effect explain";
proc sgplot data =defense.outmeans_new;
vbar btwn/response =context_std_biasstd_Mean stat=mean;
run;

title1 "std effect explain";
proc sgplot data =defense.outmeans_new;
vbar icc/response =context_std_biasstd_Mean stat=mean;
run;

title1 "std effect explain";
proc sgplot data =defense.outmeans_new;
vbar nsize/response =context_std_biasstd_Mean stat=mean;
run;

/*raw bias of  CE interaction explain */

title1 "std effect explain";
proc sgpanel data =defense.outmeans_new;
panelby  nsize /layout=columnlattice onepanel rowheaderpos=right;
vbar jsize/response =context_rawbias_Mean stat=mean;
run;

title1 "std effect explain";
proc sgplot data =defense.outmeans_new;
vbar jsize/response =context_rawbias_Mean stat=mean;
run;

title1 "std effect explain";
proc sgplot data =defense.outmeans_new;
vbar nsize/response =context_rawbias_Mean stat=mean;
run;

/*effective sample size tables*/

title1 "Contextual effect raw bias";
proc sgplot data =defense.outmeans_new;
vbar effective/response =context_rawbias_Mean stat=mean;
run;

title1 "Contextual effect raw bias";
proc sgplot data =defense.outmeans_new;
vbar effective/response =between_rawbias_Mean stat=mean;
run;

title1 "Contextual effect raw bias";
proc sgplot data =defense.outmeans_new;
vbar effective/response =context_relbias_Mean stat=mean;
run;

title1 "Contextual effect raw bias";
proc sgplot data =defense.outmeans_new;
vbar ratio/response =context_relbias_Mean stat=mean;
run;

title1 "Contextual effect raw bias";
proc sgplot data =defense.outmeans_new;
vbar effective/response =within_rawbias_Mean stat=mean;
run;

title1 ;
proc sgplot data =defense.outmeans_new;
vbar effective/response =slope_var_coverage_Mean stat=mean;
run;

title1 "Contextual effect raw bias";
proc sgplot data =defense.outmeans_new;
vbar ratio/response =within_rawbias_Mean stat=mean;
run;

title1 "Contextual effect raw bias";
proc sgpanel data =defense.outmeans_new;
panelby  nsize/layout=columnlattice onepanel rowheaderpos=right;;
vbar jsize/response =within_rawbias_Mean stat=mean;
run;

title1 "Contextual effect raw bias";
proc sgpanel data =defense.outmeans_new;
panelby  nsize/layout=columnlattice onepanel rowheaderpos=right;;
vbar jsize/response =between_rawbias_Mean stat=mean;
run;

title1 "Contextual effect raw bias";
proc sgpanel data =defense.outmeans_new;
panelby  nsize/layout=columnlattice onepanel rowheaderpos=right;;
vbar jsize/response =context_relbias_Mean stat=mean;
run;


title1 "Contextual effect raw bias";
proc sgplot data =defense.outmeans_new;
vbar ratio/response =context_rawbias_Mean stat=mean;
run;

title1 "Contextual effect raw bias";
proc sgpanel data =defense.outmeans_new;
panelby  icc/layout=columnlattice onepanel rowheaderpos=right;;
vbar ratio/response =context_rawbias_Mean stat=mean;
run;


title1 "Slope Variance Coverage";
proc sgplot data =defense.outmeans_new;
vbar nsize/response =slope_var_coverage_Mean stat=mean;
run;

title1 "Slope Variance Coverage";
proc sgplot data =defense.outmeans_new;
vbar jsize/response =slope_var_coverage_Mean stat=mean;
run;


title1 "Slope Variance Coverage";
proc sgpanel data =defense.outmeans_new;
panelby  icc/layout=columnlattice onepanel rowheaderpos=right;
vbar ratio/response =slope_var_coverage_Mean stat=mean;
run;

title1 "Contextual effect raw bias";
proc sgpanel data =defense.outmeans_new;
panelby  nsize icc/layout=lattice onepanel rowheaderpos=right;;
vbar jsize/response =context_rawbias_Mean stat=mean;
run;

title1 "Contextual effect rel bias";
proc sgpanel data =defense.outmeans_new;
panelby  nsize icc/layout=lattice onepanel rowheaderpos=right;;
vbar jsize/response =context_relbias_Mean stat=mean;
run;
********************;
proc sort data=defense.outmeans_new out=defense.contextstd;
by TRUE_context_std_Mean nsize jsize slp;
run;

			title1 "true context";
			proc tabulate data=defense.contextstd;
			class TRUE_context_std_Mean nsize jsize slp;
			var context_std_relbias_Mean;
			table TRUE_context_std_Mean*context_std_relbias_Mean=""*mean='',
			nsize *jsize *slp;
			run;

/*bar charts*/
proc sgpanel data =defense.outmeans_new;
panelby j/rows=1 columns=5;
vbar icc/response=context_RMSE_mean;
run;

proc sgpanel data =defense.outmeans_new;
panelby n j /rows=5 columns=5;
vbar slp/response=slope_var_rawbias_mean;
run;

/*line plots*/
proc sgpanel data =defense.outmeans_new;
panelby n j /rows=5 columns=5;
vline icc/response=slope_var_rawbias_mean group=slp;
run;

/*box plots*/

proc sgpanel data =defense.exp1_alldata_working;
panelby n j /rows=5 columns=5;
vbox slope_var_rawbias /category=slp;
run;


		proc sgpanel data =defense.outmeans_new;
		panelby n j /layout=lattice onepanel rowheaderpos=right ;
		vline icc/response=slope_var_relbias_mean group=slp;
		run;

		proc sort data=defense.combinedresults;
		by Dependent omegasq;
		run;

		proc print data=defense.combinedresults;
		run;


		proc sgpanel data =defense.exp1_working_new;
panelby btwn win /rows=5 columns=5;
vbox context_rawbias;
run;


		proc sgplot data =defense.exp1_working_new;
vbox context_rawbias;
run;

proc tabulate data =defense.exp1_working_new;
class  btwn win;
var context_rawbias;
table btwn*context_rawbias=""*mean='',
win;
run;
