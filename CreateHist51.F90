! Matthew V. Bilskie
! February 2019
! Copyright 2019 
!
    PROGRAM CreateHist51
        IMPLICIT NONE

        INTEGER                 :: I,J
        INTEGER                 :: Reason
        INTEGER                 :: numCon
        INTEGER                 :: numFiles

        REAL*8,ALLOCATABLE      :: speed(:)
        REAL*8,ALLOCATABLE      :: amp(:)
        REAL*8,ALLOCATABLE      :: pha(:)
        
        CHARACTER(100)              :: dum
        CHARACTER(100)              :: inFile
        CHARACTER(5),ALLOCATABLE    :: names(:)

        numCon = 0

        OPEN(UNIT=100,FILE="hist.51",STATUS="UNKNOWN")

        OPEN(UNIT=20,FILE="speeds.txt",ACTION="READ")
        DO
            READ(20,*,IOSTAT=Reason)dum
            IF(Reason < 0) EXIT ! EOF
            numCon = numCon + 1
        ENDDO

        ALLOCATE(speed(numCon))
        ALLOCATE(amp(numCon))
        ALLOCATE(pha(numCon))
        ALLOCATE(names(numCon))

        WRITE(100,'(I2)')numCon
        REWIND(20)
        DO I = 1,numCon
            READ(20,*)speed(I),amp(I),pha(I),names(I)
            WRITE(100,'(E14.9E1,5x,F9.7,5x,F9.7,5x,A4)')speed(I),amp(I),pha(I),names(I)
        ENDDO
        CLOSE(20)

        OPEN(UNIT=21,FILE="inputs.txt",ACTION="READ")
        READ(21,*)numFiles
        WRITE(100,'(I2)')numFiles
        DO I = 1, numFiles
            WRITE(100,'(I2)')I
            READ(21,*)inFile
            OPEN(UNIT=22,FILE=TRIM(inFile),ACTION="READ")
            DO J = 1, numCon
                READ(22,*)amp(I),pha(I)
                WRITE(100,'(E14.9E1,5x,F8.4)')amp(I),pha(I)
            ENDDO
            CLOSE(22)
        ENDDO
        CLOSE(21)



    ENDPROGRAM
