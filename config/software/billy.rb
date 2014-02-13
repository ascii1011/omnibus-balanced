#
# Author:: Victor Lin <victorlin@balancedpayments.com>
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

name 'billy'

dependency 'setuptools'
dependency 'pip'

dependency 'libxml2'
dependency 'libxslt'
dependency 'libpq'

source :git => 'https://github.com/balanced/billy.git'
version ENV['BILLY_VERSION'] || 'master'

relative_path 'billy'

always_build true

build do
  block do
    project = self.project
    if project.name == 'billy'
      shell = Mixlib::ShellOut.new('git describe --tags', cwd: self.project_dir)
      shell.run_command
      if shell.exitstatus == 0
        build_version = shell.stdout.chomp
        build_version = build_version[1..-1] if build_version[0] == 'v'
        project.build_version build_version
        project.build_iteration ENV['BILLY_PACKAGE_ITERATION'] ? ENV['BILLY_PACKAGE_ITERATION'].to_i : 1
      end
    end
  end

  # copy alembic folder to share folder
  command "mkdir -p #{ install_dir }/embedded/share/billy"
  command "cp -R alembic/ #{ install_dir }/embedded/share/billy"
  # install requirements
  env = {
    "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
    "PATH" => "/opt/billy/embedded/bin:#{ENV['PATH']}",
  }
  [
    'uwsgi',
    'psycopg2',
    '-r requirements.txt',
    '.'
  ].each do |target|
    command "#{ install_dir }/embedded/bin/pip install --upgrade " \
            "--install-option=--prefix=#{ install_dir }/embedded #{ target }", env: env
  end
end
