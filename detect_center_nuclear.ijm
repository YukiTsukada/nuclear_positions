showMessage("Select Save Folder");
saveDir = getDirectory("Choose a Directory");

run("Split Channels");
run("Gaussian Blur...", "sigma=2 stack");
setAutoThreshold("Otsu dark");
setOption("BlackBackground", false);
run("Convert to Mask", "method=Otsu background=Dark list");
run("Fill Holes", "stack");
rename("threshvol");
run("Watershed", "stack");

run("Z Project...", "projection=[Max Intensity] all");
run("Watershed", "stack");
rename("mask");
run("Analyze Particles...", "size=10-Infinity pixel show=[Count Masks] display clear stack");
selectWindow("Count Masks of mask");
saveAs("Tiff", saveDir+"Label.tif");
selectWindow("threshvol");
Stack.getDimensions(width, height, channels, slices, frames);

saveAs("Tiff", saveDir+"threshvol.tif");
run("Close All");
N = nResults();

// for each nuclear at each time point
for (i = 1; i < N; i++) {
  open(saveDir+"Label.tif");
  target = getResult("Slice", i-1);
  setSlice(target);ls
  run("Duplicate...", " ");
  setThreshold(i, i);
  run("Convert to Mask", "method=Default background=Dark list");
  run("Divide...", "value=255");

  rename(i);
  close("Label-1.tif");
  close("Label.tif");

  // at each time point
  for (j = 1; j < slices; j++) {
	run("Duplicate...",j);
  }
  run("Images to Stack", "name=mask title=[] use");
  saveAs("Tiff", saveDir+"mask"+i+".tif");
  run("Close All");
  
  open(saveDir+"threshvol.tif");
  run("Make Substack...", "slices=1-"+slices+" frames="+target);
  open(saveDir+"mask"+i+".tif");
  imageCalculator("AND create stack", "threshvol-1.tif","mask"+i+".tif");
  rename("Volume"+i+".tif");
  saveAs("Tiff", saveDir+"vol"+i+".tif");
  run("Close All");
}
