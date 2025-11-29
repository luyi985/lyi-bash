#!/bin/sh

PACKPATH=(
	"/home/bxmdev/git/homes-site/src/app"
	"/home/bxmdev/git/homes-site/src/test"
)

OPS=(
	# "/react-codemod/transforms/React-DOM-to-react-dom-factories.js"
	# "/react-codemod/transforms/create-element-to-jsx.js"
	# "/react-codemod/transforms/error-boundaries.js"
	# "/react-codemod/transforms/manual-bind-to-arrow.js"
	# "/react-codemod/transforms/pure-component.js"
	# "/react-codemod/transforms/rename-unsafe-lifecycles.js"
	# "/react-codemod/transforms/sort-comp.js"
	# "/react-codemod/transforms/React-PropTypes-to-prop-types.js"
	"/react-codemod/transforms/class.js --mixin-module-name=react-addons-pure-render-mixin --flow=true --pure-component=true --remove-runtime-proptypes=false"
	# "/react-codemod/transforms/findDOMNode.js"
	# "/react-codemod/transforms/react-to-react-dom.js"
)

install_r16() {
	local currentfolder="$(pwd)"
	jscodeshift --help || npm install -g jscodeshift
	[[ -d "${currentfolder}/react-codemod" ]] || git clone https://github.com/reactjs/react-codemod.git react-codemod
	[[ -d "${currentfolder}/react-codemod/node_modules" ]] || {
		cd ./react-codemod &&
		npm install && cd $currentfolder; echo ""; echo "------Install Success-------"
	}
}

uninstall_r16() {
	npm uninstall -g jscodeshift && 
	rm -rf ./react-codemod && 
	echo ""; echo "------Uninstall Success-------"
}


upgrade_in_batch() {
	for pack in "${PACKPATH[@]}"
	do
		[[ -d ${pack} ]] || echo "Can not find ${pack}"
		[[ -d ${pack} ]] && {
			upgrade ${pack}
		}
	done
}

upgrade() {
	local pack="${1}"
	local currentfolder="$(pwd)"
	echo "Start to upgrade: ${pack}"

	for op in "${OPS[@]}"
	do
		echo "_________________________________________________________________________________________________________________________________"
		echo "Start: ${op} ---> ${pack}"
		echo "_________________________________________________________________________________________________________________________________"
		jscodeshift -t ${currentfolder}${op} ${pack}/{**/**/*,**/*,*}.{js,jsx} --parser=babylon
	done
}

install_r16 &&
upgrade_in_batch
