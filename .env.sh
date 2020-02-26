#!/bin/sh

JDK_6_NAME=jdk1.6.0_45
JDK_7_NAME=jdk1.7.0_79
DOCKER_JRE_7=/usr/lib/jvm/java-7-oracle

DISTRIB_RELEASE=`cat /etc/lsb-release | grep "DISTRIB_RELEASE"`
TYPE=

today=`date +"%Y%m%d"`

export CVSROOT=:pserver:seoksangsik@vmiii.alticast.com:/home/CVS

echo ${DISTRIB_RELEASE}
if [[ ${DISTRIB_RELEASE} == *"16.04" ]]; then
    echo "unbuntu on main environment"
    export WORKSPACE=${HOME}/data

    JDK_6=${WORKSPACE}/${JDK_6_NAME}
    JDK_7=${WORKSPACE}/${JDK_7_NAME}

    export JAVAHOME=${JDK_6}
    TYPE=develop
elif [[ ${DISTRIB_RELEASE} == *"14.04" ]]; then
    echo "unbuntu on docker environment"
    export WORKSPACE=${HOME}/nfs
    export JAVAHOME=${DOCKER_JRE_7}
    TYPE=docker
else
    echo "unbuntu on unknown environment"
fi


export JAVA_HOME=${JAVAHOME}
export SOURCE_PATH=${PATH}
export PATH=.:${JAVAHOME}/bin:${PATH}

export BUILD_TARGET
export HDAROOT=/home/sangsik/test

set ts=4
set expandtab
set sw=4
set sts=4
set ai

made() {
    echo "run maker, current keyword[ ${KEYWORD} ], g4 name[ ${G4_NAME} ]"
    case ${KEYWORD} in
    "ctv")
        echo "made, select g4 name[ ${G4_NAME} ]"
        ./maker_kaon_otv otv
        ;;
    "cts" | "fcc")
        echo "made, select g4 name[ ${G4_NAME} ]"
        ./maker_cloud
        ;;
    "cos")
        echo "made, select g4 name[ ${G4_NAME} ]"
        ./maker_dmt
        ;;
    "cns")
        echo "made, select g4 name[ ${G4_NAME} ]"
        ./maker_cloud
        ;;
    "wts")
        echo "made, select g4 name[ ${G4_NAME} ]"
        ./maker
        ;;
    "wtv")
        echo "made, select g4 name[ ${G4_NAME} ]"
        ./maker_otv
        ;;
    "utv" | "uhv" | "u2tv" | "u3tv" | "u3sv" | "u3vv" | "u3vw" | "u3a" | "pinkpong")
        echo "made, select g4 name[ ${G4_NAME} ]"
        go g4
        ./maker_otv
        chmod 755 ${EV_HDAROOT}/alti.dat
        ;;
    "uts" | "uhs" | "u2s")
        echo "made, select g4 name[ ${G4_NAME} ]"
        go g4
        ./maker
        chmod 755 ${EV_HDAROOT}/alti.dat
        ;;
    *)
        echo "made, ${KEYWORD} need to configuration! g4 name[ ${G4_NAME} ]"
        ;;
    esac
}

