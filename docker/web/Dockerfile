FROM perl:5.36
RUN apt-get update && apt-get install -y \
  vim \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*
RUN cpanm DBD::mysql Mojolicious::Lite Web::Scraper LWP::Protocol::https
