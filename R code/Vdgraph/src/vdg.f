C  Computer Program for Variance Dispersion Graphs 
C    written by G. Geoffrey Vining 
C    published in Journal of Quality Technology
C            vol. 25 No. 1 1993
C
C  This is a revised program listing that incorporates
C  the changes discussed in the Corrigenda, JQT 25,
C  pp. 333-335.
C   
      SUBROUTINE VDG(NDPTS,KVAR1,KDVL,RDES,VDGR)
c
c  This program was chnged to a subroutine by 
C         John Lawson January 2011
C
C  INPUTS: 
C     NDPTS - NUMBER OF RUNS IN THE DESIGN
C     KVAR1 - NUMBER OF FACTORS IN THE DESIGN
C     KDVL  - NDPTS*KVAR1
c
      PARAMETER (MP=7,MD=99,M1=MP+1,M2=(MP+1)*(MP+2)/2
     &,MG=2**MP+2*MP,MG2=2*MP*(MP-1)*(MP-2))
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      CHARACTER*40 TITLE
      CHARACTER*10 DESIGN,NAMDAT,NAMPRT,NAMOUT
      CHARACTER*1 PLINE(60),SEARCH,CREG,CWT,CENT
      INTEGER FLAG,FLAG2,ENTER,ORDER,CUBE,SIMPLX
      DIMENSION DP(MD,M1),VDGR(84),RDES(700)
      COMMON PTS(MG,MP),PVAL(101,MP),X(M1),X0(M2),
     &PTS2(MG,MP),PTS3(MG2,MP),XMAT(M2,M2),DES(MD,MP),
     &D(MD,M2),XBEST(MP),SCA
      COMMON ORDER,MODEL,CUBE,MAX,SIMPLX,K,KP,K1,K2,
     &ITEST,INIT,LEVEL,NPTS3,NWT
      ITEST=0
      INIT=0
	  K=KVAR1
	  VK=FLOAT(K)
10    FLAG=0
20    FLAG2=0
C 
C INITIALIZE COMMON VARIABLES TO START
C
      DO 800 I = 1, 101
	     DO 801 J=1, MP
		 PVAL(I,J)=0.0
 801  CONTINUE
 800  CONTINUE
      DO 802 I=1, MG
	     DO 803 J=1,MP
		   PTS(I,J)=0.0
		   PTS2(I,J)=0.0
		   XBEST(J)=0.0
 803     CONTINUE
 802  CONTINUE
      DO 804 I=1,M1
	   X(I)=0.0
 804  CONTINUE
      DO 805 I=1,M2
	     DO 806 J=1,M2
		  XMAT(I,J)=0.0
		  X0(I)=0.0
 806     CONTINUE
 805  CONTINUE
      DO 807 I=1,MD
	     DO 808 J=1, M2
		  D(I,J)=0.0
 808     CONTINUE
 807  CONTINUE
      DO 809 I=1,MG2
	     DO 810 J=1, MP
		  PTS3(I,J)=0.0
 810     CONTINUE
 809  CONTINUE 
C
C FIX THE ORDER OF THE MODEL TO BE 2
C
      ORDER=2
C
C CHANGE THE INPUT VECTORIZED DESIGN MATRIX INTO A MATRIX
c
      IF(FLAG.EQ.1) GO TO 10
	  DO 51 I=1,K
	  DO 31 J=1,NDPTS
	  KPOS=(I-1)*NDPTS+J
	  DES(J,I)=RDES(KPOS)
31    CONTINUE
51    CONTINUE
C
c Fix the search intensity to be standard (i.e., SIMPLX=1)
      SIMPLX=1
c Fix the name for the output file to be 'Title' 
      TITLE='Title'
c Set the experimental Region to be Spherical (i.e., CUBE=0, CUBE=1 for cuboidal)
	  CUBE=0
c Weights results by the number of data points to remove this option set NWT=1
      NWT=0
c Fix the number of non-zero radii to be 20 (can be anything from 1 to 99)
      NRHO=20
c Fix the nickname to use in the output file
      DESIGN='   '
c Fix the scaling factor to be 1.0 the unit hypersphere
      SCA=DSQRT(VK)
c Fix the fraction of the total region radius you want the design to occupy 1=the entire unit region
      FACT1=1.0D0
      KP=K+1
      IF(ORDER.EQ.1) K1=K+1
      IF(ORDER.EQ.2) K1=1+2*K+K*(K-1)/2
      CALL GRID(NPTSF,NPTSA,NPTS)
      A=0
      DO 50 I=1,NDPTS
       D(I,1)=1.0D0
       DP(I,1)=1.0D0
       DO 30 J=1,K
        J2=J+1
        DP(I,J2)=DES(I,J)
30     CONTINUE
       SUM=0
       DO 40 J=2,KP
        SUM=SUM+DP(I,J)*DP(I,J)
40     CONTINUE
       IF(SUM.GT.A) A=SUM
50    CONTINUE
      FACT=FACT1/(DSQRT(A))
      DO 70 I=1,NDPTS
       DO 60 J=2,KP
        DP(I,J)=FACT*DP(I,J)
60     CONTINUE
70    CONTINUE
C
C  Set up the design in the model space and
C  find the inverse of D'D.
C
      DO 100 I=1,NDPTS
       DO 80 J=1,KP
        X(J)=DP(I,J)
80     CONTINUE
       CALL MXPAND
       DO 90 J=1,K1
        D(I,J)=X0(J)
90     CONTINUE
100   CONTINUE
      CALL BMAT(NDPTS)
C
C  Print appropriate headings and call
C  procedure to perform the analysis.
C
      IF(CUBE.EQ.1) THEN
      ELSE
      ENDIF
      CALL PROCV(NRHO,NDPTS,NPTSF,NPTSA)
C
C  Find the largest prediction variance for plotting
C  purposes, and then print the graph.
C
      NRHO2=NRHO+1
      DENOM=NRHO
      DENOMZ=NDPTS
      VMAX=2.0D0*K1
      IF(NWT.EQ.1) VMAX=VMAX/DENOMZ
      DO 110 I=1,NRHO2
       IF(PVAL(I,1).GT.VMAX) VMAX=PVAL(I,1)
       RSQ2=SCA*(I-1)/DENOM
	   VDGR(I)=RSQ2
110   CONTINUE
	  DO 111 J=1,3
	    DO 112 I=1,NRHO2
		KPOSV=J*NRHO2+I
		VDGR(KPOSV)=PVAL(I,J)
112     CONTINUE
111   CONTINUE	  
      DO 120 J=1,60
       PLINE(J) = '_'
120   CONTINUE
      DO 140 I=1,NRHO2
       DO 130 J=1,60
        PLINE(J)=' '
