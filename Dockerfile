ARG R_VERSION=3.4.3

FROM r-base:${R_VERSION}

MAINTAINER Neighborhoods.com "neighborhoods.engineering@neighborhoods.com"

ARG SHINY_SERVER_VERSION=1.5.6.875

# Install dependencies and Download and install shiny server
RUN apt-get update && apt-get install -y -t unstable \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libxt-dev \
    libxml2-dev \
    libpq-dev \
    libssl-dev && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-${SHINY_SERVER_VERSION}-amd64.deb" -O shinystudio.deb && \
    gdebi -n shinystudio.deb && \
    rm -f shinystudio.deb && \
    R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cran.rstudio.com/')" && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/log/shiny-server && \
    chown shiny:shiny /var/log/shiny-server

COPY ./shiny-server.sh /usr/bin/shiny-server.sh

EXPOSE 3838

CMD ["/usr/bin/shiny-server.sh"]