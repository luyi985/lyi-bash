export site="now"
export appKey="now-site"

export currentSite="${site}-site"
export currentSiteSrc="$HOME/git/${currentSite}/src"
export currentSiteAuto="$HOME/git/${currentSite}/automation"

export foodSiteSrc="$HOME/git/${currentSite}"

alias run="cd ${currentSiteSrc} && APP_KEY=${appKey} APP_REGION=au APP_ENV=dev APP_DEBUG=true APP_STUBBED=false npm run dev"
alias run-auto="cd ${currentSiteSrc} && APP_KEY=${appKey} APP_ENV=sit APP_DEBUG=true APP_STUBBED=true npm run dev"
alias auto="export URL=http://localhost:3001/ && export HTTP_PROXY='' && export HTTPS_PROXY=${MY_PROXY} && export APP_KEY=${appKey} && cd ${currentSiteAuto} && rf && npm run watch"
alias autop="export URL=http://localhost:3001/ && export HTTP_PROXY='' && export HTTPS_PROXY=${MY_PROXY} && export APP_KEY=${appKey}&& cd ${currentSiteAuto} && npm run watch:phantom"


export articleSrc="~/git/wn-article/lib"
export articleDes="${currentSiteSrc}/node_modules/@bxm/article/"
alias article="rm -rf ${articleDes}/lib && mv ${articleSrc} ${articleDes}"  

export serverSrc="~/git/wn-server"
export serverDes="${currentSiteSrc}/node_modules/@bxm/server/"
alias server="rm -rf ${serverDes}/lib ${serverDes}/amp && mv ${serverSrc}/lib ${serverDes} && cp -rf ${serverSrc}/amp ${serverDes}/amp"

export gallerySrc="~/git/wn-gallery/lib"
export galleryDes="${currentSiteSrc}/node_modules/@bxm/gallery/"
alias gallery="rm -rf ${galleryDes}/lib && mv ${gallerySrc} ${galleryDes}"  

export uiSrc="~/git/wn-ui/lib"
export uiDes="${currentSiteSrc}/node_modules/@bxm/ui/"
alias ui="rm -rf ${uiDes}/lib && mv ${uiSrc} ${uiDes}"  

export adSrc="~/git/wn-adverts/"
export adDes="${currentSiteSrc}/node_modules/@bxm/ad/"
alias ad="rm -rf ${adDes}/lib && mv ${adSrc}lib ${adDes} && rm -rf ${adDes}/styles && cp -rf ${adSrc}styles ${adDes}styles"

export siteHeaderSrc="~/git/wn-site-header/lib"
export siteHeaderDes="${currentSiteSrc}/node_modules/@bxm/site-header/"
alias header="rm -rf ${siteHeaderDes}/lib && mv ${siteHeaderSrc} ${siteHeaderDes}"



# -----------Install packages------------
packageInstaller() {
    infoOutput "install ${2} at ${1}"
    [ -d $2 ] && cd $2 && colorEcho green "Installing package $1 ($(pwd))" && npm install --save $1
    [ -d $2 ] || (colorEcho red "Fail to install package $1,not found ($2)" && exit 1)
}

packageInstallInBatch(){
    [[ -z ${SITE_ARR} ]] && {
        errorAlert "SITE_ARR is null";
        addProjectFolders;
    }
    [[ -z ${SITE_ARR} ]] || {
        for site in "${SITE_ARR[@]}"
        do
            packageInstaller $1 "${site}/src"
        done
    }
}

# -----------Git update code------------
gitUpdateInBatch(){
    [[ -z ${SITE_ARR} ]] && {
        errorAlert "SITE_ARR is null";
        addProjectFolders
    }
    gitInput
    [[ -z ${SITE_ARR} ]] || {
        local sites=( $(echo ${SITE_ARR}) )

        for site in "${sites[@]}"
        do
            cd $site
            colorEcho purple "Now we are in $(pwd)"
            sp $newBranchName
        done
    }
}

alias ib=packageInstallInBatch
alias gpull=gitUpdateInBatch