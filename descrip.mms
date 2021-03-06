!
! Usage:
! Build for Dev:   mms
! Build for Prod:  mms /macro=("BUILD=yes")
! Purge         :  mms purge
! mms cleanall  :  Del all exe,map,obj,...  Del all but source code
! mms clean     :  Del all obj, lis, map.  Del all but source code and exe
!
! NOTE: for includes, use this action just befor the compile action:
!       @ define mvr_inc DB1:[.INCLUDE],DT10:[YNOT.MVR.INC]
!

PGM_C1 = tstc_test
OBJ_C1 = tstc_test.obj,gdd_errorhandling.obj

PGM_C2 = tstc_node
OBJ_C2 = tstc_node.obj,gdd_node.obj,gdd_errorhandling.obj

PGM_C3 = tstc_list
OBJ_C3 = tstc_list.obj, gdd_list.obj, gdd_node.obj, gdd_errorhandling.obj

PGM_C4 = tstc_read
OBJ_C4 = tstc_read.obj

PGM_C5 = tstc_wordlist
OBJ_C5 = tstc_wordlist.obj, gdd_list.obj, gdd_node.obj, gdd_errorhandling.obj

PGM_C6 = tstc_cutils
OBJ_C6 = tstc_cutils.obj, cutils.obj

EXT_OBJS =

.IFDEF BUILD
FFLAGS = /NOLIST
CFLAGS = /nolist
LINKFLAGS = /nomap
.ELSE
FFLAGS = /LIST/nooptimize/debug=(all,traceback)
CFLAGS = /list/nooptimize/debug=(all,traceback)
LINKFLAGS = /full/MAP/symbol_table/cross_ref
.ENDIF

! ===============================================================
!!!all : tstc_node.exe,tstc_list.exe,tstc_read.exe,tstc_wordlist.exe tstc_cutils.exe
all : tstc_wordlist.exe
	@ write sys$output "All targets built"

! Link target
$(PGMTST1).exe : $(OBJTST1)
	link $(LINKFLAGS) /exec=$(PGMTST1) -
	$(OBJTST1), -
	DAC_LIB/L,-
	DB1:[DRVCHK.ROBERT.SHARE.DAC_CLIB]dac_clib/L,-
	DB1:[DRVCHK.ROBERT.SHARE.EXPAT-2]expat.olb/L

! Link target
$(PGM_C1).exe : $(OBJ_C1)
	link $(LINKFLAGS) /exec=$(PGM_C1) -
	$(OBJ_C1)

$(PGM_C2).exe : $(OBJ_C2)
	link $(LINKFLAGS) /exec=$(PGM_C2) -
	$(OBJ_C2)

$(PGM_C3).exe : $(OBJ_C3)
	link $(LINKFLAGS) /exec=$(PGM_C3) -
	$(OBJ_C3)

$(PGM_C4).exe : $(OBJ_C4)
	link $(LINKFLAGS) /exec=$(PGM_C4) -
	$(OBJ_C4)

$(PGM_C5).exe : $(OBJ_C5)
	link $(LINKFLAGS) /exec=$(PGM_C5) -
	$(OBJ_C5)

$(PGM_C6).exe : $(OBJ_C6)
	link $(LINKFLAGS) /exec=$(PGM_C6) -
	$(OBJ_C6)

! ===============================================================
!  Compile targets
!

!!tst_fxmltodoc2.obj : tst_fxmltodoc2.for
!!	FORTRAN $(FFLAGS) $(MMS$SOURCE)
!! =======================================================================

tstc_list.obj : tstc_list.c gdd_node.h gdd_errorhandling.h gdd_list.h
	cc $(CFLAGS) $(MMS$SOURCE)

gdd_list.obj : gdd_list.c gdd_node.h gdd_errorhandling.h gdd_list.h
	cc $(CFLAGS) $(MMS$SOURCE)

gdd_node.obj : gdd_node.c gdd_node.h gdd_errorhandling.h
	cc $(CFLAGS) $(MMS$SOURCE)

gdd_errorhandling.obj : gdd_errorhandling.c gdd_errorhandling.h
	cc $(CFLAGS) $(MMS$SOURCE)

tstc_node.obj : tstc_node.c gdd_node.h gdd_errorhandling.h
	cc $(CFLAGS) $(MMS$SOURCE)

tstc_read.obj : tstc_read.c
	cc $(CFLAGS) $(MMS$SOURCE)

cutils.obj : cutils.c cutils.h
	cc $(CFLAGS) $(MMS$SOURCE)

tstc_wordlist.obj : tstc_wordlist.c gdd_node.h gdd_errorhandling.h
	cc $(CFLAGS) $(MMS$SOURCE)

tstf_fortran.obj : tstf_fortran.for
	FORTRAN $(FFLAGS) $(MMS$SOURCE)

fxml_bb2doc.obj : fxml_bb2doc.c
	cc $(CFLAGS) $(MMS$SOURCE) -
	/include=([DRVCHK.ROBERT.share.expat-2], [DRVCHK.ROBERT.share.dac_clib])

! ===============================================================
! Miscellaneous target section

purge :
	@ purge

clean :
	@ delete/noconfirm *.obj;*,*.map;*,*.stb;*,*.lis;*

cleanall :
	@ purge
	@ delete/noconfirm  *.obj;*,*.lis;*,*.map;*,*.exe;*,*.stb;*
