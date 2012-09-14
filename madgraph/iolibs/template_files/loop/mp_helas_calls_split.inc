      SUBROUTINE %(bunch_name)s_%(bunch_number)d(P,NHEL,H,IC)
C  
      IMPLICIT NONE
C  
C CONSTANTS
C  
      %(nbornamps_decl)s
      INTEGER    NEXTERNAL
      PARAMETER (NEXTERNAL=%(nexternal)d)
      INTEGER    NWAVEFUNCS
      PARAMETER (NWAVEFUNCS=%(nwavefuncs)d)
	  INTEGER    NCOMB
      PARAMETER (NCOMB=%(ncomb)d)
      %(real_mp_format)s     ZERO
      PARAMETER (ZERO=0E0_16)
	  %(complex_mp_format)s IMAG1
      PARAMETER (IMAG1=(0E0_16,1E0_16))
C  
C ARGUMENTS
C
     %(real_mp_format)s P(0:3,NEXTERNAL)
      INTEGER NHEL(NEXTERNAL), IC(NEXTERNAL)
	  INTEGER H
C  
C GLOBAL VARIABLES
C  
      include 'mp_coupl_same_name.inc'

	  %(mp_born_amps_decl)s
	  %(complex_mp_format)s W(20,NWAVEFUNCS%(ncomb_helas_objs)s)
	  common/MP_WFS/W  
C
C ----------
C BEGIN CODE
C ----------

%(helas_calls)s

      END