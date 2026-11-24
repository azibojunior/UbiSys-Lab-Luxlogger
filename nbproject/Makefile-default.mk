#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=elf
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/LuxLogger.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/LuxLogger.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

ifeq ($(COMPARE_BUILD), true)
COMPARISON_BUILD=-mafrlcsj
else
COMPARISON_BUILD=
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=lib/mla_usb/src/usb_host.c lib/mla_usb/src/usb_host_msd.c lib/mla_usb/src/usb_host_msd_scsi.c lib/mla_fileio/src/fileio.c SH1101A.c main.c TouchSense.c RGBLeds.c Storage.c Clock.c Sensor.c UI.c TextDisplay.c Font5x7.c config/usb_config.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/lib/mla_usb/src/usb_host.o ${OBJECTDIR}/lib/mla_usb/src/usb_host_msd.o ${OBJECTDIR}/lib/mla_usb/src/usb_host_msd_scsi.o ${OBJECTDIR}/lib/mla_fileio/src/fileio.o ${OBJECTDIR}/SH1101A.o ${OBJECTDIR}/main.o ${OBJECTDIR}/TouchSense.o ${OBJECTDIR}/RGBLeds.o ${OBJECTDIR}/Storage.o ${OBJECTDIR}/Clock.o ${OBJECTDIR}/Sensor.o ${OBJECTDIR}/UI.o ${OBJECTDIR}/TextDisplay.o ${OBJECTDIR}/Font5x7.o ${OBJECTDIR}/config/usb_config.o
POSSIBLE_DEPFILES=${OBJECTDIR}/lib/mla_usb/src/usb_host.o.d ${OBJECTDIR}/lib/mla_usb/src/usb_host_msd.o.d ${OBJECTDIR}/lib/mla_usb/src/usb_host_msd_scsi.o.d ${OBJECTDIR}/lib/mla_fileio/src/fileio.o.d ${OBJECTDIR}/SH1101A.o.d ${OBJECTDIR}/main.o.d ${OBJECTDIR}/TouchSense.o.d ${OBJECTDIR}/RGBLeds.o.d ${OBJECTDIR}/Storage.o.d ${OBJECTDIR}/Clock.o.d ${OBJECTDIR}/Sensor.o.d ${OBJECTDIR}/UI.o.d ${OBJECTDIR}/TextDisplay.o.d ${OBJECTDIR}/Font5x7.o.d ${OBJECTDIR}/config/usb_config.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/lib/mla_usb/src/usb_host.o ${OBJECTDIR}/lib/mla_usb/src/usb_host_msd.o ${OBJECTDIR}/lib/mla_usb/src/usb_host_msd_scsi.o ${OBJECTDIR}/lib/mla_fileio/src/fileio.o ${OBJECTDIR}/SH1101A.o ${OBJECTDIR}/main.o ${OBJECTDIR}/TouchSense.o ${OBJECTDIR}/RGBLeds.o ${OBJECTDIR}/Storage.o ${OBJECTDIR}/Clock.o ${OBJECTDIR}/Sensor.o ${OBJECTDIR}/UI.o ${OBJECTDIR}/TextDisplay.o ${OBJECTDIR}/Font5x7.o ${OBJECTDIR}/config/usb_config.o

# Source Files
SOURCEFILES=lib/mla_usb/src/usb_host.c lib/mla_usb/src/usb_host_msd.c lib/mla_usb/src/usb_host_msd_scsi.c lib/mla_fileio/src/fileio.c SH1101A.c main.c TouchSense.c RGBLeds.c Storage.c Clock.c Sensor.c UI.c TextDisplay.c Font5x7.c config/usb_config.c



CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-default.mk ${DISTDIR}/LuxLogger.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=24FJ256GB106
MP_LINKER_FILE_OPTION=,--script=p24FJ256GB106.gld
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/lib/mla_usb/src/usb_host.o: lib/mla_usb/src/usb_host.c  .generated_files/flags/default/de4a1c89587228663083690dcc43c39b5c78d4f3 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/lib/mla_usb/src" 
	@${RM} ${OBJECTDIR}/lib/mla_usb/src/usb_host.o.d 
	@${RM} ${OBJECTDIR}/lib/mla_usb/src/usb_host.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  lib/mla_usb/src/usb_host.c  -o ${OBJECTDIR}/lib/mla_usb/src/usb_host.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/lib/mla_usb/src/usb_host.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/lib/mla_usb/src/usb_host_msd.o: lib/mla_usb/src/usb_host_msd.c  .generated_files/flags/default/142c861c9b479c6984b58435394ddfbe36ab992 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/lib/mla_usb/src" 
	@${RM} ${OBJECTDIR}/lib/mla_usb/src/usb_host_msd.o.d 
	@${RM} ${OBJECTDIR}/lib/mla_usb/src/usb_host_msd.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  lib/mla_usb/src/usb_host_msd.c  -o ${OBJECTDIR}/lib/mla_usb/src/usb_host_msd.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/lib/mla_usb/src/usb_host_msd.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/lib/mla_usb/src/usb_host_msd_scsi.o: lib/mla_usb/src/usb_host_msd_scsi.c  .generated_files/flags/default/456eff4c7fdf7eec42beb17a158126c12c16716 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/lib/mla_usb/src" 
	@${RM} ${OBJECTDIR}/lib/mla_usb/src/usb_host_msd_scsi.o.d 
	@${RM} ${OBJECTDIR}/lib/mla_usb/src/usb_host_msd_scsi.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  lib/mla_usb/src/usb_host_msd_scsi.c  -o ${OBJECTDIR}/lib/mla_usb/src/usb_host_msd_scsi.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/lib/mla_usb/src/usb_host_msd_scsi.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/lib/mla_fileio/src/fileio.o: lib/mla_fileio/src/fileio.c  .generated_files/flags/default/27bd1171c316ae14919801d7aa6271fcc302a7b2 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/lib/mla_fileio/src" 
	@${RM} ${OBJECTDIR}/lib/mla_fileio/src/fileio.o.d 
	@${RM} ${OBJECTDIR}/lib/mla_fileio/src/fileio.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  lib/mla_fileio/src/fileio.c  -o ${OBJECTDIR}/lib/mla_fileio/src/fileio.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/lib/mla_fileio/src/fileio.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/SH1101A.o: SH1101A.c  .generated_files/flags/default/b68fa9d82f0df2974bc059112928628d3ea153a7 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/SH1101A.o.d 
	@${RM} ${OBJECTDIR}/SH1101A.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  SH1101A.c  -o ${OBJECTDIR}/SH1101A.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/SH1101A.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/9468952f36dca50168b8904dee26eb9db3425b7a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/main.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/TouchSense.o: TouchSense.c  .generated_files/flags/default/6be72d85fad2310872e834db0054b07965925c13 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/TouchSense.o.d 
	@${RM} ${OBJECTDIR}/TouchSense.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  TouchSense.c  -o ${OBJECTDIR}/TouchSense.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/TouchSense.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGBLeds.o: RGBLeds.c  .generated_files/flags/default/816d0c039a374024b6e0a498a4a3d546aefd60 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/RGBLeds.o.d 
	@${RM} ${OBJECTDIR}/RGBLeds.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGBLeds.c  -o ${OBJECTDIR}/RGBLeds.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGBLeds.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/Storage.o: Storage.c  .generated_files/flags/default/40151eee94ca9f5382dd63f431b426f7667bcead .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Storage.o.d 
	@${RM} ${OBJECTDIR}/Storage.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  Storage.c  -o ${OBJECTDIR}/Storage.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/Storage.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/Clock.o: Clock.c  .generated_files/flags/default/d703c73e9b4d4e6a4c622e1113fd545f7e46bc39 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Clock.o.d 
	@${RM} ${OBJECTDIR}/Clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  Clock.c  -o ${OBJECTDIR}/Clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/Clock.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/Sensor.o: Sensor.c  .generated_files/flags/default/8564abc844edb8018288c747c9b44cdda37992f5 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Sensor.o.d 
	@${RM} ${OBJECTDIR}/Sensor.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  Sensor.c  -o ${OBJECTDIR}/Sensor.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/Sensor.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/UI.o: UI.c  .generated_files/flags/default/81ee37a37d27da25e43ebc59e11137a2aab1e635 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/UI.o.d 
	@${RM} ${OBJECTDIR}/UI.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  UI.c  -o ${OBJECTDIR}/UI.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/UI.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/TextDisplay.o: TextDisplay.c  .generated_files/flags/default/85bd1385f1ed79c2b786280de2c1fc90be8da5d8 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/TextDisplay.o.d 
	@${RM} ${OBJECTDIR}/TextDisplay.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  TextDisplay.c  -o ${OBJECTDIR}/TextDisplay.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/TextDisplay.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/Font5x7.o: Font5x7.c  .generated_files/flags/default/397fcbf8ea3c52259cf3844e7729f972fcd923f5 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Font5x7.o.d 
	@${RM} ${OBJECTDIR}/Font5x7.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  Font5x7.c  -o ${OBJECTDIR}/Font5x7.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/Font5x7.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/config/usb_config.o: config/usb_config.c  .generated_files/flags/default/362441a8433de2f4ba26d53966d5eaeda32f0351 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/config" 
	@${RM} ${OBJECTDIR}/config/usb_config.o.d 
	@${RM} ${OBJECTDIR}/config/usb_config.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  config/usb_config.c  -o ${OBJECTDIR}/config/usb_config.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/config/usb_config.o.d"      -g -D__DEBUG     -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
