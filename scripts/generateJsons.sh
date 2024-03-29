#!/usr/bin/env bash

# use platform version  from the root pom.xml
version=`mvn -N help:evaluate -Dexpression=project.version -q -DforceStdout | grep "^[0-9]"`

snapshot=$1

# install npm deps needed for the generator node script
[ ! -d scripts/generator/node_modules ] && (cd scripts/generator && npm install)

# download version.json file from vaadin/platform
mkdir -p ./scripts/generator/results/
curl -l -s "https://raw.githubusercontent.com/vaadin/platform/main/versions.json" > ./scripts/generator/results/versions.json
sed -i '/{{version}}/d' ./scripts/generator/results/versions.json

# run the generator
cmd="node scripts/generator/generate.js --platform=$version --versions=scripts/generator/results/versions.json $snapshot"
echo Running: "$cmd" >&2
$cmd || exit 1

# copy generated poms to the final place
cp scripts/generator/results/hilla-versions.json packages/java/hilla/hilla-versions.json
cp scripts/generator/results/hilla-react-versions.json packages/java/hilla-react/hilla-react-versions.json

echo "Copied the theme file from flow-components to hilla and hilla-react"
# download the file from flow-components
lumoFile="https://raw.githubusercontent.com/vaadin/flow-components/main/vaadin-lumo-theme-flow-parent/vaadin-lumo-theme-flow/src/main/java/com/vaadin/flow/theme/lumo/Lumo.java"
materialFile="https://raw.githubusercontent.com/vaadin/flow-components/main/vaadin-material-theme-flow-parent/vaadin-material-theme-flow/src/main/java/com/vaadin/flow/theme/material/Material.java"
curl -l -s $lumoFile > ./scripts/generator/results/Lumo.java
curl -l -s $materialFile > ./scripts/generator/results/Material.java

# remove @JsModule and @NpmPackage annotation and their import lines
sed -i '/JsModule\|NpmPackage/d' ./scripts/generator/results/Lumo.java ./scripts/generator/results/Material.java

# copy the theme files to hilla and hilla-react
mkdir -p ./packages/java/hilla-react/src/main/java/dev/hilla/
mkdir -p ./packages/java/hilla/src/main/java/dev/hilla
cp scripts/generator/results/Lumo.java packages/java/hilla-react/src/main/java/dev/hilla/Lumo.java
cp scripts/generator/results/Lumo.java packages/java/hilla/src/main/java/dev/hilla/Lumo.java
cp scripts/generator/results/Material.java packages/java/hilla-react/src/main/java/dev/hilla/Material.java
cp scripts/generator/results/Material.java packages/java/hilla/src/main/java/dev/hilla/Material.java
