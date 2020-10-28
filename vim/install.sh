source "$(pwd)/script/start.sh"

platform='Unknown'
unamestr=`uname`

if [ "${unamestr}" == 'Linux' -o  "${unamestr}" == 'Darwin' ]
then
	platform='*nix'
elif [ "${unamestr}" == 'Cygwin' ] 
then
	platform='Windows'
fi


if [ "${platform}" == 'Unknown' ]
then
	echo "Unknown platform ~"
elif [ "${platform}" == 'Windows' ]
then
	echo "Windows sucks !"
elif [ "${platform}" == '*nix' ]
then
	doInstall
fi
