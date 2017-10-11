

%macro ANOVA;

%do outcomes1 = 4 %to 4;
	%do outcomes2 = 5 %to 5;

	%if &outcomes1 = 4 %then %let dv1 = between;

		%if &outcomes2 = 5 %then %let dv2 = sig;

		proc glm data=defense.outmeans_new;
			class n j btwn win icc slp;
		    model &dv1._&dv2._Mean = n|j|btwn|win|icc|slp@4 /SS3;
			ods output ModelANOVA=defense.glm&outcomes1._&outcomes2. OverallANOVA=defense.overall&outcomes1._&outcomes2.;
		run;
		

		data defense.overallE&outcomes1._&outcomes2.;
		set defense.overall&outcomes1._&outcomes2.;
		if Source = "Error";
		MSe = MS;
		keep Dependent MSe;
		run; 

		data defense.overallT&outcomes1._&outcomes2.;
		set defense.overall&outcomes1._&outcomes2.;
		if Source = "Corrected Total";
		SSt = SS;
		keep Dependent SSt;
		run; 



		data defense.results&outcomes1._&outcomes2.;
		merge defense.glm&outcomes1._&outcomes2. defense.overallE&outcomes1._&outcomes2. defense.overallT&outcomes1._&outcomes2.;
		by Dependent;
		run;


		data defense.results&outcomes1._&outcomes2.;
		set defense.results&outcomes1._&outcomes2.;
		etasq = SS/SSt;
		omegasq = (SS-MSe)/(SSt+MSe);
		run;

	%end;
%end;

%mend ANOVA;
%ANOVA;
