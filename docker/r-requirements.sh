#!/usr/bin/bash

# Sourced from https://stackoverflow.com/questions/54534153/install-r-packages-from-requirements-txt-file

# Update R repositories
Rscript -e "options(repos = c(CRAN = 'https://cloud.r-project.org/'))"

# Install dependencies one by one in the correct order with error handling
echo "Installing base R dependencies..."
Rscript -e "install.packages('usethis', dependencies=TRUE)" || echo "Warning: Failed to install usethis"
Rscript -e "install.packages('pkgdown', dependencies=TRUE)" || echo "Warning: Failed to install pkgdown"
Rscript -e "install.packages('devtools', dependencies=TRUE)" || echo "Warning: Failed to install devtools"
Rscript -e "install.packages('V8', dependencies=TRUE)" || echo "Warning: Failed to install V8"
Rscript -e "install.packages('juicyjuice', dependencies=TRUE)" || echo "Warning: Failed to install juicyjuice"

# Now install packages from requirements file
echo "Installing packages from requirements file..."
while IFS=" " read -r package version; 
do 
  echo "Installing $package version $version..."
  Rscript -e "tryCatch({
    if (!requireNamespace('devtools', quietly=TRUE)) {
      install.packages('devtools', dependencies=TRUE)
    }
    devtools::install_version('$package', version='$version', dependencies=TRUE)
  }, error=function(e) {
    cat('Failed to install package: $package version $version\n', e\$message, '\n')
  })"
done < "r-requirements.txt"