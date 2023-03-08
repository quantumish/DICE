
# AMPL mod-file for H�nsel et.al (2020): "Climate economics support for the UN climate targets"
# when using the code the article needs to be cited
# Modified by David (hi)

# PARAMETERS
#Time horizon   
param T:=100;    
param nruns;

#######

# FIXME Ecum as CumC is likely invalid


# ENTICE-2020

# named constant signifying i know this param exists but no idea what its value is
param IDK_THE_VALUE:=0;
# named constant signifying this is a parameter but idk how to choose it
param IDK_A_GOOD_VALUE:=0;

# NOTE we're using base parameters

# percentage of exogenous reductions in carbon intensity remaining
param alpha_phi:=0.8;
# scaling factor for the effect of this human capital
param alpha_H:=0.336;
# substitution parameter between energy/knowledge. rho_H <= 1
param rho_H:=0.38;


# rate of knowledge decay (<= 1)
param delta_H := 0;

# energy R&D spending
var R_E {t in 0..T}>=0;
let R_E[0]:=10^9;

# invention possibilities frontier constants
param a:=0.02961;
param b:=0.2;
param phi:=0.55;

# knowledge stock
param H_E{t in 0..T}>=0;
let H_E[0]:=0.0001; # must be >0
let {t in 1..T} H_E[t]:=a*(R_E[t]^b)*(H_E[t-1]) + ((1-delta_H)*H_E[t-1]); # TODO: H_E[t-1] incorrect

# the (negative) growth rate of Phi_t per decade
param g_t_z:=-15.49;
# the rate of decline of g_t_z
param delta_z:=23.96;
# the ratio of carbon emissions per unit of carbon services
param Phi {t in 0..T}:=exp(((g_t_z)/(delta_z)) * (1-exp(-delta_z*t)));

# percentage of other R&D crowded out by energy R&D
param crowdout:=0.5;

#######


# Preferences
# delete this line for obtaining just the Nordhaus optimal policy
# param etas {1..nruns}; 

# inequality aversion: under Nordhaus optimal policy substitute by: param eta:=1.45; for median expert: param eta:=1.0000001;
param eta:=1.0000001; 

# delete this line for obtaining just the Nordhaus optimal policy
# param rhos {1..nruns}; 

# pure time preference: under Nordhaus optimal policy substitute by: param rho:=0.015; for median expert:param rho:=0.005; 
param rho:=0.005; 

# discount factor
param R {t in 0..T}:=1/((1+rho)^(5*t));

# Population and its dynamics, including assumption on asymptotic population of 11500 millions
param L0:=7403; 				#initial world population 2015 (millions)
param gL0:=0.134; 				#growth rate to calibrate to 2050 pop projection
param L {t in 0..T}>=0; 
let L[0]:=L0;
let {t in 1..T} L[t]:=L[t-1]*((11500/L[t-1])^gL0);

# Technology and its dynamics
param gamma:=0.3;  				#capital elasticity in production function
param deltaK:=0.100; 			#depreciation rate on capital (per year)
param Qgross0:=105.5; 			#Initial world gross output 2015 (trill 2010 USD)
param K0:=223; 					#initial capital value 2015 (trillions 2010 USD)
param A0:=5.115; 				#initial level of total factor productivity
param gA0:=0.076; 				#initial growth rate for TFP per 5 years
param deltaA:=0.005; 			#decline rate of TFP per 5 years

param gA {t in 0..T}>=0;
let {t in 0..T} gA[t]:=gA0*exp(-deltaA*5*(t));

param A {t in 0..T}>=0;
let A[0]:=A0;
let {t in 1..T} A[t]:=A[t-1]/(1-gA[t-1]);

# Emission parameters, where sigma is the carbon intensity or CO2-output ratio
param gsigma0:=-0.0152;	#initial growth of sigma (coninuous per year ), 
param deltasigma:=-0.001; #decline rate of decarbonization per period
param ELand0:=2.6; #initial Carbon emissions from land 2015 (GtCO2 per period)
param deltaLand:=0.115; #decline rate of land emissions (per period)
param EInd0:=35.85; #industrial emissions 2015 (GtCO2 per year)
param Ecum0:=400; #initial cumulative emissions (GtCO2)
param mu0:=.03; #initial emissions control rate for base year 2010; under BAU: 0.00
param Lambda0:=0; #initial abatement costs
param sigma0:=EInd0/(Qgross0*(1-mu0));#initial sigma (kgCO2 per output)

param gsigma {t in 0..T};
let gsigma[0]:=gsigma0;
let {t in 1..T} gsigma[t]:=gsigma[t-1]*((1+deltasigma)^5);

param sigma {t in 0..T}>=0;
let sigma[0]:=sigma0;
let {t in 1..T} sigma[t]:=sigma[t-1]*exp(gsigma[t-1]*5);

param ELand {t in 0..T}>=0;
let ELand[0]:=ELand0;
let {t in 1..T} ELand[t]:=ELand[t-1]*(1-deltaLand); 