130    CONTINUE
       AK1=K1
       IF(NWT.EQ.1) AK1=AK1/DENOMZ
       RATIO=AK1/VMAX
       NLOC=60.0*RATIO
       PLINE(NLOC)='|'
       RATIO=2.0*AK1/VMAX
       NLOC=60.0*RATIO
       PLINE(NLOC)='|'
       RATIO=PVAL(I,1)/VMAX
       NLOC=60.0*RATIO
       PLINE(NLOC)='L'
       RATIO=PVAL(I,2)/VMAX
       NLOC=60.0*RATIO
       PLINE(NLOC)='S'
       RATIO=PVAL(I,3)/VMAX
       NLOC=60.0*RATIO
       IF(CUBE.NE.1) PLINE(NLOC)='A'
       RSQ2=SCA*(I-1)/DENOM
140   CONTINUE
      RETURN
      END
C ****************************************************
      SUBROUTINE GRID(NPTSF,NPTSA,NPTS)
C ****************************************************
C
C  Sets up the grid used in the initial phase of
C  the search procedure.
C
      PARAMETER (MP=7,MD=99,M1=MP+1,M2=(MP+1)*(MP+2)/2
     &,MG=2**MP+2*MP,MG2=2*MP*(MP-1)*(MP-2))
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      INTEGER ORDER,CUBE,SIMPLX
      COMMON PTS(MG,MP),PVAL(101,MP),X(M1),X0(M2),
     &PTS2(MG,MP),PTS3(MG2,MP),XMAT(M2,M2),DES(MD,MP),
     &D(MD,M2),XBEST(MP),SCA
      COMMON ORDER,MODEL,CUBE,MAX,SIMPLX,K,KP,K1,K2,
     &ITEST,INIT,LEVEL,NPTS3,NWT
C
C  Set up the factorial points to be used in the
C  grid search.
C
      NPTSF=1
      NPTSF=2**K
      NPTSA=2*K
      NPTS=NPTSF+NPTSA
      DO 20 I=1,NPTS
       DO 10 J=1,K
        PTS(I,J)=0
10     CONTINUE
20    CONTINUE
      DO 40 I=1,NPTSF
       DO 30 J=1,K
        KDEN=I*(2**J)
        KEXP=KDEN/NPTSF
        PTS(I,J)=(-1.0D0)**KEXP
30     CONTINUE
40    CONTINUE
C
C  Set up the axial points to be used in the grid
C  search.
C
      INDEX=NPTSF
      AK=K
      SQRTK=DSQRT(AK)
      DO 50 I=1,K
       INDEX=INDEX+1
       PTS(INDEX,I)=-SQRTK
       INDEX=INDEX+1
       PTS(INDEX,I)=SQRTK
50    CONTINUE
      RETURN
      END
C ***************************************************
      SUBROUTINE PROCV(NRHO,NDPTS,NPTSF,NPTSA)
C ***************************************************
C
C  Controls the appropriate analysis to produce
C  the prediction variance plots.
C
      PARAMETER (MP=7,MD=99,M1=MP+1,M2=(MP+1)*(MP+2)/2
     &,MG=2**MP+2*MP,MG2=2*MP*(MP-1)*(MP-2))
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      CHARACTER*4 XVECT(7)
      INTEGER ORDER,CUBE,SIMPLX
      COMMON PTS(MG,MP),PVAL(101,MP),X(M1),X0(M2),
     &PTS2(MG,MP),PTS3(MG2,MP),XMAT(M2,M2),DES(MD,MP),
     &D(MD,M2),XBEST(MP),SCA
      COMMON ORDER,MODEL,CUBE,MAX,SIMPLX,K,KP,K1,K2,
     &ITEST,INIT,LEVEL,NPTS3,NWT
      DATA XVECT/'X(1)','X(2)','X(3)','X(4)','X(5)',
     &'X(6)','X(7)'/
C
C  Print appropriate headings
C
      X(1)=1.0D0
      X0(1)=1.0D0
      PVAL(1,4)=NDPTS
c      WRITE(8,40)
      DO 30 MAX=1,3
c       IF(MAX.EQ.1) WRITE(8,50) (XVECT(I),I=1,K)
c       IF(MAX.EQ.2) WRITE(8,60) (XVECT(I),I=1,K)
c       IF(MAX.EQ.3) WRITE(8,70)
C
C  Find the prediction variance at the design center,
C  and adjust this value to reflect the number of
C  design runs.
C
       DO 10 I=2,KP
        X(I)=0
10     CONTINUE
       DO 15 I=2,K1
        X0(I)=0
15     CONTINUE
       RSQ=0
       CALL VMULT(VALUE)
       IF(NWT.NE.1) VALUE=NDPTS*VALUE

       PVAL(1,MAX)=VALUE
c      IF(MAX.LT.3) WRITE(8,80) RSQ,VALUE,(X(I),I=2,KP)
c       IF(MAX.EQ.3) WRITE(8,90) RSQ,VALUE
C
C  Find the maximum, minimum, and average prediction
C  variance for various radii through the unit
C  hypersphere, adjust these values to reflect the
C  number of design runs used, and then print.
C
       ROLD=0
       DO 20 I=1,NRHO
        I2=I+1
        DENOM=NRHO
        AK=K
        R=I/DENOM
        RSQ=R*R
        R2=RSQ/AK
        RSQ2=SCA*R
        IF(MAX.LT.3) CALL MINLOC(ROLD,R2,RSQ,BEST,
     &  NPTSF,NPTSA)
        IF(MAX.EQ.3) CALL VSPH(BEST,RSQ)
        IF(MAX.EQ.1) BEST=-BEST
        IF(NWT.NE.1) BEST=NDPTS*BEST
        PVAL(I2,MAX)=BEST
        PVAL(I2,4)=NDPTS
c        IF(MAX.LT.3) WRITE(8,80) RSQ2,BEST,
c     &  (XBEST(J),J=1,K)
c        IF(MAX.EQ.3) WRITE(8,90) RSQ2,BEST
        ROLD=RSQ
