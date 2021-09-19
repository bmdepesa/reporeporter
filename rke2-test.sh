#!/bin/bash

# brew install jq
# login to github cli with an access token with repo permissions (not password)

mkdir -p $(pwd)/reports/
curdate=$(date +%m.%d.%y)
curdir=$(pwd)
outfile=${curdir}/reports/rke2-${curdate}


rm ${outfile}.txt
touch ${outfile}.txt

cd ~/Dev/projects/rke2/

gh api graphql --header 'GraphQL-Features: projects_next_graphql' -f query="$(cat ${curdir}/rke2testingquery.gql)" | jq '.data.nodes[0].cards.nodes+.data.nodes[1].cards.nodes | ["Issue", "Title", "Milestone", "Status"], (.[] | [.content.number, .content.title, .content.milestone.title, .column.name]) | @tsv' -r >> ${outfile}.txt

cd $curdir
python3 buildreport.py $curdate

open "reports/report-${curdate}.xlsx"