Beat Tracking
Roger Jang, 20140522

Major functions:
	All parameters for beat tracking is put in myBtOptSet.m.
	The main function for beat tracking is myBt.m.

To do the basic stuff:
	1. Modify myBtOptSet.m
	2. Run goPreprocess.m to collect wave files and perform some preprocessing
	3. Run goPerfEval.m to get the basic performance, with some plots for debugging

To fine tune BT parameter:
	1. Run goPreprocess.m to collect wave files and perform some preprocessing
		(Note that the info obtained from the preprocessing should not be affected by the varying parameters)
	2. Run goOptimize.m to plot the performance vs. parameter values

After a set of BT parameters is found, you can do the following things:
	1. Put the best parameters to myBtOptSet.m
	2. Run goPerfEval.m to use the best parameters to verify the performance
	3. Run goPlayOneFile.m to do debugging over a file with low f-measure

What you need to submit:
	1. myBtOptSet.m
	2. myBt.m
	3. myMethod.txt: Description of your method
	4. Any other files that you have changed
