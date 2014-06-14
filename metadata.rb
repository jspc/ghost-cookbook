name             'ghost'
maintainer       'James Condron'
maintainer_email 'tech@loose-seal.com'
license          'MIT'
description      'Installs/Configures Ghost'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.1'

depends 'nginx'
depends 'nodejs'
depends 'supervisor'
