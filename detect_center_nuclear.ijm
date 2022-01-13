showMessage("Select Save Folder for masks");
m_saveDir = getDirectory("Choose a Directory");
showMessage("Select Save Folder for volumes");
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
saveAs("Tiff", m_saveDir+"Label.tif");
selectWindow("threshvol");
Stack.getDimensions(width, height, channels, slices, frames);

saveAs("Tiff", m_saveDir+"threshvol.tif");
run("Close All");
N = nResults();

// for each nuclear at each time point
for (i = 1; i < N+1; i++) {
  open(m_saveDir+"Label.tif");
  target = getResult("Slice", i-1);
  setSlice(target);
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
  setMinAndMax(0, 1);
  saveAs("Tiff", m_saveDir+"mask"+i+".tif");
  run("Close All");
  
  open(m_saveDir+"threshvol.tif");
  run("Make Substack...", "slices=1-"+slices+" frames="+target);
  open(m_saveDir+"mask"+i+".tif");
  imageCalculator("AND create stack", "threshvol-1.tif","mask"+i+".tif");
  rename("Volume"+i+".tif");
  if (i<10) {
	  saveAs("Tiff", saveDir+"vol000"+i+".tif");
  }
  else if (i<100) {
	  saveAs("Tiff", saveDir+"vol00"+i+".tif");
  }
  else if (i<1000) {
	  saveAs("Tiff", saveDir+"vol0"+i+".tif");
  }
  else if (i<10000) {
	  saveAs("Tiff", saveDir+"vol"+i+".tif");
  }
  run("Close All");
}
