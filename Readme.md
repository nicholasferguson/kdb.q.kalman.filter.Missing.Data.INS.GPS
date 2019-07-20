# INS.GPS.kalman.q
    + Q version of an.intergrated.INS.GPS.kalman.v2.m
    + This was transcribed from: [MS]An integrated INS GPS navigation system for small - kalman(1998)
	+ See code.analysis.an.intergrated.INS.GPS.kalman.v2.docx

# an.intergrated.INS.GPS.kalman.m

    + This was transcribed from: [MS]An integrated INS GPS navigation system for small - kalman(1998)
	
	I edited some changes: placed local variables in global space so that
	plot would find them.  Octave required that change.

	
	For octave Octave-5.1.0.0 x64, I had to update these files, from a development branch at octave.org  Not sure this does it.
	+ annotation.m 
	+ axis.m 
	+ gtext.m 
	+ legend.m 
	+ orient.m 
	+ shading.m
	Otherwise, an error of 
	error: axis: LIMITS(3) must be less than LIMITS(4)
	
	
	To run: 
	Used Octave Octave-5.1.0.0 x64 on  Windows 10.
	
	In this directory
	+ [MS]An integrated INS GPS navigation system for small - kalman(1998).pdf
			by Glenn C. Hernandez
	+ an.intergrated.INS.GPS.kalman.m  ( original transciption of code from thesis)
# an.intergrated.INS.GPS.kalman.v2.m

    + cleaned up code. normalized variable names and
			removed unused code
			
#  code.analysis.an.intergrated.INS.GPS.kalman.v2.docx

	+ This analyzes code for Kalman Filter in a flow chart type methodoogy
	