param CumLand {t in 0..T}>=0;
let CumLand[0]:=197;
let {t in 1..T} CumLand[t]:=CumLand[t-1] + ELand[t-1]*(5/3.666);

# Carbon cycle
param MAT0=(127.159+93.313+37.840+7.721)+588.000; # Initial Concentration in atmosphere 2015 (GtC)
param MATEQ:=588; 				# Equilibrium concentration in atmosphere   (GtC)
param MUPEQ:=360; 				# Equilibrium concentration in upper strata (GtC)
param MLOEQ:=1720; 				# Equilibrium concentration in lower strata (GtC)

# Impulse response according to IPCC AR5

param t_scale {box in 1..4};
let t_scale[1]:=1000000;
let t_scale[2]:=394.4;
let t_scale[3]:=36.54;
let t_scale[4]:=4.304;

param fraction {box in 1..4};
let fraction[1]:=0.217;
let fraction[2]:=0.224;
let fraction[3]:=0.282;
let fraction[4]:=0.276;

# Climate model parameters
param nu:=3.1; # Equilibrium temperature impact (�C per doubling C02)
param TLO0:=0.324; # Initial lower stratum temperature change (�C from 1900) # adjusted to only include athropogenic forcing
param TAT0:=1.243; # Initial atmospheric temp change (�C from 1900) # adjusted to only include athropogenic forcing
param delta_T:=0.115; # adjustment parameter to compare to 1850-1900 temperature levels
param xi1:=7.3; # Speed of adjustment parameter for atmospheric temperature, default: 0.1005 venmans: 0.386; 
param xi3:=0.73; # Coefficient of heat loss from atmosphere to oceans 
param xi4:=106;	# Coefficient of heat gain by deep oceans
param kappa:=3.6813; # Forcings of equilibrium CO2 doubling (Wm-2)
param xi2:=kappa/nu; # climate model parameter 
param Fex {t in 0..T};# non-CO2 forcings (Wm-2) according to REMIND SSP2 2.6

# climate damage parameters
param Psi:=0.007438; 			# Based on Howard and Sterner (2017)
param TATlim:= 5+0.113;			# upper bound on atm. temperature change

# abatement cost
param Theta:=2.6; 				# Exponent of control cost function
param pback0:=550; 				# Cost of backstop 2010 $ per tCO2 2015
param gback:=0.025; 			# Initial cost decline backstop cost per period
param cprice0:=2; 				# Initial base carbon price (2010$ per tC02)

param pback {t in 0..T}>=0; 
let pback[0]:=pback0;
let {t in 1..T} pback[t]:=pback[t-1]*(1-gback);

param phead {t in 0..T}=pback[t]*sigma[t]/Theta/1000;
             
# VARIABLES

# capital (trillions 2010 USD)
var K {t in 0..T}>=1;

# maximum cumulative extraction fossil fuels (GtC)
var Ecum {t in 0..T}<=6000;

# fossil fuel usage
# CarbMax is vague, 6000 likely incorrect
# var F_f{t in 0..T}>=0;
# subject to constr_F_f {t in 0..T}: F_f[t] <= 0.1 * (6000-Ecum[t])/10;

# total emissions
# FIXME backstop energy not included
var E {t in 0..T};

# Gross output (trillions 2010 USD)
var Qgross {t in 0..T}=A[t]*((L[t]/1000)^(1-gamma))*(K[t]^gamma);

# carbon cycle 

# carbon reservoir atmosphere (GtC)
var MAT {t in 0..T}>=10;

var alpha {t in 0..T}>=0.01<=100;

var c_cycle{t in 0..T, box in 1..4};

# total radiative forcing (Wm-2)
var F {t in 0..T}=kappa*((log(MAT[t]/MATEQ))/log(2))+Fex[t]; 

# atmospheric temperature change (�C from 1750)
var TAT {t in 0..T}>=0, <=TATlim;

# atmospheric temperature change short (�C from 1750)
var TAT_short {t in 0..T, ts in 1..5}>=0;

# ocean temperature (�C from 1750)
var TLO {t in 0..T}>=-1, <=20;

# atmospheric temperature change (�C from 1850-1900)
var TAT_IPCC {t in 0..T}=TAT[t]-delta_T;

# damage fraction
var Omega {t in 0..T}=Psi*(TAT_IPCC[t])^2;#  1-(1/((1+(TAT[t]/20.5847)^2)+(TAT[t]/6.081)^(6.754)));

# damages (trillions 2010 USD)
var damage {t in 0..T}=Omega[t]*Qgross[t];

# emission control
var mu {t in 0..T}>=0; 

# abatement costs (fraction of output)
var Lambda {t in 0..T}=Qgross[t]*phead[t]*(mu[t]^Theta);

# industrial emissions
var EInd {t in 0..T}=sigma[t]*Qgross[t]*(1-mu[t]);
# var E_e{t in 0..T} = (alpha_H*(H_E[t]^rho) + ((EInd[t])/(alpha_phi*Phi[t]))^(rho_H))^(1/rho);

# marginal cost of carbon extraction
var q_F {t in 0..T}=113+ 700*(Ecum[t]/(6000))^4; # Ecum/6000 as model for carbon extraction dubious?

