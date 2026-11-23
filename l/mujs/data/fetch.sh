rm -f *.txt *.txt.lz
curl -s -o UnicodeData.txt https://www.unicode.org/Public/16.0.0/ucd/UnicodeData.txt
curl -s -o SpecialCasing.txt https://www.unicode.org/Public/16.0.0/ucd/SpecialCasing.txt
plzip -9 *.txt
