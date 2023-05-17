#naloga1

#!/bin/bash
zelisca=()
teze=()
indeks=0
#populira seznam z zelisci in nastavi isto število mest v seznamu tez
for a in "${@:2}";do
	zelisca+=($a)
	teze+=(0)
done

for a in "${@:2}"; do
	#najprej najdem indeks tega zelisca
	for i in "${!zelisca[@]}"; do
		if [[ "${zelisca[$i]}" = $a ]]; then
			indeks="${i}"
		fi
	done

	#vsako število ki ga grep najde za to zelišče prištejemo k teze(i)
	teza=$(grep -E -o "$a.{0,7}" arhiv.txt | cut -d ' ' -f 2 | sed 's/[A-Za-z,.]*//g')
	temparr=($teza)
	for i in "${temparr[@]}"; do
		teze[$indeks]=$((${teze[$indeks]}+i))
	done
done
#izpise vse skupaj
indeks=0
for a in ${zelisca[@]}; do
	echo "$a ${teze[indeks]}"
	((indeks+=1))
done

#naloga2

#!bin/bash
while true
do
read -p 'Vnesite ime ukaza: ' ukaz
if [ ! "$(type -t $ukaz)" == "" ]; then
        if  [[ ! "$(type -at $ukaz | wc -l)" == 1 && "$(type -t $ukaz)" == "builtin" ]]; then echo "ObOjE"
        else
                if [ "$(type -t $ukaz)" == "builtin" ]; then echo "VGRAJEN"
                else echo "nevgrajen"
                fi
        fi
fi
done

#naloga3 

#!/bin/bash
ps -e -o pid,args --no-headers | sed 's/^[ \t]*//'

#naloga4

#!/bin/bash
ps -e -o command,pcpu,pmem --no-headers --sort=-pcpu | head -n 3 | tr -s '.' ',' | tr -s ' '

#5 Skripta preveri v podanem imeniku koliko imamo navadnih datotek, koliko skritih datotek, koliko mehkih povezav, 
#koliko datotek, ki imajo več kot eno trdo povezavo, koliko cevovodov in koliko imenikov.

#!/bin/bash
echo datoteke: $(find $1 -maxdepth 1 -type f -not -name '.*' -ls | wc -l)
echo skrite: $(find $1 -maxdepth 1 -type f -name '.*' -ls | wc -l)
echo mehke povezave: $(find $1 -maxdepth 1 -type l | wc -l)
echo trde povezave: $(find $1 -maxdepth 1 -type f -links +1 | wc -l)
echo cevovodi: $(find $1 -maxdepth 1 -type p | wc -l)
echo imeniki: $(find $1 -maxdepth 1 -mindepth 1 -type d | wc -l)

#6 Skripta kot prvi argument prejme pot do datoteke, od drugega argumenta naprej pa dobi seznam uporabnikov.
# Vsem podanim uporabnikom s pomočjo ACL (Access Control List) dodeli možnost branja in poganjanja datoteke 
#(tudi če niso lastniki datoteke ali člani skupine datoteke;
# pri čemer pa vsi ostali uporabniki sistema teh dveh pravic ne dobijo). Namig: poiščite ukaz za spreminjanje ACL za datoteko.

#!/bin/bash
for user in "${@:2}"; do
	setfacl -m u:"$user":rx "$1"
done

#7 V podanem imeniku rekurzivno poiščite vse datoteke s končnico končnica, ki vsebujejo iskani niz.
# Izpišite najdeno datoteko, številko vrstice, kjer se niz nahaja in vsebino vrstice z označenim iskanim nizom..

#!/bin/bash
datoteke=$(find "$1" -name "*.$2" | sort)
for dat in $datoteke;do
    vrstice=$(grep -rnw $dat -e $3 | xargs)
    if [ ! -z "$vrstice" ];then
        IFS=':';arg=($vrstice);unset IFS;