img() {
    echo "make image ${KEYWORD} g4[ ${G4_NAME} ]"
    case ${KEYWORD} in
    "ctv" | "wtv")
        echo "img, select g4 name[ ${G4_NAME} ]"
	made
	img_kaon_otv.sh
	;;
    "wts")
        echo "img, select g4 name[ ${G4_NAME} ]"
	made
	go imgt
	./Android_BSP_E5015.sh rootfs
	./Android_BSP_E5015.sh package
	;;
    "cns")
	echo "img, select g4 name[ ${G4_NAME} ]"
	made
	./img_na1110.sh
	
	mv ${WORK_HOME}/imagetool/*.img ${WORK_HOME}/NA1110/
	cd ${WORK_HOME}/NA1110
	./na1110_sangsik_sign.sh
	go g4
	;;
    "fcc")
        echo "img, select g4 name[ ${G4_NAME} ]"
	./img_na1100.sh
	;;
    "cts")
	echo "img, select g4 name[ ${G4_NAME} ]"
	made
	day=`date +"%m%d"`
	img_dmt4900.sh ${day}
	go imgt
	img_name=${day}_${BUILD_TARGET}
	mv ${img_name}.img merger/
	cd merger
        python ./setver.py appinfo.bin ${day}
	# don't execute exe file 
	./merge.sh ${img_name}
	rm ${img_name}.img
	;;
    "uts")
        echo "img, select g4 name[ ${G4_NAME} ]"
	made
	cd ${WORK_HOME}/imagetool
	./make_image.sh
	;;
    "utv" | "uhv" | "u2tv" | "u3sv" | "u3vv" | "u3vw" | "pinkpong")
	echo "img, select g4 name[ ${G4_NAME} ]"
	made
	cd ${WORK_HOME}/imagetool


	jdk 1.7
	./make_image

	DIR_NAME=`ls -td *${today}* | sed -n 1p`
        echo "last dir name='${DIR_NAME}' included '${today}'"


        FULLNAME=`find ./${DIR_NAME} -size +1000`
        echo ${FULLNAME}

        NAME=`echo ${FULLNAME} | rev | cut -d'/' -f1 | rev`
        TYPE=${BUILD_TARGET##*_}
        echo "name=${NAME} type=${TYPE}"

        if [ ${TYPE} == "" ]; then
            IMG_NAME=${NAME}
        else
            P1=`echo ${NAME} | cut -d'.' -f1`
            P2=`echo ${NAME} | cut -d'.' -f2`
            echo "${P1} : ${P2}"

            IMG_NAME=${P1}_${TYPE}.${P2}
        fi
        echo ${IMG_NAME}
	mv ${DIR_NAME}/${NAME} ${DIR_NAME}/${IMG_NAME}

	;;
    "u3a")
	echo "img, select g4 name[ ${G4_NAME} ]"
	made
	cd ${WORK_HOME}/imagetool_air

	jdk 1.7
	
	./make_image

	DIR_NAME=`ls -td *${today}* | sed -n 1p`
        echo "last dir name='${DIR_NAME}' included '${today}'"


        FULLNAME=`find ./${DIR_NAME} -size +1000`
        echo ${FULLNAME}

        NAME=`echo ${FULLNAME} | rev | cut -d'/' -f1 | rev`
        TYPE=${BUILD_TARGET##*_}
        echo "name=${NAME} type=${TYPE}"

        if [ ${TYPE} == "" ]; then
            IMG_NAME=${NAME}
        else
            P1=`echo ${NAME} | cut -d'.' -f1`
            P2=`echo ${NAME} | cut -d'.' -f2`
            echo "${P1} : ${P2}"

            IMG_NAME=${P1}_${TYPE}.${P2}
        fi
        
	echo ${IMG_NAME}
	mv ${DIR_NAME}/${NAME} ${DIR_NAME}/${IMG_NAME}

	;;
    "u3tv")
	echo "img, select g4 name[ ${G4_NAME} ]"
	made
	cd ${WORK_HOME}/imagetool
	JAVAHOME=${JDK_7}
	JAVA_HOME=${JAVAHOME}
	PATH=${JAVAHOME}/bin:${SOURCE_PATH}

	./make_image
	;;
    *)
        echo "img, ${KEYWORD} need to configuration! g4 name[ ${G4_NAME} ]"
        ;;
    esac
}

go() {
    if [ -z "$@" ]; then
        echo "==> need to select keyword!!"
        echo "otv box [ctv, fcc, c2tv, wtv, utv, uhv, u2tv, u3tv, u3sv, u3vv, u3vw]"
        echo "ots box [cts, cns, wts, uhs, u2s]"
        echo "other box [genie, pinkpong, gigapc]"
    elif [ "g4" = $1 ]; then
        echo "move to g4 : ${G4_HOME}"
        cd ${G4_HOME}
    elif [ "work" = $1 ]; then
        echo "move to workspace : ${WORKSPACE}"
        cd ${WORKSPACE}
    elif [ "imgt" = $1 ]; then
        echo "move to imagetool : ${WORK_HOME}/imagetool"
        cd ${WORK_HOME}/imagetool
    else
        KEYWORD=$1

        if [ "ats" = $1 ]; then
	    G4_NAME=ats.dmt4900
	    WORK_HOME=${WORKSPACE}/${G4_NAME}	
	    G4_HOME=${WORK_HOME}/g4
	    cd ${G4_HOME}

	    BUILD_TARGET=dmt_economic_log
	    print now

	    EV_ROOTFS=${WORK_HOME}/imagetool
	    export EV_HDAROOT=${EV_ROOTFS}/app/alticast
        elif [ "ctv" = $1 ]; then
	    G4_NAME=ctv.na1100.web30
	    WORK_HOME=${WORKSPACE}/${G4_NAME}	
	    G4_HOME=${WORK_HOME}/g4
	    cd ${G4_HOME}

	    BUILD_TARGET=kaon_log
	    print now

	    export EV_ROOTFS=${WORK_HOME}/imagetool	
	    export HDAROOT=${EV_ROOTFS}/app/alticast
	    export REFSWROOT=${WORK_HOME}/driver

	    export EV_HDAROOT=${HDAROOT}
	    export EV_REFSWROOT=${REFSWROOT}
   	    # export REFSWROOT=${WORK_HOME}/bcm7358_refsw_kaon_otv_40
        elif [ "fcc" = $1 ]; then
	    G4_NAME=ctv.na1100.fcc
	    setWorkHome
	    
	    G4_HOME=${WORK_HOME}/g4
	    cd ${G4_HOME}

	    BUILD_TARGET=kaon_log
	    print now

	    export EV_ROOTFS=${WORK_HOME}/imagetool	
	    export HDAROOT=${EV_ROOTFS}/app/alticast
	    export REFSWROOT=${WORK_HOME}/driver

	    export EV_HDAROOT=${HDAROOT}
	    export EV_REFSWROOT=${REFSWROOT}
	elif [ "c2tv" = $1 ]; then
	    G4_NAME=ctv.na2200
	    WORK_HOME=${WORKSPACE}/${G4_NAME}	
	    G4_HOME=${WORK_HOME}/g4
	    cd ${G4_HOME}

	    BUILD_TARGET=kaon_eco_log
	    print now
	
	    #JAVAHOME=${JDK_6}
	    #JAVA_HOME=${JAVAHOME}
		
	    PATH=${JAVAHOME}/bin:${SOURCE_PATH}
	    #export HDAROOT=${WORK_HOME}/nfs/mnt/app/alticast
	    export HDAROOT=${WORK_HOME}/imagetool
	    export REFSWROOT=${WORK_HOME}/driver
	elif [ "cts" = $1 ]; then
	    G4_NAME=cts.dmt4900
	    setWorkHome

	    G4_HOME=${WORK_HOME}/g4
	    cd ${G4_HOME}

            BUILD_TARGET=cloud_dmt_economic_log
            print now
	
	    export ROOTFS=${WORK_HOME}/imagetool	
	    export EV_ROOTFS=${ROOTFS}	
	    export HDAROOT=${EV_ROOTFS}/app/alticast
	    export EV_HDAROOT=${HDAROOT}
            
	    export REFSWROOT=${WORK_HOME}/bcm7358_refsw_dmt_40
	    export EV_REFSWROOT=${WORK_HOME}/bcm7358_refsw_dmt_40
        elif [ "cos" = $1 ]; then
            G4_NAME=cts.dmt4900.old
            setWorkHome

            G4_HOME=${WORK_HOME}/g4
            cd ${G4_HOME}

            BUILD_TARGET=cloud_dmt_economic_log
            print now

            export ROOTFS=${WORK_HOME}/imagetool
            export EV_ROOTFS=${ROOTFS}
            export HDAROOT=${EV_ROOTFS}/app/alticast
            export EV_HDAROOT=${HDAROOT}

            export REFSWROOT=${WORK_HOME}/bcm7358_refsw_dmt_40
            export EV_REFSWROOT=${WORK_HOME}/bcm7358_refsw_dmt_40
	elif [ "cns" = $1 ]; then
	    G4_NAME=cns.na1110
	    setWorkHome
	    setMoveG4Home

            BUILD_TARGET=cloud_kaon_ots_log


            print now
	
	    export ROOTFS=${WORK_HOME}/imagetool	
	    export EV_ROOTFS=${ROOTFS}	
	    export HDAROOT=${EV_ROOTFS}/romfs_mp/mnt/app/alticast
	    export EV_HDAROOT=${HDAROOT}
            export REFSWROOT=${WORK_HOME}/driver
	elif [ "gigapc" = $1 ]; then
	    G4_NAME=gigapc
	    WORK_HOME=${WORKSPACE}/${G4_NAME}	
	    G4_HOME=${WORK_HOME}/g4
	    cd ${G4_HOME}
	    
	    BUILD_TARGET=gigapc_kaon_log
	    print now

	    HDAROOT=${WORK_HOME}/imagetool/mnt/app/alticast
         elif [ "wts" = $1 ]; then
            G4_NAME=wts.smt5015

            WORK_HOME=${WORKSPACE}/${G4_NAME}
            G4_HOME=${WORK_HOME}/g4
            cd ${G4_HOME}

            source script/setenv.sh

            BUILD_TARGET=dalvik_ots_log
            print now

            export ANDROIDROOT=${WORK_HOME}/build_example_ics
            export EV_HDAROOT=${WORK_HOME}/imagetool/Alticast/acap/alticast
            export EV_REFSWROOT=${WORK_HOME}/driver
         elif [ "wtv" = $1 ]; then
            G4_NAME=wtv.smt5015

            WORK_HOME=${WORKSPACE}/${G4_NAME}
            G4_HOME=${WORK_HOME}/g4
            cd ${G4_HOME}

            source script/setenv.sh

            BUILD_TARGET=dalvik_otv_log
            print now

            export ANDROIDROOT=${WORK_HOME}/build_example_ics
            export HDAROOT=${WORK_HOME}/imagetool/app/alticast
            export EV_HDAROOT=${HDAROOT}
            export REFSWROOT=${WORK_HOME}/driver
            export EV_REFSWROOT=${EV_REFSWROOT}
        elif [ "uts" = $1 ]; then
	    G4_NAME=uts.ic1100

	    WORK_HOME=${WORKSPACE}/${G4_NAME}	
	    G4_HOME=${WORK_HOME}/g4
	    cd ${G4_HOME}
		
	    BUILD_TARGET=dalvik_ots_fcc_log
	    print now	
			
	    HDAROOT=${WORK_HOME}

	    export EV_HDAROOT=${HDAROOT}/imagetool/app/alticast
	    export EV_REFSWROOT=${HDAROOT}/driver
        elif [ "utv" = $1 ]; then
	    G4_NAME=utv.ic1000

	    WORK_HOME=${WORKSPACE}/${G4_NAME}	
	    G4_HOME=${WORK_HOME}/g4
	    cd ${G4_HOME}

   	    BUILD_TARGET=dalvik_kaon_log
	    print now	
			
	    HDAROOT=${WORK_HOME}

	    export CCACHE=ccache
	    export EV_HDAROOT=${HDAROOT}/imagetool/app/alticast
	    export EV_REFSWROOT=${HDAROOT}/driver
        elif [ "uhv" = $1 ]; then
	    G4_NAME=uhv.bp4000

	    WORK_HOME=${WORKSPACE}/${G4_NAME}	
	    G4_HOME=${WORK_HOME}/g4
	    cd ${G4_HOME}
   	    
	    BUILD_TARGET=dalvik_humax_log
	    #BUILD_TARGET=dalvik_humax_1920_log
	    jdk 1.7	
	    print now	
			
	    HDAROOT=${WORK_HOME}

	    export CCACHE=ccache
	    export EV_HDAROOT=${HDAROOT}/imagetool/app/alticast
	    export EV_REFSWROOT=${HDAROOT}/driver
	elif [ "uhs" = $1 ]; then
	    G4_NAME=uhs
	    BUILD_TARGET=dalvik_ots_fcc_log

	    WORK_HOME=${WORKSPACE}/${G4_NAME}	
	    G4_HOME=${WORK_HOME}/g4
	    cd ${G4_HOME}
	
	    jdk 1.7	
	    print now	
			
	    HDAROOT=${WORK_HOME}

	    export CCACHE=ccache
	    export EV_HDAROOT=${HDAROOT}/imagetool/app/alticast
	    export EV_REFSWROOT=${HDAROOT}/driver
	elif [ "u2tv" = $1 ]; then
	    G4_NAME=u2tv.ic1100
	    BUILD_TARGET=dalvik_uhd2_kaon_log
	    jdk 1.7
 
	    WORK_HOME=${WORKSPACE}/${G4_NAME}	
	    G4_HOME=${WORK_HOME}/g4
	    cd ${G4_HOME}
		
	    print now	
			

	    export CCACHE=ccache
	    HDAROOT=${WORK_HOME}/imagetool/app/alticast
	    export REFSWROOT=${WORK_HOME}/driver
	    export EV_HDAROOT=${WORK_HOME}/imagetool/app/alticast
	    export EV_REFSWROOT=${REFSWROOT}
	elif [ "u2s" = $1 ]; then
	    G4_NAME=u2s.sl602sl
	    BUILD_TARGET=dalvik_ots2_fcc_log

	    WORK_HOME=${WORKSPACE}/${G4_NAME}	
	    G4_HOME=${WORK_HOME}/g4
	    cd ${G4_HOME}
	
	    jdk 1.7	
	    print now	
			
	    HDAROOT=${WORK_HOME}

	    export CCACHE=ccache
	    export EV_HDAROOT=${HDAROOT}/imagetool/app/alticast
	    export EV_REFSWROOT=${HDAROOT}/driver
        elif [ "u3tv" = $1 ]; then
	    G4_NAME=u3tv.ic3000
	    BUILD_TARGET=dalvik_uhd3_kaon_17_1_log

   	    WORK_HOME=${WORKSPACE}/${G4_NAME}	
	    G4_HOME=${WORK_HOME}/g4
	    cd ${G4_HOME}
		
	    print now

	    JAVAHOME=/home/sangsik/data/jdk1.6.0_45
	    JAVA_HOME=${JAVAHOME}		
	    PATH=${JAVAHOME}/bin:/${SOURCE_PATH}

	    HDAROOT=${WORK_HOME}

	    export CCACHE=ccache
     	    export EV_HDAROOT=${HDAROOT}/imagetool/app/alticast
	    export EV_REFSWROOT=${HDAROOT}/driver
        elif [ "u3sv" = $1 ]; then
            G4_NAME=u3tv.kt601el
	    
	    echo ">> check : ${BUILD_TARGET%_*}"
            if [[ "dalvik_uhd3_samsung_17_1" = ${BUILD_TARGET%_*} ]]; then
                echo "> use current target"
            else
                echo "> set default target"
                target dalvik_uhd3_samsung_17_1_log
            fi
	
            WORK_HOME=${WORKSPACE}/${G4_NAME}	
	    G4_HOME=${WORK_HOME}/g4
	    cd ${G4_HOME}

	    print now
	    HDAROOT=${WORK_HOME}

	    jdk 1.7
	    
	    export CCACHE=ccache
     	    export EV_HDAROOT=${HDAROOT}/imagetool/app/alticast
	    export EV_REFSWROOT=${HDAROOT}/driver
        elif [ "u3h" = $1 ]; then
            G4_NAME=g4_hite

            target dalvik_uhd3_samsung_17_1_log

            WORK_HOME=${WORKSPACE}/${G4_NAME}
            G4_HOME=${WORK_HOME}/hite
            cd ${G4_HOME}

	    print now
	    HDAROOT=${WORK_HOME}
	    
	    jdk 1.7

            export CCACHE=ccache
            export EV_HDAROOT=${HDAROOT}/imagetool_u3h/app/alticast
            export EV_REFSWROOT=${HDAROOT}/driver_u3h
        elif [ "u3a" = $1 ]; then
            G4_NAME=u3tv.kt601el

            if [[ "dalvik_uhd3_kaon_17_1_wifi" = ${BUILD_TARGET%_*} ]]; then
                echo "> use current target"
            else
                echo "> set default target"
                target dalvik_uhd3_kaon_17_1_wifi_log
            fi

            WORK_HOME=${WORKSPACE}/${G4_NAME}
            G4_HOME=${WORK_HOME}/g4
            cd ${G4_HOME}

            print now
            HDAROOT=${WORK_HOME}

            jdk 1.7

            export CCACHE=ccache
            export EV_HDAROOT=${HDAROOT}/imagetool_air/app/alticast
            export EV_REFSWROOT=${HDAROOT}/driver_air

        elif [ "pinkpong" = $1 ]; then
            G4_NAME=genie_pinkpong
	    BUILD_TARGET=dalvik_uhd3_samsung_17_1_log
	   	
            WORK_HOME=${WORKSPACE}/${G4_NAME}	
	    G4_HOME=${WORK_HOME}/g4
	    cd ${G4_HOME}

	    print now
	    HDAROOT=${WORK_HOME}

	    #JAVAHOME=/home/sangsik/data/jdk1.6.0_45
	    #JAVA_HOME=${JAVAHOME}		
            JAVAHOME=${JDK_7}
	    JAVA_HOME=${JAVAHOME}		
	    PATH=${JAVAHOME}/bin:/${SOURCE_PATH}
	    export CCACHE=ccache
     	    export EV_HDAROOT=${HDAROOT}/imagetool/app/alticast
	    export EV_REFSWROOT=${HDAROOT}/driver
        elif [ "u3vv" = $1 ]; then
            G4_NAME=u3tv.voice
            BUILD_TARGET=dalvik_uhd3_samsung_17_1_log

            WORK_HOME=${WORKSPACE}/${G4_NAME}
            G4_HOME=${WORK_HOME}/g4
            cd ${G4_HOME}

            print now
            HDAROOT=${WORK_HOME}
	    
            JAVAHOME=${JDK_7}
	    JAVA_HOME=${JAVAHOME}		
	    PATH=${JAVAHOME}/bin:/${SOURCE_PATH}

            export CCACHE=ccache
            export EV_HDAROOT=${HDAROOT}/imagetool/app/alticast
            export EV_REFSWROOT=${HDAROOT}/driver
        elif [ "u3vw" = $1 ]; then
            G4_NAME=u3tv.voice.cont
            BUILD_TARGET=dalvik_uhd3_samsung_17_1_log

            WORK_HOME=${WORKSPACE}/${G4_NAME}
            G4_HOME=${WORK_HOME}/g4
            cd ${G4_HOME}

            print now
            HDAROOT=${WORK_HOME}
	    
            JAVAHOME=${JDK_7}
	    JAVA_HOME=${JAVAHOME}		
	    PATH=${JAVAHOME}/bin:/${SOURCE_PATH}

            export CCACHE=ccache
            export EV_HDAROOT=${HDAROOT}/imagetool/app/alticast
            export EV_REFSWROOT=${HDAROOT}/driver
        elif [ "genie" = $1 ]; then
            G4_NAME=genie
            BUILD_TARGET=hi_cas_log

            WORK_HOME=${WORKSPACE}/${G4_NAME}
            G4_HOME=${WORK_HOME}/g4
            cd ${G4_HOME}

            print now
            HDAROOT=${WORK_HOME}
	    
            JAVAHOME=${JDK_7}
	    JAVA_HOME=${JAVAHOME}		
	    PATH=${JAVAHOME}/bin:/${SOURCE_PATH}
	    source script/setenv.sh

            #export CCACHE=ccache
            #export EV_HDAROOT=${HDAROOT}/imagetool/app/alticast
            #export EV_REFSWROOT=${HDAROOT}/driver
        fi
    fi
}

target() {
    if [ -z "$@" ] ; then
	echo ""	
    elif [[ "rel" = $1 || "log" = $1 ]] ; then
        echo "$BUILD_TARGET -> $1"
        BUILD_TARGET=${BUILD_TARGET%_*}_$1
    else
	BUILD_TARGET=$1
    fi
    
    echo "BUILD_TARGET=[ $BUILD_TARGET ]"
}


jdk() {
    echo "[jdk] $1, now : ${JAVAHOME}"

    jdk=

    if [ "1.6" = $1 ] ; then
         jdk=${JDK_6}
    elif [ "1.7" = $1 ]; then
         jdk=${JDK_7}
    else
        echo "[jdk] undefined $1"
    fi

    if [ -n $jdk ] ; then
        echo "[jdk] change $jdk"

        export JAVAHOME=$jdk
        export JAVA_HOME=${JAVAHOME}

        export PATH=.:${JAVAHOME}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/db/bin:/usr/lib/jvm/java-8-oracle/jre/bin
    else
        echo "[jdk] show $jdk"
    fi
}


setWorkHome() {
    echo "setWorkHome(${TYPE}), G4_NAME=[ ${G4_NAME} ]"
    if [ "develop" = ${TYPE} ]; then
        WORK_HOME=${WORKSPACE}/nfs/${G4_NAME}	
    elif [ "docker" = ${TYPE} ]; then
    	WORK_HOME=${WORKSPACE}/${G4_NAME}	
    	export WORK_ROOT=${WORKSPACE}/${G4_NAME}	
    else
	echo 'undefined environment'
    fi
    echo "setWorkHome, WORK_HOME=[ ${WORK_HOME} ]"
}

setMoveG4Home() {
    G4_HOME=${WORK_HOME}/g4
    echo "setMoveG4Home, G4_HOME=[ ${G4_HOME} ]"
    cd ${G4_HOME}
}

print() {
    if [  $1 = "now" ]; then
	echo current g4 name=[ ${G4_NAME} ], build target=[ ${BUILD_TARGET} ]
    fi
}

