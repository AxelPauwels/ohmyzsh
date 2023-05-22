# Change Directory
alias cdIMS='cd ~/Ravago/Projects/ims-front'
alias cdIMSOFFICE='cd ~/Ravago/Projects/ims-office-front'
alias cdRC='cd ~/Ravago/Projects/revenue-capturing-front'
alias cdJOM='cd ~/Ravago/Projects/jom-front'
alias cdRMS='cd ~/Ravago/Projects/recipe-management-front'
alias cdMDM='cd ~/Ravago/Projects/master-data-front'
alias cdSFC='cd ~/Ravago/Projects/shop-floor-front'
alias cdWMS='cd ~/Ravago/Projects/wms-front'

# Github
alias ghPullRequest='gh pr create --assignee @me --reviewer Roel-Frison_ravago,kevin-jannis_ravago,dennis-gadomski_ravago,teun-verhaert_ravago,bert-fonteyn_ravago,tim-frijters_ravago,niels-hamelryck_ravago' 
alias huskySetExecutable='chmod ug+x .husky/* && chmod ug+x .git/hooks/*'

# NPM
alias npmInstall='npm ci -s' ### -s is silent to supress the warnings

# Mac
alias checkPort='(){ lsof -i tcp:$1;}' # use as 'checkPort 3000'
alias killProcess='kill -9 ' # use as 'kill -9 44475'

# WMS2
alias wmsFront='npm start wms-front'
alias wmsServer='npm start server'
alias wmsTestAll='npm run test'
alias wmsTest='(){ npx nx test $1;}' ### add a NX projectname after this command like 'npxTest foundation' ###
alias wmsGraph='npx nx graph'
alias wmsLintAll='npm run lint:all'
alias wmsLint='(){ npx nx lint $1 --quiet;}' ### add a NX projectname after this command like 'npxLint kernel-shared' ### --quite flag is to supress warnings
alias wmsLintStyles='npm run lint:styles'
alias wmsFormatStyles='npm run format:styles'
alias wmsLintPrettier='npm run lint:prettier'
alias wmsFormatPrettier='npm run format:prettier'
alias wmsChecks='wmsFormatPrettier && wmsLintAll && wmsLintStyles'

