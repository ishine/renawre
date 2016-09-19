#***************************************************************************
#  Copyright 2014-2016, mettatw
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#***************************************************************************

JSFILES := $(patsubst tmpl/rtools/src-js/%,tmpl/rtools/%,$(wildcard tmpl/rtools/src-js/*.js))

.PHONY: all
all: $(JSFILES)

clean:
	rm -f $(JSFILES)

node_modules: package.json
	@npm install

tmpl/rtools/%.js: tmpl/rtools/src-js/%.js node_modules
	node_modules/.bin/browserify -t [ babelify --presets [ es2015 ] ] -g uglifyify \
    --node "$<" --outfile "$@"
