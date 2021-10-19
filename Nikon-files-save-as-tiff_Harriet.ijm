filepath = "X:/Harriet/FIJI_Macro-scripting/nd2-images";
output_filepath = filepath + "/tiffs";
// print(output_filepath);


filelist = getFileList(filepath);

for (i = 0; i < filelist.length; i++) {
	filename = filelist [i];

	open(filepath + "/" + filename);
	//to open the pictures without having to click 'ok' each time:
	//select 'Plugins'->'BioFormats'->'BioFormats Plugin Configurations'->'Formats'->'Nikon ND2'->tick 'windowless'
	title = getTitle();
	print(title);
	//run("Brightness/Contrast...");
	setMinAndMax(300, 1100);
	run("Apply LUT");
	// run("Close");
	run("Gaussian Blur...", "sigma=2");
	saveAs("Tiff", output_filepath + "/" + filename);
	close ("*");
}

