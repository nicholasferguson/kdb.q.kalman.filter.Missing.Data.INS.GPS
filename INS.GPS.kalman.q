/ for documentation see my directory kalman.filter.studies
/ Read [MS]An integrated INS GPS navigation system for small - kalman(1998)
/ And octave file: an.intergrated.INS.GPS.kalman.v2
/ code.analysis.an.intergrated.INS.GPS.kalman.v2.docx
/ 

/------ helper functions
make_diagA:{[x]`float$x*{x=/:x}til count x};
make_diag:{[x]
	:make_diagA (x)#1f;
	};
make_diagY:{[x;y]
	:make_diagA (x)#y;
	};
zeroM1:{[x] (x,x)#0f,x#0f}; / Returns an x by x matrix of 0f 
zeroM2:{[x;y] (x;y)#0.0f };  / Returns an x by y matrix of 0f 
/ from stat.q.  similar to octave/matlab randn
pi:acos -1
nor:{$[x=2*n:x div 2;raze sqrt[-2*log n?1f]*/:(sin;cos)@\:(2*pi)*n?1f;-1_.z.s 1+x]}


/--Sample Size--

minutes:6;
delta_t:.01;
/ Sample size
samples:(2 * minutes * 60 % delta_t);
s:`long$samples;

/------------ DB
xV:zeroM2[8;s];
xV1:zeroM2[8;s];
x:zeroM2[8;s];

/ Time Constants
tau_1:60;     / seconds for velocity
tau_2:60;     / seconds for GPS
tau_3:3600;   / seconds for ocean  current

/ size of square matrices
n:8;

/ Process Noise  Vector
wA:nor s;
w2:nor s;
w3:nor s;
w4:nor s;
w5:600.0f * nor s;       / Gives  a GPS standard  deviation of  3 m
w6:600.0f * nor s;      / Gives  a GPS standard  deviation of  3 m
w7:s#0.0f;        / No white  noise input  for x7
w8:s#0.0f;        / No white  noise input  for x8
w:zeroM2[n;s];
w[0;]:wA;w[1;]:w2;w[2;]:w3;w[3;]:w4;
w[4;]:w5;w[5;]:w6;w[6;]:w7;w[7;]:w8;

/ Measurement Noise  Vector
vA:nor s;
vB:nor s;
vC:nor s;
vD:nor s;
v_1:zeroM2[4;s];
v_0:zeroM2[2;s];
v_1[0;]:vA;v_1[1;]:vB;v_1[2;]:vC;v_1[3;]:vD; / Noise vector with  GPS input
v_0[0;]:vA;v_0[1;]:vB; / Noise vector without  GPS input

/ Generate GPS Sampling
/ gps_flag:nor s;

/ State Transition  Matrix
F:zeroM2[8;8];
F[0;0]:exp[-1*delta_t%tau_1];
F[1;1]:exp[-1*delta_t%tau_1];
F[2;2]:exp[-1*delta_t%tau_2];
F[3;3]:exp[-1*delta_t%tau_2];
F[4;4]:exp[-1*delta_t%tau_3];
F[5;5]:exp[-1*delta_t%tau_3];
F[6;0]:tau_1*(1-exp[-1*delta_t%tau_1]);
F[6;2]:tau_2*(1-exp[-1*delta_t%tau_2]);
F[7;1]:tau_1*(1-exp[-1*delta_t%tau_1]);
F[7;3]:tau_2*(1-exp[-1*delta_t%tau_2]);

/ Q is the mean of Process Noise  Vector 'w'
/ Q = E[w wT]
Q:zeroM2[8;8];
Q[0;0]:(1%(2*tau_1))*(1-exp[-2*delta_t]%tau_1);
Q[1;1]:(1%(2*tau_1))*(1-exp[-2*delta_t]%tau_1);
Q[2;2]:(1%(2*tau_2))*(1-exp[-2*delta_t]%tau_2);
Q[3;3]:(1%(2*tau_2))*(1-exp[-2*delta_t]%tau_2);
Q[4;4]:(1%(2*tau_3))*(1-exp[-2*delta_t]%tau_3);
Q[5;5]:(1%(2*tau_3))*(1-exp[-2*delta_t]%tau_3);

/ Generate Process  Noise Vectors
process_noise:mmu[xexp[Q;.5];w];

/ Identify Matrix
EY:make_diag[8];
 
/ Error Covariance  Matrix
R_0:make_diag[2];
R_0[0;0]:0.5;R_0[1;1]:0.5;
R_1:make_diag[4];
R_1[0;0]:0.5;R_1[1;1]:0.5;R_1[2;2]:0.0;R_1[3;3]:0.0;

/ Generate Measurement  Noise Vectors
sensor_noise_0:mmu[sqrt[R_0];v_0]; / Without GPS signal
sensor_noise_1:mmu[sqrt[R_1];v_1]; / With GPS signal


/ Initial z as globals for graphing
z_gps:zeroM2[1;s];
z_gpsA:zeroM2[1;s];
z_gps2:zeroM2[1;s];
z_gps3:zeroM2[1;s];
z_gps4:zeroM2[1;s];
z_gps_time:zeroM2[1;s];

/ System Error Covariance
/ P is initial Error Covariance Matrix
P:make_diag[8];
P[0;0]:0.5;P[1;1]:0.5;P[4;4]:3.0;P[5;5]:3.0;
P[6;6]:5.0;P[7;7]:5.0;		
P1:zeroM2[8;8];
/ Index for Measurement Vector
tia:0;tia:`long$tia; /Initial Index for Measurement Vector without  GPS
tib:0;tib:`long$tib; /Initial Index for Measurement Vector with  GPS

/ Vector with measurements
z_vel:zeroM2[2;s];
z_vel1:s#0f;
z_vel2:s#0f;
/ Vector with measurements
z_gps:zeroM2[4;s];
z_gps1:zeroM2[1;s]
z_gps2:zeroM2[1;s]
z_gps3:zeroM2[1;s]
z_gps4:zeroM2[1;s]
/ noiseless connection between measurement and state vector
H0:2 8#0.0;   / without GPS
H0[0;0]:1.0;H0[1;1]:1.0;
H1:4 8#0f;    / with GPS
H1[0;0]:1f;H1[1;1]:1f;H1[2;4]:1f;H1[2;6]:1f;H1[3;5]:1f;H1[3;7]:1f;
/ Measurement error covariance.
R_0:2 2#0.0;R_0[0;0]:0.5;R_0[1;1]:0.5; / Without GPS
R_1:4 4#0.0;R_1[0;0]:0.5;R_1[1;1]:0.5;R_1[2;2]:0.0;R_1[3;3]:0.0; / with GPS

myfunction:{[it]

			x[;it]::process_noise[;it-1]+ mmu[F;x[;it-1]];
			j:first nor 1;
			$[j < 0.5;gps_flag::0f;gps_flag::1f];
			/ show "gps_flag";show gps_flag;
			if[gps_flag=0f; / loop w/o GPS Signal
			     [
					sensor_noise_0[;it]: mmu[xexp[R_0;0.5];v_0[;it]];
					z_vel1[tia]::mmu[H0[0;];x[;it]]+sensor_noise_0[0;it];
					z_vel2[tia]::mmu[H0[1;];x[;it]]+sensor_noise_0[1;it];
					z_vel::(z_vel1;z_vel2);			
				/ Compute Ka1man  Gain
					K:mmu[mmu[P;flip H0];inv[mmu[mmu[H0;P];flip H0]+R_0]];
				/ Update Estimate
					xV1[;it]::xV[;it-1]+ mmu[K;(z_vel[;tia]-mmu[H0;xV[;it-1]])];	
				/  Compute Error  Covariance for Updated  Estimate
					P1::mmu[(EY- mmu[K;H0]);P];
					P1::mmu[P1;flip P1]%2;
					tia+:1;
				 ]];			
			if[gps_flag=1f; / Loop with GPS Signal
				 [
					z_gps1:mmu[H1[0;];x[;it]]+sensor_noise_1[0;it];
					z_gps2:mmu[H1[1;];x[;it]]+sensor_noise_1[1;it];
					z_gps3:mmu[H1[2;];x[;it]]+sensor_noise_1[2;it];
					z_gps4:mmu[H1[3;];x[;it]]+sensor_noise_1[3;it];
					z_gps[0;it]:first z_gps1;
					z_gps[1;it]:first z_gps2;
					z_gps[2;it]:first z_gps3;
					z_gps[3;it]:first z_gps4;
                   / Compute  Ka1man Gain
					 K:mmu[mmu[P;flip H1];inv[mmu[H1;mmu[P;flip H1]]+R_1]];
				/ Update  Estimate
					 xV1[;it]::xV[;it-1]+ mmu[K;(z_gps[;tib]-mmu[H1;xV[;it-1]])];
				/ Compute  Error Covariance  for Updated Estimate
					 P1::mmu[(EY- mmu[K;H1]);P];
					 P1::mmu[P1;flip P1]%2;					
					tib+:1;	
				 ]];

				xV[;it]::process_noise[;it-1] + mmu[F;xV1[;it]];
				P::Q + mmu[F;mmu[P1;flip F]];
				P::mmu[P;flip P]%2;	
				x[;it]::xV[;it];

    }
simulation:{[]
	    it:1;
		while[it< s;
        		myfunction[it];	
				it+:1;
		]

   }
show "sample size";
show s;
simulation[];

