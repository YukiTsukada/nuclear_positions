//function vol_center() { 
showMessage("Select Open Folder");
openDir = getDirectory("Choose a Directory");

list = getFileList(openDir);
f = File.open(openDir+"coordinates.csv");

for (j = 0; j < list.length; j++) {
	open(openDir+list[j]);
	run("Set Measurements...", "area center stack display redirect=None decimal=3");
	setThreshold(1, 254);
	run("Analyze Particles...", "size=10-Infinity pixel show=[Count Masks] display clear stack");
	Stack.getDimensions(width, height, channels, slices, frames);
	X_cent = 0;
	Y_cent = 0;
	Z_cent = 0;
	Area_total = 0;
	Num_result = nResults();
	Area = newArray(Num_result);
	Slice = newArray(Num_result);
	XM = newArray(Num_result);
	YM = newArray(Num_result);

	for (i = 0; i < Num_result; i++) {
		Area[i] = getResult("Area", i);
		Slice[i] = getResult("Slice",i);
		XM[i] = getResult("XM",i);
		YM[i] = getResult("YM",i);
		X_cent = X_cent + (XM[i] * Area[i]);
		Y_cent = Y_cent + (YM[i] * Area[i]);
		Z_cent = Z_cent + (Slice[i] * Area[i]);
		Area_total = Area_total + Area[i];
	}

	X_cent = X_cent / Area_total;
	Y_cent = Y_cent / Area_total;
	Z_cent = Z_cent / Area_total;

	print("center of X = "+ X_cent);
	print("center of Y = "+ Y_cent);
	print("center of Z = "+ Z_cent);
	run("Close All");
	print(f,X_cent+","+ Y_cent +","+ Z_cent + "\t"); 
}
File.close(f);

//}