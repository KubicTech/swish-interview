#!/usr/bin/bash
Rscript -e "install.packages(c(\"usethis\",\"pkgdown\",\"devtools\"),dependencies = TRUE)";
while IFS=" " read -r package version; 
do 
  Rscript -e "devtools::install_version('"$package"', version='"$version"')"; 
done < "r-requirements.txt"