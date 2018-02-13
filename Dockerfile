FROM gems/concourse-fuselage

ADD . /opt/concourse-resource-rubygems/
ADD .git /opt/concourse-resource-rubygems/.git

RUN apk-install ca-certificates git openssl-dev ruby-bigdecimal \
    && update-ca-certificates \
    && cd /opt/concourse-resource-rubygems \
    && gem build concourse-resource-rubygems.gemspec \
    && gem install ./concourse-resource-rubygems-*.gem \
    && ruby -rfileutils -e 'Gem.path.map { |path| "#{path}/cache" }.each(&FileUtils.method(:rm_rf))' \
    && cd /opt/resource \
    && rm -rf /opt/concourse-resource-rubygems \
    && apk del git openssl-dev

RUN find $(gem environment gemdirs) -type f -path '*/concourse-resource-rubygems-*/bin/*' -exec ln -s '{}' \;
