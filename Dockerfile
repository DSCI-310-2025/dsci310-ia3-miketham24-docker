# # Use Rocker RStudio image
# FROM rocker/rstudio:4.4.2

# # Install renv and remotes
# RUN Rscript -e "install.packages('renv', repos = c(CRAN = 'https://cloud.r-project.org'))"
# RUN Rscript -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"

# # Switch to root to copy files
# USER root
# COPY renv.lock /home/rstudio/renv.lock
# COPY renv /home/rstudio/renv

# # Ensure correct permissions
# RUN chown -R rstudio:rstudio /home/rstudio/renv /home/rstudio/renv.lock

# # Switch back to rstudio user
# USER rstudio

# # Restore R environment from renv.lock
# RUN Rscript -e "renv::restore(prompt = FALSE)"

# # Set working directory
# WORKDIR /home/rstudio
# Use Rocker RStudio as the base image
FROM rocker/rstudio:4.4.2

# Set working directory
WORKDIR /home/rstudio

# Switch to root to install system dependencies
USER root

# Install system dependencies required by R packages
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev

# Install renv package
RUN Rscript -e 'install.packages("renv", repos="https://cran.rstudio.com")'

#Install ggplot2 package
RUN Rscript -e 'install.packages("ggplot2", repos="https://cran.rstudio.com")'

# Switch back to rstudio user to maintain best practices
USER rstudio

# Copy renv files from the local machine into the container
COPY renv.lock renv.lock
COPY renv/ renv/

# Restore R packages using renv
RUN Rscript -e 'renv::restore()'

# Expose RStudio Server port
EXPOSE 8787

# Set default command
CMD ["/init"]