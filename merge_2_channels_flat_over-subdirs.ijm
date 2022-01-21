/* This script takes a tiff file with specified name ending, opens its sisters and merges them to a LUT at will
 * Sarah V. Schweighofer, MPIBPC November 2021
 */


// choose source directory
SourceDir = getDirectory("Choose Source Directory ");
// filepath = "P:/Private/practice/imaging/IF/IF79_BaxK-on-WT_Bcl2-sampler/IF79_STEDycon/obfs_only/"; //this needs to be changed and needs to have backslash at the end!
subDirlist = getFileList(SourceDir);

namepart1 = "Bax.STED_BG-20._enh99.9.tiff"
namepart2 = "Bak.STED_BG-20._enh99.9.tiff"

for (i = 0; i < subDirlist.length; i++) {
	subdir = SourceDir + subDirlist[i] + "renamed/" + "tifs/";
	print(subdir);
	filelist = getFileList(subdir);
	for (j = 0; j < filelist.length; j++) {
		filename = filelist [j];
		
	
		if(endsWith(filename, namepart1)) {
			open(subdir + "/" + filename);
			title = getTitle();
			print(title);
			
			new_title = replace(title, namepart1, namepart2);
			print(new_title);
			open(subdir + "/" + new_title);
	
			run("Merge Channels...", "c2=[" + title + "] c6=[" + new_title + "] create ignore");

			run("Flatten");
			run("8-bit");
			
			save_title = replace(title, "Bax", "XKmerge");
			saveAs("Tiff", subdir + save_title);
			close ("*");
		}
		// break
	}
}
