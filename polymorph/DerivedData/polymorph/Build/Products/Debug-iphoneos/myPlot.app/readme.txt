to convert dvi to png use:
latex nsrds_6
dvipng -bg Transparent -T tight -D 640 -z 9 nsrds_6.dvi -o nsrds_6.png

dvipng -T tight -D 600 -bg Transparent

the imageview is 
320 x 416 pixels


1655 x ?
? = 1655 * 416 / 320 = 2151

adjust vspace to get the png to 2151 pt in height
check size with 'file'


