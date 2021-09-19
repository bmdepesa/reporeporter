#!/bin/bash

# brew install jq
# brew install gnumeric
# login to github cli with an access token with repo permissions (not password)
mkdir -p $(pwd)/reports/
curdate=$(date +%m.%d.%y)
outfile=$(pwd)/reports/rke2-${curdate}
curdir=$(pwd)

rm ${outfile}.raw
rm ${outfile}.xlsx

touch ${outfile}.raw
echo -e 'Issue #\tTitle\tMilestone\tStatus' >> ${outfile}.raw

cd ~/Dev/projects/rke2/

gh api graphql --header 'GraphQL-Features: projects_next_graphql' -f query="$(cat ${curdir}/rke2testingquery.gql)" | jq '.data.nodes[] | add | add | (.[] | [.content.number, .content.title,.content.milestone.title, .column.name]) | @tsv' -r >> ${outfile}.raw
ssconvert ${outfile}.raw ${outfile}.xlsx

rm ${outfile}.raw
open ${outfile}.xlsx