else
${OBJECTDIR}/lib/mla_usb/src/usb_host.o: lib/mla_usb/src/usb_host.c  .generated_files/flags/default/feddade12affc726476b3cde34a90eebfe6626d2 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/lib/mla_usb/src" 
	@${RM} ${OBJECTDIR}/lib/mla_usb/src/usb_host.o.d 
	@${RM} ${OBJECTDIR}/lib/mla_usb/src/usb_host.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  lib/mla_usb/src/usb_host.c  -o ${OBJECTDIR}/lib/mla_usb/src/usb_host.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/lib/mla_usb/src/usb_host.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/lib/mla_usb/src/usb_host_msd.o: lib/mla_usb/src/usb_host_msd.c  .generated_files/flags/default/3bca55796da5326e070d6f79accc126629ecbe5d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/lib/mla_usb/src" 
	@${RM} ${OBJECTDIR}/lib/mla_usb/src/usb_host_msd.o.d 
	@${RM} ${OBJECTDIR}/lib/mla_usb/src/usb_host_msd.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  lib/mla_usb/src/usb_host_msd.c  -o ${OBJECTDIR}/lib/mla_usb/src/usb_host_msd.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/lib/mla_usb/src/usb_host_msd.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/lib/mla_usb/src/usb_host_msd_scsi.o: lib/mla_usb/src/usb_host_msd_scsi.c  .generated_files/flags/default/34fd20ad65b964b1a7ea201bf228407c8795ff5b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/lib/mla_usb/src" 
	@${RM} ${OBJECTDIR}/lib/mla_usb/src/usb_host_msd_scsi.o.d 
	@${RM} ${OBJECTDIR}/lib/mla_usb/src/usb_host_msd_scsi.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  lib/mla_usb/src/usb_host_msd_scsi.c  -o ${OBJECTDIR}/lib/mla_usb/src/usb_host_msd_scsi.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/lib/mla_usb/src/usb_host_msd_scsi.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/lib/mla_fileio/src/fileio.o: lib/mla_fileio/src/fileio.c  .generated_files/flags/default/69d1aa8dac30e4dc4d583704be42b4c1a9087dd .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/lib/mla_fileio/src" 
	@${RM} ${OBJECTDIR}/lib/mla_fileio/src/fileio.o.d 
	@${RM} ${OBJECTDIR}/lib/mla_fileio/src/fileio.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  lib/mla_fileio/src/fileio.c  -o ${OBJECTDIR}/lib/mla_fileio/src/fileio.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/lib/mla_fileio/src/fileio.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/SH1101A.o: SH1101A.c  .generated_files/flags/default/b27507c8717d2b951673052df151f83026c85807 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/SH1101A.o.d 
	@${RM} ${OBJECTDIR}/SH1101A.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  SH1101A.c  -o ${OBJECTDIR}/SH1101A.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/SH1101A.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/67ee42c72fe686ff83f254224d70da8f79b3e34a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  main.c  -o ${OBJECTDIR}/main.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/main.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/TouchSense.o: TouchSense.c  .generated_files/flags/default/63ca285082056c98f8c47fdd7a04d7e5d9245ad3 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/TouchSense.o.d 
	@${RM} ${OBJECTDIR}/TouchSense.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  TouchSense.c  -o ${OBJECTDIR}/TouchSense.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/TouchSense.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/RGBLeds.o: RGBLeds.c  .generated_files/flags/default/efc0cd9e8d306f7ceb2d4fd8b4147b4ff9a91471 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/RGBLeds.o.d 
	@${RM} ${OBJECTDIR}/RGBLeds.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  RGBLeds.c  -o ${OBJECTDIR}/RGBLeds.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/RGBLeds.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/Storage.o: Storage.c  .generated_files/flags/default/ecc3833ed08edb96ae2f3e70c54c3d35885bf4d3 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Storage.o.d 
	@${RM} ${OBJECTDIR}/Storage.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  Storage.c  -o ${OBJECTDIR}/Storage.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/Storage.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/Clock.o: Clock.c  .generated_files/flags/default/88a66552292d331a36a302dbbce5b73a143ddd0a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Clock.o.d 
	@${RM} ${OBJECTDIR}/Clock.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  Clock.c  -o ${OBJECTDIR}/Clock.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/Clock.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/Sensor.o: Sensor.c  .generated_files/flags/default/7b2d064f69b6c3387d97bdee02757f302cf96f45 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Sensor.o.d 
	@${RM} ${OBJECTDIR}/Sensor.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  Sensor.c  -o ${OBJECTDIR}/Sensor.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/Sensor.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/UI.o: UI.c  .generated_files/flags/default/9be84b16424d9741b4931da974ed9e3aad660f2d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/UI.o.d 
	@${RM} ${OBJECTDIR}/UI.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  UI.c  -o ${OBJECTDIR}/UI.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/UI.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/TextDisplay.o: TextDisplay.c  .generated_files/flags/default/f832fb8e6957f21ea6e448fdd5141880867fe1a3 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/TextDisplay.o.d 
	@${RM} ${OBJECTDIR}/TextDisplay.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  TextDisplay.c  -o ${OBJECTDIR}/TextDisplay.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/TextDisplay.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/Font5x7.o: Font5x7.c  .generated_files/flags/default/bc2836de1c6d4e4dc5b8a4ad3a18504c65596f32 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Font5x7.o.d 
	@${RM} ${OBJECTDIR}/Font5x7.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  Font5x7.c  -o ${OBJECTDIR}/Font5x7.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/Font5x7.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