# price of carbon
var P_F{t in 0..T}=q_F[t] + 163.29;

# Marginal cost of abatement (carbon price)
var cprice {t in 0..T}=pback[t]*mu[t]^(Theta-1);

# output net of damages and abatement (trillions 2010 USD)
var Q {t in 0..T}=(Qgross[t]*(1-Omega[t]))-Lambda[t];

# per capita consumption (1000s 2010 USD]
var c {t in 0..T} >= .1;

# aggregate consumption
var C {t in 0..T} = L[t]*c[t]/1000;

# Investment (trillions 2005 USD)
var I {t in 0..T}>=0;

# utility
var U {t in 0..T} =c[t]^(1-eta)/(1-eta);

# total period utility
var U_period {t in 0..T}=U[t]*R[t];

# welfare/objective function sl
var W=sum{t in 0..T} L[t]*U[t]*R[t];

# welfare optimization
maximize objective_function: W;
subject to constr_accounting {t in 0..T}: 			C[t]=Q[t]-I[t];
subject to constr_emissions {t in 0..T}: 			E[t]=EInd[t]+ELand[t];
#todo things like I and R_E are t-1 rather than t but the model was already like this so :shrug:
subject to constr_capital_dynamics {t in 1..T}: 	K[t]=(1-deltaK)^5*K[t-1]+5*I[t-1]-(4*crowdout*R_E[t-1]); 
subject to constr_cumulativeemissions {t in 1..T}: 	Ecum[t]=Ecum[t-1]+(EInd[t-1]*5/3.666); 


subject to alpha_calibration {t in 0..T} :			35+0.019*((Ecum[t]+CumLand[t])-(MAT[t]-588)) + 4.165*(TAT[t])= sum {box in 1..4} alpha[t]*fraction[box]*t_scale[box]*(1-2.718^(-100/(alpha[t] * t_scale[box])));

subject to carbon_cycle_calibration {t in 1..T, box in 1..4}: c_cycle[t,box] = c_cycle[t-1,box]*2.718^(-5/(alpha[t-1]*t_scale[box])) 
																			   + fraction[box] * (E[t-1]*2.781^(-5    /(alpha[t-1]*t_scale[box]))*(1/3.666)) 
																			   + fraction[box] * (E[t-1]*2.781^(-(5-1)/(alpha[t-1]*t_scale[box]))*(1/3.666))	
																			   + fraction[box] * (E[t-1]*2.781^(-(5-2)/(alpha[t-1]*t_scale[box]))*(1/3.666))  
																			   + fraction[box] * (E[t-1]*2.781^(-(5-3)/(alpha[t-1]*t_scale[box]))*(1/3.666)) 
																			   + fraction[box] * (E[t-1]*2.781^(-(5-4)/(alpha[t-1]*t_scale[box]))*(1/3.666));

subject to constr_atmosphere {t in 0..T}: 			MAT[t]= sum{box in 1..4} c_cycle[t,box] + 588;	


#Equation below have been rewritten to match a geophysical interpretation of the energy balance model based on Geoffroy (2013)

subject to constr_atmospheric_temp_1 {t in 0..T, ts in 1..5}: 		TAT_short[t,1]=TAT[t];
subject to constr_atmospheric_temp_2 {t in 0..T-1, ts in 1..4}:   	TAT_short[t,ts+1]=TAT_short[t,ts] + 1/xi1*((F[t+1]-xi2*TAT_short[t,ts])-(xi3*(TAT_short[t,ts]-TLO[t])));
subject to constr_atmospheric_temp_3 {t in 0..T-1, ts in 1..5}: 	TAT[t+1]=TAT_short[t,5];
subject to constr_ocean_temp {t in 0..T-1}: 						TLO[t+1]=TLO[t]+5*xi3/xi4*(TAT[t]-TLO[t]);


# Initial conditions
subject to initial_capital: 		K[0] = K0;
subject to initial_Ecum: 			Ecum[0]=Ecum0;
subject to initial_MAT: 			MAT[0]=MAT0;
subject to initial_TLO: 			TLO[0]=TLO0;
subject to initial_TAT: 			TAT[0]=TAT0;
subject to initial_control: 		mu[0]=mu0;
subject to initial_control_2020: 	mu[1]=1-(EInd0*(1.01)^5)/(sigma[1]*Qgross[1]);
subject to control1a {t in 2..6}: 	mu[t]<=1-(EInd[t-1]-10)/(sigma[t]*Qgross[t]);
subject to control1 {t in 2..6}: 	mu[t]<=1;
subject to control2 {t in 7..T}: 	mu[t]<=1.2;		# from 2160
subject to control3 {t in 7..T}: 	mu[t]<=mu[t-1]*1.1;	
subject to c_cycle_fix1:			c_cycle[0,1]=127.159;
subject to c_cycle_fix2:			c_cycle[0,2]=93.313;
subject to c_cycle_fix3:			c_cycle[0,3]=37.840;
subject to c_cycle_fix4:			c_cycle[0,4]=7.721;


