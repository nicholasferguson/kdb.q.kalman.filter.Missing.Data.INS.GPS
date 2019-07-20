# INS.GPS.kalman.q
    + Q version of matlab code in file: an.intergrated.INS.GPS.kalman.v2.m
	+ See documentation in code.analysis.an.intergrated.INS.GPS.kalman.v2.docx

# an.intergrated.INS.GPS.kalman.m

    + This matlab code was transcribed from its support documentation: 
	
	Hernandez, Glenn, "An integrated INS GPS navigation system for small AUVs
	using an asynchronous Kalman Filter", Master's Thesis, Naval
	Postgraduate School, Monterey, California. 1998
	
	I edited code: placed local variables in global space so that
	plot would find them.  Octave 5.1 x64 Windows 10, required that change.

	
	For octave Octave-5.1.0.0 x64, I had to update these files, from a development branch at octave.org.
	Otherwise, the plot functions returned an error code. 
	Needs more testing if this is indeed a common solution.
	+ annotation.m 
	+ axis.m 
	+ gtext.m 
	+ legend.m 
	+ orient.m 
	+ shading.m
	Otherwise, an error of 
	error: axis: LIMITS(3) must be less than LIMITS(4)
	
	
	This code was run on: 
	Octave-5.1.0.0 x64 on  Windows 10.

# an.intergrated.INS.GPS.kalman.v2.m

    + cleaned up matlab code. 
			normalized variable names and removed unused code
			This copy served as basis to migrate code to KDB/Q.
			
#  code.analysis.an.intergrated.INS.GPS.kalman.v2.docx

	+ This analyzes code for Kalman Filter in a flow chart type methodology
	
