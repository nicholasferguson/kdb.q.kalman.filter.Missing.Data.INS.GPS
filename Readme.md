# an.intergrated.INS.GPS.kalman.m

    + This was transcribed from: [MS]An integrated INS GPS navigation system for small - kalman(1998)
	
	I edited some changes: placed local variables in global space so that
	plot would find them.  Octave required that change.

	
	For octave Octave-5.1.0.0 x64, I had to update these files, from a development branch at octave.org
	+ annotation.m 
	+ axis.m 
	+ gtext.m 
	+ legend.m 
	+ orient.m 
	+ shading.m
	Otherwise, an error of 
	error: axis: LIMITS(3) must be less than LIMITS(4)
	
	
	To run: 
	Using Octave Octave-5.1.0.0 x64 on  Windows 10.
	
	line 10:  minutes = 1; % original was 6
	line 16: 1/delta_t * 2 * minutes % original was 1/delta * 60