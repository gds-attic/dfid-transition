#!/usr/bin/env bash

VERSIONED_DIRNAME=apache-jena-fuseki-2.4.0
DB_LOCATION=run/databases/r4d
R4D_OUTPUTS_ARCHIVE=http://r4d.dfid.gov.uk/RDF/R4DOutputsData.zip
TMP_R4D_OUTPUTS_ARCHIVE=/tmp/`basename ${R4D_OUTPUTS_ARCHIVE}`
R4D_RDF_FILES=/tmp/R4DOutputs

mkdir -p ${DB_LOCATION}

cd /usr/local/fuseki/${VERSIONED_DIRNAME}

if [ ! -f ${TMP_R4D_OUTPUTS_ARCHIVE} ]; then
    curl ${R4D_OUTPUTS_ARCHIVE} > ${TMP_R4D_OUTPUTS_ARCHIVE}
fi

mkdir -p ${R4D_RDF_FILES}
unzip -od ${R4D_RDF_FILES} ${TMP_R4D_OUTPUTS_ARCHIVE}

# Load FAO countries
if [ ! -f /tmp/fao_countries.rdf ]; then
    curl http://www.fao.org/countryprofiles/geoinfo/geopolitical/data > /tmp/fao_countries.rdf
fi
java -cp fuseki-server.jar tdb.tdbloader --loc ${DB_LOCATION} /tmp/fao_countries.rdf


# Load R4D DocumentTypes
if [ ! -f /tmp/DocumentTypes.rdf ]; then
    curl http://r4d.dfid.gov.uk/rdf/skos/DocumentTypes.rdf > /tmp/DocumentTypes.rdf
fi
java -cp fuseki-server.jar tdb.tdbloader --loc ${DB_LOCATION} /tmp/DocumentTypes.rdf

# Load R4D Themes
if [ ! -f /tmp/Themes.rdf ]; then
    curl http://r4d.dfid.gov.uk/rdf/skos/Themes.rdf > /tmp/Themes.rdf
fi
java -cp fuseki-server.jar tdb.tdbloader --loc ${DB_LOCATION} /tmp/Themes.rdf

# Load R4D main output triples
java -cp fuseki-server.jar tdb.tdbloader --loc ${DB_LOCATION} ${R4D_RDF_FILES}/*.rdf
