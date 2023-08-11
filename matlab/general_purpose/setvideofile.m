function logfileout=setvideofile(fullFilename)
% 'Archival' 		Motion JPEG 2000 file with lossless compression
% 'Motion JPEG AVI' 	AVI file using Motion JPEG encoding
% 'Motion JPEG 2000' 	Motion JPEG 2000 file
% 'MPEG-4' 		MPEG-4 file with H.264 encoding (systems with Windows 7 or later, or macOS 10.7 and later)
% 'Uncompressed AVI' 	Uncompressed AVI file with RGB24 video
% 'Indexed AVI' 		Uncompressed AVI file with indexed video
% 'Grayscale AVI' 	Uncompressed AVI file with grayscale video
% logfileout=VideoWriter(fullFilename, "Motion JPEG AVI"); % Usually
% logfileout=VideoWriter(fullFilename, "Grayscale AVI");