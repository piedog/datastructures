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
OBJ_C1 = tstc_test.obj

PGM_C2 = container
OBJ_C2 = container.obj

PGMTST3 =
OBJTST3 =

PGMTST4 =
OBJTST4 =

PGMTST5 =
OBJTST5 =

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
all : container.exe
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
	$(OBJ_C2), -
	DB1:[DRVCHK.ROBERT.SHARE.DAC_CLIB]dac_clib/L

! Link target
$(PGMTST3).exe : $(OBJTST3)
	link $(LINKFLAGS) /exec=$(PGMTST3) -
	$(OBJTST3), -
	$(EXT_OBJS),-
	DB1:[DRVCHK.ROBERT.work.myfutils]myfutils/L,-
	DAC_LIB/L,-
	DB1:[DRVCHK.ROBERT.SHARE.DAC_CLIB]dac_clib/L,-
	DB1:[DRVCHK.ROBERT.SHARE.EXPAT-2]expat.olb/L

$(PGMTST4).exe : $(OBJTST4)
	link $(LINKFLAGS) /exec=$(PGMTST4) -
	$(OBJTST4),-
	DB1:[DRVCHK.ROBERT.SHARE.DAC_CLIB]dac_clib/L

$(PGMTST5).exe : $(OBJTST5)
	link $(LINKFLAGS) /exec=$(PGMTST5) -
	$(OBJTST5),-
	dac_lib/L,-
	DB1:[DRVCHK.ROBERT.SHARE.DAC_CLIB]dac_clib/L


! ===============================================================
!  Compile targets
!

!!tst_fxmltodoc2.obj : tst_fxmltodoc2.for
!!	FORTRAN $(FFLAGS) $(MMS$SOURCE)
!! =======================================================================

container.obj : container.c
	cc $(CFLAGS) $(MMS$SOURCE)

tstc_test1.obj : tstc_test1.c
	cc $(CFLAGS) $(MMS$SOURCE)

tstf_fortran.obj : tstf_fortran.for
	FORTRAN $(FFLAGS) $(MMS$SOURCE)

fxml_bb2doc.obj : fxml_bb2doc.c
	cc $(CFLAGS) $(MMS$SOURCE) -
	/include=([DRVCHK.ROBERT.share.expat-2], [DRVCHK.ROBERT.share.dac_clib])

stringmod.obj : stringmod.c
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