20     CONTINUE
30    CONTINUE
c40    FORMAT(///1X,'PREDICTION VARIANCE RESULTS')
50    FORMAT(///1X,'MAXIMUMS'//4X,'R',8X,'VALUE',
     &           6(6X,A4)//)
60    FORMAT(///1X,'MINIMUMS'//4X,'R',8X,'VALUE',
     &           6(6X,A4)//)
70    FORMAT(///1X,'AVERAGES'//13X,'R',14X,'VALUE')
80    FORMAT(1X,F8.4,7F10.6)
90    FORMAT(1X,2F16.6)
      RETURN
      END
C ****************************************************
      SUBROUTINE MINLOC(ROLD,R2,RSQ,BEST,NPTSF,NPTSA)
C ****************************************************
C
C  Finds the minimum prediction variance over a
C  hypersphere of a given radius.
C
      PARAMETER (MP=7,MD=99,M1=MP+1,M2=(MP+1)*(MP+2)/2
     &,MG=2**MP+2*MP,MG2=2*MP*(MP-1)*(MP-2))
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      INTEGER OVER(MP),SAVE,TRUNC,FLAG,FLAG2,ORDER,
     &CUBE,SIMPLX
      DOUBLE PRECISION MAXLEN,MAX2
      DIMENSION PROP(MP),TEMP2(MP)
      COMMON PTS(MG,MP),PVAL(101,MP),X(M1),X0(M2),
     &PTS2(MG,MP),PTS3(MG2,MP),XMAT(M2,M2),DES(MD,MP),
     &D(MD,M2),XBEST(MP),SCA
      COMMON ORDER,MODEL,CUBE,MAX,SIMPLX,K,KP,K1,K2,
     &ITEST,INIT,LEVEL,NPTS3,NWT
C
C  Project the location of the best value from the
C  previous radius to the current radius.
C
      MAXLEN=DSQRT(1.0D0/K)
      MAX2=1.0D0/K
      TRUNC=0
      BEST=9999999.0D0
      RSQ=K*R2
      R=DSQRT(R2)
      RP=DSQRT(ROLD)
      RP2=DSQRT(RSQ)
      X(1)=1.0D0
      X0(1)=1.0D0
      IF(CUBE.EQ.1 .AND. RP2.GE.MAXLEN) TRUNC=1
      IF(ROLD.NE.0) THEN
       DO 10 J=1,K
        J2=J+1
        XBEST(J)=RP2*XBEST(J)/RP
        X(J2)=XBEST(J)
10     CONTINUE
       IF(TRUNC.NE.0) THEN
C
C   Find a reasonable projection of the previous best
C   point when the region is cuboidal and the search
C   must be restricted.
C
       NUM=0
        DO 20 J=1,K
         IF(DABS(XBEST(J)).GT.MAXLEN) THEN
          NUM=NUM+1
          OVER(NUM)=J
         ENDIF
20      CONTINUE
        IF(NUM.GT.0) THEN
30       DO 40 J=1,K
          PROP(J)=99.0D0
          TEMP2(J)=0
40       CONTINUE
         SUM=0
         DO 60 J=1,K
          DO 50 JDEX=1,NUM
           IF(J.EQ.OVER(JDEX)) GO TO 60
50        CONTINUE
          PROP(J)=XBEST(J)*XBEST(J)
          SUM=SUM+PROP(J)
60       CONTINUE
         IF(SUM.EQ.0.AND.NUM.LT.K)
     &   PROP2=1.0D0/(K-NUM)
         IF(SUM.EQ.0.AND.NUM.EQ.K) PROP2=1.0D0/K
          TEMP=RSQ-NUM*MAX2
          IF(TEMP.LT.0) TEMP=0
          DO 70 J=1,K
           IF(PROP(J).LE.1.0D0.AND.SUM.NE.0)
     &     TEMP2(J)=PROP(J)*TEMP/SUM
           IF(PROP(J).LE.1.0D0.AND.SUM.EQ.0)
     &     TEMP2(J)=PROP2*TEMP
           IF(PROP(J).GT.1.0D0) TEMP2(J)=MAX2
           IF(TEMP2(J).GT.MAX2) THEN
            NUM=NUM+1
            OVER(NUM)=J
            GO TO 30
           ENDIF
70        CONTINUE
          DO 80 J=1,K
           J2=J+1
           TEMP1=DSQRT(TEMP2(J))
           IF(XBEST(J).GE.0) XBEST(J)=TEMP1
           IF(XBEST(J).LT.0) XBEST(J)=-TEMP1
           X(J2)=XBEST(J)
80        CONTINUE
         ENDIF
         CALL MXPAND
         CALL VMULT(BEST)
         IF(MAX.EQ.1) BEST=-BEST
c         IF(INIT.EQ.1) WRITE(8,290) (X(J),J=2,KP),BEST
        ENDIF
        IF(TRUNC.EQ.0.AND.SIMPLX.GE.1) THEN
         DO 90 J=1,K
          J2=J+1
          X(J2)=XBEST(J)
90       CONTINUE
         CALL AMOEBA(RSQ,VALUE)
         IF(VALUE.LT.BEST) THEN
          DO 100 J=1,K
           J2=J+1
           XBEST(J)=X(J2)
100       CONTINUE
          BEST=VALUE
         ENDIF
        ENDIF
       ENDIF
       SAVE=0
       IF(TRUNC.EQ.0) NEND=NPTSF+NPTSA
       IF(TRUNC.EQ.1) NEND=NPTSF
       IF(TRUNC.NE.0) THEN
C
C  Look at other refinements of the projected best
C  point when the region is cuboidal and the search
C  is over a truncated sphere.
C
        FLAG=0
        DO 190 J=1,K
         TEMP=RSQ
         DO 110 J2=1,K
          J3=J2+1
          X(J3)=XBEST(J2)
          IF(DABS(XBEST(J2)).GE.MAXLEN) TEMP=TEMP-MAX2
110      CONTINUE
         IF(TEMP.LE.0) TEMP=0
         TEMP1=DSQRT(TEMP)
         IF(TEMP1.LE.MAXLEN) THEN
          DO 120 J2=1,K
           IF(J.EQ.J2.AND.DABS(XBEST(J2)).GE.MAXLEN)
     &     GO TO 190
           J3=J2+1
           IF(XBEST(J2).GE.MAXLEN) X(J3)=MAXLEN
           IF(XBEST(J2).LE.MAXLEN) X(J3)=-MAXLEN
           IF(J.EQ.J2.AND.XBEST(J2).GE.0) X(J3)=TEMP1
           IF(J.EQ.J2.AND.XBEST(J2).LT.0) X(J3)=-TEMP1
           IF(J.NE.J2.AND.DABS(XBEST(J2)).LT.MAXLEN)
     &     X(J3)=0
120       CONTINUE
          CALL MXPAND
          CALL VMULT(VALUE)
          IF(MAX.EQ.1) VALUE=-VALUE
c          IF(INIT.EQ.1) WRITE(8,290) (X(J2),J2=2,KP),
c     &    VALUE
          IF(VALUE.LT.BEST) THEN
           FLAG=1
           DO 130 J2=1,K
            J3=J2+1
            TEMP2(J2)=X(J3)
130        CONTINUE
          ENDIF
         ELSE
          DO 140 J2=1,K
           J3=J2+1
           X(J3)=XBEST(J2)
140       CONTINUE
          FLAG2=0
150       DO 160 J2=1,K
           J3=J2+1
           IF(DABS(X(J3)).LT.MAXLEN.AND.J.NE.J2) THEN
            FLAG2=1
            SAVE=J2
           ENDIF
160       CONTINUE
          IF(FLAG2.EQ.1) THEN
           J3=SAVE+1
           IF(XBEST(SAVE).LT.0) X(J3)=-MAXLEN
           IF(XBEST(SAVE).GE.0) X(J3)=MAXLEN
           TEMP=TEMP-MAX2
           IF(TEMP.LE.0) TEMP=0
           TEMP1=DSQRT(TEMP)
           IF(TEMP1.GT.MAXLEN) GO TO 150
           DO 170 J2=1,K
            J3=J2+1
            IF(J.EQ.J2.AND.DABS(X(J3)).GE.MAXLEN)
     &      GO TO 190
            IF(J.EQ.J2.AND.X(J3).GE.0) X(J3)=TEMP1
            IF(J.EQ.J2.AND.X(J3).LT.0) X(J3)=-TEMP1
            IF(J.NE.J2.AND.DABS(X(J3)).LT.MAXLEN)
     &      X(J3) = 0
170        CONTINUE
           CALL MXPAND
           CALL VMULT(VALUE)
           IF(MAX.EQ.1) VALUE=-VALUE
c           IF(INIT.EQ.1) WRITE(8,290) (X(J2),J2=2,KP),
c     &     VALUE
           IF(VALUE.LT.BEST) THEN
            FLAG=1
            DO 180 J2=1,K
             J3=J2+1
             TEMP2(J2)=X(J3)
180         CONTINUE
           ENDIF
          ENDIF
         ENDIF
190     CONTINUE
        IF(FLAG.EQ.1) THEN
         DO 200 J=1,K
          XBEST(J)=TEMP2(J)
200      CONTINUE
       ENDIF
      ENDIF
C
C  Perform the grid search in an attempt to
C  improve the starting value.
C
      DO 240 I=1,NEND
       PTS2(I,1)=1.0D0
       DO 210 J=1,K
        J2=J+1
        PTS2(I,J)=R*PTS(I,J)
        X(J2)=PTS2(I,J)
210    CONTINUE
       CALL MXPAND
       CALL VMULT(VALUE)
       IF(MAX.EQ.1) VALUE=-VALUE
c       IF(INIT.EQ.1) WRITE(8,290) (X(J),J=2,KP),VALUE
       IF(VALUE.LT.BEST) THEN
        BEST=VALUE
        DO 220 J=1,K
         XBEST(J)=PTS2(I,J)
220     CONTINUE
       ENDIF
       IF(SIMPLX.EQ.2.AND.TRUNC.EQ.0) THEN
        CALL AMOEBA(RSQ,VALUE)
        IF(VALUE.LT.BEST) THEN
         DO 230 J=1,K
          J2=J+1
          XBEST(J)=X(J2)
230      CONTINUE
         BEST=VALUE
        ENDIF
       ENDIF
240   CONTINUE
C
C  Perform the floating portion of the search.
C
      IF(TRUNC.EQ.0) STEP=2.0D0*R
      IF(TRUNC.EQ.1) STEP=1.414D0*(1.0D0-RSQ)
      DO 280 I=1,5
       FLAG=0
       NLOOPS=0
       STEP=STEP/2.0D0
       CALL NEWX(STEP,RSQ)
250    IF(FLAG.EQ.1) CALL NEWX2(SAVE,STEP,RSQ)
        NLOOPS=NLOOPS+1
        IF(NLOOPS.GT.200) THEN
c         WRITE(8,300)
c         WRITE(8,310)
c         WRITE(8,320) NLOOPS
         RETURN
        ENDIF
        FLAG=0
        DO 270 J1=1,NPTS3
         DO 260 J2=1,K
          J3=J2+1
          X(J3)=PTS3(J1,J2)
260      CONTINUE
         CALL MXPAND
c         IF(ITEST.EQ.1) WRITE(8,330) (X0(JZ),JZ=2,KP)
         CALL VMULT(VALUE)
         IF(MAX.EQ.1) VALUE=-VALUE
         IF(VALUE.LT.BEST) THEN
          FLAG=1
          SAVE=J1
          BEST=VALUE
         ENDIF
270     CONTINUE
       IF(FLAG.EQ.1) GO TO 250
280   CONTINUE
290   FORMAT(4F16.6//)
300   FORMAT(////' PROBLEM ENCOUNTERED IN MINLOC')
310   FORMAT(//' YOU MAY WISH TO CHANGE NLOOPS')
320   FORMAT(//' CURRENT VALUE FOR NLOOPS:',I5)
330   FORMAT(3F16.6)
      RETURN
      END
C ******************************************************
      SUBROUTINE NEWX2(SAVE,STEP,R2)
C ******************************************************
C
C  Places the current best estimate of the maximum
C  or mimimum into xbest and then sets up another
C  grid for the floating portion of the search.
C
      PARAMETER (MP=7,MD=99,M1=MP+1,M2=(MP+1)*(MP+2)/2
     &,MG=2**MP+2*MP,MG2=2*MP*(MP-1)*(MP-2))
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      INTEGER ORDER,CUBE,SAVE
      COMMON PTS(MG,MP),PVAL(101,MP),X(M1),X0(M2),
     &PTS2(MG,MP),PTS3(MG2,MP),XMAT(M2,M2),DES(MD,MP),
     &D(MD,M2),XBEST(MP),SCA
      COMMON ORDER,MODEL,CUBE,MAX,SIMPLX,K,KP,K1,K2,
     &ITEST,INIT,LEVEL,NPTS3,NWT
      DO 100 I=1,K
       XBEST(I)=PTS3(SAVE,I)
 100  CONTINUE
      CALL NEWX(STEP,R2)
      RETURN
      END
C *******************************************************
      SUBROUTINE NEWX(STEP,R2)
C *******************************************************
C
C  Determines the grid for the floating portion of
C  the search.
C
      PARAMETER (MP=7,MD=99,M1=MP+1,M2=(MP+1)*(MP+2)/2
     &,MG=2**MP+2*MP,MG2=2*MP*(MP-1)*(MP-2))
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      INTEGER ORDER,CUBE,SIMPLX
      DOUBLE PRECISION MAXLEN
      COMMON PTS(MG,MP),PVAL(101,MP),X(M1),X0(M2),
     &PTS2(MG,MP),PTS3(MG2,MP),XMAT(M2,M2),DES(MD,MP),
     &D(MD,M2),XBEST(MP),SCA
      COMMON ORDER,MODEL,CUBE,MAX,SIMPLX,K,KP,K1,K2,
     &ITEST,INIT,LEVEL,NPTS3,NWT
C
C  Based on the step size set up the distance measures
C  that are required to construct base levels for the
C  factorial points.
C
      MAXLEN=DSQRT((1.0D0/K))
      R=DSQRT(R2)
      IF(K.EQ.2) CALL NEWXK(STEP,R)
      IF(K.EQ.2) RETURN
      DIST=STEP*STEP/(2.0D0*R2)
      STEP2=R2*(2.0D0*DIST-DIST*DIST)*DSQRT(.75D0)
      KOUNT=0
      DO 120 J3=1,K-1
       DO 110 J4=J3+1,K
        DO 100 J5=1,K
         IF(J5.EQ.J3) GO TO 100
         IF(J5.EQ.J4) GO TO 100
         KPOS=4*KOUNT
         KOUNT=KOUNT+1
         KPOS1=KPOS+1
         KPOS2=KPOS+2
         KPOS3=KPOS+3
         KPOS4=KPOS+4
         DO 10 INDEX=1,K
          PTS3(KPOS1,INDEX)=XBEST(INDEX)
          PTS3(KPOS2,INDEX)=XBEST(INDEX)
          PTS3(KPOS3,INDEX)=XBEST(INDEX)
          PTS3(KPOS4,INDEX)=XBEST(INDEX)
10       CONTINUE
C
C  Calculate the base values for the two design
C  variables chosen to construct the factorial
C  portion.
C
         C3=XBEST(J3)*(1.0D0-DIST)
         C4=XBEST(J4)*(1.0D0-DIST)
C
C  Calculate the angle required by the geometrical
C  relationship to find the high and low levels for
C  the factorials,and then construct the first point
C  in this portion.
C
         IF(C3.NE.0) THETA=DATAN(C4/C3)
         IF(C3.EQ.0) THETA=0.7854D0
         TEMP1=C3+(STEP2)*DSIN(THETA)
         TEMP2=C4-(STEP2)*DCOS(THETA)
         C2=R2-TEMP1*TEMP1-TEMP2*TEMP2
         SUM=0
         DO 20 LDEX=1,K
          IF(LDEX.EQ.J3) GO TO 20
          IF(LDEX.EQ.J4) GO TO 20
          IF(LDEX.EQ.J5) GO TO 20
          SUM=SUM+XBEST(LDEX)*XBEST(LDEX)
20       CONTINUE
         C2=C2-SUM
         IF(C2.LT.0) GO TO 40
         IF(CUBE.NE.1) GO TO 30
         IF(C2.GT.MAXLEN) GO TO 40
         IF(DABS(TEMP1).GT.MAXLEN) GO TO 40
         IF(DABS(TEMP2).GT.MAXLEN) GO TO 40
30       C2=DSQRT(C2)
         IF(CUBE.EQ.1.AND.C2.GT.MAXLEN) GO TO 40
         IF(XBEST(J5).LT.0) C2=-C2
         PTS3(KPOS1,J3)=TEMP1
         PTS3(KPOS1,J4)=TEMP2
         PTS3(KPOS1,J5)=C2
C
C  Construct the second point
C
40       TEMP1=C3-(STEP2)*DSIN(THETA)
         TEMP2=C4+(STEP2)*DCOS(THETA)
         C2=R2-TEMP1*TEMP1-TEMP2*TEMP2
         C2=C2-SUM
         IF(C2.LT.0) GO TO 60
         IF(CUBE.NE.1) GO TO 50
         IF(C2.GT.MAXLEN) GO TO 60
         IF(DABS(TEMP1).GT.MAXLEN) GO TO 60
         IF(DABS(TEMP2).GT.MAXLEN) GO TO 60
50       C2=DSQRT(C2)
         IF(CUBE.EQ.1.AND.C2.GT.MAXLEN) GO TO 60
         IF(XBEST(J5).LT.0) C2=-C2
         PTS3(KPOS2,J3)=TEMP1
         PTS3(KPOS2,J4)=TEMP2
         PTS3(KPOS2,J5)=C2
C
C  Construct the third point
C
60       TEMP1=C3-(STEP2)*DSIN(THETA)
         TEMP2=C4-(STEP2)*DCOS(THETA)
         C2=R2-TEMP1*TEMP1-TEMP2*TEMP2
         C2=C2-SUM
         IF(C2.LT.0) GO TO 80
         IF(CUBE.NE.1) GO TO 70
         IF(C2.GT.MAXLEN) GO TO 80
         IF(DABS(TEMP1).GT.MAXLEN) GO TO 80
         IF(DABS(TEMP2).GT.MAXLEN) GO TO 80
70       C2=DSQRT(C2)
         IF(CUBE.EQ.1.AND.C2.GT.MAXLEN) GO TO 80
         IF(XBEST(J5).LT.0) C2=-C2
         PTS3(KPOS3,J3)=TEMP1
         PTS3(KPOS3,J4)=TEMP2
         PTS3(KPOS3,J5)=C2
C
C  Construct the fourth point
C
80       TEMP1=C3+(STEP2)*DSIN(THETA)
         TEMP2=C4+(STEP2)*DCOS(THETA)
         C2=R2-TEMP1*TEMP1-TEMP2*TEMP2
         C2=C2-SUM
         IF(C2.LT.0) GO TO 100
         IF(CUBE.NE.1) GO TO 90
         IF(C2.GT.MAXLEN) GO TO 100
         IF(DABS(TEMP1).GT.MAXLEN) GO TO 100
         IF(DABS(TEMP2).GT.MAXLEN) GO TO 100
90       C2=DSQRT(C2)
         IF(CUBE.EQ.1.AND.C2.GT.MAXLEN) GO TO 100
         IF(XBEST(J5).LT.0) C2=-C2
         PTS3(KPOS4,J3)=TEMP1
         PTS3(KPOS4,J4)=TEMP2
         PTS3(KPOS4,J5)=C2
100     CONTINUE
110    CONTINUE
120   CONTINUE
      NPTS3=4*KOUNT
      RETURN
      END
C ****************************************************
      SUBROUTINE NEWXK(STEP,R)
C ****************************************************
C
C   Determines the grid for the floating portion of
C   the search when K=2.
C
      PARAMETER (MP=7,MD=99,M1=MP+1,M2=(MP+1)*(MP+2)/2
     &,MG=2**MP+2*MP,MG2=2*MP*(MP-1)*(MP-2))
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      INTEGER ORDER,CUBE,SIMPLX
      COMMON PTS(MG,MP),PVAL(101,MP),X(M1),X0(M2),
     &PTS2(MG,MP),PTS3(MG2,MP),XMAT(M2,M2),DES(MD,MP),
     &D(MD,M2),XBEST(MP),SCA
      COMMON ORDER,MODEL,CUBE,MAX,SIMPLX,K,KP,K1,K2,
     &ITEST,INIT,LEVEL,NPTS3,NWT
      THETA1=DCOS(XBEST(1)/R)
      THETA2=DSIN(STEP/R)
      NPTS3=2
      PTS3(1,1)=R*DCOS(THETA1+THETA2)
      PTS3(1,2)=R*DSIN(THETA1+THETA2)
      PTS3(2,1)=R*DCOS(THETA1-THETA2)
      PTS3(2,2)=R*DSIN(THETA1-THETA2)
      RETURN
      END
C *****************************************************
      SUBROUTINE VSPH(VALUE,RSQ)
C *****************************************************
C
C  Finds the spherical average for the prediction
C  variance over a hypersphere of a given radius.
C
      PARAMETER (MP=7,MD=99,M1=MP+1,M2=(MP+1)*(MP+2)/2
     &,MG=2**MP+2*MP,MG2=2*MP*(MP-1)*(MP-2))
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      INTEGER ORDER,CUBE,SIMPLX
      DIMENSION P(M2,M2),P2(M2,M2)
      COMMON PTS(MG,MP),PVAL(101,MP),X(M1),X0(M2),
     &PTS2(MG,MP),PTS3(MG2,MP),XMAT(M2,M2),DES(MD,MP),
     &D(MD,M2),XBEST(MP),SCA
      COMMON ORDER,MODEL,CUBE,MAX,SIMPLX,K,KP,K1,K2,
     &ITEST,INIT,LEVEL,NPTS3,NWT
C
C  Find the spherical variance for the first order case.
C
      IF(ORDER.EQ.1) THEN
       VALUE=XMAT(1,1)
       DO 10 I=2,KP
        DENOM=K
        VALUE=VALUE+XMAT(I,I)*RSQ/DENOM
10     CONTINUE
       RETURN
      ENDIF
C
C  Find the spherical variance for the second order
C  case.
C
      DO 30 I=1,K1
       DO 20 J=1,K1
        P(I,J)=0
20     CONTINUE
30    CONTINUE
      DENOM=K
      DENOM2=K*(K+2)
      P(1,1)=1
      DO 50 I=1,K
       I2=I+1
       P(I2,I2)=RSQ/DENOM
       KLOC=KP+I
       P(1,KLOC)=RSQ/DENOM
       P(KLOC,1)=RSQ/DENOM
       DO 40 J=1,K
        KLOC2=KP+J
        P(KLOC,KLOC2)=RSQ*RSQ/DENOM2
40     CONTINUE
       P(KLOC,KLOC)=3*P(KLOC,KLOC)
50    CONTINUE
C
C  Set up P for the section corresponding to the
C  two-factor interactions.
C
      KLOC=2+2*K
      DO 60 I=KLOC,K1
       P(I,I)=RSQ*RSQ/DENOM2
60    CONTINUE
      DO 90 I=1,K1
       DO 80 J=1,K1
        P2(I,J)=0
        DO 70 J2=1,K1
         P2(I,J)=P2(I,J)+P(I,J2)*XMAT(J2,I)
70      CONTINUE
80     CONTINUE
90    CONTINUE
C
C  Find the spherical variance, which is the
C  trace of P*XMAT
C
      VALUE=0
      DO 100 I=1,K1
       VALUE=VALUE+P2(I,I)
100   CONTINUE
      RETURN
      END
C ************************************************
      SUBROUTINE BMAT(NDPTS)
C ************************************************
C
C  Forms D'D and then takes its inverse.
C
      PARAMETER (MP=7,MD=99,M1=MP+1,M2=(MP+1)*(MP+2)/2
     &,MG=2**MP+2*MP,MG2=2*MP*(MP-1)*(MP-2))
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      INTEGER INDX(M2),ORDER,CUBE,SIMPLX
      DIMENSION X11MAT(M2,M2)
      COMMON PTS(MG,MP),PVAL(101,MP),X(M1),X0(M2),
     &PTS2(MG,MP),PTS3(MG2,MP),XMAT(M2,M2),DES(MD,MP),
     &D(MD,M2),XBEST(MP),SCA
      COMMON ORDER,MODEL,CUBE,MAX,SIMPLX,K,KP,K1,K2,
     &ITEST,INIT,LEVEL,NPTS3,NWT
      DO 30 I=1,K1
       DO 20 J=1,K1
        X11MAT(I,J)=0
        DO 10 I2=1,NDPTS
         X11MAT(I,J)=X11MAT(I,J)+D(I2,I)*D(I2,J)
10      CONTINUE
20     CONTINUE
30    CONTINUE
      LD=M2
      CALL NVERT(LD,K1,X11MAT,XMAT,INDX)
      RETURN
      END
C **************************************************
      SUBROUTINE MXPAND
C **************************************************
C
C  Expands a vector of design variables in accordance
C  with the model actually fit.
C
      PARAMETER (MP=7,MD=99,M1=MP+1,M2=(MP+1)*(MP+2)/2
     &,MG=2**MP+2*MP,MG2=2*MP*(MP-1)*(MP-2))
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      INTEGER ORDER,CUBE,SIMPLX
      COMMON PTS(MG,MP),PVAL(101,MP),X(M1),X0(M2),
     &PTS2(MG,MP),PTS3(MG2,MP),XMAT(M2,M2),DES(MD,MP),
     &D(MD,M2),XBEST(MP),SCA
      COMMON ORDER,MODEL,CUBE,MAX,SIMPLX,K,KP,K1,K2,
     &ITEST,INIT,LEVEL,NPTS3,NWT
C
C  If the model is first order, then no expansion is
C  required.
C
      DO 10 I=1,KP
       X0(I)=X(I)
10    CONTINUE
      IF(ORDER.EQ.1) RETURN
C
C  Create the pure quadratic terms for the second
C  order model.
C
      INDEX=KP
      DO 20 I=2,KP
       INDEX=INDEX+1
       X0(INDEX)=X(I)*X(I)
20    CONTINUE
C
C  Create the two-factor interactions.
C
      DO 40 I=2,K
       I2=I+1
       DO 30 J=I2,KP
        INDEX=INDEX+1
        X0(INDEX)=X(I)*X(J)
30     CONTINUE
40    CONTINUE
      RETURN
      END
C *****************************************************
      SUBROUTINE VMULT(VALUE)
C *****************************************************
C
C  Calculates the prediction variance.
C
      PARAMETER (MP=7,MD=99,M1=MP+1,M2=(MP+1)*(MP+2)/2
     &,MG=2**MP+2*MP,MG2=2*MP*(MP-1)*(MP-2))
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      INTEGER ORDER,CUBE,SIMPLX
      COMMON PTS(MG,MP),PVAL(101,MP),X(M1),X0(M2),
     &PTS2(MG,MP),PTS3(MG2,MP),XMAT(M2,M2),DES(MD,MP),
     &D(MD,M2),XBEST(MP),SCA
      COMMON ORDER,MODEL,CUBE,MAX,SIMPLX,K,KP,K1,K2,
     &ITEST,INIT,LEVEL,NPTS3,NWT
      CALL MXPAND
      VALUE=0
      DO 20 I=1,K1
       RIGHT=0
       DO 10 J=1,K1
        RIGHT=RIGHT+X0(J)*XMAT(J,I)
10     CONTINUE
       VALUE=VALUE+RIGHT*X0(I)
20    CONTINUE
      RETURN
      END
C *******************************************************
      SUBROUTINE AMOEBA(RSQ,VALUE)
C
C *******************************************************
C  This routine performs the nelder-mead simplex
C  search.  Essentially, it is the routine that
C  appears in Numerical Recipes (1986).  The
C  procedure has been modified to perform the search
C  in K-1 dimensional space.
C
c      PARAMETER (ALPHA=1.0D0,BETA=0.5D0,GAMMA=2.0D0,
c     &ITMAX=200)
      PARAMETER (ITMAX=200)
      PARAMETER (MP=7,MD=99,M1=MP+1,M2=(MP+1)*(MP+2)/2
     &,MG=2**MP+2*MP,MG2=2*MP*(MP-1)*(MP-2))
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DIMENSION P(M1,MP),Y(M1),PR(M1),PRR(M1),PBAR(M1)
      INTEGER FLAG,ORDER,CUBE,SIMPLX
      COMMON PTS(MG,MP),PVAL(101,MP),X(M1),X0(M2),
     &PTS2(MG,MP),PTS3(MG2,MP),XMAT(M2,M2),DES(MD,MP),
     &D(MD,M2),XBEST(MP),SCA
      COMMON ORDER,MODEL,CUBE,MAX,SIMPLX,K,KP,K1,K2,
     &ITEST,INIT,LEVEL,NPTS3,NWT
      FTOL=.00001D0
      NDIM=K-1
      MPTS=K
      ITER=0
      X(1)=1.0D0
      X0(1)=1.0D0
      DO 10 J=1,NDIM
       J2=J+1
       P(1,J)=X(J2)
10    CONTINUE
      CALL REJECT(RSQ,FLAG)
      CALL EVAL(VALUE2)
      Y(1)=VALUE2
      FACT=0.25D0*DSQRT(RSQ)
      DO 40 I=2,MPTS
       DO 20 J=1,NDIM
        P(I,J)=0
20     CONTINUE
       I2=I-1
       P(I,I2)=FACT
       DO 30 J=1,NDIM
        J2=J+1
        X(J2)=P(I,J)
30     CONTINUE
       CALL REJECT(RSQ,FLAG)
       CALL EVAL(VALUE2)
       Y(I)=VALUE2
40    CONTINUE
50    ILO=1
       IF(Y(1).GT.Y(2)) THEN
        IHI=1
        INHI=2
       ELSE
        IHI=2
        INHI=1
       ENDIF
       DO 60 I=1,MPTS
        IF(Y(I).LT.Y(ILO)) ILO=I
        IF(Y(I).GT.Y(IHI)) THEN
         INHI=IHI
         IHI=I
        ELSE IF(Y(I).GT.Y(INHI)) THEN
         IF(I.NE.IHI) INHI=1
        ENDIF
60     CONTINUE
       RTOL=2.0D0*DABS(Y(IHI)-Y(ILO))/(DABS(Y(IHI))+
     & DABS(Y(ILO)))
       IF(RTOL.LT.FTOL) THEN
        DO 70 J=1,NDIM
         J2=J+1
         X(J2)=P(ILO,J)
70      CONTINUE
        CALL REJECT(RSQ,FLAG)
        CALL EVAL(VALUE)
        RETURN
       ENDIF
       IF(ITER.GE.ITMAX) THEN
        IF(SIMPLX.EQ.1) THEN
c         WRITE(8,220)
c         WRITE(8,230)
c         WRITE(8,240)
c         WRITE(8,250) FTOL,ITMAX
        ENDIF
        DO 80 J=1,NDIM
         J2=J+1
         X(J2)=P(ILO,J)
80      CONTINUE
        CALL REJECT(RSQ,FLAG)
        CALL EVAL(VALUE)
        RETURN
       ENDIF
       ITER=ITER+1
       DO 90 J=1,NDIM
        PBAR(J)=0
90     CONTINUE
       DO 110 I=1,MPTS
        IF(I.NE.IHI) THEN
         DO 100 J=1,NDIM
          PBAR(J)=PBAR(J)+P(I,J)
100      CONTINUE
        ENDIF
110    CONTINUE
       DO 120 J=1,NDIM
        PBAR(J)=PBAR(J)/NDIM
        PR(J)=(2.0D0)*PBAR(J)-P(IHI,J)
c		PR(J)=(1.0D0+ALPHA)*PBAR(J)-ALPHA*P(IHI,J)
        J2=J+1
        X(J2)=PR(J)
120    CONTINUE
       CALL REJECT(RSQ,FLAG)
       IF(FLAG.NE.1) THEN
        CALL EVAL(YPR)
       ELSE
        YPR=Y(IHI)+1.0
       ENDIF
       IF(YPR.LE.Y(ILO)) THEN
        DO 130 J=1,NDIM
c        PRR(J)=GAMMA*PR(J)-(1.0D0-GAMMA)*PBAR(J)
		 PRR(J)=2.0D0*PR(J)+(1.0D0)*PBAR(J)
         J2=J+1
         X(J2)=PRR(J)
130     CONTINUE
        CALL REJECT(RSQ,FLAG)
        IF(FLAG.NE.1) THEN
         CALL EVAL(YPRR)
        ELSE
         YPRR=Y(IHI)+1.0
        ENDIF
        IF(YPRR.LT.Y(ILO)) THEN
         DO 140 J=1,NDIM
          P(IHI,J)=PRR(J)
140      CONTINUE
         Y(IHI)=YPRR
        ELSE
         DO 150 J=1,NDIM
          P(IHI,J)=PR(J)
150      CONTINUE
         Y(IHI)=YPR
        ENDIF
       ELSE IF(YPR.GE.Y(INHI)) THEN
        IF(YPR.LT.Y(IHI)) THEN
         DO 160 J=1,NDIM
          P(IHI,J)=PR(J)
160      CONTINUE
         Y(IHI)=YPR
        ENDIF
        DO 170 J=1,NDIM
c         PRR(J)=BETA*P(IHI,J)+(1.0D0-BETA)*PBAR(J)
		 PRR(J)=0.5D0*P(IHI,J)+(0.5D0)*PBAR(J)
         J2=J+1
         X(J2)=PRR(J)
170     CONTINUE
        CALL REJECT(RSQ,FLAG)
        IF(FLAG.NE.1) THEN
         CALL EVAL(YPRR)
        ELSE
         YPRR=Y(IHI)+1.0D0
        ENDIF
        IF(YPRR.LT.Y(IHI)) THEN
         DO 180 J=1,NDIM
          P(IHI,J)=PRR(J)
180      CONTINUE
         Y(IHI)=YPRR
        ELSE
        DO 200 I=1,MPTS
         IF(I.NE.ILO) THEN
          DO 190 J=1,NDIM
           PR(J)=0.5D0*(P(I,J)+P(ILO,J))
           P(I,J)=PR(J)
           J2=J+1
           X(J2)=PR(J)
190       CONTINUE
          CALL REJECT(RSQ,FLAG)
          IF(FLAG.NE.1) THEN
           CALL EVAL(FUNK)
          ELSE
           FUNK=Y(IHI)+1.0D0
          ENDIF
          Y(I)=FUNK
         ENDIF
200     CONTINUE
       ENDIF
       ELSE
        DO 210 J=1,NDIM
         P(IHI,J)=PR(J)
210     CONTINUE
        Y(IHI)=YPR
       ENDIF
      GO TO 50
220   FORMAT(' PROBLEM ENCOUNTERED IN AMOEBA')
230   FORMAT(//' YOU MAY WISH TO CHANGE EITHER FTOL',
     &' OR ITMAX IN AMOEBA')
240   FORMAT(' CURRENT VALUES FOR FTOL AND ITMAX')
250   FORMAT(//' FTOL =',F10.6,10X,' ITMAX =',I5)
      END
C ******************************************************
      SUBROUTINE REJECT(RSQ,FLAG)
C ******************************************************
C
C  Determines if a proposed point falls on the
C  hypershere of interest.
C
      PARAMETER (MP=7,MD=99,M1=MP+1,M2=(MP+1)*(MP+2)/2
     &,MG=2**MP+2*MP,MG2=2*MP*(MP-1)*(MP-2))
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      INTEGER FLAG,ORDER,CUBE,SIMPLX
      COMMON PTS(MG,MP),PVAL(101,MP),X(M1),X0(M2),
     &PTS2(MG,MP),PTS3(MG2,MP),XMAT(M2,M2),DES(MD,MP),
     &D(MD,M2),XBEST(MP),SCA
      COMMON ORDER,MODEL,CUBE,MAX,SIMPLX,K,KP,K1,K2,
     &ITEST,INIT,LEVEL,NPTS3,NWT
      FLAG=0
      XLAST=RSQ
      DO 10 J=2,K
       XLAST=XLAST-X(J)*X(J)
10    CONTINUE
      IF(XLAST.LT.0) THEN
       FLAG=1
      ELSE
       X(KP)=DSQRT(XLAST)
      ENDIF
      RETURN
      END
C ********************************************************
      SUBROUTINE EVAL(VALUE)
C ********************************************************
C
C  Determines the value for the K-th variable
C  required to place the point on the hyperesphere
C  of interest.
C
      PARAMETER (MP=7,MD=99,M1=MP+1,M2=(MP+1)*(MP+2)/2
     &,MG=2**MP+2*MP,MG2=2*MP*(MP-1)*(MP-2))
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      INTEGER ORDER,CUBE,SIMPLX
      COMMON PTS(MG,MP),PVAL(101,MP),X(M1),X0(M2),
     &PTS2(MG,MP),PTS3(MG2,MP),XMAT(M2,M2),DES(MD,MP),
     &D(MD,M2),XBEST(MP),SCA
      COMMON ORDER,MODEL,CUBE,MAX,SIMPLX,K,KP,K1,K2,
     &ITEST,INIT,LEVEL,NPTS3,NWT
      CALL MXPAND
      CALL VMULT(VALUE2)
      X(KP)=-X(KP)
      CALL MXPAND
      CALL VMULT(VALUE)
      IF(VALUE2.LT.VALUE) THEN
       X(KP)=-X(KP)
       VALUE=VALUE2
      ENDIF
      IF(MAX.EQ.1) VALUE=-VALUE
      RETURN
      END
C ******************************************************
      SUBROUTINE NVERT(LD,N,A,AINV,INDX)
C ******************************************************
C
C  Finds the inverse of a matrix a using the LU
C  decomposition.
C
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      INTEGER INDX(LD)
      DOUBLE PRECISION A(LD,LD),AINV(LD,LD)
      DO 20 I=1,N
       DO 10 J=1,N
        AINV(I,I)=0
10     CONTINUE
       AINV(I,I)=1.0D0
20    CONTINUE
      CALL LUDCMP(A,N,LD,INDX,D)
      DO 30 J=1,N
         CALL LUBKSB(A,N,LD,INDX,AINV(1,J))
30    CONTINUE
      RETURN
      END
C *********************************************************
      SUBROUTINE LUDCMP(A,N,NP,INDX,D)
C
C  Finds the LU decomposition.
C
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      PARAMETER (NMAX=100,TINY=1.0D-20)
      INTEGER INDX(NP)
      DOUBLE PRECISION A(NP,NP),VV(NMAX)
      D=1.0D0
      DO 12 I=1,N
       AAMAX = 0
       DO 11 J=1,N
        IF(DABS(A(I,J)).GT.AAMAX) AAMAX=DABS(A(I,J))
11     CONTINUE
C       IF(AAMAX.EQ.0) WRITE(*,20)
       VV(I)=1.0D0/AAMAX
12    CONTINUE
      DO 19 J=1,N
       DO 14 I=1,J-1
        SUM=A(I,J)
        DO 13 K=1,I-1
         SUM=SUM-A(I,K)*A(K,J)
13      CONTINUE
        A(I,J)=SUM
14    CONTINUE
       AAMAX=0
       DO 16 I=J,N
        SUM=A(I,J)
        DO 15 K=1,J-1
         SUM=SUM-A(I,K)*A(K,J)
15      CONTINUE
        A(I,J)=SUM
        DUM=VV(I)*DABS(SUM)
        IF(DUM.GE.AAMAX) THEN
         IMAX=I
         AAMAX=DUM
        ENDIF
16     CONTINUE
       IF(J.NE.IMAX) THEN
        DO 17 K=1,N
         DUM=A(IMAX,K)
         A(IMAX,K)=A(J,K)
         A(J,K)=DUM
17      CONTINUE
        D=-D
        VV(IMAX)=VV(J)
       ENDIF
       INDX(J)=IMAX
       IF(A(J,J).EQ.0) A(J,J)=TINY
       IF(J.NE.N) THEN
        DUM=1.0D0/A(J,J)
        DO 18 I=J+1,N
         A(I,J)=A(I,J)*DUM
18      CONTINUE
       ENDIF
19    CONTINUE
20    FORMAT(' PROBLEM IN LUDCMP, SINGULAR MATRIX')
      RETURN
      END
C *******************************************************
      SUBROUTINE LUBKSB(A,N,NP,INDX,B)
C *******************************************************
C
C  Solves the set of linear equations AX = B using
C  the LU decomposition.
C
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      INTEGER INDX(NP)
      DOUBLE PRECISION A(NP,NP),B(NP)
      II=0
      DO 12 I=1,N
       LL=INDX(I)
       SUM=B(LL)
       B(LL)=B(I)
       IF(II.NE.0) THEN
        DO 11 J=II,I-1
         SUM=SUM-A(I,J)*B(J)
11      CONTINUE
       ELSE IF(SUM.NE.0) THEN
        II=I
       ENDIF
       B(I)=SUM
12    CONTINUE
      DO 14 I=N,1,-1
       SUM=B(I)
       DO 13 J=I+1,N
        SUM=SUM-A(I,J)*B(J)
13     CONTINUE
       B(I)=SUM/A(I,I)
14    CONTINUE
      RETURN
      END
