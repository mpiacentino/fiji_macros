indir=getDirectory("Choose a directory");
outdir=getDirectory("Choose a directory");
indirlist=getFileList(indir);

setBatchMode(true);

for(i=0;i<indirlist.length;i++){
	run("Bio-Formats Windowless Importer", "open=" + indir + indirlist[i]);
	name=File.nameWithoutExtension;
	print("Processing: " + name);

//	run("Rotate... ", "angle=180 grid=1 interpolation=Bilinear stack");
	run("Median...", "radius=2 stack");
	run("Z Project...", "projection=[Max Intensity]");
	
	// NOTE: Imaging embryos on the LSM880 results in them being reflected 
	// with experimental side on left and control on right. Correcting that here.
//	run("Flip Vertically", "stack");

	rename("A");
	run("Split Channels");

	//export each channel
	selectWindow("C1-A");
	run("Grays");
	run("Enhance Contrast", "saturated=0.10");
//	saveAs("JPEG", outdir+name+"_GPI-eGFP");
//	selectWindow("C2-A");
//	run("Grays");
//	run("Enhance Contrast", "saturated=0.25");
//	saveAs("JPEG", outdir+name+"_RFP");
	selectWindow("C3-A");
	run("Grays");
	run("Enhance Contrast", "saturated=0.25");
//	saveAs("JPEG", outdir+name+"_Phase");
//	selectWindow("C4-A");
//	run("Grays");
//	run("Enhance Contrast", "saturated=0.35");
//	saveAs("JPEG", outdir+name+"_DAPI");
//	selectWindow("C5-A");
//	run("Grays");
//	run("Enhance Contrast", "saturated=0.05");
//	saveAs("JPEG", outdir+name+"_DIC");


//merge channels
	//c1 = red, c2 = green, c3 = blue, 
	//c4 = gray, c5 = cyan, c6 = magenta, 
	//c7 = yellow
	
	run("Merge Channels...", "c5=C3-A c6=C1-A create");
	
	rename("A");
	selectWindow("A");
	run("RGB Color");
	saveAs("JPEG", outdir+name+"_composite");
	run("Close All");

}