#
# Author:: Noah Kantrowitz <noah@coderanger.net>
#
# Copyright 2014, Balanced, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name 'rump'
maintainer 'Balanced <dev@balancedpayments.com>'
homepage 'https://github.com/balanced/rump'

replaces 'rump'
install_path '/opt/rump'
build_version '0'
build_iteration 1

# creates required build directories
dependency 'preparation'

# brache dependencies/components
dependency 'rump'
dependency 'ipython'

# version manifest file
dependency 'version-manifest'

exclude '\.git*'
exclude 'bundler\/git'
