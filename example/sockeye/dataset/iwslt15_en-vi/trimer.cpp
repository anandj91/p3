/*
 * @author ArmageddonKnight (bojian@cs.toronto.edu)
 * 
 *  This file trims the empty lines on the dataset provided.
 */

#include <cstdlib>

#include <string>
#include <fstream>
#include <iostream>

int main(int argc, char ** argv)
{
	if (argc != 5)
	{
		std::cerr << "Usage: ./trimer RAW_SRC_TXT RAW_TGT_TXT "
			"TRIMED_SRC_TXT TRIMED_TGT_TXT" << std::endl;
                std::exit(EXIT_FAILURE);
	}
	std::ifstream src_fin , tgt_fin ;
	std::ofstream src_fout, tgt_fout;
	
	src_fin .open(argv[1]); tgt_fin .open(argv[2]);
        src_fout.open(argv[3]); tgt_fout.open(argv[4]);
	
	while (src_fin.good() && tgt_fin.good())
	{
		std::string src_line, tgt_line;
		
		std::getline(src_fin, src_line);
		std::getline(tgt_fin, tgt_line);
		
		if (src_line == "" || tgt_line == "")
		{
			continue;
		}
		src_fout << src_line << std::endl;
		tgt_fout << tgt_line << std::endl;
	}
	
	return 0;
}

