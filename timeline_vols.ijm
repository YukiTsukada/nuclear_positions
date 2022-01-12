showMessage("Select mask Folder");
openDir = getDirectory("Choose a Directory");
open(openDir+"Label.tif");
f = File.open(openDir+"timeline.txt");
Stack.getDimensions(width, height, channels, slices, frames);
Count = 1;
for (i = 0; i < slices; i++) {
	setSlice(i+1);
	getStatistics(area, mean, min, max, std, histogram);
	Num = i+1;
	print(f,Num+","+ Count +","+ max + "\t"); 
	Count = max + 1;
}

File.close(f);
close();