${OBJECTDIR}/config/usb_config.o: config/usb_config.c  .generated_files/flags/default/46b87e9303e952bbd9bc8a926471e92aaab50101 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/config" 
	@${RM} ${OBJECTDIR}/config/usb_config.o.d 
	@${RM} ${OBJECTDIR}/config/usb_config.o 
	${MP_CC} $(MP_EXTRA_CC_PRE)  config/usb_config.c  -o ${OBJECTDIR}/config/usb_config.o  -c -mcpu=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/config/usb_config.o.d"        -g -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -O0 -I"config" -I"lib/mla_usb/inc" -I"lib/mla_fileio/inc" -msmart-io=1 -Wall -msfr-warn=off    -mdfp="${DFP_DIR}/xc16"
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemblePreproc
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${DISTDIR}/LuxLogger.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o ${DISTDIR}/LuxLogger.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)        -D__DEBUG=__DEBUG   -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)   -mreserve=data@0x800:0x84F   -Wl,,,--defsym=__MPLAB_BUILD=1,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,-D__DEBUG=__DEBUG,,$(MP_LINKER_FILE_OPTION),--heap=2048,--stack=16,--check-sections,--data-init,--pack-data,--handles,--no-gc-sections,--fill-upper=0,--stackguard=16,--no-force-link,--smart-io,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--report-mem,--memorysummary,${DISTDIR}/memoryfile.xml$(MP_EXTRA_LD_POST)  -mdfp="${DFP_DIR}/xc16" 
	
else
${DISTDIR}/LuxLogger.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -o ${DISTDIR}/LuxLogger.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -mcpu=$(MP_PROCESSOR_OPTION)        -omf=elf -DXPRJ_default=$(CND_CONF)    $(COMPARISON_BUILD)  -Wl,,,--defsym=__MPLAB_BUILD=1,$(MP_LINKER_FILE_OPTION),--heap=2048,--stack=16,--check-sections,--data-init,--pack-data,--handles,--no-gc-sections,--fill-upper=0,--stackguard=16,--no-force-link,--smart-io,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--report-mem,--memorysummary,${DISTDIR}/memoryfile.xml$(MP_EXTRA_LD_POST)  -mdfp="${DFP_DIR}/xc16" 
	${MP_CC_DIR}\\xc-dsc-bin2hex ${DISTDIR}/LuxLogger.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} -a  -omf=elf   -mdfp="${DFP_DIR}/xc16" 
	
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r ${OBJECTDIR}
	${RM} -r ${DISTDIR}

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(wildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
