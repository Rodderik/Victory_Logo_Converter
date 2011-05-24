#!/bin/sh
# Victory Kernel Logo Maker by Rodderik
# Original author unknown (Contact me for proper credits)
#
# Victory Kernel Logo Maker is a script to convert a C Header
# image (.h) to a proper kernel logo file for the Epic 4g (Victory)
#
# Instructions:
# 1. Create 480x800 PNG with Gimp
# 2. Save the PNG as a "C source code header" (ie: mylogo.h)
# 3. Copy mylogo.h into the same folder as this script
# 4. Type: ./makelogo.sh mylogo.h
# 5. Replace logo_rgb24_wvga_portrait_victory.h in Kernel/drivers/video/samsung/

# Write parsing code to file
cat > victorylogo << __EOF__
#include <iostream>
#include "$1" //this is the logo, saved in gimp as "C header"
using namespace std;

int main( )
{
	int totalpixels = 480 * 800;
	int breakcount=1;
	cout << "const unsigned int LOGO_RGB24[] = {\n\t";
	for( int i = 0; i < totalpixels; i++ )
        {
		unsigned char pixel[6]="";
                HEADER_PIXEL(header_data,pixel);
		
		cout << "0x00";
		for (int j = 0; j <3 ; j++)
		{
			if ( pixel[j] < 16)
		   	cout << "0";	
			cout << std::hex << (int)pixel[j];
		}
			if ( breakcount == 16) {	
					breakcount = 1;
					cout << ",\n\t";
			}
			else {
					breakcount++;
					cout << ", ";
			}
	}
	cout << "\n};\n\n";
	return 0;
}
__EOF__

# Parse header image file
g++ -o victorylogo -x c++ victorylogo >> /dev/null 2>&1

# Assemble logo_rgb24_wvga_portrait_victory.h
./victorylogo > logo_rgb24_wvga_portrait_victory.h
cat assets/charge >> logo_rgb24_wvga_portrait_victory.h

# Clean up
rm -f victorylogo
