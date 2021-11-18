#!/bin/bash
if [ "$1" == "" ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
	echo "nf.sh version 1.4.1 help"
	echo "------------------------"
	echo "load all dependancies and patch a nerd font easily"
	echo ""
	echo "usage: nf.sh (font file) [nerd font patcher args]"
	echo "nf.sh help/version: nf.sh [--help | -h]"
	echo "nerd font patcher help: nf.sh patcher --help"
	echo "example: ./nf.sh Inter.ttf -c"
	exit
fi;

NF=~/.cache/nf.sh/
FF_AI="$NF""FontForge.AppImage"
NF_PATCHER="$NF""font-patcher"
FONT="$(realpath $1)"
ARGS="${@:2}"

echo "=> Checking if the Nerd Font patcher is available..."
if [ -d "$NF" ]; then
	echo " ==> Nerd font patcher available at '$NF', skipping installation."
else
	echo " ==> Nerd font patcher not installed, installing to '$NF'..."
	git clone --filter=blob:none --sparse "https://github.com/ryanoasis/nerd-fonts.git" "$NF"
	git -C "$NF" sparse-checkout add src/glyphs
fi;

echo "=> Checking if FontForge is available..."
if [ -x "$(command -v fontforge)" ]; then
	echo " ==> FontForge installed, skipping..."
	FF="fontforge"
elif [ -f "$FF_AI" ]; then
	echo " ==> FontForge AppImage present at '$FF_AI', skipping...";
	chmod +x "$FF_AI"
	FF="$FF_AI"
else
	echo " ==> FontForge not installed, downloading AppImage..."
	# this is static, but this version should always work
	curl -o "$FF_AI" "https://github.com/fontforge/fontforge/releases/download/20201107/FontForge-2020-11-07-21ad4a1-x86_64.AppImage"
	chmod +x "$FF_AI"
	FF="$FF_AI"
fi;

echo "=> Running" $FF "-script" $NF_PATCHER $FONT $ARGS
$FF -script $NF_PATCHER $FONT $ARGS
